// functions/index.js
const AdmZip = require("adm-zip");
const crypto = require("crypto");
const { onSchedule } = require("firebase-functions/v2/scheduler");
const { defineSecret } = require("firebase-functions/params");
const admin = require("firebase-admin");
admin.initializeApp();

const db = admin.firestore();

// Déclare le secret (la vraie valeur est stockée dans Secret Manager,
// configurée via `firebase functions:secrets:set CURRENTS_API_KEY`)
const currentsApiKey = defineSecret("CURRENTS_API_KEY");

const PARTIES = [
  { id: "rn", name: "Rassemblement National", query: "Rassemblement National", matchTerms: ["rassemblement national", " rn "] },
  { id: "renaissance", name: "Renaissance", query: "Renaissance Macron parti", matchTerms: ["renaissance"] },
  { id: "les-republicains", name: "Les Républicains", query: "Les Républicains parti", matchTerms: ["les républicains", " lr "] },
  { id: "lfi", name: "La France insoumise", query: "La France insoumise", matchTerms: ["france insoumise", " lfi "] },
  { id: "ps", name: "Parti Socialiste", query: "Parti Socialiste France", matchTerms: ["parti socialiste", " ps "] },
  { id: "ecologistes", name: "Les Écologistes", query: "Europe Écologie Les Verts", matchTerms: ["écologistes", "eelv", "europe écologie"] },
  { id: "pcf", name: "Parti Communiste Français", query: "Parti Communiste Français", matchTerms: ["parti communiste", " pcf "] },
  { id: "modem", name: "MoDem", query: "MoDem Bayrou", matchTerms: ["modem", "mouvement démocrate"] },
  { id: "udr", name: "UDR", query: "Éric Ciotti UDR", matchTerms: [" udr ", "éric ciotti"] },
  { id: "reconquete", name: "Reconquête", query: "Reconquête Zemmour", matchTerms: ["reconquête"] },
];

// Normalise un texte : minuscules, sans accents, entouré d'espaces pour matcher les mots isolés
function normalize(text) {
  return " " + text
    .toLowerCase()
    .normalize("NFD").replace(/[\u0300-\u036f]/g, "")
    + " ";
}

// Vérifie que l'article parle bien du parti (titre OU description contient un des termes)
function isRelevantToParty(article, party) {
  const haystack = normalize((article.title || "") + " " + (article.description || ""));
  return party.matchTerms.some((term) => haystack.includes(normalize(term).trim()));
}

const GROUP_TO_PARTY = {
  RN: "rn",
  LFI: "lfi",
  SOC: "ps",
  EcoS: "ecologistes",
  DR: "les-republicains",
  DEM: "modem",
  EPR: "renaissance",
  UDR: "udr",
};

// ---------- 1. Récupération des actualités via Currents API ----------

exports.fetchPartyNews = onSchedule(
  { schedule: "every 6 hours", secrets: [currentsApiKey] },
  async (event) => {
    const apiKey = currentsApiKey.value();

    for (const party of PARTIES) {
      const url = `https://api.currentsapi.services/v1/search?keywords=${encodeURIComponent(party.query)}&language=fr&apiKey=${apiKey}`;

      try {
        const response = await fetch(url);
        console.log(`[DEBUG] ${party.id} - HTTP status: ${response.status}`);

        const rawText = await response.text();
        console.log(`[DEBUG] ${party.id} - Réponse brute: ${rawText.slice(0, 500)}`);

        const data = JSON.parse(rawText);

        if (data.status !== "ok") {
          console.error(`Erreur Currents API pour ${party.id}:`, JSON.stringify(data));
          continue;
        }

        for (const article of data.news) {
          // Ne garde que les articles réellement pertinents pour ce parti
          if (!isRelevantToParty(article, party)) continue;

          // Utilise un hash MD5 pour l'ID du document afin d'éviter les caractères interdits
          const docId = crypto.createHash("md5").update(article.url).digest("hex");

          await db.collection("news").doc(docId).set({
            partyId: party.id,
            title: article.title,
            description: article.description || "",
            url: article.url,
            sourceName: article.author || "Source inconnue",
            // On stocke une vraie date (Timestamp) pour faciliter les requêtes Firestore
            publishedAt: article.published ? new Date(article.published) : new Date(),
            fetchedAt: admin.firestore.FieldValue.serverTimestamp(),
          }, { merge: true });
        }
      } catch (err) {
        console.error(`Échec de récupération pour ${party.id}:`, err.message);
      }

    }
    console.log("Récupération des actualités terminée.");
  }
);

// ---------- 2. Récupération des scrutins/votes via NosDéputés.fr ----------
exports.fetchVotes = onSchedule(
  {
    schedule: "every 24 hours",
    timeoutSeconds: 300,
    memory: "1GiB",
  },
  async (event) => {
    const url =
      "https://data.assemblee-nationale.fr/static/openData/repository/17/loi/scrutins/Scrutins.json.zip";
    const organesUrl =
      "https://data.assemblee-nationale.fr/static/openData/repository/17/amo/deputes_actifs_mandats_actifs_organes_divises/AMO40_deputes_actifs_mandats_actifs_organes_divises.json.zip";
    console.log("[fetchVotes] Téléchargement des scrutins...");

    try {
      const response = await fetch(url);

      console.log(`[fetchVotes] HTTP status: ${response.status}`);

      if (!response.ok) {
        throw new Error(
          `Erreur téléchargement Assemblée nationale: HTTP ${response.status}`
        );
      }

      const arrayBuffer = await response.arrayBuffer();
      const buffer = Buffer.from(arrayBuffer);

      console.log(
        `[fetchVotes] Archive téléchargée : ${(buffer.length / 1024 / 1024).toFixed(1)} Mo`
      );

      const zip = new AdmZip(buffer);
      console.log("[fetchVotes] Téléchargement des groupes politiques...");

      const organesResponse = await fetch(organesUrl);

      if (!organesResponse.ok) {
        throw new Error(
          `Erreur téléchargement organes: HTTP ${organesResponse.status}`
        );
      }

      const organesBuffer = Buffer.from(
        await organesResponse.arrayBuffer()
      );

      const organesZip = new AdmZip(organesBuffer);

      // Mapping POxxxx → informations du groupe
      const groupesMap = {};

      for (const entry of organesZip.getEntries()) {
        if (
          entry.isDirectory ||
          !entry.entryName.startsWith("organe/") ||
          !entry.entryName.endsWith(".json")
        ) {
          continue;
        }

        try {
          const data = JSON.parse(
            entry.getData().toString("utf8")
          );

          const organe = data.organe;

          // GP = Groupe politique
          if (organe?.codeType === "GP") {
            groupesMap[organe.uid] = {
              nom: organe.libelle,
              abreviation:
                organe.libelleAbrev ||
                organe.libelleAbrege ||
                null,
            };
          }
        } catch (err) {
          console.error(
            `[fetchVotes] Erreur organe ${entry.entryName}:`,
            err.message
          );
        }
      }

      console.log(
        `[fetchVotes] ${Object.keys(groupesMap).length} groupes politiques trouvés`
      );

      const jsonEntries = zip
        .getEntries()
        .filter(
          (entry) =>
            !entry.isDirectory &&
            entry.entryName.startsWith("json/") &&
            entry.entryName.endsWith(".json")
        );

      console.log(
        `[fetchVotes] ${jsonEntries.length} scrutins trouvés dans l'archive`
      );

      const parsedScrutins = [];

      for (const entry of jsonEntries) {
        try {
          const raw = entry.getData().toString("utf8");
          const data = JSON.parse(raw);

          if (!data.scrutin) continue;

          parsedScrutins.push(data.scrutin);
        } catch (err) {
          console.error(
            `[fetchVotes] Erreur lecture ${entry.entryName}:`,
            err.message
          );
        }
      }

      parsedScrutins.sort((a, b) => {
        const dateComparison =
          new Date(b.dateScrutin).getTime() -
          new Date(a.dateScrutin).getTime();

        if (dateComparison !== 0) {
          return dateComparison;
        }

        return Number(b.numero) - Number(a.numero);
      });

      // Pour commencer, on ne stocke que les 20 scrutins les plus récents.
      const recentScrutins = parsedScrutins.slice(0, 20);

      console.log(
        `[fetchVotes] ${recentScrutins.length} scrutins récents à enregistrer`
      );

      for (const scrutin of recentScrutins) {
        const groupesRaw =
          scrutin.ventilationVotes?.organe?.groupes?.groupe || [];

        // Selon le JSON, "groupe" peut théoriquement être un objet unique
        // ou un tableau.
        const groupesArray = Array.isArray(groupesRaw)
          ? groupesRaw
          : [groupesRaw];

        const groupes = groupesArray.map((groupe) => {
          const voix = groupe.vote?.decompteVoix || {};

          const infosGroupe = groupesMap[groupe.organeRef];

          const abreviation = infosGroupe?.abreviation || null;

          return {
            organeRef: groupe.organeRef || null,

            nom: infosGroupe?.nom || "Groupe inconnu",
            abreviation: abreviation,

            partyId: GROUP_TO_PARTY[abreviation] || null,

            nombreMembres: Number(groupe.nombreMembresGroupe || 0),

            positionMajoritaire:
              groupe.vote?.positionMajoritaire || null,

            pour: Number(voix.pour || 0),
            contre: Number(voix.contre || 0),
            abstentions: Number(voix.abstentions || 0),
            nonVotants: Number(voix.nonVotants || 0),
            nonVotantsVolontaires: Number(
              voix.nonVotantsVolontaires || 0
            ),
          };
        });

        const synthese = scrutin.syntheseVote || {};
        const decompte = synthese.decompte || {};

        const document = {
          uid: scrutin.uid,

          numero: Number(scrutin.numero),

          legislature: Number(scrutin.legislature),

          date: scrutin.dateScrutin,

          titre:
            scrutin.titre ||
            scrutin.objet?.libelle ||
            "Scrutin sans titre",

          objet: scrutin.objet?.libelle || null,

          dossierLegislatif:
            scrutin.objet?.dossierLegislatif?.libelle || null,

          dossierRef:
            scrutin.objet?.dossierLegislatif?.dossierRef || null,

          typeVote:
            scrutin.typeVote?.libelleTypeVote || null,

          resultat: scrutin.sort?.code || null,

          resultatLibelle: scrutin.sort?.libelle || null,

          synthese: {
            nombreVotants: Number(synthese.nombreVotants || 0),
            suffragesExprimes: Number(
              synthese.suffragesExprimes || 0
            ),
            suffragesRequis: Number(
              synthese.nbrSuffragesRequis || 0
            ),

            pour: Number(decompte.pour || 0),
            contre: Number(decompte.contre || 0),
            abstentions: Number(decompte.abstentions || 0),
            nonVotants: Number(decompte.nonVotants || 0),
          },

          groupes,

          source: "Assemblée nationale",

          fetchedAt:
            admin.firestore.FieldValue.serverTimestamp(),
        };

        await db
          .collection("votes")
          .doc(`scrutin-${scrutin.numero}`)
          .set(document, { merge: true });

        console.log(
          `[fetchVotes] Scrutin ${scrutin.numero} enregistré (${scrutin.dateScrutin})`
        );
      }

      console.log(
        `[fetchVotes] Terminé : ${recentScrutins.length} scrutins mis à jour`
      );
    } catch (err) {
      console.error("[fetchVotes] ERREUR :", err);
      throw err;
    }
  }
);

// ---------- 3. Regroupement des news par sujet (pour le système d'étoiles) ----------

// Découpe un titre en mots significatifs (ignore les mots courts/accents)
function significantWords(title) {
  return normalize(title)
    .replace(/[^a-z0-9\s]/g, "")
    .split(/\s+/)
    .filter((w) => w.length > 3);
}

// Similarité de Jaccard entre deux listes de mots (0 = rien en commun, 1 = identique)
function similarity(wordsA, wordsB) {
  const setA = new Set(wordsA);
  const setB = new Set(wordsB);
  const intersection = [...setA].filter((w) => setB.has(w));
  const union = new Set([...setA, ...setB]);
  return union.size === 0 ? 0 : intersection.length / union.size;
}

exports.buildNewsClusters = onSchedule(
  { schedule: "every 6 hours" },
  async (event) => {
    // Récupère les news des 3 derniers jours pour comparaison
    // On utilise un objet Date car on stocke maintenant des Timestamps dans "news"
    const threeDaysAgo = new Date(Date.now() - 3 * 24 * 60 * 60 * 1000);
    const snapshot = await db.collection("news")
      .where("publishedAt", ">=", threeDaysAgo)
      .get();

    const articles = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
    const used = new Set();
    const clusters = [];

    for (let i = 0; i < articles.length; i++) {
      if (used.has(articles[i].id)) continue;
      const base = articles[i];
      const baseWords = significantWords(base.title);
      const group = [base];
      used.add(base.id);

      for (let j = i + 1; j < articles.length; j++) {
        if (used.has(articles[j].id)) continue;
        const candidateWords = significantWords(articles[j].title);
        if (similarity(baseWords, candidateWords) >= 0.4) {
          group.push(articles[j]);
          used.add(articles[j].id);
        }
      }
      clusters.push(group);
    }

    // Écrit chaque groupe dans Firestore, avec le nombre de sources uniques
    for (const group of clusters) {
      // Dédupliquer par source (un même journal ne compte qu'une fois)
      const uniqueSources = [];
      const seenSources = new Set();
      for (const article of group) {
        if (!seenSources.has(article.sourceName)) {
          seenSources.add(article.sourceName);
          uniqueSources.push({
            name: article.sourceName,
            url: article.url,
          });
        }
      }

      // Prend la description la plus longue comme description principale
      const mainArticle = group.reduce((a, b) =>
        (b.description?.length || 0) > (a.description?.length || 0) ? b : a
      );

      const clusterId = crypto.createHash("md5").update(mainArticle.url).digest("hex");

      await db.collection("newsClusters").doc(clusterId).set({
        title: mainArticle.title,
        description: mainArticle.description,
        publishedAt: mainArticle.publishedAt,
        sourceCount: uniqueSources.length,
        sources: uniqueSources,
        fetchedAt: admin.firestore.FieldValue.serverTimestamp(),
      }, { merge: true });
    }

    console.log(`${clusters.length} sujets regroupés depuis ${articles.length} articles.`);
  }
);

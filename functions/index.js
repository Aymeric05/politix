// functions/index.js
const { onSchedule } = require("firebase-functions/v2/scheduler");
const { defineSecret } = require("firebase-functions/params");
const admin = require("firebase-admin");
admin.initializeApp();

const db = admin.firestore();

// Déclare le secret (la vraie valeur est stockée dans Secret Manager,
// configurée via `firebase functions:secrets:set CURRENTS_API_KEY`)
const currentsApiKey = defineSecret("CURRENTS_API_KEY");

const PARTIES = [
  { id: "rn", name: "Rassemblement National", query: "Rassemblement National" },
  { id: "renaissance", name: "Renaissance", query: "Renaissance Macron parti" },
  { id: "les-republicains", name: "Les Républicains", query: "Les Républicains parti" },
  { id: "lfi", name: "La France insoumise", query: "La France insoumise" },
  { id: "ps", name: "Parti Socialiste", query: "Parti Socialiste France" },
  { id: "ecologistes", name: "Les Écologistes", query: "Europe Écologie Les Verts" },
  { id: "pcf", name: "Parti Communiste Français", query: "Parti Communiste Français" },
  { id: "modem", name: "MoDem", query: "MoDem Bayrou" },
  { id: "udr", name: "UDR", query: "Éric Ciotti UDR" },
  { id: "reconquete", name: "Reconquête", query: "Reconquête Zemmour" },
];

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
          const docId = Buffer.from(article.url).toString("base64").slice(0, 100);

          await db.collection("news").doc(docId).set({
            partyId: party.id,
            title: article.title,
            description: article.description || "",
            url: article.url,
            sourceName: article.author || "Source inconnue",
            publishedAt: article.published,
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
  { schedule: "every 24 hours" },
  async (event) => {
    const LEGISLATURE = 17; // ajuste selon la législature en cours

    const scrutinsResponse = await fetch(`https://www.nosdeputes.fr/${LEGISLATURE}/scrutins/json`);
    const scrutinsData = await scrutinsResponse.json();

    const recentScrutins = (scrutinsData.scrutins || []).slice(0, 10);

    for (const s of recentScrutins) {
      const scrutin = s.scrutin;

      const detailResponse = await fetch(
        `https://www.nosdeputes.fr/${LEGISLATURE}/scrutin/${scrutin.numero}/json`
      );
      const detail = await detailResponse.json();

      await db.collection("votes").doc(`scrutin-${scrutin.numero}`).set({
        numero: scrutin.numero,
        titre: scrutin.titre || scrutin.demandeur || "Scrutin sans titre",
        date: scrutin.date,
        sort: scrutin.sort,
        groupes: detail.scrutin?.groupes || {},
        fetchedAt: admin.firestore.FieldValue.serverTimestamp(),
      }, { merge: true });
    }

    console.log(`${recentScrutins.length} scrutins mis à jour.`);
  }
);

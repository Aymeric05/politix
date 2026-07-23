import 'package:flutter/material.dart';
import '../models/political_orientation.dart';
import '../models/party.dart';
import '../models/party_representation.dart';
import '../theme/app_theme.dart';

class MockData {
  static const List<PoliticalOrientation> orientations = [
    PoliticalOrientation(
      id: 'extreme-gauche',
      name: 'Extrême gauche',
      description: 'Courants anticapitalistes et révolutionnaires',
      color: AppTheme.extremeGauche,
      summary:
      "L'extrême gauche porte une critique radicale du capitalisme et prône une "
          "transformation profonde, voire révolutionnaire, de la société et de l'économie.",
      longDescription:
      "L'extrême gauche regroupe des courants qui portent une critique radicale du système "
          "capitaliste et prônent une transformation profonde, voire révolutionnaire, de la société "
          "et de l'économie. On y trouve des traditions marxistes, trotskistes ou anarchistes, qui "
          "défendent la collectivisation des moyens de production et une rupture nette avec "
          "l'ordre économique libéral. Le classement précis de certains partis (comme LFI) dans "
          "cette catégorie ou dans la « gauche radicale » fait débat parmi les politologues.",
      sources: ['Wikipédia — Extrême gauche', 'CEVIPOF (Sciences Po)'],
    ),
    PoliticalOrientation(
      id: 'gauche',
      name: 'Gauche',
      description: 'Courants sociaux-démocrates et écologistes',
      color: AppTheme.gauche,
      summary:
      "La gauche défend l'égalité sociale et la redistribution des richesses, avec un rôle "
          "fort de l'État pour protéger les travailleurs et réduire les inégalités.",
      longDescription:
      "La gauche regroupe des courants politiques qui privilégient l'égalité sociale, la "
          "redistribution des richesses et l'intervention de l'État dans l'économie. Elle défend "
          "historiquement les droits des travailleurs, la protection sociale (santé, retraites, "
          "chômage) et, plus récemment, une forte attention portée à l'écologie et aux questions "
          "sociétales (droits des minorités, égalité femmes-hommes). Elle s'oppose généralement "
          "aux logiques de dérégulation économique et défend un rôle actif de la puissance "
          "publique pour corriger les inégalités produites par le marché.",
      sources: ['Vie-publique.fr', 'Wikipédia — Gauche (politique)'],
    ),
    PoliticalOrientation(
      id: 'centre',
      name: 'Centre',
      description: 'Courants centristes et libéraux',
      color: AppTheme.centre,
      summary:
      "Le centre cherche un équilibre entre régulation sociale et libéralisme économique, "
          "en misant sur le dialogue, le pragmatisme et l'ancrage européen.",
      longDescription:
      "Le centre rassemble des courants qui se positionnent entre la gauche et la droite, "
          "cherchant un équilibre entre régulation sociale et libéralisme économique. Il défend "
          "souvent le dialogue social, le pragmatisme sur les réformes économiques, et un fort "
          "attachement à la construction européenne. Les partis centristes s'allient historiquement "
          "tantôt avec la gauche, tantôt avec la droite, selon les contextes électoraux.",
      sources: ['Vie-publique.fr', 'Wikipédia — Centrisme'],
    ),
    PoliticalOrientation(
      id: 'droite',
      name: 'Droite',
      description: 'Courants conservateurs et libéraux-conservateurs',
      color: AppTheme.droite,
      summary:
      "La droite privilégie la liberté individuelle et économique, un État plus restreint, "
          "et une ligne ferme sur l'ordre, la sécurité et l'identité nationale.",
      longDescription:
      "La droite regroupe des courants qui privilégient la liberté individuelle et "
          "économique, un État plus restreint dans l'économie, et l'attachement à l'ordre, à la "
          "sécurité et aux traditions. Elle défend généralement la baisse des impôts et des "
          "dépenses publiques, la valorisation du mérite individuel et de l'initiative privée, "
          "ainsi qu'une ligne plus ferme sur les questions d'immigration et de sécurité que la "
          "gauche.",
      sources: ['Vie-publique.fr', 'Wikipédia — Droite (politique)'],
    ),
    PoliticalOrientation(
      id: 'extreme-droite',
      name: 'Extrême droite',
      description: 'Courants nationalistes',
      color: AppTheme.extremeDroite,
      summary:
      "L'extrême droite place l'identité nationale au cœur de son projet, avec une ligne "
          "très restrictive sur l'immigration et une critique forte de l'Union européenne.",
      longDescription:
      "L'extrême droite regroupe des courants nationalistes qui placent l'identité nationale "
          "au cœur de leur projet politique, avec une ligne très restrictive sur l'immigration et "
          "une critique forte des institutions supranationales comme l'Union européenne. Ces "
          "partis défendent généralement une vision autoritaire de l'ordre et de la sécurité, et "
          "mettent en avant la préférence nationale dans l'accès à certains droits sociaux.",
      sources: ['Wikipédia — Extrême droite', 'CEVIPOF (Sciences Po)'],
    ),
    PoliticalOrientation(
      id: 'sans-etiquette',
      name: 'Sans étiquette',
      description: 'Partis divers ou non classés',
      color: AppTheme.sansEtiquette,
      summary:
      "Cette catégorie rassemble les candidats et petites formations qui ne se rattachent à "
          "aucune grande famille politique nationale ou au clivage gauche-droite classique.",
      longDescription:
      "Cette catégorie regroupe les candidats et petites formations qui ne se rattachent à "
          "aucune des grandes familles politiques nationales, ou dont le positionnement ne "
          "correspond pas clairement au clivage gauche-droite traditionnel. Elle inclut aussi des "
          "listes purement locales ou des candidatures individuelles.",
      sources: ["Ministère de l'Intérieur"],
    ),
  ];

  static const List<Party> parties = [
    // ---------- EXTRÊME GAUCHE ----------
    Party(
      id: 'lfi',
      name: 'La France insoumise',
      orientationId: 'extreme-gauche',
      shortDescription: 'Mouvement de gauche radicale fondé par Jean-Luc Mélenchon.',
      leader: 'Jean-Luc Mélenchon (fondateur), Manuel Bompard (coordinateur)',
      leaderImageUrl: 'https://upload.wikimedia.org/wikipedia/commons/8/88/JLM_EP_2016_%28cropped%29.jpg',
      keyFigures: ['Jean-Luc Mélenchon', 'Manuel Bompard', 'Mathilde Panot'],
      foundedYear: '2016',
      representation: const PartyRepresentation(
        deputies: 71,
        senators: 0,
        euroDeputies: 9,
        deptPresidents: 0,
        regPresidents: 0,
        largeCityMayors: 0,
      ),
      historySummary:
      "La France insoumise est un mouvement de gauche fondé en 2016 par Jean-Luc Mélenchon. "
          "Il défend une VIe République, une rupture avec le capitalisme financier et une écologie "
          "de rupture. Son classement politique (gauche radicale ou extrême gauche) fait débat "
          "parmi les politologues.",
      historyRoots:
      "LFI naît en 2016 dans la continuité du Parti de Gauche, lui-même fondé en 2008 par "
          "Jean-Luc Mélenchon après sa scission du Parti Socialiste. Le mouvement s'inscrit dans "
          "la tradition de la gauche républicaine et socialiste française, tout en s'en démarquant "
          "par un positionnement plus radical.",
      historyDetails:
      "Le mouvement se structure autour de la campagne présidentielle de 2017, où Jean-Luc "
          "Mélenchon obtient environ 19,6% des voix au premier tour. LFI défend un programme "
          "articulé autour de « L'Avenir en Commun » : planification écologique, revalorisation du "
          "smic, sortie des traités européens jugés contraignants, VIe République. Le mouvement "
          "devient la première force de gauche à l'Assemblée nationale après les législatives de "
          "2022 et 2024. Il a connu plusieurs tensions internes et départs (notamment vers le "
          "mouvement L'Après en 2024).",
      sources: ['Wikipédia', 'Site officiel LFI', 'Vie-publique.fr'],
    ),

    // ---------- GAUCHE ----------
    Party(
      id: 'ps',
      name: 'Parti Socialiste',
      orientationId: 'gauche',
      shortDescription: 'Parti historique de la gauche française, social-démocrate.',
      leader: 'Olivier Faure',
      leaderImageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTGqThpJt6rkQSfJLb7CzgwWiWbbVstzHjcnXY0raY-jAXFgsBiB_ROw1lzJ8EmpoYpO_75zcA8w1WtCN1iFdxjKJvwC3mkwaB7HqV2Nope&s=10',
      keyFigures: ['Olivier Faure', 'Raphaël Glucksmann'],
      foundedYear: '1969',
      representation: const PartyRepresentation(
        deputies: 66,
        senators: 64,
        euroDeputies: 13,
        deptPresidents: 21,
        regPresidents: 5,
        largeCityMayors: 42,
      ),
      historySummary:
      "Le Parti Socialiste est le parti historique de la gauche de gouvernement en France, "
          "dirigé par Olivier Faure depuis 2018. Après une forte perte d'influence dans les années "
          "2010, il amorce une reconstruction en s'alliant notamment avec Place Publique.",
      historyRoots:
      "Fondé en 1969 au congrès d'Issy-les-Moulineaux à partir de la SFIO (Section Française "
          "de l'Internationale Ouvrière), le PS prend sa forme moderne en 1971 au congrès "
          "d'Épinay sous l'impulsion de François Mitterrand.",
      historyDetails:
      "Le PS domine la gauche française pendant plusieurs décennies, portant François "
          "Mitterrand (1981, 1988) puis François Hollande (2012) à la présidence. Il connaît un "
          "net recul électoral après le quinquennat Hollande, tombant sous la barre des 10% en "
          "2017. Ces dernières années, le parti amorce un début de reconstruction, notamment via "
          "une alliance avec Place Publique de Raphaël Glucksmann aux élections européennes de "
          "2024.",
      sources: ['Wikipédia', 'Site officiel du PS', 'Vie-publique.fr'],
    ),
    Party(
      id: 'ecologistes',
      name: 'Les Écologistes (EELV)',
      orientationId: 'gauche',
      shortDescription: 'Parti écologiste de gauche, ex-Europe Écologie Les Verts.',
      leader: 'Marine Tondelier',
      leaderImageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKIqkyTQJuOrGmxOQJpr00z5sJtRz4xqLcQ8FndoU6UA&s=10',
      keyFigures: ['Marine Tondelier'],
      foundedYear: '1984',
      representation: const PartyRepresentation(
        deputies: 38,
        senators: 16,
        euroDeputies: 5,
        deptPresidents: 0,
        regPresidents: 0,
        largeCityMayors: 9,
      ),
      historySummary:
      "Les Écologistes (anciennement Europe Écologie Les Verts) portent une écologie "
          "politique de gauche, combinant urgence climatique et justice sociale. Le parti est "
          "dirigé depuis 2022 par Marine Tondelier.",
      historyRoots:
      "Le mouvement trouve ses racines dans les luttes écologistes des années 1970 "
          "(mouvement antinucléaire notamment) et se structure en parti politique, Les Verts, "
          "en 1984.",
      historyDetails:
      "Le parti prend le nom d'Europe Écologie Les Verts en 2010 après une alliance électorale "
          "réussie. Il participe à des gouvernements de gauche (notamment sous François Hollande) "
          "et connaît des résultats variables selon les scrutins, avec un score notable en 2024.",
      sources: ['Wikipédia', 'Site officiel Les Écologistes'],
    ),
    Party(
      id: 'pcf',
      name: 'Parti Communiste Français',
      orientationId: 'gauche',
      shortDescription: 'Parti historique de la gauche ouvrière et républicaine.',
      leader: 'Fabien Roussel',
      leaderImageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOTkIw1dUiXLWksRPzZlJusLjo8OXlUVb2r-rHqSo0KTrH-_KYCM4GleFiookG381IKyYUAPDE1THulTW0w-asrpPMGKsmeLztdTh3SChv&s=10',
      keyFigures: ['Fabien Roussel'],
      foundedYear: '1920',
      representation: const PartyRepresentation(
        deputies: 9,
        senators: 14,
        euroDeputies: 0,
        deptPresidents: 0,
        regPresidents: 0,
        largeCityMayors: 3,
      ),
      historySummary:
      "Le PCF est un parti historique de la gauche française, ancré dans la tradition "
          "ouvrière et républicaine. Dirigé par Fabien Roussel, il défend un positionnement "
          "distinct de celui de LFI, notamment sur la laïcité et l'énergie nucléaire.",
      historyRoots:
      "Fondé en 1920 lors du congrès de Tours, à la suite d'une scission de la SFIO sur la "
          "question de l'adhésion à la Troisième Internationale.",
      historyDetails:
      "Le PCF fut un acteur majeur de la vie politique française tout au long du XXe siècle, "
          "notamment dans la Résistance et les gouvernements de la Libération. Son influence "
          "électorale décline fortement à partir des années 1980. Aujourd'hui, le parti défend une "
          "ligne se voulant distincte de LFI au sein de la gauche.",
      sources: ['Wikipédia', 'Site officiel du PCF'],
    ),

    // ---------- CENTRE ----------
    Party(
      id: 'renaissance',
      name: 'Renaissance',
      orientationId: 'centre',
      shortDescription: 'Parti centriste fondé par Emmanuel Macron.',
      leader: 'Gabriel Attal',
      leaderImageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSwK3Av2izSUQRGL3mmRccm8-U_qHJTeTfPIAjuPrpvEWLpOg7WhTzSjBCJnUnKw-15ObqevsGczwv1hO0ieWodsx3e18_EqQSmFwOrK7Cm4Q&s=10',
      keyFigures: ['Emmanuel Macron', 'Gabriel Attal'],
      foundedYear: '2016',
      representation: const PartyRepresentation(
        deputies: 99,
        senators: 24,
        euroDeputies: 13,
        deptPresidents: 2,
        regPresidents: 1,
        largeCityMayors: 12,
      ),
      historySummary:
      "Renaissance (ex-La République en Marche) est le parti central de la majorité "
          "présidentielle depuis 2017. Il défend une ligne libérale et pro-européenne, entre "
          "gauche et droite.",
      historyRoots:
      "Fondé en 2016 par Emmanuel Macron sous le nom « En Marche ! », en dehors des partis "
          "traditionnels de gauche et de droite.",
      historyDetails:
      "Le mouvement porte Emmanuel Macron à la présidence en 2017 puis en 2022, et obtient "
          "une majorité (relative à partir de 2022) à l'Assemblée nationale. Il prend le nom de "
          "Renaissance en 2022 et forme, avec le MoDem et Horizons, le socle de la coalition "
          "« Ensemble ». Le parti est aujourd'hui dirigé par Gabriel Attal.",
      sources: ['Wikipédia', 'Site officiel Renaissance'],
    ),
    Party(
      id: 'modem',
      name: 'MoDem',
      orientationId: 'centre',
      shortDescription: 'Parti centriste et démocrate-chrétien, allié de Renaissance.',
      leader: 'François Bayrou',
      leaderImageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcThbfiUDhwx3LvtN1YDgFd7rxL4Fq2tbvc4nJYzw9OslA&s',
      keyFigures: ['François Bayrou'],
      foundedYear: '2007',
      representation: const PartyRepresentation(
        deputies: 36,
        senators: 26,
        euroDeputies: 0,
        deptPresidents: 1,
        regPresidents: 0,
        largeCityMayors: 5,
      ),
      historySummary:
      "Le Mouvement Démocrate est un parti centriste historique, dirigé par François Bayrou, "
          "allié de la majorité présidentielle depuis 2017.",
      historyRoots:
      "Fondé en 2007 par François Bayrou après l'échec de l'UDF à la présidentielle, dans la "
          "tradition du centrisme et de la démocratie chrétienne française.",
      historyDetails:
      "Le MoDem participe à toutes les majorités présidentielles depuis 2017 aux côtés de "
          "Renaissance. François Bayrou a occupé la fonction de Premier ministre en 2024-2025.",
      sources: ['Wikipédia', 'Site officiel du MoDem'],
    ),

    // ---------- DROITE ----------
    Party(
      id: 'les-republicains',
      name: 'Les Républicains',
      orientationId: 'droite',
      shortDescription: 'Parti de droite issu du gaullisme et du libéralisme.',
      leader: 'Bruno Retailleau',
      leaderImageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRlnn2kRIaWsU3UJBgBgXG8dbbwUU3G1JhzGroUhAf99A&s',
      keyFigures: ['Bruno Retailleau', 'Laurent Wauquiez'],
      foundedYear: '2015',
      representation: const PartyRepresentation(
        deputies: 47,
        senators: 132,
        euroDeputies: 6,
        deptPresidents: 38,
        regPresidents: 7,
        largeCityMayors: 58,
      ),
      historySummary:
      "Les Républicains sont le principal parti de la droite de gouvernement, héritier du "
          "gaullisme. Le parti défend une ligne conservatrice sur les valeurs et libérale sur "
          "l'économie.",
      historyRoots:
      "Fondé en 2015 sous l'impulsion de Nicolas Sarkozy, en remplacement de l'UMP "
          "(elle-même issue en 2002 du RPR fondé par Jacques Chirac en 1976).",
      historyDetails:
      "Héritier direct du RPR puis de l'UMP, le parti a fourni plusieurs présidents de la "
          "République (Jacques Chirac, Nicolas Sarkozy). Depuis 2017, LR connaît un fort recul "
          "électoral, mais reste influent au Sénat et dans les collectivités locales. Une partie de "
          "ses cadres (dont Éric Ciotti) ont fait scission en 2024 pour se rapprocher du RN.",
      sources: ['Wikipédia', 'Site officiel LR'],
    ),
    Party(
      id: 'udr',
      name: 'Union des droites pour la République (UDR)',
      orientationId: 'droite',
      shortDescription: "Parti fondé par Éric Ciotti après sa rupture avec LR.",
      leader: 'Éric Ciotti',
      leaderImageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQqqx4YCoD0miXAaca_TU-mdcoBS6GcPQHI3u7ygfQTYQ&s=10',
      keyFigures: ['Éric Ciotti'],
      foundedYear: '2024',
      representation: const PartyRepresentation(
        deputies: 16,
        senators: 0,
        euroDeputies: 0,
        deptPresidents: 0,
        regPresidents: 0,
        largeCityMayors: 0,
      ),
      historySummary:
      "L'UDR est un parti de droite fondé en 2024 par Éric Ciotti après son exclusion des "
          "Républicains, avec une ligne assumant des alliances avec le Rassemblement National.",
      historyRoots:
      "Né d'une scission des Républicains en 2024, après qu'Éric Ciotti a appelé à une "
          "alliance électorale avec le RN aux législatives anticipées de 2024.",
      historyDetails:
      "Le parti se positionne comme une passerelle entre la droite classique et l'extrême "
          "droite, en assumant des alliances électorales avec le RN, ce qui le distingue "
          "nettement de la ligne officielle des Républicains.",
      sources: ['Wikipédia', 'Presse politique française'],
    ),

    // ---------- EXTRÊME DROITE ----------
    Party(
      id: 'rn',
      name: 'Rassemblement National',
      orientationId: 'extreme-droite',
      shortDescription: 'Premier parti à l\'Assemblée nationale depuis 2024, ligne nationaliste.',
      leader: 'Jordan Bardella',
      leaderImageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcROt3Eb47oQiDFEJUavIz6YpHw8ef4YETS0pvTJpgQO5Q&s',
      keyFigures: ['Marine Le Pen', 'Jordan Bardella'],
      foundedYear: '1972',
      representation: const PartyRepresentation(
        deputies: 126,
        senators: 3,
        euroDeputies: 30,
        deptPresidents: 0,
        regPresidents: 0,
        largeCityMayors: 3,
      ),
      historySummary:
      "Le Rassemblement National, ex-Front National, défend une ligne nationaliste sur "
          "l'immigration et souverainiste sur l'Europe. Il est devenu la première force à "
          "l'Assemblée nationale après les législatives de 2024.",
      historyRoots:
      "Fondé en 1972 sous le nom de Front National, à l'initiative notamment de Jean-Marie Le "
          "Pen, rassemblant plusieurs courants nationalistes.",
      historyDetails:
      "Longtemps marginalisé, le parti amorce une dynamique électorale forte à partir des "
          "années 2010 sous la présidence de Marine Le Pen, qui engage une stratégie de "
          "« dédiabolisation » et rebaptise le parti Rassemblement National en 2018. Marine Le "
          "Pen atteint le second tour de la présidentielle en 2017 et 2022. Sous la présidence de "
          "Jordan Bardella depuis 2022, le parti obtient le plus grand nombre de sièges à "
          "l'Assemblée nationale lors des législatives de 2024.",
      sources: ['Wikipédia', 'Site officiel RN'],
    ),
    Party(
      id: 'reconquete',
      name: 'Reconquête',
      orientationId: 'extreme-droite',
      shortDescription: "Parti nationaliste fondé par Éric Zemmour.",
      leader: 'Éric Zemmour',
      leaderImageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjBxqwB61-kXbLVdz6I3hxOKuNGTWbxftasNlxSScA5A&s=10',
      keyFigures: ['Éric Zemmour', 'Marion Maréchal'],
      foundedYear: '2021',
      representation: const PartyRepresentation(
        deputies: 0,
        senators: 0,
        euroDeputies: 1,
        deptPresidents: 0,
        regPresidents: 0,
        largeCityMayors: 0,
      ),
      historySummary:
      "Reconquête est un parti d'extrême droite fondé par Éric Zemmour en 2021, avec une "
          "ligne axée sur l'identité nationale et une critique radicale de l'immigration.",
      historyRoots:
      "Fondé en décembre 2021 par le polémiste et essayiste Éric Zemmour, en vue de sa "
          "candidature à l'élection présidentielle de 2022.",
      historyDetails:
      "Éric Zemmour obtient environ 7% des voix à la présidentielle de 2022. Le parti connaît "
          "des tensions internes, notamment le départ de Marion Maréchal en 2024 pour rejoindre "
          "une liste commune avec le RN aux élections européennes.",
      sources: ['Wikipédia', 'Site officiel Reconquête'],
    ),

    // ---------- SANS ÉTIQUETTE ----------
    Party(
      id: 'divers',
      name: 'Divers / Non classés',
      orientationId: 'sans-etiquette',
      shortDescription: 'Candidats et petites formations sans étiquette nationale.',
      leader: 'Variable selon les candidatures',
      leaderImageUrl: '',
      keyFigures: ['À compléter'],
      foundedYear: '—',
      representation: const PartyRepresentation(
        deputies: 0,
        senators: 0,
        euroDeputies: 0,
        deptPresidents: 0,
        regPresidents: 0,
        largeCityMayors: 0,
      ),
      historySummary:
      "Cette catégorie regroupe les candidats indépendants et petites formations locales ne "
          "se rattachant à aucun des grands partis nationaux.",
      historyRoots:
      "Catégorie administrative utilisée notamment par le ministère de l'Intérieur pour "
          "classer les candidatures ne relevant pas des partis structurés au niveau national.",
      historyDetails:
      "Cette rubrique sera enrichie au fur et à mesure de l'identification de candidatures "
          "notables pour l'élection présidentielle de 2027.",
      sources: ['Ministère de l\'Intérieur'],
    ),
  ];

  static List<Party> getPartiesByOrientation(String orientationId) {
    return parties.where((p) => p.orientationId == orientationId).toList();
  }
}
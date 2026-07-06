const SupportModel = require('../model/supportModel');

// Longueurs maximales pour éviter les contenus démesurés / abusifs.
const MAX_SUBJECT = 120;
const MAX_DESCRIPTION = 4000;
const MAX_EMAIL = 120;
const MAX_REPORTER = 80;

// Types de signalement autorisés -> label GitHub associé (null = pas de label additionnel).
const CATEGORY_LABELS = {
  bug: 'bug',
  suggestion: 'evolution',
  question: 'besoin-info',
  autre: null,
};

// Libellés lisibles pour le corps de l'issue.
const CATEGORY_TEXT = {
  bug: 'Bug / Problème technique',
  suggestion: "Suggestion d'amélioration",
  question: 'Question',
  autre: 'Autre',
};

// Création d'un ticket de support (signalement d'un utilisateur final).
exports.createTicket = async (req, res) => {
  const { category, subject, description, email, reporter } = req.body;

  // --- Validation des champs obligatoires ---
  if (!subject || !subject.trim() || !description || !description.trim()) {
    return res
      .status(400)
      .json({ error: 'Le sujet et la description sont obligatoires.' });
  }

  const cleanSubject = subject.trim().slice(0, MAX_SUBJECT);
  const cleanDescription = description.trim().slice(0, MAX_DESCRIPTION);
  const cleanEmail = (email || '').trim().slice(0, MAX_EMAIL);
  const cleanReporter = (reporter || '').trim().slice(0, MAX_REPORTER);
  const categoryKey = Object.prototype.hasOwnProperty.call(CATEGORY_LABELS, category)
    ? category
    : 'autre';

  // Validation basique de l'email s'il est fourni.
  if (cleanEmail && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(cleanEmail)) {
    return res
      .status(400)
      .json({ error: "L'adresse email fournie n'est pas valide." });
  }

  // --- Construction du ticket (issue GitHub) ---
  const title = `[Utilisateur] ${cleanSubject}`;

  const bodyLines = [
    '### Signalement utilisateur',
    '',
    `**Type :** ${CATEGORY_TEXT[categoryKey]}`,
    cleanReporter ? `**Signalé par :** ${cleanReporter}` : null,
    cleanEmail
      ? `**Email de contact :** ${cleanEmail}`
      : '**Email de contact :** _non fourni_',
    '',
    '### Description',
    cleanDescription,
    '',
    '---',
    "_Ticket créé automatiquement depuis l'application mobile CESIZen._",
  ].filter(Boolean);

  // Labels : toujours user-report, + label de catégorie si pertinent.
  const labels = ['user-report'];
  if (CATEGORY_LABELS[categoryKey]) labels.push(CATEGORY_LABELS[categoryKey]);

  try {
    const issue = await SupportModel.createIssue({
      title,
      body: bodyLines.join('\n'),
      labels,
    });
    return res.status(201).json({
      message: 'Votre signalement a bien été transmis. Merci !',
      ticket: issue.number,
    });
  } catch (error) {
    console.error('Erreur lors de la création du ticket de support :', error.message);
    // 502 : le service en amont (GitHub) est en cause, pas la requête du client.
    return res
      .status(502)
      .json({ error: 'Impossible de transmettre le signalement pour le moment.' });
  }
};

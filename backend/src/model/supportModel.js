// Modèle Support : couche d'accès à la source de données externe (API GitHub).
// C'est ici qu'un signalement utilisateur est transformé en issue GitHub.
// Le token d'accès reste côté serveur (jamais exposé à l'application).

const GITHUB_API = 'https://api.github.com';

const SupportModel = {
  // Crée une issue GitHub à partir d'un signalement.
  // Retourne { number, url } en cas de succès, lève une erreur sinon.
  createIssue: async ({ title, body, labels }) => {
    const token = process.env.GITHUB_TOKEN;
    const repo = process.env.GITHUB_REPO;

    if (!token || !repo) {
      throw new Error('Configuration GitHub manquante (GITHUB_TOKEN / GITHUB_REPO).');
    }

    const response = await fetch(`${GITHUB_API}/repos/${repo}/issues`, {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${token}`,
        Accept: 'application/vnd.github+json',
        'Content-Type': 'application/json',
        'X-GitHub-Api-Version': '2022-11-28',
      },
      body: JSON.stringify({ title, body, labels }),
    });

    if (response.status !== 201) {
      const errorData = await response.json().catch(() => ({}));
      throw new Error(
        `Erreur API GitHub (${response.status}) : ${errorData.message || 'inconnue'}`
      );
    }

    const data = await response.json();
    return { number: data.number, url: data.html_url };
  },
};

module.exports = SupportModel;

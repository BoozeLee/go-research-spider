# Security Policy

## 🛡️ Supported Versions

| Version | Supported |
|---------|-----------|
| `main` | ✅ Active |
| Older   | ❌ Not supported |

## 🔒 Reporting a Vulnerability

**Please do NOT report security vulnerabilities via public GitHub Issues.**

If you discover a security vulnerability, please report it responsibly:

1. **Email:** [security@bakerstreetproject221b.store](mailto:security@bakerstreetproject221b.store)
2. **GitHub Private Advisory:** Use [GitHub's private security advisory feature](https://github.com/BoozeLee/go-research-spider/security/advisories/new)

### What to Include

- A description of the vulnerability
- Steps to reproduce the issue
- Potential impact assessment
- Any suggested fixes (optional)

### Response Timeline

- **Acknowledgement:** Within 48 hours
- **Initial Assessment:** Within 5 business days
- **Fix & Disclosure:** Coordinated with reporter

## 🚨 Known Security Considerations

### Crawling Ethics
This tool is designed for **authorized security research and data collection only**.

- Always obtain explicit permission before crawling any website
- Respect `robots.txt` directives
- Do not use this tool for unauthorized data collection, scraping, or attacks

### Secrets & Credentials
- Never hardcode API keys, tokens, or passwords in code
- Use environment variables or GitHub Actions Secrets
- Secrets are automatically scanned by GitHub Secret Scanning

### Dependency Security
- Dependencies are automatically scanned weekly via Dependabot
- govulncheck runs on every push to `main`
- pip-audit checks Python dependencies on every push

## 🔐 Security Best Practices for Contributors

1. **No hardcoded secrets** — Use environment variables
2. **Validate all inputs** — Especially URLs before crawling
3. **Pin action versions** — Use SHA pins for GitHub Actions
4. **Run security checks locally** before pushing:
   ```bash
   # Go
   gosec ./...
   govulncheck ./...

   # Python
   pip-audit -r requirements.txt
   ```

---

*Maintained by [Bakertreet Labs](https://github.com/Bakery-street-project)*

React apps build into static files (HTML/JS/CSS) instead of a backend service, you need to:

In the repo is a standard production-ready Dockerfile for a React app (serving via NGINX)
✅ This ensures your React app is bundled and served via NGINX.
✅ This exposes your React frontend via a LoadBalancer service.

OWASP ZAP DAST
Since React is frontend-only, OWASP ZAP will scan your deployed UI for vulnerabilities (XSS, misconfigurations, etc.).
That works fine — just keep in mind there’s no backend API in this setup unless you deploy one alongside.

🚀 Workflow Recap for React

Build React → Dockerize with NGINX

Push to GHCR

Deploy to AKS

Run Gitleaks, Semgrep, Trivy, Checkov ✅

Run OWASP ZAP DAST against the React frontend ✅

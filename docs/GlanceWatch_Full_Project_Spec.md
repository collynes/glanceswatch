
# Glances-Kuma-Alerts / GlanceWatch — Full Project Specification & GA Package
**Comprehensive, single-file project blueprint** — includes justification, architecture, API, UI, implementation details, code snippets, Docker/systemd, CI/CD, distribution and release checklist ready for GitHub.

---

## Table of Contents
1. Executive Summary & Justification
2. Goals & Non-goals
3. High-level Architecture
4. Functional Specification (Endpoints & Behavior)
5. Configuration Model (env, YAML)
6. Lightweight UI Design (full details)
7. Implementation Plan (code layout, libraries, examples)
8. Security & Hardening
9. Testing Strategy & CI/CD
10. Performance & Resource Targets
11. Distribution & Packaging (Docker, PyPI, system packages)
12. Developer Experience (contrib guide, templates)
13. Release / GA Checklist
14. Roadmap & Future Features
15. Example Quickstart (commands)
16. Example Files (Dockerfile, systemd, main.py, monitor.py)
17. Licensing & Community
18. Appendix: Sample JSON Responses & Kuma Examples

---

# 1. Executive Summary & Justification
**Project names:** `glances-kuma-alerts` (technical) / **GlanceWatch** (marketing-friendly)

**Problem:** Glances provides system metrics; Uptime Kuma monitors endpoints — but Kuma cannot evaluate numeric thresholds inside JSON. Users must either add external tooling or hack around keyword checks.

**Solution:** A small, reliable adapter service that:
- reads Glances API (or other collectors),
- evaluates configurable thresholds (RAM, CPU, Disk, Network),
- exposes simple Kuma-friendly boolean JSON endpoints and a lightweight UI for configuration,
- can be deployed via Docker or systemd,
- optionally exports Prometheus metrics for dashboards.

**Why this is valuable:**
- Fast adoption: no fork of Kuma or Glances required.
- Accessibility: low-footprint component for 1GB VPSes and hobbyists.
- Extensibility: add more metrics, exporters, UIs later.

---

# 2. Goals & Non-goals

## Goals (v1 GA)
- RAM, CPU, Disk threshold checks (percent-based)
- Single binary / Docker image + systemd service option
- FastAPI-based HTTP API endpoints: `/status`, `/ram`, `/cpu`, `/disk`, `/health`, `/metrics` (optional)
- Lightweight UI to configure thresholds (Vue or Svelte front-end served from the same service)
- Kuma compatibility: endpoints return boolean keys so Kuma can use Keyword monitoring
- Documentation, Docker image, example systemd file, CI pipeline

## Non-goals (v1)
- Long-term historical storage (beyond simple logs)
- Full enterprise-grade authentication/SSO (only basic auth/token supported)
- Complex rule engine (only simple threshold expressions; advanced rule DSL later)

---

# 3. High-level Architecture
```
[Glances (local)] -> HTTP JSON -----------------> [GlanceWatch/Adapter Service] -> returns boolean JSON endpoints -> [Uptime Kuma]
                                                      │
                                                      ├-> Lightweight UI (served by service) for thresholds
                                                      └-> Optional Prometheus metrics endpoint -> Grafana 
```
Design notes:
- Service is stateless by default with optional local persistence for thresholds (JSON or SQLite).
- Integration point is the Glances HTTP API by default, but adapters can be added for Netdata, Node Exporter, or local /proc reads.

---

# 4. Functional Specification

## Endpoints (v1)
- `GET /status` — aggregated boolean summary + details
- `GET /ram` — per-RAM check
- `GET /cpu` — per-CPU check
- `GET /disk` — per-disk checks
- `GET /health` — service health (200/503) and basic diagnostics
- `GET /metrics` — raw Glances JSON passthrough (optional)
- `GET /metrics/prom` — Prometheus metrics (optional)
- `GET /ui` and front-end assets — lightweight UI for thresholds

### Expected JSON responses (examples)
`/status`:
```json
{
  "ok": true,
  "ram_ok": true,
  "cpu_ok": true,
  "disk_ok": true,
  "details": {
    "ram_percent": 63.1,
    "cpu_percent": 12.3,
    "disk": [{"mount":"/","percent":67}]
  }
}
```
`/ram`:
```json
{"ram_ok":true,"ram_percent":63.1,"total_mb":914}
```

### Behavior rules
- `ok` is true only when all monitored metrics pass their thresholds.
- When Glances is unreachable, service returns `ok:false` and relevant metric keys set to false or null depending on `RETURN_HTTP_ON_FAILURE` config.
- By default return `HTTP 200` with `ok:false` to allow Kuma keyword matching; make `RETURN_HTTP_ON_FAILURE=503` optional for operations expecting non-200 on failure.
- Keyword for Kuma: either `"true"` or `"ok": true` — instructions will recommend `"true"` as simplest option.

---

# 5. Configuration Model

## Environment variables (recommended for Docker)
```
API_HOST=0.0.0.0
API_PORT=5000
GLANCES_MEM_URL=http://localhost:61208/api/3/mem
GLANCES_CPU_URL=http://localhost:61208/api/3/cpu
RAM_THRESHOLD_PERCENT=80
CPU_THRESHOLD_PERCENT=90
DISK_THRESHOLD_PERCENT=90
RETURN_HTTP_ON_FAILURE=200   # or 503
AUTH_ENABLED=false
AUTH_USER=admin
AUTH_PASS=secret
LOG_LEVEL=info
PROMETHEUS_ENABLED=false
```
## YAML config (optional)
`config.yml` example included in repo for people who prefer files.
Precedence order: Environment Variables > CLI Flags > config.yml defaults.

Persistence: thresholds saved to `~/.glancewatch/config.json` or SQLite at `/var/lib/glancewatch/db.sqlite` (if enabled).

---

# 6. Lightweight UI — Full Design & Implementation

## Goals
- Make threshold configuration accessible to non-devs
- Keep UI tiny (single-page app < 300 KB bundled)
- No heavy frontend frameworks unless necessary; prefer Svelte for minified size or Vue with CDN build
- Allow quick visual confirmation of current metrics and thresholds

## UI Features
- Home dashboard: current system metrics (pulled from `/metrics`) and threshold comparison
- Threshold editor: sliders and numeric inputs for RAM, CPU, Disk per-mount
- Rule presets: "Default", "Conservative", "Aggressive"
- Save/Load profiles (local JSON)
- Test button: "Run check now" (calls `/status`) with visual green/red result
- Authentication prompt (if enabled) for changes
- Small Help / About section with Kuma integration steps

## UX Flow
1. User opens UI (served at `http://host:5000/ui`)
2. Current metrics show in small tiles (CPU, RAM, Disk)
3. User adjusts slider for RAM, e.g. 80% → Save
4. Backend persists thresholds and uses them on the next poll
5. User clicks "Test now" to confirm alert state

## Implementation choices
- **Frontend**: Svelte (recommended) or Vue 3 with Vite for dev; build artifacts served by FastAPI static files directory.
- **Communication**: Frontend calls REST endpoints `/api/v1/thresholds` (GET/POST) and `/status` for live preview.
- **Storage**: thresholds persisted in JSON or SQLite through backend endpoints; UI does not write files directly.
- **Accessibility**: keyboard accessible, basic ARIA attributes, mobile responsive.

## Security considerations for UI
- UI should be disabled or require auth if `AUTH_ENABLED=true` or `BIND_ADDRESS` is `0.0.0.0` and `AUTH_ENABLED=false` – show clear warning.
- Use CSRF tokens for mutating endpoints if you add session-based auth later.
- Optionally serve UI only on `127.0.0.1` and recommend SSH tunnel for remote management.

---

# 7. Implementation Plan (detailed)

## Tech stack (v1)
- Python 3.11+
- FastAPI (HTTP + static files)
- httpx (async HTTP client)
- uvicorn (ASGI server)
- pydantic (config & schemas)
- Svelte for UI (or Vue for familiarity)
- Docker for packaging
- pytest for tests

## Project layout
```
glances-kuma-alerts/
├─ app/
│  ├─ main.py              # FastAPI app & routes
│  ├─ monitor.py           # fetch & threshold logic
│  ├─ config.py            # env & yaml loader
│  ├─ api/                 # REST endpoints for UI
│  │  ├─ thresholds.py
│  │  └─ health.py
│  ├─ ui/                  # built frontend (static)
│  ├─ auth.py              # basic auth middleware
│  └─ prometheus.py        # optional metrics exporter
├─ docker/
│  └─ Dockerfile
├─ systemd/
│  └─ glancewatch.service
├─ web-ui/                 # frontend source (Svelte)
├─ tests/
└─ README.md
```
## Core logic (monitor.py)
- `async def fetch_glances(url)` with timeout, retries
- Normalization helpers: bytes → MB, ensure percent present
- `def evaluate_thresholds(metrics, thresholds)` returns dict of booleans + details
- Circuit breaker: if repeated Glances failures occur, mark health degraded

## API Routes
- `/api/v1/thresholds` (GET/POST) — manage thresholds
- `/api/v1/status` — same as `/status`, used by UI
- `/api/v1/metrics` — raw metrics passthrough (optional)
- Static files served at `/ui/`

## Persistence
- Minimal: JSON file under `/var/lib/glancewatch/config.json` or `~/.config/glancewatch/config.json`
- Optional DB: SQLite for profiles, audit trail

---

# 8. Security & Hardening (detailed)
- Default bind: `127.0.0.1`. Only when `BIND_ALL=true` will it bind to `0.0.0.0` (and then require AUTH).
- Basic Auth via HTTP Basic (configurable `AUTH_USER`/`AUTH_PASS`)
- Recommend placing behind a reverse proxy (nginx, Traefik, Caddy) with TLS and optional client certs
- Rate-limit mutating endpoints
- Input validation with pydantic for all inbound data
- Do not log secrets; redact passwords from logs
- Recommend running as unprivileged user (`glancewatch`), not root
- Security policy file `SECURITY.md` with disclosure contact

---

# 9. Testing Strategy & CI/CD
- Unit tests (pytest) for monitor and config layers
- Integration tests:
  - Start a test FastAPI instance with mocked Glances endpoints (use httpx mocking)
  - Test endpoints `/status`, `/ram`, UI endpoints
- E2E smoke test in CI: build Docker image, run container, call `/status`
- GitHub Actions workflow:
  - Lint (ruff/flake8), format check (black)
  - Run unit tests
  - Build Docker image and run smoke test
  - Publish to GHCR on release
- Code coverage goal: 80%+

---

# 10. Performance & Resource Targets
- Target idle memory usage < 50 MB
- CPU minimal (async, non-blocking)
- Response time < 200ms for `/status` under normal load
- Poll Glances at a configurable interval (default 15s). Kuma poll interval independent (set by user).

---

# 11. Distribution & Packaging

## Docker (primary)
- Publish image to GHCR (`ghcr.io/<org>/glancewatch:1.0.0`)
- Tags: `latest`, `vX.Y.Z`
- Small base image: `python:3.12-slim` or `python:3.11-alpine` if compatibility tested

## Python Package (optional)
- `pip install glancewatch`
- Console entrypoint `glancewatch` that launches uvicorn with default settings

## System Packaging (optional)
- Debian package for apt-based servers, Homebrew tap for macOS

## Kubernetes & Helm (future)
- Helm chart with values for Glances URL, thresholds, persistence, and RBAC

---

# 12. Developer Experience & Contribution Docs

Essential repo files:
- `CONTRIBUTING.md` — how to run tests, style, PR expectations
- `CODE_OF_CONDUCT.md` — Contributor Covenant
- `SECURITY.md` — vulnerability reporting
- `ISSUE_TEMPLATE.md` and `PULL_REQUEST_TEMPLATE.md`
- `CHANGELOG.md` — keep semantic versioning

PR checklist:
- Add tests for new logic
- Update README and docs where feature changes behavior
- Lint and format (pre-commit hooks: black, ruff)

---

# 13. Release / GA Checklist (detailed)

Pre-release
- [ ] All core endpoints implemented & documented
- [ ] Unit & integration tests passing
- [ ] Docker image builds & smoke tests run
- [ ] README & Quickstart complete
- [ ] LICENSE & CODE_OF_CONDUCT present
- [ ] Security disclosure instructions included

GA release steps
1. Tag `v1.0.0`
2. Create GitHub release with notes and changelog
3. Push Docker image to GHCR/DockerHub
4. Publish PyPI package (optional)
5. Announce on channels (r/selfhosted, Uptime Kuma community, Glances project)

---

# 14. Roadmap & Future Features

- v1.1: Swap & network thresholds, alert grouping
- v1.2: Prometheus metrics + Grafana dashboard
- v1.3: Historical storage + /history API
- v2.0: Web UI for multiple hosts & aggregation, Kubernetes operator

---

# 15. Quickstart Examples

### Run with Docker (simple)
```bash
docker run -d --name glancewatch \
  -p 5000:5000 \
  -e GLANCES_MEM_URL=http://host.docker.internal:61208/api/3/mem \
  -e RAM_THRESHOLD_PERCENT=80 \
  ghcr.io/yourorg/glancewatch:latest
```
### Run locally (dev)
```bash
git clone https://github.com/yourorg/glancewatch.git
cd glancewatch
pip install -r requirements.txt
uvicorn app.main:app --host 127.0.0.1 --port 5000 --reload
```
### Uptime Kuma monitor
- URL: `http://<server-ip>:5000/status`
- Keyword: `"true"`

---

# 16. Example Files (ready-to-paste)

## Dockerfile (app directory)
```dockerfile
FROM python:3.12-slim
WORKDIR /app
COPY ./app /app/app
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt
EXPOSE 5000
ENV API_HOST=0.0.0.0
ENV API_PORT=5000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "5000"]
```

## systemd service (`systemd/glancewatch.service`)
```ini
[Unit]
Description=GlanceWatch - Glances to Kuma thresholds adaptor
After=network.target

[Service]
User=glancewatch
Group=glancewatch
WorkingDirectory=/opt/glancewatch
ExecStart=/usr/bin/env python3 -m uvicorn app.main:app --host 127.0.0.1 --port 5000
Restart=on-failure
RestartSec=5
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
```

## Minimal `app/main.py`
```python
# app/main.py
from fastapi import FastAPI
from app.monitor import get_status_sync

app = FastAPI(title="GlanceWatch")

@app.get("/status")
async def status():
    return await get_status_sync()
```
*(Full async implementation recommended — this snippet is minimal for demo.)*

## Minimal `app/monitor.py` (async)
```python
# app/monitor.py
import httpx
import os
from typing import Dict
GLANCES_MEM = os.getenv("GLANCES_MEM_URL", "http://localhost:61208/api/3/mem")
RAM_THRESHOLD = int(os.getenv("RAM_THRESHOLD_PERCENT", "80"))

async def fetch_json(url: str, timeout: float = 3.0) -> Dict:
    async with httpx.AsyncClient(timeout=timeout) as client:
        r = await client.get(url)
        r.raise_for_status()
        return r.json()

async def check_ram() -> Dict:
    try:
        data = await fetch_json(GLANCES_MEM)
        percent = float(data.get("percent", 0))
        return {"ram_ok": percent < RAM_THRESHOLD, "ram_percent": percent}
    except Exception as e:
        return {"ram_ok": False, "ram_percent": None, "error": str(e)}

async def get_status_sync() -> Dict:
    ram = await check_ram()
    # stub cpu check - implement similarly
    cpu = {"cpu_ok": True, "cpu_percent": 0.0}
    ok = bool(ram.get("ram_ok")) and bool(cpu.get("cpu_ok"))
    return {"ok": ok, **ram, **cpu, "details": {"ram_percent": ram.get("ram_percent")}}
```

---

# 17. Licensing & Community
- Recommended license: **MIT** for permissive adoption (or Apache-2.0 if you want patent grant)
- Include `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md`
- Set up GitHub Discussions for community Q&A and roadmap

---

# 18. Appendix: Sample Glances JSON & Kuma examples

**Sample Glances mem JSON (`/api/3/mem`)**:
```json
{
  "total": 958521344,
  "available": 353501184,
  "percent": 63.1,
  "used": 605020160,
  "free": 353501184,
  "active": 457863168,
  "inactive": 208273408,
  "buffers": 17027072,
  "cached": 446013440,
  "shared": 15048704
}
```

**Kuma monitor example**:
- URL: `http://YOUR_HOST:5000/status`
- Keyword: `"true"` (or check for `"ok": true` in the response)

---

## Contact & Next Steps
- If you want, I can generate a GitHub-ready repository tree with all files (code, Dockerfile, README.md, systemd, frontend scaffold) and package it as a zip you can download and push to GitHub. Tell me and I will produce the full repo contents and a downloadable archive now.

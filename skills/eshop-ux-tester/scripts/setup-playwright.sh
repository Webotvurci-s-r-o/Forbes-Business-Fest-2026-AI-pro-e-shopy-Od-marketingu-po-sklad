#!/usr/bin/env bash
# setup-playwright.sh
# Ensures Playwright is installed and ready for eshop-ux-tester.
# Installs into ux-testing/.playwright/ (workspace-local, not global).
# Skips install work if setup completed within the last 30 days.

set -euo pipefail

WORKSPACE="ux-testing/.playwright"
MARKER="$WORKSPACE/.setup-complete"
MAX_AGE_DAYS=30

log() { printf '[setup-playwright] %s\n' "$*"; }
fail() { printf '[setup-playwright] ERROR: %s\n' "$*" >&2; exit 1; }

# 1. Node.js check
if ! command -v node >/dev/null 2>&1; then
    fail "Node.js nenalezen. Nainstaluj Node.js 18+ (https://nodejs.org) a spusť skill znovu."
fi
NODE_MAJOR=$(node --version | sed 's/^v//' | cut -d. -f1)
if [ "$NODE_MAJOR" -lt 18 ]; then
    fail "Máš Node.js $(node --version), potřebuješ ≥ 18."
fi
log "Node.js $(node --version) ✓"

# 2. Skip if recent setup marker exists
if [ -f "$MARKER" ]; then
    MARKER_AGE_DAYS=$(( ( $(date +%s) - $(stat -f %m "$MARKER" 2>/dev/null || stat -c %Y "$MARKER") ) / 86400 ))
    if [ "$MARKER_AGE_DAYS" -lt "$MAX_AGE_DAYS" ]; then
        log "Setup hotový před $MARKER_AGE_DAYS dny, přeskakuju instalaci."
        exit 0
    fi
fi

# 3. Prepare workspace
mkdir -p "$WORKSPACE"
cd "$WORKSPACE"

# 4. Minimal package.json if missing
if [ ! -f package.json ]; then
    cat > package.json <<'EOF'
{
  "name": "eshop-ux-tester-workspace",
  "version": "1.0.0",
  "private": true,
  "type": "module",
  "description": "Isolated Playwright workspace for eshop-ux-tester skill."
}
EOF
    log "Vytvořen workspace package.json"
fi

# 5. Install playwright if missing or outdated
if [ ! -d node_modules/playwright ]; then
    log "Instaluji playwright (může trvat minutu)…"
    npm install --no-audit --no-fund playwright@latest
else
    log "playwright už nainstalovaný, zkouším update…"
    npm install --no-audit --no-fund playwright@latest || log "Update selhal, pokračuju se stávající verzí."
fi

# 6. Install browser binaries (chromium for desktop + Pixel, webkit for iPhone)
log "Stahuji browser engines (chromium, webkit)…"
npx playwright install chromium webkit

# 7. Write marker
touch .setup-complete
log "Setup dokončen ✓"

# DEV_RULES.md — Technická pravidla pro eshop-ux-tester

This file captures the technical rules and constraints every agent in this skill must follow. If you're the Orchestrator or a persona-tester subagent, read this before touching any tool.

## 1. Playwright is the only browser tool. No exceptions.

Shoptet (and similar CZ e-commerce CMSs) override CSS and JS so aggressively that any static fetch (`curl`, `fetch`, `urllib`, `requests`, `wget`, HTTP-only scrapers) will return markup that doesn't match what a real user sees. Prices, availability, cart widgets, pop-ups, GDPR banners, variant selectors — all of those are client-rendered.

**Rule:** every single observation about the eshop must come from Playwright in headed or headless mode. If you catch yourself reaching for `curl`, stop.

**Acceptable tools:** Playwright (via `playwright` npm package driven from Node.js scripts). Nothing else.

**Required permissions in Claude Code `.claude/settings.local.json`** (or global `~/.claude/settings.json`):

```json
{
  "permissions": {
    "allow": [
      "Bash(node:*)",
      "Bash(mkdir:*)",
      "Bash(chmod:*)",
      "Bash(ln:*)",
      "Bash(bash /abs/path/to/skill/scripts/*)"
    ]
  }
}
```

Without `Bash(node:*)` the skill cannot run any Playwright script and must hard-stop at the Phase 1 preflight check. See SKILL.md Phase 1 action 2 for the preflight message.

---

## 2. Setup

Before Phase 1 crawl, the Orchestrator must verify Playwright is available.

Run `scripts/setup-playwright.sh`. It does:

1. Checks `node --version` (≥ 18). If missing → stop and tell the user to install Node.js 18+.
2. Checks `ux-testing/.playwright/node_modules/playwright`. If not present → `cd ux-testing/.playwright && npm install playwright@latest`.
3. Runs `npx --prefix ux-testing/.playwright playwright install chromium webkit` (need both — webkit for iOS Safari accuracy).
4. Writes `ux-testing/.playwright/.setup-complete` with timestamp.

If the setup already completed within the last 30 days, skip steps 2–3 to save time.

**Install is local to the skill workspace, not global.** This avoids polluting the user's global npm and keeps installs reproducible.

---

## 3. Device profiles

Use Playwright's built-in device emulation where possible (`devices['iPhone 14 Pro']`), and fall back to explicit viewport + UA when the preset is missing. Supported default profiles:

| Label              | Viewport      | Touch | UA / Browser engine                         |
|--------------------|---------------|-------|---------------------------------------------|
| iPhone 14 Pro      | 393×852       | yes   | WebKit (mobile Safari)                      |
| Pixel 7            | 412×915       | yes   | Chromium (mobile Chrome)                    |
| Desktop 1920×1080  | 1920×1080     | no    | Chromium                                    |
| Laptop 1366×768    | 1366×768      | no    | Chromium                                    |

Custom profiles (user-requested) must at minimum define: viewport, user-agent, touch enabled/disabled, deviceScaleFactor.

**Each persona gets an isolated browser context** (not just a new page in the same browser). This means cookies, localStorage, and session are per-persona.

---

## 3a. Shoptet selector tips (empirical)

These are footguns observed during real Shoptet crawls — patch them in your scripts:

- **`.product-name` selector leaks button text.** Shoptet's product tile uses `.product-name` for the title and also renders a `Detail` action link near it; a loose query picks up both. Filter in your script: `names.filter(n => n && !/^Detail$/i.test(n.trim()))`.
- **Product-tile anchor discovery is brittle.** Shoptet category pages don't expose predictable class names on tile links. A reliable fallback locator is the "Detail" anchor text — `page.locator('a:has-text("Detail")').first()`.
- **Homepage frequently has no `<h1>`.** Don't fail your crawl on missing H1 — capture H2/H3 headings and the `og:title` meta as a fallback.
- **Sub-pages may use the fallback title `"Můj e-shop"`** (template default not overridden). That's itself a UX observation — flag it.
- **Cookie consent covers the whole viewport on first visit** — take your first screenshot BEFORE accepting cookies (to capture the as-seen-by-real-user state), THEN observe & accept.
- **`mkdir -p` via Bash may be blocked by permission matchers even with `Bash(mkdir:*)` allowed** — the flag-with-path pattern sometimes doesn't match. Workaround: create dirs from Node: `require('fs').mkdirSync(path, { recursive: true })`. Scripts in this skill do this already.

---

## 4. Handling common Shoptet / CZ-eshop friction

Personas WILL hit these. Handle them in character (they are themselves UX observations):

- **Cookie consent banner** — document which categories the persona clicks ("Přijmout vše" / "Nezbytné" / "Nastavení"). **Note, but don't automate-click** through without observation. Real users find this annoying; capture that.
- **GDPR newsletter popup** — capture that it appeared, what it asked for, whether the close button was obvious.
- **Age verification** (e-lékárny, alkohol) — if present, handle in character (pass if adult persona; note that a child persona wouldn't be expected here).
- **Live-chat widget popping up** — common in Shoptet plugins. Document that it appeared and whether it blocked interaction.
- **Add-to-cart modal** — Shoptet often shows a "Přidáno do košíku" modal with cross-sells. Document behavior.
- **Heureka "Ověřeno zákazníky" banner / Chránit nákup** — document visibility; this is a trust signal.

When a banner or modal blocks interaction, the persona's FIRST reaction is to observe and note it. Only THEN dismiss to continue the journey. Don't suppress pop-ups programmatically — that defeats the purpose.

---

## 5. Screenshot discipline

Capture screenshots at these moments:
- First impression of homepage (above-the-fold)
- Any time a persona hits a friction point worth documenting
- Category/search results page
- PDP
- Cart
- Each step of checkout
- Final state (thank-you page for Buyer; pre-submit state for others)

File naming: `screenshots/<persona-slug>/<NN>-<short-label>.png`, where NN is a zero-padded sequence.

Full-page screenshots preferred for content-heavy pages (category, PDP, cart). Viewport-only fine for modals and transient friction.

---

## 6. Test data policy

When personas fill forms (checkout):
- **Email:** `test+<persona-slug>@<eshop-domain-with-hyphens>` — e.g., `test+barbora-k@mujeshop-cz.cz`. Never use a real human's email.
- **Telefon:** `+420 777 000 000` (or a variant persona might type — real personas make realistic typos; note any related validation).
- **Adresa:** plausibly real (persona's stated city + a plausible street). Don't use a real person's address. Generic apartment numbers.
- **Jméno:** from persona definition.
- **Poznámka k objednávce (Designated Buyer ONLY):** must contain `TEST OBJEDNÁVKA — prosím ignorovat` exactly. This is how the shop owner knows to cancel.

---

## 7. The one-order rule

Only **one** order may be submitted per full test run. That's the Designated Buyer.

**Safeguards:**
- Before any persona clicks "Odeslat objednávku", the persona subagent must check whether it is the Designated Buyer. If `is_buyer: false`, the subagent MUST NOT click that button, regardless of what seems natural in character.
- The Designated Buyer subagent checks that the order note contains the test string before clicking submit.
- After submit, the Designated Buyer STOPS. Does not retry, does not navigate elsewhere, does not "try another purchase".

---

## 8. Concurrency & rate limiting

All personas browse in parallel (separate browser contexts, separate subagents). But that means the eshop gets **N simultaneous real visitors** from the same IP.

- Default N = 4 is fine for most shops.
- If the user warns the shop is on a fragile hosting / has anti-bot → back off to sequential (but tell user this doubles the wall-clock time).
- Insert small `waitForTimeout(500-2000ms)` between actions within each persona's script to simulate real human rhythm and avoid rate limits.
- Respect `robots.txt` if it explicitly disallows the path — report to user and stop.

---

## 9. No dark patterns in personas

Personas must not:
- Use obviously fake payment info and attempt real card processing (even in test environments)
- Attempt SQL injection, XSS, or other security tests — this skill is for UX, not pentesting
- Crawl admin URLs or attempt unauthorized access
- Scrape product data **at scale** for competitive intelligence purposes (i.e., don't iterate every URL under `/produkty/` to build a price DB)

What IS allowed: Phase 1 discovery crawl of a shop you have permission to test (≥5 representative URLs — homepage, a few categories, a PDP or two, an info page) to observe UX for the shop owner's benefit. That's the job; it's not what §9 bans.

---

## 10. Output file writing

- Each persona writes to their own markdown file. The subagent must not touch other personas' files.
- The Orchestrator writes `raw-crawl.json`, `personas.json`, and `SUMMARY.md`. Subagents don't.
- All files UTF-8. Czech diacritics preserved.
- Markdown uses standard CommonMark; no GitHub-specific extensions that would break other renderers.

---

## 11. Error handling

- If a page doesn't load (timeout, 500, network error): persona notes it as a critical observation and attempts retry ONCE. If still failing, document and move to next step.
- If a selector expected to exist doesn't (e.g., "Přidat do košíku" button missing): persona tries two alternative strategies (role-based, text-based, visual) before flagging as a blocker.
- If Playwright crashes entirely: subagent reports failure to Orchestrator with last-known step; Orchestrator marks that persona as "⚠️ částečně" in status update.

---

## 12. What to do if Shoptet returns non-CZ language

If the crawled eshop is clearly in Slovak, or has EN variant, adapt:
- Personas speak the primary language of the shop.
- Journey step names (headings in reports) remain Czech (that's what the Czech user who ordered the test reads).
- Product names / copy excerpts appear in the original language.

---

## 13. Respect for shop owner

This skill is often run BY the shop owner ON THEIR OWN shop. But it can also be run on competitors or during due-diligence. Regardless:

- Always obvious test-markers in submitted data.
- One order max.
- No server-harming patterns.
- If asked to test a shop the user doesn't own, confirm once: "Testuju `domena.cz`. Máš povolení toto dělat (je to tvůj eshop, nebo máš souhlas vlastníka)?" Pokud uživatel odpoví "ne" → stop.

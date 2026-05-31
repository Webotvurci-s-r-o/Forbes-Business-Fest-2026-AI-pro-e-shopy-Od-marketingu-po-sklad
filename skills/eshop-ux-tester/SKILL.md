---
name: eshop-ux-tester
description: Runs simulated user-testing of an e-commerce site using 4+ tailored personas that browse the shop in parallel via Playwright (desktop + mobile), then synthesizes their observations into a UX report. Use this skill whenever the user asks for user testing, UX review, persona-based testing, eshop feedback, conversion audit, or wants outside perspectives on their shop, especially for Shoptet stores. The skill is designed for Shoptet CMS where CSS/JS overrides prevent static scraping — Playwright is mandatory.
triggers:
  - ux test
  - uživatelské testování
  - persona test
  - eshop test
  - user testing
  - conversion review
  - uxový audit eshopu
version: 1.0.0
author: skills-marketplace
---

# Skill: eshop-ux-tester

You are the **Orchestrator** of a simulated user-testing workflow for e-commerce sites. Four (or more) eshop-specific personas will browse the shop in parallel via Playwright — each with their own viewport, motivations, and anxieties — and you will synthesize their observations into a UX report.

This skill is built for **Shoptet** stores (Czech/Slovak e-commerce CMS) where aggressive CSS/JS overrides make static scraping unreliable. Playwright is therefore the only acceptable tool.

All user-facing output, persona dialogue, and reports are **in Czech**. Internal instructions and code remain in English.

## CRITICAL RULES

1. **NEVER skip a [HITL PAUSE].** Two pauses are mandatory: after persona proposal, and after final report. The user must explicitly approve before continuing.
2. **Personas must be tailored to the specific eshop you are testing.** Before proposing personas, you MUST crawl the shop (see Phase 1) to understand what it sells, for whom, and at what price point. Generic archetypes like "price-sensitive shopper" are forbidden — give each persona a name, age, occupation, concrete motivation, and real reason they landed on *this* shop.
3. **Only one real order may be submitted per run.** The persona designated as the "Buyer" (see JOURNEYS.md) goes through full checkout and submits once with `TEST OBJEDNÁVKA — prosím ignorovat` in the order note. All other personas must stop before the submit button.
4. **Guest purchases only** unless the user explicitly asks for logged-in flows.
5. **Playwright is mandatory.** Never use `curl`, `fetch`, `requests`, or any static scraper. Shoptet's client-side overrides will give misleading results.
6. **Each persona runs as its own subagent in parallel.** Spawn all persona subagents in a single turn (multiple Agent tool calls in one message). See AGENTS.md.
7. **Read the supporting files.** Before Phase 1 starts, load `PERSONAS.md`, `JOURNEYS.md`, `DEV_RULES.md`, and `AGENTS.md`. They contain rules you must follow.

---

## Output Directory

All output goes to:

```
ux-testing/<eshop-domain>/<YYYY-MM-DD-HHMM>/
├── personas/
│   ├── <persona-slug>.md           # full feedback from each persona
│   └── ...
├── screenshots/
│   └── <persona-slug>/              # screenshots captured during the run
├── raw-crawl.json                   # Phase 1 discovery data
├── personas.json                    # approved persona definitions (for re-tests)
└── SUMMARY.md                       # final aggregated report
```

`<eshop-domain>` is the **full hostname** with dots replaced by hyphens (no scheme, no path). Lowercase. Keep subdomains — they distinguish dev from prod. Examples: `mujeshop-cz`, `www-eshop-motolety-cz`, `748896-myshoptet-com`, `shop-example-com`. Details in Phase 1 action 3.

If previous runs for this domain exist, list them in Phase 1 and offer **Re-Test Mode** (see Phase 5).

---

## Phase 1: Discovery & Persona Proposal

**Trigger:** Skill is invoked.

**Actions:**

1. **Collect input.** Ask the user for:
   - Eshop URL (required)
   - Any context they want to share: target audience, known issues, specific concerns, recent changes, campaigns running
   - Number of personas (default: 4)
   - Device mix (default: 2× mobile + 2× desktop — iPhone 14 Pro, Pixel 7, Desktop 1920×1080, Laptop 1366×768). **Keep this default unless the user asks to change it.** If the crawl reveals something that tempts you to deviate (e.g., "this persona feels like they'd be on a Mac with Safari"), resist — note it in the persona's `browser` field if needed, but keep the 2-mobile/2-desktop split.
   - Whether this is a first test or a re-test of a previously tested eshop

2. **Preflight: check that `node` is executable.** Run `node -e "console.log('node-ok')"` via Bash. If it fails with a permission error, STOP immediately and tell the user:

   > "Tvoje Claude Code prostředí blokuje spouštění `node`. Bez toho nedokážu pustit Playwright, bez kterého tenhle skill nemá jak pozorovat eshop (Shoptet client-side rendering). Prosím přidej do `.claude/settings.local.json` (nebo globálního settings.json) do `permissions.allow`:
   > - `\"Bash(node:*)\"` — spouštění node skriptů pro Playwright
   > - `\"Bash(mkdir:*)\"` — vytváření výstupních adresářů
   > - `\"Bash(bash /path-to-skill/scripts/*)\"` — trusted wrappery
   >
   > Jakmile to přidáš, spusť skill znovu."
   
   Nepokračuj k dalším krokům. Tohle je hard-stop.

3. **Determine the domain-slug for output paths.** Lowercase the eshop hostname (strip scheme + path + trailing slash), replace dots with hyphens. Examples:
   - `https://mujeshop.cz/` → `mujeshop-cz`
   - `https://www.eshop.motolety.cz/produkty` → `www-eshop-motolety-cz`
   - `https://748896.myshoptet.com/` → `748896-myshoptet-com`
   - `https://shop.example.com/cs/` → `shop-example-com`
   
   This avoids collisions between a main eshop and its dev/staging subdomains on the same TLD.

4. **Check for previous runs.** Look in `ux-testing/<domain-slug>/`. If previous dated folders exist (e.g., `2026-03-14-0930/`, `2026-04-02-1500/`), list them like:
   ```
   Našel jsem 2 předchozí běhy pro tento eshop:
   - 2026-04-02-1500 (18 dní zpět)
   - 2026-03-14-0930 (37 dní zpět)
   ```
   Ask: Nový test, nebo Re-test s personami z [nejnovější]?

5. **Set up Playwright.** Run `scripts/setup-playwright.sh`. First time this takes ~2 min (download ~300 MB). Subsequent runs detect the marker file and return in under a second. If it fails, stop and report exactly why (missing Node? network?) and how to fix.

6. **Crawl the eshop for persona generation context.** Using Playwright, visit **at least 5 distinct URLs**:
   - Homepage (1)
   - 2+ top-level category pages (pick visually/linguistically distinct ones)
   - 1+ product detail page (pick a product that seems representative — not the first one on the homepage; something that reflects the shop's bread-and-butter)
   - 1+ info page: `/o-nas`, `/kontakt`, `/obchodni-podminky`, or whatever the shop uses for trust signals (company story, contact info, IČO, shipping/returns policy)
   
   The footer is inspected on every page as metadata — it's not a separate URL visit.
   
   For each URL, capture: page title, H1/H2 headings, dominant product types, visible price range, trust signals (reviews count, certifications, "od roku XXXX", Heureka/Zboží badge), tone of copy (casual/formal/technical), apparent target audience cues, any pop-ups (cookie banner, newsletter, GDPR). Save to `raw-crawl.json` with one entry per URL.

7. **If crawl is impossible** (permission-blocked as in step 2, URL permanently down, or Shoptet returns error): STOP. Do NOT generate fallback personas from domain knowledge alone — that's explicitly forbidden by PERSONAS.md's grounding rule. Tell the user what happened and what to fix. Only exception: if user explicitly opts in to "provisional personas" mode during the conversation, you may generate personas from user-provided context + category knowledge, BUT you MUST (a) mark every persona JSON with `"provisional": true`, (b) prefix the Phase 1 output with a prominent blocker notice, (c) recommend re-running once the crawl is possible. The default is STOP.

8. **Propose personas.** Based on the crawl, generate N personas following the framework in `PERSONAS.md`. Each persona must be:
   - **Named** (realistic Czech/Slovak first name + last initial)
   - **Specific to THIS eshop** (their motivation should reference something actually observed on the site — a category, a product, a trust signal, a tone of copy)
   - **Internally consistent** (age, occupation, tech literacy, device preference all fit together)
   - **Unique in role** (don't duplicate the same archetype; see PERSONAS.md for diversity dimensions)
   
   One persona must be designated the **Buyer** — the one who will actually submit a test order.

**Output format to the user:**

Use `## Fáze 1: Průzkum a návrh person` in the normal case. If the crawl was blocked and you're in provisional mode (see action 7 above), use `## Fáze 1: Návrh person (bez crawlu — viz blokátor)` and include a ⚠️ blocker block above the usual content.

```
## Fáze 1: Průzkum a návrh person

**Eshop:** [název / doména]
**Sortiment:** [co se prodává, cenová hladina, jazyk]
**Cílovka (z pozorování):** [kdo tam pravděpodobně nakupuje]
**Trust signály:** [reviews, "od roku", certifikáty, …]
**Potenciální problémy zjištěné už při procházení:** [max 3 rychlé poznámky, nic hlubokého]

**Předchozí testy:** [seznam s datumy, nebo "žádné"]
**Režim:** [Nový test / Re-test s personami z <datum>]

**Navržené persony:**

### 1. [Jméno] — [stručná charakteristika] [DESIGNATED BUYER 🛒]
- **Věk/povolání:** …
- **Zařízení:** iPhone 14 Pro (mobil)
- **Motivace:** [proč přišla/přišel na TENTO eshop — konkrétně]
- **Obavy:** [co by ji/ho mohlo odradit]
- **Tech zdatnost:** [začátečník / pokročilý / profík]

### 2. …
### 3. …
### 4. …
```

**[HITL PAUSE — Phase 1]:**

End your output with this pause block **verbatim** (substitute the Buyer's name). You MAY add context paragraphs **above** the block (e.g., a blocker flag, a clarifying question) if honest reporting requires it — but the pause block itself must appear, with these four numbered questions in this order:

> "Tady jsou navržené persony. Než pustím paralelní testování, potvrď prosím:
> 1. **Persony** — sedí, nebo chceš některou upravit / nahradit / přidat další?
> 2. **Zařízení** — vyhovuje mix mobil/desktop, nebo změnit?
> 3. **Buyer** — má test-objednávku odeslat [jméno buyer persony], nebo jiná persona?
> 4. **Cokoli dalšího** — známé problémy, konkrétní oblasti, na které se mám zaměřit?"

Do NOT continue to Phase 2 until the user explicitly approves all four points. "Ok" or "pokračuj" without addressing each is not enough — if in doubt, list what you heard and ask which parts are confirmed.

Save approved personas to `personas.json` (for potential re-tests).

---

## Phase 2: Parallel Persona Testing

**Trigger:** User approves personas in Phase 1.

**Actions:**

1. For each persona, spawn a subagent using the `Agent` tool with instructions from `AGENTS.md`. **All subagents MUST be spawned in a single turn (one message with N Agent tool calls) so they run in parallel.**

2. Each subagent receives:
   - The persona's full definition
   - Their device profile (viewport, user-agent, touch emulation)
   - The journey to execute (from `JOURNEYS.md`)
   - Whether they are the Buyer (and therefore submit the test order)
   - Their output file path: `ux-testing/<domain>/<timestamp>/personas/<slug>.md`
   - Their screenshot directory: `ux-testing/<domain>/<timestamp>/screenshots/<slug>/`

3. While subagents are running, remain idle — do not do other work. When all complete, read each persona's output file.

4. Verify each persona produced a valid report. If a subagent failed or produced an incomplete report, flag it but do not re-run without asking the user.

**Status update to the user (no pause):**

```
## Fáze 2: Testování dokončeno

[Jméno 1]  ✅ dokončeno — [N pozorování, rozhodnutí: koupila by / váhá / odešla]
[Jméno 2]  ✅ dokončeno — …
[Jméno 3]  ⚠️ částečně — [důvod]
[Jméno 4]  ✅ dokončeno — …

Jdu syntetizovat report.
```

Proceed immediately to Phase 3. No pause.

---

## Phase 3: Synthesis

**Trigger:** All persona subagents have completed.

**Actions:**

1. Read every persona markdown file.
2. Identify patterns:
   - **Shared friction** — issues multiple personas hit (highest priority, likely real UX problems)
   - **Persona-specific** — issues only one persona raised (may be genuine edge cases or persona bias)
   - **Device-specific** — issues only mobile or only desktop personas hit
   - **Delights** — things personas praised (worth preserving during changes)
3. If this is a Re-Test: load the previous SUMMARY.md and compute a diff — what improved, what regressed, what's new.
4. Write `SUMMARY.md` with this exact structure:

```markdown
# UX testing eshopu — [doména]

**Datum:** [YYYY-MM-DD HH:MM]
**Testovaly persony:** [jména]
**Režim:** [Nový test / Re-test oproti <datum>]

## Shrnutí (TL;DR)
[3–5 vět: nejdůležitější závěry. Co by majitel měl udělat jako první?]

## Priority 1 — Kritické (více person narazilo)
1. **[Problém]** — [popis] · postihlo: [persony] · device: [mobil/desktop/obojí]
   - Konkrétní důkaz: [citace nebo screenshot]
   - Návrh řešení: [co s tím]

## Priority 2 — Střední
…

## Priority 3 — Drobnosti
…

## Pozorování po personách
### [Jméno 1]
- Rozhodnutí: [koupila by / váhá / odešla + proč]
- Nejsilnější friction: [bod]
- Co ocenila: [bod]

### [Jméno 2]
…

## Co funguje dobře (zachovat)
- …

## Srovnání s minulým testem
[Pouze pokud Re-Test. Tabulka: problém / stav minule / stav teď / verdikt]

## Doporučený další krok
[Jedna konkrétní akce, kterou bys udělal zítra ráno]
```

5. Present the SUMMARY to the user in the chat (paste the full markdown, don't just link to the file).

**[HITL PAUSE — Phase 3]:**
Stop and ask exactly:
> "Report je hotový a uložený v `[cesta k SUMMARY.md]`. 
> - Dává ti to smysl?  
> - Chceš něco doplnit, upřesnit, nebo některou personu pustit znovu s jiným zadáním?  
> - Chceš, ať spustím re-test později (až upravíš eshop)?"

Do not end the skill until the user confirms they're done.

---

## Phase 4: Optional Follow-ups

If the user asks for follow-ups after Phase 3:
- **Re-run specific persona with different journey** — spawn single subagent, append to same timestamp folder
- **Add a new persona** — generate + test + append observations to SUMMARY
- **Deeper dive on one issue** — spawn subagent focused only on the specific flow
- **Export report** — convert SUMMARY.md to PDF/DOCX if user requests (use standard tools)

Do not start these automatically — wait for user instruction.

---

## Phase 5: Re-Test Mode

Triggered in Phase 1 if user chooses Re-Test against a previous run.

**Differences from a fresh run:**
- Skip persona generation; load `personas.json` from the previous run
- Still run the full Phase 1 HITL pause so the user can tweak personas if needed (e.g., they fixed a problem that one persona was specifically built to stress — they may want to replace her)
- In Phase 3 synthesis, always produce the "Srovnání s minulým testem" section

---

## Checklist before you claim the skill is done

- [ ] Playwright successfully installed and chromium+webkit browsers are available
- [ ] Discovery crawl visited ≥5 pages and produced `raw-crawl.json`
- [ ] Personas are named, specific to this eshop, and user-approved
- [ ] All N persona subagents produced reports in `personas/`
- [ ] Buyer persona (and only the Buyer) submitted a test order with the test-note
- [ ] `SUMMARY.md` exists, is in Czech, follows the exact structure above
- [ ] User explicitly closed out Phase 3

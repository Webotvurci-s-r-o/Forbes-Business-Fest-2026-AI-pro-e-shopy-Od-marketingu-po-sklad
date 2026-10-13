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
version: 1.1.0
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
8. **The run never ends without `SUMMARY.md`.** Partial personas, blocked Buyer, whatever happened — Phase 3 always runs and always produces the report, with gaps honestly marked. A run folder without SUMMARY is a failed delivery.
9. **The Buyer pays převodem/dobírkou, never by card gateway** — otherwise the redirect eats the thank-you page and the order number, which is the run's key proof. See JOURNEYS.md Step 7.

---

## Output Directory

All output goes to:

```
ux-testing/<eshop-domain>/<YYYY-MM-DD-HHMM>/
├── personas/
│   ├── <persona-slug>.md           # full feedback from each persona
│   └── ...
├── screenshots/
│   └── <persona-slug>/              # ONLY .png files — nothing else
├── work/
│   └── <persona-slug>/              # scratch: .cjs scripts, storage.json, DOM dumps, raw notes
├── raw-crawl.json                   # Phase 1 discovery data
├── personas.json                    # approved persona definitions (for re-tests)
└── SUMMARY.md                       # final aggregated report
```

**This folder is a client deliverable.** The client opens it. Hard rules:

- `screenshots/<slug>/` contains **only `.png` files**. Scripts, `*.storage.json`, DOM dumps, `*-body.txt`, selector probes — all of that goes to `work/<slug>/`.
- No scratch files at the run-folder top level (`crawl.cjs`, `raw-crawl2.json`, `*-observations-raw.txt`, `menu-extraction.json`, …). Orchestrator scratch goes to `work/_orchestrator/`.
- `personas.json` always has the shape `{"personas": [...]}` — never a bare array (Re-Test Mode depends on this).
- All screenshot references in any `.md` file are **relative paths** (`screenshots/<slug>/NN-label.png`), never absolute filesystem paths.
- Phase 3 ends with a cleanup pass: any stray file gets moved into `work/` before the run is declared done.

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

5. **If the Designated Buyer was blocked** (age-gate, permission error, payment-gateway dead end) and no order was submitted, say so in the status update and record it for Phase 3 — the SUMMARY must state it as a scoped limitation in client language ("objednávku se nepodařilo dokončit kvůli X, doporučujeme ověřit ručně"), never as an internal tooling excuse.

6. **The run MUST NOT end without `SUMMARY.md`.** Even if only 2 of 4 personas finished, proceed to Phase 3 and synthesize what exists, clearly marking gaps. A run folder with persona reports but no SUMMARY is a failed delivery — the client gets nothing they can read.

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

**Trigger:** All persona subagents have completed (or failed — see Phase 2 action 6: SUMMARY is always produced).

### 3a. Pre-synthesis verification (do this BEFORE writing SUMMARY)

1. **Read every persona markdown file.**
2. **Screenshot integrity gate.** Collect every `*.png` reference from every persona report and verify the file exists on disk. A reference to a non-existent screenshot is a fabrication risk: remove or correct the reference in your synthesis, and never carry an unverifiable claim into SUMMARY as fact. Any claim whose only evidence is a missing screenshot gets downgraded to `[hypotéza — nutno ověřit]`.
3. **Cross-persona fact reconciliation.** Extract every numeric or named fact that appears in 2+ reports (prices, shipping tariffs, discount %, free-shipping threshold, platform name, countdown/banner presence, warranty lengths). Diff them. For every disagreement, either (a) re-verify with one quick Playwright check, or (b) publish it in a `## Sporná zjištění` section. Never silently pick one version — a client reading two persona reports with different numbers loses trust in the whole report.
4. **Workspace cleanup.** Move stray scratch files (`*.cjs`, `*.storage.json`, DOM dumps, raw notes) into `work/`. After cleanup the run folder contains only: `personas/`, `screenshots/` (PNGs only), `work/`, `raw-crawl.json`, `personas.json`, `SUMMARY.md`.

### 3b. Synthesis rules

1. **Priorities are by business impact, not by vote count.** How many personas hit an issue is supporting evidence, not the definition:
   - **P1 — Blokátory nákupu:** anything that charges the customer wrongly, blocks or corrupts order submission, violates a legal obligation (chybějící souhlas s OP/GDPR, cookie lišta bez odmítnutí), or contradicts a public promise of the shop (slibovaná doprava zdarma, která v checkoutu není). **P1 even if only one persona hit it.**
   - **P2 — Brzdy konverze:** slows down, confuses, or discourages, but doesn't block.
   - **P3 — Hygiena:** cosmetic and technical debt. Keep it compact (max ~8 items) — no devtools noise a shop owner will never action.
2. **Anti-fabrication rules (hard):**
   - Never state a % conversion impact, revenue estimate, or "industry benchmark" without a named source or the client's own data. If you must estimate, label it `[kvalifikovaný odhad, neověřeno daty]`.
   - Never invent segment sizes ("dárky = 30–50 % obratu parfumérií").
   - Tag every finding with its source: `[pozorováno personou]` / `[z crawlu]` / `[hypotéza — nutno ověřit]`.
   - Never describe persona agreement as "nezávisle na sobě" — personas are simulated by the same model; convergence is an indicator, not independent validation. Write "shodně napříč personami".
   - If the Buyer's submit failed because of automation (blocked input, gateway redirect, sandbox), that goes into `## Otevřené věci — nutno ověřit ručně`, **not** into P1 as a customer-facing bug.
3. **Client language only.** SUMMARY.md must never contain: sandbox, subagent, harness, Playwright, storageState, selector, `.cjs`, or any agent/tooling vocabulary. Rephrase into what a shop owner understands ("automatizovaný test nedokázal pole vyplnit — doporučujeme ověřit ručně").
4. **Generic vs. specific.** Findings that are Shoptet platform defaults (newsletter opt-out wording, e-mail validace odmítající `+`, cookie lišta, chybějící H1 na homepage, default "Můj e-shop" title) go into their own section `## Standardní nedostatky platformy Shoptet` — never mixed into the shop-specific priorities. Two clients comparing reports must not find the same "bespoke" finding.
5. **Screenshots are the product.** Every P1 finding embeds at least one screenshot inline with `![popis](screenshots/<slug>/NN-label.png)` (relative path). P2 findings link screenshots where available. The personas captured 100+ images — a report that references none of them wastes the run's single biggest asset.
6. **Real data when available — and say which mode you're in.** Analytics access is usually NOT available (agency clients rarely share GA). In Phase 3, actively verify: check whether connected MCP tools (GA4 / Search Console / Shoptet API) actually contain a property/account for the tested domain. Then state the mode **prominently in the SUMMARY header**:
   - Data available → pull checkout funnel drop-off, mobile vs. desktop conversion, AOV vs. free-shipping threshold, internal-search zero-result queries, and mark findings backed by them `[změřeno]`. One real number ("v kroku 2 odpadá 41 % košíků") beats any estimate.
   - No data → SUMMARY header says: `**Datová opora:** bez analytických dat — čistě simulované uživatelské testování (4 persony)`. Never imply quantitative backing that doesn't exist; this line is what keeps the report honest.
7. If this is a Re-Test: load the previous SUMMARY.md and compute a diff — what improved, what regressed, what's new.

### 3c. SUMMARY.md structure

Sections marked *(volitelné)* are omitted when empty — never write an empty section. Everything else is mandatory.

```markdown
# UX testing eshopu — [doména]

**Datum:** [YYYY-MM-DD HH:MM]
**Testovaly persony:** [jména + zařízení]
**Režim:** [Nový test / Re-test oproti <datum>]
**Datová opora:** [GA4/Search Console data použita (property X) / bez analytických dat — čistě simulované uživatelské testování]
**Testovací objednávka:** [č. XXXX odeslána (částka, platba) / neodeslána — důvod v klientské řeči]

## Manažerské shrnutí (přečtete za 60 sekund)
**Verdikt:** [1 věta]
**Skóre nákupní cesty:** [X/100 — viz skórkarta]
**3 věci, které vás stojí nejvíc peněz:**
- [max 20 slov]
- [max 20 slov]
- [max 20 slov]
**Co udělat tento týden:** [3 odrážky s odhadem času]
[Max 150 slov celkem. Žádné DOM detaily, žádná jména person, žádné důkazy — jen závěry.]

## Skórkarta
| Oblast | Skóre | Proč |
|---|---|---|
| Vyhledávání | X/5 | [1 věta] |
| Navigace a kategorie | X/5 | … |
| Produktová stránka | X/5 | … |
| Košík | X/5 | … |
| Checkout | X/5 | … |
| Důvěryhodnost | X/5 | … |
| Mobilní zážitek | X/5 | … |
| Právní náležitosti | X/5 | … |

Celkem: [součet × 2,5 = X/100]

## Efekt × náročnost
[Jedna tabulka všech P1+P2 zjištění, seřazená od nejlepšího poměru:]
| ID | Zjištění | Kdo narazil | Dopad | Náročnost | Kde opravit |
|---|---|---|---|---|---|
| P1-01 | … | 3/4 person · mobil | Vysoký | 2 h | Shoptet admin |
[Náročnost ∈ {15 min, 2 h, 1 den, 3–5 dní, projekt}. Dopad ∈ {Vysoký, Střední, Nízký} + důvod v textu zjištění.]

## Rychlé výhry — checklist na tento týden
- [ ] [ID] [akce] ([odhad času], [kdo: admin / šablona / vývojář])
- [ ] …

## P1 — Blokátory nákupu
1. **[Problém]** (P1-01) — postihlo: [persony] · zařízení: [mobil/desktop/obojí] · `[pozorováno personou]`
   - **Důkaz:** [přesná URL] · citace persony · ![popis](screenshots/<slug>/NN-label.png)
   - **Návrh řešení:** [konkrétně, proveditelně]
   - **Kde opravit:** [Shoptet admin klik-cesta, např. „Nastavení → Objednávkový proces → …“ / „Vzhled → Editor šablon“ / „⚠️ vyžaduje vývojáře (~X h)“]

## P2 — Brzdy konverze
[stejná struktura, screenshot kde je]

## P3 — Hygiena (stručně)
- [max ~8 odrážek, bez balastu]

## Standardní nedostatky platformy Shoptet *(volitelné)*
[Nálezy, které sdílí většina Shoptet eshopů — opt-out newsletteru, e-mail validace, cookie lišta… Stále stojí za opravu, ale nejsou specifické pro tento eshop.]

## Právní rizika *(volitelné)*
[Souhrn všeho s právní expozicí na jednom místě: souhlas s OP/GDPR, cookies, IČO, reklamační podmínky. Sekce, kterou majitel přepošle právníkovi.]

## Sliby vs. realita *(volitelné)*
[Rozpor mezi tím, co eshop veřejně slibuje (doprava zdarma, záruka, termíny), a tím, co persony reálně zažily v checkoutu.]

## Co se láme jen na některých zařízeních *(volitelné)*
| Problém | iPhone | Pixel | Desktop | Laptop |

## Hotové texty k nasazení
| Místo | Současný text | Navržený text | Proč |
[5–15 řetězců připravených ke zkopírování: chybové hlášky, CTA, mikrocopy k dopravě. Nejvyšší vnímaná hodnota na jednotku práce.]

## Pozorování po personách
### [Jméno] ([věk, role, zařízení])
- **Provedená akce:** [odeslala objednávku / zastavila před odesláním / blokována — proč]
- **Rozhodnutí:** [koupila by / váhá / odešla + proč] · pravděpodobnost dokončení X/10
- **Nejsilnější friction:** [bod]
- **Co ocenila:** [bod]

## Co funguje dobře (zachovat)
- …

## Sporná zjištění *(volitelné)*
[Fakta, na kterých se persony neshodly a nešla doověřit: co tvrdí kdo, a jak to ověřit ručně.]

## Otevřené věci — nutno ověřit ručně *(volitelné)*
[Co automatizovaný test nedokázal ověřit (např. dokončení platby kartou) a majitel/agentura by měli projít ručně.]

## Srovnání s minulým testem *(pouze Re-test)*
[Tabulka: ID / problém / stav minule / stav teď / verdikt]

## Jak ověříme, že to zabralo
[Pro 3–5 nejdůležitějších zjištění: co změřit, aktuální stav, cílový stav, kdy pustit re-test. Přirozený podklad pro navazující spolupráci.]

## Doporučený další krok
[Jedna konkrétní akce, kterou bys udělal zítra ráno.]
```

### 3d. Definition of done for SUMMARY.md

Before presenting, self-check:

- [ ] Manažerské shrnutí ≤150 slov, čitelné bez zbytku reportu
- [ ] Každé P1 má: URL + citaci + vložený screenshot (`![]`), návrh řešení, "Kde opravit"
- [ ] Všechny vložené screenshoty existují na disku (ověřeno v 3a)
- [ ] Žádné vymyšlené % / benchmarky bez zdroje; odhady označené
- [ ] Žádný interní žargon (sandbox, subagent, Playwright, selector…)
- [ ] Generické Shoptet nálezy odděleny od specifických
- [ ] Efekt × náročnost tabulka pokrývá 100 % P1+P2
- [ ] Hotové texty: ≥5 řetězců
- [ ] Konzistentní ID formát (P1-01, P2-03…) použitelný v ticketovacím systému

Finally, present the SUMMARY to the user in the chat (paste the full markdown, don't just link to the file).

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
- [ ] All N persona subagents produced reports in `personas/` (or gaps are documented in SUMMARY)
- [ ] Buyer persona (and only the Buyer) submitted a test order with the test-note — with **převod/dobírka** payment so the thank-you page and order number were captured; if blocked, it's in `## Otevřené věci`
- [ ] `SUMMARY.md` exists, is in Czech, follows the exact structure above, and passed the 3d definition-of-done self-check
- [ ] Every screenshot referenced in SUMMARY.md and persona reports exists on disk
- [ ] Run folder is clean: only `personas/`, `screenshots/` (PNGs only), `work/`, `raw-crawl.json`, `personas.json` (`{"personas": [...]}`), `SUMMARY.md`
- [ ] User explicitly closed out Phase 3

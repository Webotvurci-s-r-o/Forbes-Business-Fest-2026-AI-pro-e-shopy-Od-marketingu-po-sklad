# Changelog — eshop-ux-tester

## [1.1.0] — 2026-07-27

### Optimalizace na základě analýzy 10 reálných běhů (9 eshopů)

**Report (Fáze 3) — přestavba na konzultační deliverable:**
- Priority nově podle **byznys dopadu, ne počtu person** — cokoli, co špatně účtuje, blokuje objednávku, porušuje právní povinnost nebo odporuje veřejnému slibu eshopu = P1 i při jedné personě.
- Nové sekce: **Manažerské shrnutí (60 s, max 150 slov)**, **Skórkarta (8 oblastí, skóre /100)**, **Efekt × náročnost tabulka**, **Rychlé výhry checklist**, **Hotové texty k nasazení**, **Právní rizika**, **Sliby vs. realita**, **Sporná zjištění**, **Jak ověříme, že to zabralo**.
- Každé P1 zjištění povinně: URL + citace + **vložený screenshot** + „Kde opravit" (Shoptet admin klik-cesta). Dosud se z ~1300 pořízených screenshotů do reportů dostalo 14.
- **Anti-fabrikační pravidla:** žádná vymyšlená % dopadu ani „industry benchmarky" bez zdroje; každé zjištění označeno zdrojem (pozorováno / z crawlu / hypotéza); zákaz „nezávisle na sobě" u shody person.
- Generické Shoptet nálezy (opt-out newsletteru, e-mail validace, cookie lišta…) odděleny do vlastní sekce — nemíchají se do specifických priorit.
- **Zákaz interního žargonu** v klientských výstupech (sandbox, subagent, Playwright, selector…).

**Persony (Fáze 2) — hloubka a věrohodnost:**
- Povinná **vyhledávací matice** (přesný + přirozený + use-case dotaz) a povinný **filtr + řazení** — use-case dotazy historicky přinesly nejcennější nálezy, filtry byly testované ve 3 z 36 reportů.
- Povinné **checkout micro-testy**: prázdný submit, neplatný e-mail/PSČ, kupón TEST123, zpět v prohlížeči, přepočet množství, mobilní klávesnice vs. CTA.
- **Buyer platí převodem/dobírkou, nikdy kartou** — platební brána dosud sežrala číslo objednávky ve 3 ze 4 odeslaných testů. Buyer si drží identitu persony (žádná reálná jména/e-maily agentury).
- **Poctivost důkazů:** zákaz odkazů na neexistující screenshoty (ověřuje se strojově), zákaz „předpokládám → potvrzeno", povinný blok mobilních měření (tap targety, sticky CTA, klávesnice).
- Verdikt: nové pole **Provedená akce** (odděleno od rozhodnutí persony), definice skóre, konzistence dealbreaker ⇒ skóre <7, kontrola rodu.
- Zákaz per-persona redesign kapitol (4 persony psaly 4 IA přestavby — balast).

**Orchestrace a hygiena:**
- **Běh nikdy nekončí bez SUMMARY.md** — 2 z 10 historických běhů skončily bez reportu (klient nedostal nic).
- Pre-syntézní brána: ověření existence screenshotů, **cross-persona rekonciliace faktů** (ceny, sazby, sliby), úklid workspace.
- Nová složka `work/` pro scratch soubory — run folder je klientský deliverable, `screenshots/` obsahuje jen PNG.
- `personas.json` vždy `{"personas": [...]}` (bare array rozbíjelo Re-Test Mode).
- Volitelné napojení na GA4 / Search Console / Shoptet API (přes MCP) pro reálná čísla ve fázi syntézy.

## [1.0.0] — 2026-04-21

### První veřejná verze

- 4-fázový orchestrátor (Průzkum → Návrh person → Paralelní testování → Syntéza) se dvěma HITL pauzami.
- Framework pro generování person konkrétních pro daný eshop (nikoli generické šablony).
- Paralelní spouštění persona-tester subagentů, každý s izolovaným browser contextem.
- Defaultní device mix: 2× mobil (iPhone 14 Pro, Pixel 7) + 2× desktop (1920×1080, 1366×768).
- Workspace-local Playwright install (`ux-testing/.playwright/`), nekolinduje s globálním npm.
- Re-test mode: load `personas.json` z minulého běhu + generuje diff oproti předchozímu SUMMARY.
- Bezpečnostní limity: max 1 objednávka / run, povinná test-note, guest checkout only.
- Vše česky: persona dialog, friction/delight poznámky, finální SUMMARY.

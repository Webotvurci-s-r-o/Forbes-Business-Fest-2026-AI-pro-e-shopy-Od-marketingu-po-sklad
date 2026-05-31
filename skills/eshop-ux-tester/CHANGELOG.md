# Changelog — eshop-ux-tester

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

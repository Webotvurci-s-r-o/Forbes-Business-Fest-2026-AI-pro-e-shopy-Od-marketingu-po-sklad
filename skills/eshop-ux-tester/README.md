# eshop-ux-tester

**Version:** 1.0.0  
**Category:** UX / E-commerce  
**Author:** skills-marketplace

## Co skill dělá

Simulované uživatelské testování e-shopu. Claude Code nejdřív obejde tvůj eshop přes Playwright, pochopí, **co se tam prodává a komu**, a navrhne 4 persony ušité přímo na ten eshop — žádné generické šablony. Ty si persony potvrdíš / upravíš, a pak **4 persony běží paralelně jako subagenti**, procházejí eshop (mobil + desktop), každá v čase se svou "duší", obavami a motivací. Na konci dostaneš UX report: co štve, co funguje, priority co řešit jako první.

Navrženo pro **Shoptet** (a jiné CZ e-commerce CMS), kde agresivní JS/CSS override znemožňuje statický scraping — proto je **Playwright povinný**.

### Klíčové vlastnosti

- ✅ **Persony podle eshopu, ne šablony** — Claude nejdřív crawluje tvůj eshop a teprve pak generuje Barboru, 34, MD, která hledá kočárek do 20 tis., ne "price-sensitive shopper".
- ✅ **Paralelní testování** — 4+ subagenti najednou, každý s vlastním browser contextem.
- ✅ **Mobil + desktop** — default 2× mobil (iPhone 14 Pro, Pixel 7) + 2× desktop (1920×1080, 1366×768). Lze upravit.
- ✅ **Bezpečné testy objednávek** — pouze jedna persona (Designated Buyer) dojde až k odeslání, s povinnou poznámkou `TEST OBJEDNÁVKA — prosím ignorovat`. Ostatní zastaví před tlačítkem.
- ✅ **Re-test mode** — po úpravách eshopu pustíš znovu se stejnými personami a dostaneš diff oproti minulému běhu.
- ✅ **HITL pauzy** — orchestrátor se ptá po navržených personách a před finálním reportem; nerozbuší se ti účet bez kontroly.
- ✅ **Vše česky** — persony, feedback, SUMMARY.

## Požadavky (před instalací)

- **Claude Code** (CLI, VS Code extension, nebo Cursor IDE)
- **Node.js 18+** — skill potřebuje `node` pro Playwright. Ověř: `node --version`
- **Přístup k git** a k tomuto marketplace repozitáři
- **Disk:** ~500 MB na Playwright install (první běh) + ~50 MB na každý test run (screenshoty)

## Instalace — krok za krokem

### Krok 1: Naklonuj marketplace repo (pokud ho ještě nemáš)

```bash
git clone https://github.com/Webotvurci-s-r-o/skills-marketplace.git
cd skills-marketplace
```

### Krok 2: Pusť install script

Ze složky svého projektu, kam chceš skill nainstalovat:

```bash
# Lokálně do projektu (doporučeno):
/path/to/skills-marketplace/install.sh eshop-ux-tester

# Nebo globálně pro všechny projekty:
/path/to/skills-marketplace/install.sh eshop-ux-tester --global
```

Script zkopíruje skill do `.claude/skills/eshop-ux-tester/` a vytvoří `.marketplace-source.json` (aby `wt_update-skills` vědělo kam pro updaty).

### Krok 3: Zaregistruj skill v Claude Code settings

Otevři `.claude/settings.json` (nebo `.claude/settings.local.json`) a přidej:

```json
{
  "skills": [
    ".claude/skills/eshop-ux-tester/SKILL.md"
  ]
}
```

### Krok 4: Přidej požadovaná permissions (DŮLEŽITÉ)

Skill potřebuje pustit Playwright přes `node`. Claude Code sandbox to ve výchozím nastavení blokuje. Přidej do `.claude/settings.local.json`:

```json
{
  "permissions": {
    "allow": [
      "Bash(node:*)",
      "Bash(mkdir:*)",
      "Bash(chmod:*)",
      "Bash(ln:*)",
      "Bash(rm:*)",
      "Bash(bash /ABS/PATH/.claude/skills/eshop-ux-tester/scripts/*)"
    ]
  }
}
```

Poslední řádek uprav na absolutní cestu ke svému projektu (kde je `.claude/skills/eshop-ux-tester/scripts/`).

Bez těchto permissions skill při první fázi hard-stopne s chybovou hláškou co přesně chybí.

### Krok 5: První spuštění (stáhne Playwright, ~2 min)

Pusť v Claude Code:

```
/eshop-ux-tester
```

a dej mu URL tvého eshopu. Při prvním běhu skill stáhne Playwright + Chromium + WebKit browsery do `ux-testing/.playwright/` (cca 300 MB jednorázově). Dalších běhy to přeskočí — zjistí existující instalaci.

### Krok 6: Přidej výstupy do .gitignore

Výstupy testů (reporty, screenshoty, Playwright install) nepatří do gitu. Přidej do root `.gitignore`:

```gitignore
# eshop-ux-tester outputs
ux-testing/
**/*.storage.json
```

## Ověření instalace

Pusť:
```
/eshop-ux-tester
```

Claude by měl reagovat typicky ve stylu:
> "OK. Jakou URL eshopu chceš otestovat? Kolik person preferuješ (default 4)? …"

Pokud dostaneš preflight-chybu o chybějícím `Bash(node:*)` permission, vrať se ke Kroku 4.

## Použití

Spusť slash příkazem:
```
/eshop-ux-tester
```

Nebo přirozeně:
> "Udělej UX test mého eshopu mujeshop.cz"  
> "Potřebuju uživatelský test — pusť 4 persony na https://…"  
> "Pořádný conversion audit pro tenhle shop"  
> "Re-test mého eshopu, něco jsem tam minulý týden upravil"

## Workflow

```
┌─────────────────────────────────────────────────────────┐
│ Fáze 1: Průzkum + návrh person                          │
│  • Playwright crawl homepage + kategorie + produkty     │
│  • Orchestrátor generuje 4 konkrétní persony            │
│  • [HITL PAUZA] — potvrď / uprav persony                │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│ Fáze 2: Paralelní testování                             │
│  • 4 subagenti, 4 browser contexty, 4 zařízení          │
│  • Každý prochází journey (landing → PDP → checkout)    │
│  • Buyer pošle 1 test objednávku, ostatní zastaví       │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│ Fáze 3: Syntéza                                         │
│  • Agregace + pattern-matching přes persony             │
│  • SUMMARY.md s prioritami + per-persona insights       │
│  • (Re-test) diff oproti minulému běhu                  │
│  • [HITL PAUZA] — review reportu                        │
└─────────────────────────────────────────────────────────┘
```

## Výstup

```
ux-testing/
└── mujeshop-cz/
    └── 2026-04-21-1430/
        ├── personas/
        │   ├── barbora-k.md          ← detailní zpětná vazba od persony
        │   ├── tomas-h.md
        │   ├── jitka-m.md
        │   └── pavel-s.md
        ├── screenshots/
        │   ├── barbora-k/
        │   │   ├── 01-homepage.png
        │   │   ├── 02-category.png
        │   │   └── …
        │   └── …
        ├── raw-crawl.json            ← data z průzkumu eshopu
        ├── personas.json             ← schválené definice person (pro re-test)
        └── SUMMARY.md                ← finální report
```

## Bezpečnost & etika

- **Pouze jedna reálná objednávka** na běh, jasně označená jako test.
- **Pouze guest nákup** (bez registrace), pokud explicitně nepožádáš o přihlášený flow.
- **Žádné dark patterny** — skill neprovádí security testy, SQL injection, ani scraping pro konkurenční rešerše.
- Pokud testuješ **cizí eshop**, orchestrátor se tě jednou zeptá, zda máš povolení.

## Omezení

- Skill je laděný pro **Shoptet a podobné CZ e-commerce CMS**. U eshopů s netypickým frontendem (headless, custom SPA) může vyžadovat ruční kalibraci selektorů.
- **Login flowy** (přihlášené sekce, M2B portály) nejsou v defaultu — musíš explicitně požádat a dodat test credentials.
- Skill **nedoporučuje konkrétní copywriting ani design** — dává pozorování person, které může agentura/copywriter interpretovat.
- Persony jsou **simulace**, ne náhrada reálného user testingu s lidmi. Jsou dobré jako rychlá první úroveň zpětné vazby a na věci, které si majitel přestal všímat.

## Reálný příklad běhu

První produkční test byl na Ergo Interiér (DEV Shoptet eshop):

- **Fáze 1 Discovery:** Playwright crawl 6 URL (homepage + 2 kategorie + 1 PDP + 2 info stránky), 51 KB raw-crawl.json
- **Persony (ukotvené v crawlu):**
  - Lenka H., 36, Praha, backoffice v bance, desktop (Buyer 🛒) — zaměstnavatelský budget 15k
  - Radek M., 42, Brno, IT profík, Safari laptop — hledá klekačku Rokko
  - Martina K., 39, Jihlava, učitelka, iPhone — Actikid pro dceru se skoliózou
  - Pavel S., 53, České Budějovice, B2B stomatologie, Edge — 3 ks MAYER Medi Dent
- **Fáze 2 Paralelní testování:** 4 persona subagenti, 15 min wall clock, 103 pozorování, 79 screenshotů
- **Lenka odeslala test objednávku** č. 2026000001 (16 083 Kč) s poznámkou `TEST OBJEDNÁVKA — prosím ignorovat`
- **Fáze 3 Syntéza:** tři persony **nezávisle** našly stejný top problém (out-of-stock produkty lze přidat do košíku a projít celým checkoutem) → jistota, že jde o reálný #1 dealbreaker. Další sdílená zjištění: Lorem ipsum v production obsahu, chybějící GDPR checkbox před OBJEDNAT, default Shoptet "Můj e-shop" title na sub-pages, rozpor záruky 10 let vs 3–5 let.

Pro celý příklad viz SUMMARY.md z daného runu (gitignored v `ux-testing/<domain>/<timestamp>/`).

## Licence

MIT

## Poznámka ke kvalitě

Tento skill je první verze (1.0.0). Jeho kvalita **stojí a padá na tom, jak dobře Claude Code během crawlování pochopí daný eshop**. Pro atypické eshopy doporučujeme v HITL pauze persony důkladně projít a případně doplnit vlastní — ty, co znáš z tvé reálné cílovky.

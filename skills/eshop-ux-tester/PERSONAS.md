# PERSONAS.md — Framework pro generování person konkrétních pro daný eshop

This file tells the Orchestrator **how to generate personas that are specific to the eshop being tested** — not generic archetypes. The goal of this skill is to approximate real user testing, so personas must feel like people who could actually show up on *this* shop.

## The one rule

**Personas must be grounded in what you actually saw on the eshop.** If you visited a shop selling organic baby food and propose "Pavel, 42, IT consultant, looking for premium headphones" — you've failed. Pavel doesn't belong here. Every persona's motivation must reference something you saw in `raw-crawl.json`: a product category, a price band, a tone of copy, a trust signal, a promotion on the homepage.

## What to do if the crawl was impossible

Default: **don't generate fallback personas from domain knowledge alone.** SKILL.md Phase 1 action 7 covers this — STOP and ask the user to fix the environment, or explicitly opt in to "provisional personas" mode.

If the user opts in to provisional mode (they say "udělej aspoň návrh i bez crawlu"):

1. Generate personas from user-provided context + generic category knowledge.
2. Mark every persona JSON with `"provisional": true`.
3. In the Phase 1 output, prefix with a prominent ⚠️ blocker notice that explains the crawl didn't happen, why the personas are tentative, and what specific assumptions you made that the user should verify.
4. In the HITL pause, add an extra question: "Odpovídají persony tomu, co reálně na eshopu prodáváš a kdo ti reálně chodí? Pokud ne, přegeneruju po odblokování crawlu."
5. Phase 2 should not run until either (a) the crawl-blocker is resolved and personas are regenerated, or (b) the user explicitly confirms the provisional personas are close enough to reality.

---

## Persona construction — required fields

Each persona has these fields. Fill every one. If you can't fill one, you don't understand the persona well enough yet.

### 1. Identity
- **Jméno a příjmení-iniciála** — realistic Czech/Slovak names. Mix genders. No "Jan Novák" clichés — use names a real owner would recognize from their order list (Barbora K., Tomáš H., Jitka M., …).
- **Věk** — specific number, not a range.
- **Povolání** — specific. "Učitelka na druhém stupni" beats "učitelka". "OSVČ — instalatér" beats "řemeslník".
- **Bydliště** — město nebo velikost obce (vliv na dopravu, dostupnost výdejen).
- **Rodinný stav / děti** — relevant if the eshop sells for kids/family.

### 2. Motivation (the most important field)
- **Proč je na tomhle eshopu?** — one concrete sentence. Reference something from the crawl. Good: "Hledá prvorozenému synovi kočárek do 20 tisíc a narazila na Instagram reklamu Kuřátka.cz." Bad: "Chce koupit kočárek."
- **Co ji sem přivedlo?** — Google / sociální sítě / doporučení / sleva / dlouholetý zákazník / porovnávač cen (Heureka / Zbozi). This influences expectations (Heureka user expects reviews; Instagram user expects visual consistency).
- **Jaký má rozpočet?** — konkrétní částka nebo cenové pásmo, a **ověř, že v tomhle eshopu reálně něco za ten rozpočet je**.

### 3. Anxieties & resistance points
- **Čeho se bojí?** — 1–2 konkrétní obavy. Příklady: "Bojí se, že zboží nedorazí před Vánoci.", "Bojí se, že to bude jiný odstín než na fotce.", "Bojí se, že firma neexistuje a jen přeprodává Aliexpress." Tyto obavy řídí, co na eshopu aktivně hledá (trust signály, recenze, reklamační podmínky).
- **Co ji odradí a zavře tab?** — 1 konkrétní deal-breaker. Příklady: "Nemožnost platit kartou online.", "Nevím, kolik bude poštovné, dokud nezaložím účet.", "Hlavní fotka produktu je stock z Alibaby."

### 4. Tech fluency & behavior
- **Technická zdatnost:** *začátečník / průměr / pokročilý / profík*. Začátečníci nevidí hamburger menu, nepoznají, že se obrázek dá zvětšit kliknutím. Profíci otevírají dev tools, když něco nefunguje.
- **Zařízení:** konkrétní model + iOS/Android verze nebo desktop + prohlížeč. Starší iPhone SE má odlišné chování od iPhonu 14 Pro.
- **Rychlost rozhodování:** *impulsivní / zvažující / chronicky nerozhodná*.
- **Chování při frustraci:** *opustí / zkusí znovu / napíše na chat / zavolá*.

### 5. Role in this test (assigned by Orchestrator)
- **Designated Buyer?** — exactly one persona per run. This persona goes all the way through checkout and submits one test order.
- **Device profile** — iPhone 14 Pro / Pixel 7 / Desktop 1920×1080 / Laptop 1366×768 (or custom).
- **Journey focus** — everyone does the full journey from JOURNEYS.md, but each persona has **one extra emphasis** based on their identity (e.g., Marie's focus is "dětská bezpečnost a materiály", Honza's focus is "rychlost dopravy a skladovost").

---

## Diversity dimensions — how to avoid 4 copies of the same persona

When generating N personas, distribute them across these dimensions. Aim for variance, not balance — some shops legitimately have narrow audiences.

| Dimension            | Example poles                              |
|----------------------|--------------------------------------------|
| Věk                  | 19 student × 65 důchodce                   |
| Cenová hladina       | Nejlevnější varianta × prémium             |
| Naléhavost           | Spěchá (zítra narozeniny) × bádá měsíc     |
| Tech fluency         | První online nákup × e-commerce profík     |
| Zařízení             | Mobil na cestě × desktop doma              |
| Lokalita             | Praha × obec 800 obyv.                     |
| Vztah k značce       | Nový × vrací se                            |
| Důvod hledání        | Konkrétní produkt × inspirace              |
| Platební preference  | Dobírka × karta × převod × odložená platba |

**Default 4-persona mix (nejlepší výchozí spread):**

1. **První nákup, mobil, mladší** — nemá vztah k eshopu, přišla z reklamy. Testuje onboarding, trust, dopravní přehlednost.
2. **Zkušený kupec, desktop, střední věk** — porovnává, čte recenze, ověřuje parametry. Testuje infrastruktury produktových stránek.
3. **Spěchající, mobil, různý věk** — potřebuje to do dvou dnů, řeší dopravu a skladovost. Testuje vyhledávání a checkout.
4. **Opatrná / nedůvěřivá, desktop nebo mobil** — má obavy, hledá reference, impresum, recenze. Testuje trust signály a help center. **Defaultně NENÍ Buyer** (pravděpodobně by reálně neodeslala).

Buyer default = persona 2 (zkušený kupec) — nejvíc pravděpodobně dokončí objednávku a reálně zvládne edge-case během checkoutu. Lze přesunout.

---

## Persona file format

Each persona is saved as `personas.json` entry (machine-readable, for re-tests) AND will be rendered into the subagent prompt in plain Czech text. Example:

```json
{
  "slug": "barbora-k",
  "name": "Barbora K.",
  "age": 34,
  "occupation": "Marketing manažerka, MD s 8měsíční dcerou",
  "location": "Brno",
  "family": "Vdaná, první dítě",
  "motivation": "Shání první kočárek pro dceru, rozpočet 15–22 tis. Narazila na vás přes srovnávač Heureka, protože měla eshop v top 3 výsledků u dotazu 'kočárek pro novorozence kombinovaný'.",
  "channel": "Heureka",
  "budget_czk": 22000,
  "anxieties": [
    "Bojí se, že kočárek nepasuje do výtahu v paneláku.",
    "Bojí se, že objednávka nedorazí do konce mateřské."
  ],
  "dealbreaker": "Pokud nebude moct platit kartou online, opustí košík (nechce dobírku s 200 Kč navíc).",
  "tech_fluency": "průměr",
  "device": {
    "type": "mobile",
    "model": "iPhone 14 Pro",
    "os": "iOS 17",
    "viewport": "393x852",
    "touch": true
  },
  "decision_speed": "zvažující",
  "frustration_behavior": "zavře tab, jindy zkusí znovu",
  "is_buyer": false,
  "focus": "parametry kočárku (rozměry, hmotnost), doprava, reklamace"
}
```

This JSON is for the Orchestrator's tracking. The subagent receives a natural-language rendering (see AGENTS.md).

---

## Red flags when generating personas

Self-check before presenting personas to the user. If any of these are true, regenerate:

- ❌ Two personas have the same age ±5 years AND same device AND same decision speed → duplicates
- ❌ Persona's motivation doesn't reference a specific category, product, or signal visible on the eshop
- ❌ Persona's budget is outside what the eshop sells (nothing under 500 Kč in shop, but persona has budget 300 Kč)
- ❌ Anxieties feel generic ("cares about quality") rather than concrete ("bojí se, že to bude menší velikost, protože eshop neuvádí tabulku rozměrů")
- ❌ No mobile persona or no desktop persona (unless user explicitly configured otherwise)
- ❌ Buyer persona has "zavře tab při frustraci" + "nedůvěřivá" — they wouldn't submit

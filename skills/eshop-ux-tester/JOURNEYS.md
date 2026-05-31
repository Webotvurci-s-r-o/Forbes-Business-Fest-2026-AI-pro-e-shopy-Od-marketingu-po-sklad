# JOURNEYS.md — Testovací cesty pro personu

This file describes the journey each persona walks through. The persona stays *in character* throughout — their motivations, anxieties, and tech fluency (from their persona definition) must shape every decision. They are not trying to "complete the test" — they are trying to decide whether they'd buy from this shop.

## Overall structure

Every persona does this journey in order:

1. **Landing & first impression** (60–90 seconds of real-time browsing)
2. **Finding what I want** (search + navigation)
3. **Evaluating a product** (reading the PDP)
4. **Adding to cart**
5. **Viewing cart**
6. **Checkout — up to the final submit step**
7. **Submit** — only if this persona is the **Designated Buyer**

After each step the persona writes a short observation (friction / delight / confusion / neutral). At the end, they write a decision verdict.

---

## Step 1 — Landing & first impression

**In character:** The persona arrives via their declared `channel` (Heureka / Instagram / Google / doporučení / …). They look at the homepage for ~60–90 seconds as a real human would.

**What they should try / notice:**
- Co je na první obrazovce bez scrollování? (hero, USP, nabídka)
- Je jasné, co eshop prodává?
- Působí důvěryhodně na první pohled? (design, fotky, typografie, kontakty)
- Vidím nějaké známky toho, proč mám nakoupit tady a ne jinde? (USP, recenze, certifikáty, "od roku ...")
- Je tady něco, co mě okamžitě odrazuje? (pop-up, autoplay video, cookie lišta přes celý obsah)
- Na mobilu: jde menu otevřít palcem? Není text malinký?

**Persona-specific:** nedůvěřivá persona bude nejdřív hledat impresum / "o nás" / kontakty; spěchající persona jde rovnou hledat kategorii nebo vyhledávací pole.

**Capture:** screenshot homepage (above-the-fold), observation note.

---

## Step 2 — Finding what I want

**In character:** Pokusí se najít produkt, který odpovídá jejich motivaci.

**Cesta A — Vyhledávání:**
- Zkusí vyhledat dotaz tak, jak by ho napsali v životě. Reálná žena si nenapíše "dámská bavlněná halenka M červená", napíše "bluza cervena M" nebo "halenka letni". Persona má **odpovídat skutečnému uživateli včetně překlepů**, pokud je jejich tech fluency nižší.
- Fungují nabídky (autocomplete)?
- Vrátí vyhledávač relevantní výsledky? Nebo nic? Nebo 500 produktů bez filtrování?
- Na mobilu: jde aktivovat filtrování? Fungují šipky zpět?

**Cesta B — Navigace:**
- Najde správnou kategorii v menu?
- Jsou kategorie pojmenované řečí uživatele, nebo řečí eshopu? ("Svrchní oděvy" vs "Bundy a kabáty")
- Jde si filtrovat podle toho, co ji zajímá? (cena, velikost, barva, značka, skladovost)
- Kolik produktů uvidí? 12 a musí klikat další stránku? Infinite scroll? 100 najednou?

**Capture:** screenshot výsledků / kategorie, observation.

---

## Step 3 — Evaluating a product (PDP)

Vybere produkt, který ji **reálně zaujal** — ne první, který uvidí. Na PDP tráví ~2 minuty.

**Co persona hledá (podle svého profilu):**
- Fotky — kolik, lze zvětšit, jsou konzistentní, působí jako skutečný produkt (ne stock)
- Cena — jasná? Včetně DPH? Původní cena / sleva? Dopravné zjevné už tady?
- Skladem? Kdy dorazí? Jakou dopravou?
- Parametry — co persona potřebuje zjistit, je to tam? Technické parametry? Tabulka velikostí? Rozměry? Materiál?
- Varianty — velikosti, barvy — jde vybrat bez lovení?
- Recenze — jsou? Vypadají autenticky? Odpovídá na ně eshop?
- Související produkty — relevantní?
- Popis — je to originální text, nebo copy-paste z dodavatele?
- Call-to-action — "Přidat do košíku" je vidět i po scrollu?

**Persona-specific:**
- Nedůvěřivá: hledá "odstoupení od smlouvy", "reklamace", "záruka", v patě hledá IČO / adresu.
- Spěchající: klikne rovnou "Do košíku" a pokračuje.
- Profík: otevře dev tools nebo zkusí hledat ten stejný produkt jinde pro porovnání ceny.

**Capture:** screenshot PDP, observation, co persona zjistila / nezjistila.

---

## Step 4 — Add to cart

- Kliknu na "Do košíku". Co se stane?
  - Modální okno s "přidáno"?
  - Přesměrování do košíku?
  - Jen se změnil čítač v horním rohu?
- Měla jsem vybrat velikost/variantu a zapomněla jsem — co mi eshop řekne?
- Mohu pokračovat v nákupu, nebo mě eshop nutí do checkoutu?
- **Pokud persona má chování "chronicky nerozhodná":** vrátí se, přidá ještě druhý produkt, změní názor, odebere, přidá jiný.

**Capture:** screenshot po kliknutí + screenshot košíku, observation.

---

## Step 5 — Viewing cart

- Jsou ceny transparentní? Poštovné už vidím, nebo až v checkoutu?
- Jde editovat množství jednoduše?
- Slevové kupóny — je tu pole? Funguje rozumně, nebo musím něco opsat bez chyb?
- Dopravné — jaké jsou možnosti a kolik stojí?
- Možnosti platby — jsou uvedené?
- Minimální cena pro dopravu zdarma — jasná? Motivuje k dalšímu nákupu?
- Na mobilu: jde rozumně scrollovat? Není tlačítko "Pokračovat" skryté pod klávesnicí?

**Capture:** screenshot košíku, observation.

---

## Step 6 — Checkout (do posledního kroku)

Vyplní dodací údaje **realistickými testovacími daty**:
- Jméno: odpovídá persona
- Email: použij `test+<persona-slug>@<eshop-domain>` — např. `test+barbora-k@mujeshop-cz.cz`
- Telefon: `+420 777 000 000`
- Adresa: reálná adresa (persona bydliště), PSČ odpovídající
- Poznámka k objednávce: **musí obsahovat** řetězec `TEST OBJEDNÁVKA — prosím ignorovat`

**Co persona pozoruje:**
- Je formulář rozumně rozdělený na kroky, nebo jedna dlouhá stránka?
- Jsou povinná pole jasně označená?
- Autocomplete z browseru funguje?
- Validace — hlásí chyby hned, nebo až po submitu? Jsou srozumitelné?
- Doprava & platba — kolik možností? Jasné ceny? Odhad doručení?
- Je vidět průběžný souhrn objednávky?
- Stack panic: persona omylem klikne zpět — ztratí data?
- GDPR & souhlas s podmínkami — jasné, nebo schované?
- Guest checkout je možný, nebo nutí k registraci?

**KRITICKÁ HRANICE:**
- Persona, která **NENÍ Designated Buyer**, zastaví **na stránce posledního kroku, přímo před tlačítkem "Odeslat objednávku"**. Tlačítko NESMÍ kliknout. Udělá screenshot stavu a napíše, jestli by v reálu tlačítko zmáčkla.
- Persona, která **JE Designated Buyer**, klikne Odeslat. Jednou. Vyplní výše uvedenou poznámku. Zachytí stránku potvrzení + číslo objednávky.

**Capture:** screenshot každého kroku checkoutu, observation per krok.

---

## Step 7 — Submit (pouze Designated Buyer)

Pouze pokud jsi Designated Buyer:

1. Zkontroluj, že v poli poznámky je `TEST OBJEDNÁVKA — prosím ignorovat`.
2. Klikni "Odeslat objednávku" (nebo ekvivalent).
3. Zachyť:
   - Screenshot děkovací stránky
   - Číslo objednávky (pokud je zobrazené)
   - Zda přijde confirmation email (pokud ten email kontroluješ, jinak zapiš že neověřeno)
4. **Nezkoušej to znovu.** Jeden request, jeden test order.

---

## Decision verdict (povinný poslední záznam)

Na konec každý persona report dopiš strukturovaný verdikt:

```markdown
## Verdikt

**Rozhodnutí:** [Koupila bych / Váhám / Odešla bych]

**Pravděpodobnost dokončení (0–10):** [číslo]

**Jeden důvod, který to rozhodl:** [věta]

**Největší friction:**  
1. …
2. …
3. …

**Co mě naopak potěšilo:**  
1. …
2. …
```

---

## Persona focus — extra důraz

Každá persona má v definici pole `focus` — extra oblast, které věnuje víc pozornosti než průměr. Ale journey je stále stejná kostra — focus jen zvětšuje hloubku pozorování v dané oblasti.

Příklady:
- focus = "rychlost dopravy a skladovost" → ve Step 3 podrobně prozkoumá dostupnost, v Step 5 ověří, co stojí expres, v Step 6 zkontroluje, zda lze doručit do konkrétního data.
- focus = "dětská bezpečnost a materiály" → na PDP intenzivně hledá složení / certifikáty / atesty, aktivně hledá "pro děti" sekci v patičce.
- focus = "cena a konkurence" → během journey si otevře srovnávač a porovná 2 produkty s konkurencí.

---

## Časový budget

Každá persona má cca 15–20 minut "reálné" doby. V rámci Playwright session to bude rychlejší (žádné skutečné čtení), ale nesmí to být "splní 7 kroků za 30 vteřin". Každý krok potřebuje dostatek interakce, aby persona reálně nasbírala pozorování. Pokud persona doběhne journey za méně než 5 minut Playwright činností, nejspíš neudělala kvalitní práci — rozšiř hloubku pozorování (víc produktů, víc kategorií, vrácení se o krok zpět).

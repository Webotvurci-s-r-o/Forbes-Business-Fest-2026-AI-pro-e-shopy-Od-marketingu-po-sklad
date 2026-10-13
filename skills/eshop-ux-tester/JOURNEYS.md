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

**Cesta A — Vyhledávání (POVINNÁ MATICE — přesně 3 dotazy):**

Každá persona zadá **tři** dotazy a u každého zaznamená: přesný zadaný text, počet výsledků, názvy top 3 výsledků, zda naskočil autocomplete.

1. **Přesný dotaz** — konkrétní produkt/model/značka, kterou persona hledá ("oregon 3/8 řetěz", "GABI standard").
2. **Přirozený/nepřesný dotaz** — jak by to napsal reálný člověk, včetně překlepů a bez diakritiky u méně zdatných person ("bluza cervena M", "polohovaci postel pronajem").
3. **Use-case dotaz** — účel místo produktu ("stan na svatbu", "dárek pro vapera", "židle pro dítě se skoliózou").

Use-case dotazy historicky odhalily nejcennější nálezy celého testu (vyhledávač vrátil nic / nesmysl) — proto jsou povinné, ne volitelné.

**Cesta B — Navigace:**
- Najde správnou kategorii v menu?
- Jsou kategorie pojmenované řečí uživatele, nebo řečí eshopu? ("Svrchní oděvy" vs "Bundy a kabáty")
- **POVINNÉ: použij aspoň jeden filtr a jedno řazení** (cena, velikost, skladem…). Pokud kategorie filtry ani řazení nemá, je to samo o sobě zjištění — zapiš ho explicitně ("kategorie X s 23 produkty nemá žádné řazení ani filtr").
- Kolik produktů uvidí? 12 a musí klikat další stránku? Infinite scroll? 100 najednou?

**Capture:** screenshot výsledků každého dotazu / kategorie s aplikovaným filtrem, observation.

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
- Doprava & platba — kolik možností? Jasné ceny? Odhad doručení?
- Je vidět průběžný souhrn objednávky?
- GDPR & souhlas s podmínkami — jasné, nebo schované?
- Guest checkout je možný, nebo nutí k registraci?

**POVINNÉ MICRO-TESTY (každý se screenshotem a výsledkem pass/fail):**

Tohle nejsou volitelná pozorování — každá persona, která dojde do checkoutu, provede všech šest (mobilní bod jen mobilní persony):

| # | Test | Co zaznamenat |
|---|---|---|
| a | Odeslat formulář **prázdný** | Přesné texty chybových hlášek; skočí fokus na první chybné pole? |
| b | Zadat **neplatný e-mail** a **neplatné PSČ** | Přesné hlášky; validace hned, nebo až po submitu? |
| c | Zadat smyšlený kupón **`TEST123`** do pole pro slevu | Přesná hláška; je pole vůbec k nalezení? |
| d | Kliknout **Zpět v prohlížeči** z posledního kroku | Co přežilo? (vyplněná pole, košík, vybraná doprava) |
| e | Změnit **množství 1→2→1** v košíku | Přepočítá se cena + doprava správně a hned? |
| f | *(jen mobil)* Fokus na poslední pole formuláře | Je hlavní CTA pod klávesnicí? Screenshot s otevřenou klávesnicí. |

**KRITICKÁ HRANICE:**
- Persona, která **NENÍ Designated Buyer**, zastaví **na stránce posledního kroku, přímo před tlačítkem "Odeslat objednávku"**. Tlačítko NESMÍ kliknout. Udělá screenshot stavu a napíše, jestli by v reálu tlačítko zmáčkla.
- Persona, která **JE Designated Buyer**, klikne Odeslat. Jednou. Vyplní výše uvedenou poznámku. Zachytí stránku potvrzení + číslo objednávky.

**Capture:** screenshot každého kroku checkoutu, observation per krok.

---

## Step 7 — Submit (pouze Designated Buyer)

Pouze pokud jsi Designated Buyer:

1. **Zvol platbu převodem, dobírkou nebo fakturou — NIKDY online kartou / platební bránou.** Brána (GoPay, ComGate, Adyen…) tě po submitu přesměruje pryč z eshopu a přijdeš o děkovací stránku i číslo objednávky — přesně to se stalo ve 3 ze 4 historických běhů. Číslo objednávky je hlavní důkaz celého testu. (Chování platebních bran popiš z checkout kroku, kde jsou vypsané — neklikej do nich.)
2. Zkontroluj, že v poli poznámky je `TEST OBJEDNÁVKA — prosím ignorovat`.
3. Klikni "Odeslat objednávku" (nebo ekvivalent).
4. Zachyť:
   - Screenshot děkovací stránky
   - **Číslo objednávky** (pokud je zobrazené) — bez něj je test poloviční
   - Zda přijde confirmation email (pokud ten email kontroluješ, jinak zapiš že neověřeno)
5. Pokud tě přesto něco přesměrovalo pryč (nešlo se bráně vyhnout), vrať se na eshop a zkus zachytit stav objednávky / košíku. Zapiš přesně, co se stalo.
6. **Nezkoušej to znovu.** Jeden request, jeden test order.
7. Pokud submit nešel dokončit (age-gate, blokovaná pole, technická chyba): zapiš přesný krok a důvod do reportu jako `Provedená akce: blokována — <důvod>`. Orchestrátor to v SUMMARY uvede jako omezení testu, ne jako chybu eshopu (pokud nejde prokazatelně o chybu, kterou by zažil i reálný člověk).

---

## Decision verdict (povinný poslední záznam)

Na konec každý persona report dopiš strukturovaný verdikt. **Bez tohoto bloku je report neúplný** — orchestrátor ho vyžaduje pro syntézu.

```markdown
## Verdikt

**Provedená akce:** [odeslala objednávku č. X / zastavila před odesláním / blokována — důvod]

**Rozhodnutí:** [Koupila bych / Váhám / Odešla bych]

**Pravděpodobnost dokončení (0–10):** [číslo]

**Co by muselo být jinak, aby to bylo o 3 body výš:** [1–2 věty]

**Jeden důvod, který to rozhodl:** [věta]

**Největší friction:**  
1. …
2. …
3. …

**Co mě naopak potěšilo:**  
1. …
2. …
```

**Pravidla pro verdikt:**

- **Definice skóre:** pravděpodobnost, že TATO persona dokončí TENTO nákup **online v TÉTO návštěvě**. Ne "jestli by někdy nakoupila" ani "jestli by zavolala" — to patří do textu rozhodnutí.
- **Provedená akce ≠ rozhodnutí.** "Dokončil jsem skript" není důvod psát "Koupila bych". Akce říká, co se v testu stalo; rozhodnutí říká, co by persona udělala v reálu.
- **Konzistence:** pokud jsi v textu něco označil jako dealbreaker / KO kritérium, skóre nesmí být ≥7. Buď to dealbreaker není (přepiš text), nebo je skóre nižší.
- **Rod a osoba:** piš celý report v rodě odpovídajícím personě (Jaroslav → "koupil bych", Jitka → "koupila bych"). Zkontroluj před uložením.

---

## Persona focus — extra důraz

Každá persona má v definici pole `focus` — extra oblast, které věnuje víc pozornosti než průměr. Ale journey je stále stejná kostra — focus jen zvětšuje hloubku pozorování v dané oblasti.

Příklady:
- focus = "rychlost dopravy a skladovost" → ve Step 3 podrobně prozkoumá dostupnost, v Step 5 ověří, co stojí expres, v Step 6 zkontroluje, zda lze doručit do konkrétního data.
- focus = "dětská bezpečnost a materiály" → na PDP intenzivně hledá složení / certifikáty / atesty, aktivně hledá "pro děti" sekci v patičce.
- focus = "cena a konkurence" → během journey si otevře srovnávač a porovná 2 produkty s konkurencí.

**Pravidlo konkurence:** pokud v reportu tvrdíš, že by ses "podívala ke konkurenci" nebo že "konkurence to má lépe", musíš tu konkurenční stránku v Playwrightu **reálně otevřít** a zaznamenat aspoň jeden konkrétní údaj (cenu, dodací lhůtu, počet fotek) + screenshot. Jinak tvrzení o konkurenci z reportu vypusť. Neověřené srovnání s konkurencí je nejrychlejší způsob, jak před klientem ztratit důvěryhodnost.

---

## Časový budget

Každá persona má cca 15–20 minut "reálné" doby. V rámci Playwright session to bude rychlejší (žádné skutečné čtení), ale nesmí to být "splní 7 kroků za 30 vteřin". Každý krok potřebuje dostatek interakce, aby persona reálně nasbírala pozorování. Pokud persona doběhne journey za méně než 5 minut Playwright činností, nejspíš neudělala kvalitní práci — rozšiř hloubku pozorování (víc produktů, víc kategorií, vrácení se o krok zpět).

# Number Match Party (Matching Party) — Zasady i Cel Gry

## Główna Idea Gry

**Number Match Party** to dwuwymiarowa gra platformowa (2D platformer) łącząca elementy zręcznościowe z mechanikami pamięciowymi oraz strategicznym zarządzaniem cierpliwością postaci.

Głównym motywem gry jest wchodzenie w interakcje z przyjaciółmi (postaciami NPC) na planszy, odkrywanie przypisanych im ukrytych liczb oraz łączenie w pary postaci o identycznych wartościach.

---

## Jak to działa? (Mechanika Rozgrywki)

1. **Ukryte Liczby:** Przed rozpoczęciem każdego poziomu wszystkim NPC na planszy zostają przypisane losowe, niewidoczne dla gracza liczby w parach.
2. **Eksploracja i Rozmowa:** Gracz porusza się po platformach (`strzałki lewo/prawo` + `spacja`), odnajduje postacie i rozmawia z nimi (`E`), aby dowiedzieć się, jaką liczbę skrywają.
3. **Podążanie za Graczem:** Gracz może poprosić dowolnego NPC (o ile ma wystarczającą cierpliwość) o podążanie — niezależnie od tego, czy zna już jego liczbę.
4. **Parowanie Postaci:** Gracz doprowadza idącego za nim NPC do innej postaci i **rozpoczyna z nią rozmowę**, wybierając opcję _Match!_. Gra sprawdza wówczas liczby obu postaci — jeśli są identyczne, obie znikają z planszy.
5. **Kara za błędne parowanie:** Próba połączenia dwóch NPC o różnych liczbach obniża cierpliwość wszystkich NPC na poziomie o 1 punkt.
6. **Zarządzanie Cierpliwością (Patience):** Każda postać ma swój poziom cierpliwości (max 5), która spada na skutek:
   - Zadawania pytań o liczbę (−1 za każde pytanie).
   - Zbyt długiego chodzenia za graczem (−0.1 na sekundę).
   - Błędnego parowania (−1 dla wszystkich NPC).
   - Bezczynna postać powoli regeneruje cierpliwość (+0.04 na sekundę).
7. **Skutki wyczerpania cierpliwości:** NPC odmawia podania swojej liczby i przestaje podążać za graczem. Cierpliwość regeneruje się jednak powoli sama z siebie (gdy NPC stoi bezczynnie), dzięki czemu można wyjść z trudnej sytuacji — wystarczy odczekać chwilę, zanim ponownie zapytamy lub poprosimy o podążanie.

---

## Restart Poziomu

Jeśli gracz lub dowolny NPC **spadnie poniżej granicy mapy**, poziom natychmiast się restartuje. Wymaga to ostrożności przy prowadzeniu NPC przez trudniejsze sekcje platformowe. Dobra strategia to prowadzenie NPC z góry na dół — NPC lepiej radzą sobie ze schodzeniem niż z wskakiwaniem na wyższe platformy.

---

## Typy Postaci (NPC)

W miarę przechodzenia kolejnych etapów gracz napotyka postacie o zróżnicowanych zachowaniach:

- **Zwykły (Basic):** Odpowiada na pytania wprost; jego cierpliwość spada standardowo.
- **Kujon (Nerd):** Przed wyjawieniem liczby zadaje graczowi zagadkę matematyczną lub logiczną. Pomyłka blokuje liczbę i wywołuje obelgę, ale nie zużywa cierpliwości przy ponownej próbie jeśli zagadka jest już rozwiązana.
- **Błazen (Jester):** Gdy jego cierpliwość spadnie poniżej 40%, zaczyna kłamać — podaje losową liczbę z zakresu 0–20 zamiast prawdziwej.
- **Teleporter:** Zaimplementowany w kodzie, lecz nieużyty w finalnych poziomach — rozgrywka z jego udziałem okazała się zbyt trudna i chaotyczna.

---

## Cel Gry

Głównym celem każdego poziomu jest **prawidłowe dopasowanie wszystkich postaci w pary**.

Aby odnieść sukces, gracz musi wykazać się:

- **Pamięcią** — zapamiętując podawane przez NPC liczby, by nie pytać ich wielokrotnie.
- **Refleksem i Zręcznością** — sprawnie pokonując przeszkody platformowe i pilnując, by NPC nie spadł z platformy.
- **Strategią** — pytając Błazna zanim straci cierpliwość, unikając błędnych parowań i szybko prowadząc NPC do jego pary.

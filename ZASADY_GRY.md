# Number Match Party (Matching Party) — Zasady i Cel Gry

## 💡 Główna Idea Gry
**Number Match Party** to dwuwymiarowa gra platformowa (2D platformer) łącząca elementy zręcznościowe z mechanikami pamięciowymi oraz strategicznym zarządzaniem cierpliwością postaci. 

Głównym motywem gry jest wchodzenie w interakcje z przyjaciółmi (postaciami NPC) na planszy, odkrywanie przypisanych im ukrytych liczb oraz łączenie w pary postaci o identycznych wartościach.

---

## 🎮 Jak to działa? (Mechanika Rozgrywki)

1. **Ukryte Liczby:** Przed rozpoczęciem każdego poziomu wszystkim NPC na planszy zostają przypisane losowe, niewidoczne dla gracza liczby.
2. **Eksploracja i Rozmowa:** Gracz musi poruszać się po platformach, odnajdywać postacie i rozmawiać z nimi, aby dowiedzieć się, jaką liczbę skrywają.
3. **Podążanie za Graczem:** Po poznaniu liczby gracz może poprosić danego NPC, aby zaczął za nim podążać.
4. **Parowanie Postaci:** Gracz doprowadza idącego za nim NPC do innej postaci z tą samą liczbą. Gdy dwie postacie o identycznych wartościach znajdą się blisko siebie, następuje dopasowanie.
5. **Zarządzanie Cierpliwością (Patience):** Każda postać ma swój poziom cierpliwości, która spada na skutek:
   - Zbyt częstego zadawania pytań.
   - Zbyt długiego chodzenia za graczem (wymaga to szybkiego i sprawnego działania).
   - Rozmawiania z innymi postaciami na mapie.
6. **Wskaźnik Sympatii (Global Likeliness):** Jeśli cierpliwość postaci spada, obniża to ogólny poziom sympatii w grze. Jeśli wskaźnik ten spadnie poniżej dopuszczalnego limitu, gracz **przegrywa poziom**.
7. **Monety (Coins):** Udane dopasowania nagradzają gracza monetami, które można wydać na przywrócenie cierpliwości postaciom lub zmniejszenie negatywnych skutków jej utraty.

---

## 👥 Typy Postaci (NPC)
W miarę przechodzenia kolejnych etapów gracz napotyka postacie o zróżnicowanych zachowaniach:
* **Zwykły (Basic):** Odpowiada na pytania wprost; jego cierpliwość spada standardowo.
* **Kujon (Nerd):** Przed wyjawieniem liczby zadaje graczowi zagadkę matematyczną lub logiczną.
* **Błazen (Jester):** Gdy jego cierpliwość jest niska, zaczyna kłamać i przy każdym pytaniu podaje losowe, nieprawdziwe liczby.
* **Teleporter:** Co jakiś czas losowo teleportuje się w inne miejsce na mapie, co utrudnia jego śledzenie.

---

## 🎯 Cel Gry
Głównym celem każdego poziomu jest **prawidłowe dopasowanie wszystkich postaci w pary przed spadkiem globalnego wskaźnika sympatii (Global Likeliness) do zera**.

Aby odnieść sukces, gracz musi wykazać się:
* **Pamięcią** – zapamiętując podawane przez NPC liczby, by nie pytać ich wielokrotnie.
* **Refleksem i Zręcznością** – sprawnie pokonując przeszkody platformowe.
* **Strategią** – planując optymalne trasy parowania i odpowiednio zarządzając budżetem monet.

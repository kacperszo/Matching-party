# Number Match Party (Matching Party) — Dokumentacja Projektu

## Spis treści

1. [Krótki opis gry](#1-krótki-opis-gry)
2. [Użyte narzędzia](#2-użyte-narzędzia)
3. [Mechanika gry](#3-mechanika-gry)
4. [Użyte assety](#4-użyte-assety)
5. [Wykorzystanie sztucznej inteligencji (AI)](#5-wykorzystanie-sztucznej-inteligencji-ai)
6. [Instrukcja uruchomienia gry](#6-uruchomienie-gry)
7. [Bibliografia i źródła](#7-bibliografia)

---

### 1. Krótki opis gry

**Tytuł:** Number Match Party (znana również jako _MatchParty_)

**Koncepcja i cel gry:**
Gra jest dwuwymiarową platformówką (2D platformer) z elementami gry pamięciowej (memory) oraz strategicznym zarządzaniem relacjami i cierpliwością postaci NPC. Zadaniem gracza jest przemieszczanie się po poziomach, rozmawianie z napotkanymi przyjaciółmi (NPC) i odkrywanie przypisanych im na początku poziomu, ukrytych liczb. Gracz może nakazać jednemu z przyjaciół podążanie za sobą, a następnie doprowadzić go do innej postaci z identycznym numerem, aby ich połączyć (sparować). Poziom zostaje ukończony sukcesem, kiedy wszystkie postacie zostaną pomyślnie dopasowane w pary przed wyczerpaniem się wskaźnika globalnej sympatii (Global Likeliness).

**Inspiracje:**

- **Inspiracje bezpośrednie:** Klasyczne, dwuwymiarowe platformówki zręcznościowe, takie jak _Super Mario Bros._ (stylistyka poziomów, ruch gracza, skakanie po platformach).
- **Inspiracje pośrednie:** Gry logiczne i pamięciowe (np. tradycyjna gra _Memory_ polegająca na szukaniu par, gry karciane). Gra wymaga od gracza zapamiętywania wcześniej usłyszanych liczb, aby nie tracić cennego czasu i punktów cierpliwości NPC na ponowne pytania.

**Cechy charakterystyczne i innowacje:**
Większość platformówek skupia się na walce, unikaniu przeszkód lub zbieraniu przedmiotów. _Number Match Party_ przenosi punkt ciężkości na interakcje społeczne i zarządzanie zasobami (cierpliwością postaci).
Kluczowymi innowacjami są:

1. **Dynamiczne typy NPC:**
   - _Kujon (Nerd)_ – nie zdradzi swojej liczby, dopóki gracz nie odpowie na jego zagadkę logiczną/matematyczną.
   - _Błazen (Jester)_ – wraz ze spadkiem jego cierpliwości rośnie prawdopodobieństwo, że zacznie kłamać i podawać złośliwie losowe liczby.
   - _Teleporter_ – dynamicznie zmienia swoją pozycję na mapie, zmuszając gracza do ponownego odszukania go.
2. **Wielowymiarowy system cierpliwości:** Cierpliwość NPC wyczerpuje się nie tylko przy zadawaniu pytań, ale również podczas podążania za graczem (stres) oraz gdy postacie rozmawiają między sobą.
3. **Globalna sympatia (Global Likeliness):** Wyczerpanie cierpliwości pojedynczych NPC wpływa negatywnie na globalną atmosferę imprezy, co może prowadzić do przegranej.

---

### 2. Użyte narzędzia

- **Silnik gry:** Godot Engine 4 (skonfigurowany pod wersję 4.6+, wykorzystujący wydajny renderer _Forward Plus_).
- **Język skryptowy logiki:** GDScript (użyty do oprogramowania ruchu postaci, fizyki, logiki poziomów, algorytmu parowania i zachowania NPC).
- **Obsługa dialogów:** Plugin _Dialogue Manager_ (język skryptowy `.dialogue`), umożliwiający tworzenie dynamicznych, rozgałęzionych dialogów z warunkami logicznymi i wywoływaniem metod silnika bezpośrednio z poziomu konwersacji.
- **Formaty danych:** JSON (przechowywanie pytań, obelg oraz domyślnych dialogów).
- **Platforma docelowa:** Komputery osobiste PC (Windows, macOS, Linux) oraz przeglądarki internetowe wspierające WebGL2/HTML5.

---

### 3. Mechanika gry

**Opis świata:**
Świat gry jest dwuwymiarowy (2D), ograniczony rozmiarem poszczególnych plansz. Składa się z wiszących platform, przeszkód terenowych oraz stabilnego podłoża, po których poruszają się gracz i postacie NPC.

**Zachowanie kamery:**
Kamera śledzi pozycję gracza w czasie rzeczywistym w osi X i Y, zaimplementowano płynne wygładzanie ruchu (Camera Smoothing), co zapobiega gwałtownym szarpnięciom obrazu podczas skoków i nagłych zmian kierunku.

**Opis postaci i ich atrybutów:**

1. **Gracz (Player):**
   - Sterowanie: Ruch w lewo/prawo (Strzałki / klawisze ruchu) oraz skok (Spacja).
   - Zaawansowane ulepszenia fizyki ruchu (Game Feel):
     - **Coyote Time (0.12s):** Czas po zejściu z krawędzi platformy, w którym gracz nadal może wykonać skok w powietrzu.
     - **Jump Buffer (0.12s):** Zapamiętywanie wciśnięcia przycisku skoku tuż przed wylądowaniem, co sprawia, że postać skacze natychmiast po dotknięciu ziemi.
     - **Zmienna wysokość skoku:** Zwolnienie przycisku skoku w locie zmniejsza prędkość wznoszenia o połowę, dając graczowi większą kontrolę.
   - Zasięg interakcji: Promień interakcji wokół gracza (60 pikseli), pozwalający na aktywowanie rozmowy z NPC przyciskiem interakcji (`E`).

2. **Przyjaciele (NPC):**
   - Każdy NPC dziedziczy z bazowej klasy `NPC` i posiada indywidualny pasek cierpliwości (ProgressBar) wyświetlany nad jego głową.
   - **Cierpliwość (Patience):**
     - Maksymalna wartość: `5.0`.
     - Koszt zapytania o liczbę: `1.0`.
     - Koszt podążania (Follow drain): `0.1` na sekundę (NPC denerwuje się i męczy ciągłym bieganiem za graczem).
     - Regeneracja cierpliwości: `0.04` na sekundę gdy postać stoi bezczynnie.
   - W przypadku spadku cierpliwości do zera, NPC odmawia współpracy i wypowiada losowe kwestie frustracji (np. _"GO AWAY! I'm calling the pixel police!"_).
   - **Mechanika podążania:** NPC potrafią biegać za graczem, a także skakać na wyższe platformy, gdy gracz znajduje się odpowiednio wysoko (próg wysokości `60px`). W danym momencie za graczem może podążać maksymalnie jeden NPC (włączenie podążania u innego automatycznie zatrzymuje poprzedniego).
   - **Mechanika parowania:** Gdy gracz prowadzi jednego NPC i wejdzie w interakcję z drugim, pojawia się opcja _Match!_. Gra sprawdza ukryte wartości obu postaci:
     - _Zgodność:_ Obie postacie znikają z planszy (zostają pomyślnie dopasowane).
     - _Niezgodność:_ Następuje kara – cierpliwość wszystkich NPC na poziomie zostaje obniżona o `1.0`.

**Typy NPC i ich zachowania:**

- **Zwykły (BasicNPC):** Odpowiada na pytania wprost; jego cierpliwość spada standardowo.
- **Kujon (NerdNPC):** Przed ujawnieniem swojej liczby zadaje graczowi losowe pytanie testowe (matematyczne, geograficzne, historyczne lub ogólne). Jeśli gracz odpowie błędnie, Kujon rzuca obelgą (np. _"I've seen rocks with higher cognitive function than you."_) i nie ujawnia liczby, a kolejna próba zużywa cierpliwość. Rozwiązanie zagadki zapisuje stan `riddle_solved = true` na danym NPC, eliminując konieczność ponownego odpowiadania.
- **Błazen (JesterNPC):** Zachowuje się normalnie, gdy jego cierpliwość jest wysoka. Kiedy spadnie poniżej progu `40%`, zaczyna kłamać – przy każdym zapytaniu generuje losową liczbę z przedziału `0-20`, aby zmylić gracza.
- **Teleporter (TeleporterNPC):** Co losowy czas (`25.0` do `40.0` sekund) teleportuje się w losowe miejsce na planszy oznaczone w grupie `teleport_points` (pod warunkiem, że punkt docelowy nie jest już zajęty przez innego NPC). Jeśli w trakcie teleportacji trwał dialog z graczem, zostaje on automatycznie przerwany.

**System walki:**
W grze nie występuje przemoc ani system walki. Konflikt opiera się na wyścigu z czasem (spadająca cierpliwość) oraz wyzwaniach intelektualnych (zagadki, zapamiętywanie).

**Sugestie taktyczne dla gracza:**

- **Pisz lub zapamiętuj:** Próba zapamiętania wszystkich liczb „w głowie” jest trudna na wyższych poziomach. Warto kojarzyć postacie (np. Pink Man, Ninja Frog) z ich liczbami.
- **Oszczędzaj pytania:** Nie pytaj tej samej postaci wielokrotnie. Każde pytanie kosztuje 1 punkt cierpliwości.
- **Zapobiegaj kłamstwom Błazna:** Błazna pytaj na samym początku, póki ma pełną cierpliwość. Gdy jego cierpliwość spadnie, jego informacje staną się bezużyteczne.
- **Szybkie parowanie:** Kiedy NPC zaczyna za Tobą podążać, biegnij prosto do jego pary. Czas spędzony na podążaniu stale obniża jego pasek cierpliwości.
- **Zwracaj uwagę na Kujona:** Zagadki Kujona nie mają limitu czasu – zastanów się dobrze przed wyborem odpowiedzi, pomyłka blokuje informację i marnuje cierpliwość.

**Interfejs Użytkownika (UI):**

- **Menu Główne:** Zrealizowane jako estetyczna karta menu z dynamicznymi mikroanimacjami. Tło menu ozdobione jest unoszącymi się postaciami i owocami (efekt pływania/sinusoidy). Przyciski reagują na najechanie myszą płynnym powiększeniem skali (LERP) oraz zmianą przezroczystości.
- **Paski Cierpliwości:** Minimalistyczne, dopasowane kolorystycznie paski nad głowami postaci (zielone wypełnienie na ciemnoszarym tle), ułatwiające szybką ocenę stanu psychicznego NPC.
- **Dymki Dialogowe:** Estetyczne panele dialogowe wyświetlane na dole ekranu, obsługujące interaktywne opcje wyboru odpowiedzi (w tym wielokrotny wybór w zagadkach Kujona).

---

### 4. Użyte assety

Wszystkie assety graficzne użyte w projekcie są darmowymi zasobami i zostały zaimportowane z zewnętrznych źródeł:

- **Grafika 2D (Pixel Art):**
  - Pakiet **"Pixel Adventure 1"** oraz **"Pixel Adventure 2"** autorstwa **Pixel Frog**.
  - Licencja: CC0 (Public Domain / do użytku darmowego i komercyjnego).
  - Źródło: [Pixel Frog na itch.io](https://pixelfrog-assets.itch.io/).
  - Zawartość: Animacje ruchu gracza i postaci NPC (Ninja Frog, Pink Man, Mask Dude, Virtual Guy), kafle ziemi, platformy, dekoracje (owoce, flagi) oraz tła poziomów.
- **Muzyka i Dźwięki:**
  - Gra w obecnej wersji prototypowej **nie posiada wdrożonej ścieżki dźwiękowej ani efektów dźwiękowych**. Planowane jest ich dodanie w kolejnych etapach projektu.

---

### 5. Wykorzystanie sztucznej inteligencji (AI)

Sztuczna inteligencja odegrała istotną rolę w procesie tworzenia gry na kilku płaszczyznach:

1. **Generowanie kodu źródłowego:**
   - Wykorzystano duże modele językowe (LLM) do optymalizacji skryptów fizyki ruchu gracza w GDScript (szczególnie wdrożenie responsywnego systemu Coyote Time i Jump Buffer) oraz implementacji algorytmu wyszukiwania wolnych punktów dla postaci typu Teleporter.
2. **Generowanie treści tekstowych:**
   - Baza pytań i odpowiedzi (zagadki logiczno-matematyczne w `riddles.json`), złośliwe obelgi Kujona (`insults.json`) oraz kwestie po utracie cierpliwości (`patience_responses.json`) zostały wygenerowane i sformatowane przy użyciu sztucznej inteligencji.
3. **Logika zachowania NPC (Game AI):**
   - Zachowanie postaci NPC opiera się na deterministycznej maszynie stanów (State Machine) zakodowanej w GDScript (stany: spoczynek/regeneracja, podążanie, parowanie, teleportacja). W obecnej wersji nie stosowano sieci neuronowych ani algorytmów uczenia maszynowego wewnątrz silnika gry.

---

### 6. Uruchomienie gry

Gra dostarczana jest w formie gotowego pliku wykonywalnego (pliku `.exe` dla systemu Windows). Aby uruchomić grę lokalnie, wykonaj poniższe kroki:

**Instrukcja uruchomienia:**

1. Pobierz paczkę z gotową grą (archiwum zip/rar) zawierającą pliki gry.
2. Rozpakuj zawartość archiwum w dowolnym folderze na swoim dysku.
3. Uruchom grę, klikając dwukrotnie na plik wykonywalny `.exe` (np. `NumberMatchParty.exe`).
4. Domyślnie gra otworzy się w oknie lub trybie pełnoekranowym, zaczynając od menu głównego.

---

### 7. Bibliografia

1. **Dokumentacja Godot Engine 4:** [https://docs.godotengine.org/](https://docs.godotengine.org/) — materiały referencyjne dotyczące fizyki ciał fizycznych (`CharacterBody2D`) oraz systemu sygnałów.
2. **Plugin Dialogue Manager:** [https://github.com/nathanhoad/godot_dialogue_manager](https://github.com/nathanhoad/godot_dialogue_manager) — repozytorium i dokumentacja systemu dialogowego autorstwa Nathana Hoada.
3. **Zasoby graficzne Pixel Frog:** [https://pixelfrog-assets.itch.io/](https://pixelfrog-assets.itch.io/) — licencja i pobieranie paczek _Pixel Adventure_.
4. **Metodyka Game Feel (Coyote Time & Jump Buffer):** Luyren, _Platformer Physics in Godot_ — internetowe opracowania optymalizacji sterowania w grach platformowych 2D.

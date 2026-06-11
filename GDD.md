# Number Match Party - Game Design Document

> Wewnętrzny dokument projektowy zespołu. Pełna dokumentacja gry znajduje się w [README.md](README.md).

## Overview

**Number Match Party** is a 2D platform game inspired by classic games like Mario.  
Before the start of each level, NPCs (friends) are automatically assigned hidden numbers.  
The player's goal is to find 2 NPCs with the same number, ask them about their numbers, and match them together.

The game focuses on platforming, NPC interaction, memory, and patience management across increasingly difficult levels.

---

# Game Objective

The main goal of the player is to:

- Navigate through 2D platform levels
- Find and interact with NPCs to learn their numbers
- Ask NPCs to follow you
- Match 2 NPCs with the same number together
- Progress through levels of increasing difficulty

**The level finishes once all people are matched.**

Success requires balancing efficient exploration with careful patience management.

---

# Level Structure

The game contains four levels of increasing difficulty:

- **Tutorial (Level 0):** A "Party Host" NPC auto-greets the player and explains the mechanics (excluded from matching). One pair of basic NPCs to practice on.
- **Level 1:** Four NPCs (two pairs), introduces Jester NPCs.
- **Level 2-3:** Five NPCs each, both Nerd and Jester NPCs; more complex platforming layouts.

**Win condition:** All pairs matched, advance to next level.  
**Restart condition:** Player or any NPC falls below the map boundary, level restarts immediately.

---

# Core Gameplay Mechanics

## Number Assignment

At the start of each level, NPCs are automatically assigned hidden numbers in pairs.

- Numbers are **not visible** to the player
- Players must **ask NPCs directly** about their numbers
- NPCs will reveal their number when asked (depending on their type and patience)

---

## NPC Interactions

### Asking About Numbers

- The player approaches an NPC and presses `E` to start dialogue
- The NPC reveals their number (if they have patience remaining)
- Each ask costs 1.0 patience

### Following Mechanic

- The player can ask any NPC to follow them via dialogue - regardless of whether their number is known yet
- The NPC runs after the player at 80 px/s and can jump onto platforms independently
- Only one NPC can follow at a time - starting a new follower stops the previous one
- NPC patience drains at 0.1/s while following; at zero patience the NPC stops following automatically

### Matching NPCs

- When the player has an NPC following them, they must **start a dialogue** with a second NPC and choose the _Match!_ option - matching is never automatic
- If numbers match: both NPCs disappear (matched), success sound plays
- If numbers differ: all NPCs on the level lose 1.0 patience (fail sound plays)

---

## Patience System

Each NPC has a **patience level** (max 5.0).

### Patience Drain

- Asking an NPC their number: **−1.0**
- Following the player: **−0.1 per second**
- Failed match attempt: **−1.0 to all unmatched NPCs**

### Patience Recovery

- Idle (not following): **+0.04 per second**

### Consequences of Zero Patience

- NPC refuses to reveal their number and says a random frustration line
- NPC stops following if currently following

---

# Types of NPCs

## Basic Type

- Answers the number question directly
- Standard patience behaviour

## Nerd Type

- Before answering, asks the player a random challenge (math, geography, history, general knowledge)
- Incorrect answer triggers an insult and blocks the number for that interaction
- Once the riddle is solved (`riddle_solved = true`), no further challenges are needed for that NPC

## Jester Type

- Behaves normally when patience is high
- **Below 40% patience**, may lie - the lie chance scales linearly from 60% at the threshold to 100% at zero patience; a lie returns a random number in range 0-20 instead of the real one

## Teleporter Type *(implemented; cut from final levels after playtesting)*

- Randomly teleports to a designated `teleport_points` location every 25-40 seconds
- Teleportation is skipped while following; active dialogue is interrupted on teleport
- Playtesting showed that levels featuring this NPC lost readability - players struggled to keep track of who was who. We made a deliberate design decision to prioritize a coherent player experience over mechanic count; the code remains in the project for future levels designed around it

---

# Player Strategy

- **Remember NPC numbers** to avoid asking the same NPC twice
- **Ask the Jester first** while their patience is full - once it drops they start lying
- **Match quickly** when an NPC is following - patience drains continuously
- **Think before matching** - a wrong match penalizes every NPC on the level
- **Watch platform edges** - a falling NPC restarts the level

---

# Genre

2D platformer / puzzle / memory / NPC management game.

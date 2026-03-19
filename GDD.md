# Number Match Party

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

# Core Gameplay Mechanics

## Level-Based Progression

The game is split into multiple levels, each harder than the previous one.

- Levels feature different layouts and platforming challenges
- More NPCs and number variety in later levels
- Different types of NPCs appear as difficulty increases

---

## Number Assignment

At the start of each level, NPCs are automatically assigned hidden numbers.

- Numbers are **not visible** to the player
- Players must **ask NPCs directly** about their numbers
- NPCs will reveal their number when asked (depending on their type and patience)

---

## NPC Interactions

The player can interact with NPCs in the following ways:

### Asking About Numbers

- The player can ask an NPC what their number is
- The NPC will answer (if they have patience remaining)
- Some NPC types may have special conditions before answering

### Following Mechanic

- The player can ask an NPC to follow them
- The NPC will follow the player around the level
- The player can guide them to match with another NPC

### Matching NPCs

- When the player has 2 NPCs with the same number, they can match them
- Successful matches complete objectives and may award coins
- Following NPCs for too long may decrease their patience

---

## Losing Patience System

Each NPC has a **patience level** that decreases through various interactions.

### Ways to Lose Patience

**Repeated Interactions:**
- Making too many interactions with the same NPC decreases their patience
- Once patience is low, the NPC may stop answering questions about their number

**Following Too Long:**
- NPCs lose patience when they've been following the player for too long
- This encourages efficient matching

**NPCs Talking With Others:**
- NPCs may start talking with other NPCs
- When engaged in conversation, they are less likely to talk with the player

**Room for Additional Mechanics:**
- Additional patience-affecting mechanics can be added in the future

### Consequences of Low Patience

- NPCs stop answering questions
- NPCs may provide incorrect information (especially Jester type)
- Contributes to global likeliness decrease

### Global Likeliness

- There is a **global likeliness indicator** representing overall NPC attitude toward the player
- When any NPC's patience decreases, it may affect the global likeliness
- If global likeliness falls below a certain **threshold**, the player **loses the game**
- This creates a strategic challenge: manage all NPCs' patience, not just individual ones

---

# Coins System

Players can earn and spend coins during gameplay.

## Earning Coins

- Coins are earned through successful matches
- Bonus coins for efficient matches
- Coins may be found in levels

## Spending Coins

- **Buy Likeliness:** Coins can be used to increase an NPC's patience level
- **Decrease Patience Impact:** Reduce the negative effects of low patience
- Strategic use of coins is essential in harder levels

---

# Types of NPCs

As the game progresses and difficulty increases, different NPC types are introduced.

## Basic Type

- Standard NPC behavior
- Answers the question about their number directly
- Patience decreases with each interaction
- No special mechanics

## Nerd Type

- Before answering the number question, asks the player a challenge
- Challenges include:
  - Mathematical questions
  - Knowledge riddles
- The player must answer correctly to get the NPC's number
- Patience still decreases as normal

## Jester Type

- Behaves normally when patience is high
- **When patience decreases**, they become unreliable:
  - More likely to give an **incorrect number**
  - They do this to make fun of the player
- Adds risk to letting patience drop too low
- Requires careful patience management

## Teleporter Type

- Randomly teleports from one part of the map to another
- Makes them harder to track and interact with
- Teleportation happens periodically
- Adds an extra layer of difficulty in finding and matching them

## Future NPC Types

- Room for additional NPC types as the game expands
- More complex behaviors and challenges can be added

---

# Player Strategy

To succeed, the player should:

- **Efficiently explore** the 2D platforming levels
- **Minimize repeated interactions** with the same NPCs to preserve patience
- **Remember NPC numbers** to avoid asking multiple times
- **Match quickly** when NPCs are following to avoid patience loss
- **Manage global likeliness** by not over-interacting with any single NPC
- **Use coins strategically** to recover patience when needed
- **Adapt to different NPC types** and their unique mechanics
- **Plan routes** to efficiently gather information and make matches

---

# Game Progression

## Early Levels

- Few NPCs with simple number assignments
- Mostly Basic type NPCs
- Forgiving patience mechanics
- Simple platforming challenges

## Later Levels

- More NPCs and number variety
- Introduction of Nerd, Jester, and Teleporter types
- Stricter patience requirements
- Complex platforming layouts
- Requires efficient strategies and coin management

---

# Genre

2D platformer / puzzle / memory / NPC management game.

---

# Status

Concept / Early design stage.
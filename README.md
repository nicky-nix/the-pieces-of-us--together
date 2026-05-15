# 💖 The Pieces of Us · Together — Complete MVP Design Document

*A heartfelt, 2D puzzle‑platformer built in Godot for Android.  
Made with love for her 18th birthday on June 27th.  
Scope: 2 levels, 2 memory items, a full emotional arc, and plenty of dialogue.*

---

## 📖 1. Story & Emotional Arc (Full MVP Narrative)

### Prologue – "The Drift"
- The screen fades in on a starry void. Two soft silhouettes stand far apart on tiny floating islands.
- Text appears slowly, letter by letter:
  > **You:** "I'm here... where are you?"  
  > **Her:** "I can't see you. Find me."
- The island beneath Her crumbles slightly. The screen fades to white.

### Act 1 – "First Hello" (Level 1: The Café)
**Theme:** The early, gentle moments of getting to know each other.  
**Environment:** A warm but dimly lit café corner. Mismatched chairs, a wooden counter, floating coffee cups in the background, sticky notes on a wall.  
**Memory Item:** *Cat Doodle* – a silly, poorly drawn cat you once sketched on a napkin.

#### Key Dialogue Beats (Level 1)
1. **Level Start** – Characters appear on opposite sides of the counter.
   > **Her:** "It’s so dark over here... I can't see the way."  
   > **You:** "Hold on. I’ll find something."
2. **When You pushes the sack onto the switch** (a dim light flickers on):
   > **You:** "A little light. That's a start."
3. **When Her picks up the Cat Doodle**:
   > **Her (inner thought):** "This little cat... he drew this the day we laughed until we cried."
4. **When the Cat Doodle is used** (a floating cat platform appears):
   > **Her:** "Even your silliest drawings save me."
5. **After the Music Box is activated** (full light floods the room):
   > **You:** "The whole room is bright now."
   > **Her:** "Because we made it bright. Together."
6. **At the Memory Stone** (checkpoint at the end of the level):
   > **You:** "Even in the dark, we found a way."
   > **Her:** "Because you left me a little light."

### Act 2 – "Growing Together" (Level 2: The Hilltop)
**Theme:** Facing small storms together.  
**Environment:** A windy hilltop under a night sky, a rickety wooden bench, fireflies, and a swirling grey storm cloud in the distance.  
**Memory Item:** *Handwritten Note* – a real love letter you once gave her.

#### Key Dialogue Beats (Level 2)
1. **Level Start** – Wind visibly blows. Her gets pushed back.
   > **Her:** "This wind is too strong... I can't walk against it!"  
   > **You:** "Wait there. I'll stop the storm."
2. **When You breaks the rock wall** to reveal the note:
   > **You (inner thought):** "Every word I ever wrote was to bring her peace."
3. **When You picks up the Handwritten Note**:
   > **You:** "I remember writing this. I meant every word."
4. **When the Note is used on the storm pedestal** (wind stops, clouds part):
   > **Her:** "The storm... it's gone."
   > **You:** "Only because you're standing there."
5. **At the Memory Stone under the tree**:
   > **Her:** "You wrote away the storm."
   > **You:** "I’d write away anything for you."

### Epilogue – "You Found Me"
- Both characters stand together on a single, solid platform under a canopy of stars. Fireflies drift around them.
- The UI shows a single glowing heart. Tapping it triggers a gentle hug animation.
- Final dialogue appears in a beautiful, slow typewriter effect:
  > **Her:** "You found me."  
  > **You:** "I always will. Happy 18th birthday, [Her Name]."
- The screen fades into a personal letter from you, followed by one or two real photos. A small text at the bottom reads: *"Press anywhere to save a memory."* (If implemented, she can tap to save a screenshot of the in‑game moment to her phone gallery.)
- Background music softens, and an optional whispered "I love you" plays.

---

## 🗺️ 2. World Map – Simplified but Still Meaningful

Since this is an MVP, there is no separate interactive world map screen. Instead, the flow is linear but visually linked:

- **Prologue Scene** → fades to **Level 1** → after completing Level 1, a short transition shows the two islands drifting slightly closer → **Level 2** → transition with islands almost touching → **Epilogue** (islands merge).
- These transitions are simple 2-second animations (a tween moving two image sprites closer) and require only a single static background image split into two parts. It adds immense emotional value for very little work.

**Godot Implementation:**  
Create a `Transition.tscn` with two `Sprite2D` nodes (islands) and an `AnimationPlayer` that tweens their positions. Call it between levels.

---

## 👫 3. Characters – "You" and "Her" (Detailed)

### Visual Design
- **Style:** Minimal chibi or simple capsule characters (rounded rectangles) with distinct colors and one defining feature.
- **You:** Soft teal/blue, slightly taller or broader. Optional: a tiny scarf or glasses.
- **Her:** Warm pink/orange, a small flower or hair bow drawn on top.
- **Size:** 32×48 pixels, with simple 3‑frame animations: idle (gentle bob), run (2 frames), jump (1 frame).

### Abilities
| Character | Ability | How It Works |
|-----------|---------|---------------|
| **You** | **Strong Push** | Walk into a marked "Pushable" block (CharacterBody2D with a script) to move it. Walk into a "Breakable Wall" (StaticBody2D with an Area2D) to destroy it. |
| **Her** | **Light Up** | While holding the action button, a `PointLight2D` child node activates, revealing hidden `TileMap` layers or platforms that have their visibility tied to the light radius. |

### Character Switching
- A heart‑shaped `TouchScreenButton` in the top‑left corner. It shows two small portrait icons; the currently active character’s portrait is full color, the inactive one is greyed out.
- On tap: camera smoothly pans to the other character (using `Camera2D` tween), and input is redirected.
- While inactive, a character plays a slow "waiting" animation (looking around, softly glowing, etc.).

---

## 💎 4. Memory Items – The Heart of the Puzzles (MVP)

Only 2 items, each deeply personal.

### Item 1: Cat Doodle
- **Real memory:** A silly cat you drew on a napkin or in a notebook that made her laugh.
- **In‑game icon:** A simple, cute cat face on a crumpled paper background.
- **Puzzle function:** Summons a floating cat‑shaped platform that rises upward. Both characters can ride it.
- **When collected:** Dialogue box with memory text.
- **Usage:** Stand on a specific glowing spot near the music box, press "Action". The platform appears and slowly floats up for a few seconds.

### Item 2: Handwritten Note
- **Real memory:** A letter you wrote her, maybe for a special occasion or just because.
- **In‑game icon:** A folded paper with a tiny heart seal.
- **Puzzle function:** Calms the storm. When used on a stone pedestal, the wind zone disappears, clouds clear, and a bridge of stars appears.
- **When collected:** Dialogue box with inner thought.
- **Usage:** Carry to the pedestal (marked with a glowing symbol), press "Action". The area transforms.

**No inventory UI** — when an item is picked up, a small icon appears next to the action button. When used, it vanishes.

---

## 🧩 5. Level Design – Step by Step Walkthrough

### Level 1 – The Café (Cozy & Dim)

**Layout (single wide screen):**
- Left side: Your starting platform, a heavy sack (pushable block), a floor switch.
- Center: A tall wooden counter acting as a barrier.
- Right side: Her starting platform (dark, barely visible), a high alcove with a Music Box, and a dark corridor leading to the Memory Stone exit.

**Puzzle Sequence:**
1. **Start.** Her area is almost pitch black; only her silhouette is visible. Dialogue triggers.
2. Player (as You) walks right, pushes the sack onto the switch. A dim `PointLight2D` turns on above Her, revealing some platforms but not the path forward.
3. Switch to Her. She can now move a little. She walks right and picks up the **Cat Doodle** (sparkling item on a table). Dialogue.
4. She walks to the glowing spot beneath the alcove and uses the item. A floating cat platform rises from that spot, carrying her upward.
5. At the top, she finds the **Music Box** (an interactable object). Using her `Light Up` ability near it (or simply pressing action) plays a melody, and all lights in the café turn on fully.
6. Now, with full light, a bridge of warm light extends from Her's side to a central door, and the counter on Your side opens a gap.
7. Switch to You, walk through the gap, meet Her at the **Memory Stone** (a softly glowing crystal). Touching it triggers the final level dialogue and saves the game.

### Level 2 – The Hilltop (Windy & Starry)

**Layout:**
- Left side: Your starting area, a cracked rock wall, a storm pedestal.
- Right side: Her starting area, a winding path that is blocked by a strong wind zone (invisible Area2D that pushes Her back), and a starry bridge that is initially missing.
- Middle distance: The Memory Stone under a large, bare tree.

**Puzzle Sequence:**
1. **Start.** Wind howls, Her tries to move right but gets pushed back. Dialogue.
2. Player (as You) walks left, breaks the cracked wall (just walk into it). Inside a small nook lies the **Handwritten Note**. Pick it up. Dialogue.
3. Walk right to the storm pedestal (a stone with a glowing blue rune). Use the item there.
4. The wind immediately ceases, clouds part, and a beautiful bridge of twinkling stars connects Her path to the central tree.
5. Switch to Her, walk across the star bridge to the Memory Stone.
6. Switch back to You and walk directly to the same Memory Stone. Both characters arrive. Final level dialogue plays.
7. Touching the stone triggers the Epilogue transition.

---

## 🗣️ 6. Dialogue System – How It's Built in Godot

**Technical Design:**
- A `DialogueManager` autoload (singleton) controls all dialogue.
- It has functions: `show_dialogue(character, text)`, `advance()`, `hide()`.
- The UI is a `CanvasLayer` with a `Panel` and a `Label`. The label uses your handwritten font.
- Dialogue data is stored in a dictionary where keys are trigger IDs (e.g., `"level1_start"`) and values are arrays of { `char`, `line` } dicts.
- Triggers are `Area2D` nodes placed in the level. When the player enters, it calls `DialogueManager.show_dialogue(...)` and pauses movement until the dialogue is dismissed by tapping.

**Example dialogue dictionary:**
```gdscript
var dialogues = {
   "level1_start": [
      { "char": "Her", "line": "It’s so dark over here... I can't see the way." },
      { "char": "You", "line": "Hold on. I’ll find something." }
   ],
   "level1_found_cat": [
      { "char": "Her", "line": "This little cat... he drew this the day we laughed until we cried." }
   ]
   # ... etc
}

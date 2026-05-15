# 🎓 The Pieces of Us · Together — Complete Learning & Development Roadmap

*A zero‑to‑MVP guide for building a heartfelt 2D puzzle‑platformer in Godot as an Android APK.  
Made for her 18th birthday on June 27. No prior experience required.*

---

## 1. Overview & Time Budget

- **Total available days:** 44 (May 14 → June 27)
- **Daily commitment:** ~3 hours (≈ 132 total hours)
- **End product:** A 10‑15 minute 2‑level game with dual‑character switching, memory‑item puzzles, dialogue, and a personal epilogue.
- **Core philosophy:** Learn only what you need, build as you learn, ship from the heart.

---

## 2. Skill Map & Detailed Breakdown

### 2.1 Godot Engine Fundamentals (8‑10 h)
You need to be able to create scenes, add nodes, use the inspector, and export an APK.

| Sub‑skill | What you'll do | Time | Recommended resources |
|-----------|----------------|------|------------------------|
| **Interface & Scene System** | Navigate the editor, create 2D scenes, save/run. | 2h | Official docs "Step by Step" + Godot 4 2D tutorial (GDQuest/GameDev.tv) |
| **Nodes & Scenes** | Understand `Node2D`, `Sprite2D`, `Area2D`, `CollisionShape2D`, `CharacterBody2D`, `Camera2D`, `TileMap`, `PointLight2D`. | 2h | Godot documentation node pages; practice by adding each to a scene. |
| **Signals & basic connections** | Connect buttons, detect collisions, react to input. | 1.5h | "Dodge the Creeps" tutorial covers signals. |
| **Input Map & Touch** | Set up on‑screen buttons, map to actions (`ui_left`, `ui_right`, `jump`, `action`). | 1.5h | Godot "Mobile game with touch buttons" tutorials on YouTube. |
| **Export to APK** | Install Android build template, generate debug APK, test on phone. | 1h | Godot docs "Exporting for Android"; enable USB debugging on your phone. |
| **Total** | | **8h** | |

**Mini‑exercises to lock it in:**
1. Create a scene with a colored rectangle and a `Camera2D`; make it move left/right with keyboard.
2. Add a second scene and switch between them using a button.
3. Build a simple test with on‑screen touch buttons (use `TouchScreenButton` nodes) and run it on your phone.

---

### 2.2 GDScript Coding Skills (10‑12 h)
You don't need to be a programmer – just enough to write simple scripts that control the game.

| Sub‑skill | Where it's used | Time | Learning approach |
|-----------|-----------------|------|-------------------|
| **Variables, `export`, `@onready`** | Storing player speed, item references. | 1h | Follow along with beginner GDScript series (e.g., "GDScript in 10 minutes"). |
| **Functions & `_process`/`_physics_process`** | Movement code, checking states each frame. | 1.5h | Write small scripts that print a number every frame, then move a sprite. |
| **If statements & simple state** | Is this the active character? Is an item held? | 1h | Create a state variable and toggle behavior (e.g., change color on press). |
| **Vectors & movement (`velocity`, `move_and_slide`)** | Basic platformer physics. | 2h | Copy the `CharacterBody2D` movement template from the official docs; modify it. |
| **Signals & custom signals** | Trigger dialogue, puzzle solved event. | 1.5h | Define a custom signal `puzzle_solved` and emit it when an `Area2D` is entered. |
| **Autoloads (singletons)** | `GameManager` and `DialogueManager` global scripts. | 1.5h | Create a singleton that stores a variable; access it from another scene. |
| **Tween basics (`create_tween()`)** | Camera pan, UI fade, island animations. | 1h | Animate a sprite's position or modulate with one line of code. |
| **Collision layers & masks** | Who can push, who can break. | 1h | Set up layers and use `move_and_collide` to detect pushable objects. |
| **Total** | | **10h** | |

**Mini‑exercises:**
1. Make a ball that bounces using `move_and_slide()`.
2. Create a `Coin` scene with an `Area2D` that prints "collected" when entered.
3. Build an autoload that keeps a score, then display it on a label.

---

### 2.3 2D Platformer & Character Switching (5‑6 h)
These are the specific gameplay mechanics of your game.

| Sub‑skill | Implementation detail | Time | Tips |
|-----------|-----------------------|------|------|
| **CharacterBody2D movement with touch** | Left/right, jump, apply gravity, handle `Input.get_action_strength()`. | 1h | Use the template from the official "2D movement" docs; bind touch buttons. |
| **Switching between two players** | Two `CharacterBody2D` scenes; a global variable tracks `active_player`; `_input` only works for the active one. | 2h | Create a heart button that toggles a string `"you"` / `"her"`, and each player script checks if it's active. |
| **Pushable block** | A separate `CharacterBody2D` that moves when the player collides with it while holding a direction. | 1.5h | Use `move_and_collide` on the block; apply a velocity based on the player's direction. |
| **Breakable wall** | A `StaticBody2D` with an `Area2D` child; when the player with the "You" tag enters, queue_free(). | 1h | Use collision masks so only "You" can trigger it. |
| **PointLight2D / darkness** | Hide a tilemap layer until a light source reveals it; or use a light mask. | 1.5h | Create a `PointLight2D` on the "Her" scene; set the tilemap's `light_mask` so it's only visible when illuminated. |
| **Total** | | **6h** | |

**Mini‑exercises:**
1. Prototype the switch mechanic with two colored rectangles – tap the heart to control the other.
2. Make a crate that can be pushed and stops at walls.
3. Add a simple dark room: everything is black until the light character walks near, then a circle reveals platforms.

---

### 2.4 UI & Dialogue System (6‑8 h)
You need a dialogue box, an inventory indicator, a pause menu, and a title screen.

| Sub‑skill | What it does | Time | How to learn |
|-----------|--------------|------|---------------|
| **Control nodes basics** | `Panel`, `Label`, `TextureButton`, `MarginContainer`. | 1.5h | Build a simple title screen with a start button that changes scene. |
| **TouchScreenButton & anchors** | Position buttons for mobile, use anchors and margins. | 1h | Experiment with `Control` layout options; test on different screen sizes in the editor. |
| **Dialogue manager autoload** | Store lines in a dictionary, display them character‑by‑character, wait for tap to advance. | 3h | Create a `DialogueManager` singleton with functions `show_dialogue(trigger_id)` and `advance()`. Use a `Timer` to reveal text slowly. |
| **CanvasLayer** | Keep HUD and dialogue on top of the game world. | 0.5h | Attach all UI to a `CanvasLayer` node. |
| **Scene transitions** | Fade to black between levels. | 0.5h | Use a `ColorRect` and `create_tween()` to animate its `modulate.a`. |
| **Total** | | **6h** | |

**Mini‑exercises:**
1. Create a text box that shows "Hello" when you enter an `Area2D` and hides when you leave.
2. Make a dialogue system where tapping advances through multiple lines stored in an array.
3. Build a simple pause overlay that stops the game.

---

### 2.5 Pixel Art & Simple Animation (6‑10 h)
A charming, minimal style works – you don't need to be an artist.

| Sub‑skill | Tools / Approach | Time | Resources |
|-----------|------------------|------|-----------|
| **Pixel art editor basics** | Aseprite (paid) / LibreSprite (free) / Piskel (browser). Learn canvas, layers, onion skin. | 1h | YouTube: "Pixel art for beginners" (Brandon James Greer, AdamCYounis). |
| **Designing a tiny character (32×48)** | Silhouette, limited palette (3‑5 colors), simple features. | 2h | Study "chibi pixel art" references; sketch with basic shapes. |
| **Idle animation (3 frames)** | Slight up‑down bob, maybe a blink. | 1h | Duplicate frame, move a few pixels, toggle onion skin. |
| **Run animation (2‑4 frames)** | Simple leg movement, one step per frame. | 1.5h | Keep it super simple; even a sliding motion with a bounce can work. |
| **Tileset creation** | Ground, wall, counter tiles – 16×16 or 32×32 that repeat. | 2h | Use a grid; draw a few variations for dirt, wood, bricks. |
| **Backgrounds** | Soft gradient or starry sky (non‑pixel). | 1h | Can be done in any program (even Canva or a photo blurred). |
| **Total** | | **8h** | |

**Shortcuts:**  
- If drawing is too hard, use Kenney's free 1‑bit or platformer packs and recolor them.  
- For animation, 2‑frame "bobbing" is fine – nobody expects smooth 60fps sprites from a handmade gift.

---

### 2.6 Audio Sourcing & Editing (3‑4 h)
No composing required – just find free music and cut it.

| Sub‑skill | What you'll do | Time | Places to search |
|-----------|----------------|------|------------------|
| **Finding royalty‑free music** | One soft, looping instrumental. | 1h | Pixabay Music, Incompetech, FreeSound. Keywords: "soft ukulele lullaby", "calm piano loop". |
| **Basic audio editing (Audacity)** | Trim, loop, adjust volume, export as OGG. | 1.5h | Install Audacity (free); YouTube "Audacity loop music" tutorial. |
| **Adding audio to Godot** | `AudioStreamPlayer` nodes, trigger on item pickup. | 1h | Godot docs: "Audio Streams". |
| **Total** | | **3.5h** | |

**Mini‑exercise:**  
1. Find a loop, trim it to a perfect loop in Audacity, put it in Godot and make it play when the game starts.

---

## 3. Integrated Week‑by‑Week Learning & Building Plan

### Week 1 (May 14‑20) – Foundation
**Learning focus:** Godot basics, touch movement, character switching prototype.  
**Daily breakdown:**
- **Day 1‑2:** Complete "Dodge the Creeps" tutorial (3h). Get comfortable with editor, scenes, signals.
- **Day 3:** Build a test scene with a rectangle that moves with touch buttons. Test on phone (3h).
- **Day 4:** Add a second rectangle. Create a heart button that switches control between them (3h).
- **Day 5:** Implement pushable block and breakable wall on rectangles (3h).
- **Day 6:** Add a `PointLight2D` to the "Her" rectangle; make dark tiles appear when illuminated (3h).
- **Day 7:** Rest, review all code, fix any bugs, test on phone again.

**Checkpoint:** You have two colored rectangles that can switch, push, break, and light up. The tech is proven.

### Week 2 (May 21‑27) – Level 1
**Learning focus:** Tilemaps, puzzle logic, trigger dialogue.  
**Daily:**
- **Day 1‑2:** Learn `TileMap` basics, draw a simple café layout (counter, floor). (2h learning + 1h building).
- **Day 3‑4:** Transfer switch/push/light mechanics to the café scene. Replace rectangles with placeholder sprites. (3h).
- **Day 5:** Add the **Cat Doodle** pickup and platform summon. (3h).
- **Day 6:** Add Music Box, bridge, and level‑end Memory Stone. (3h).
- **Day 7:** Add all dialogue triggers (using placeholder text) and test full flow. (3h).

**Checkpoint:** A playable Level 1, start to finish, with placeholder art and text.

### Week 3 (May 28‑Jun 3) – Level 2 & Story
**Learning focus:** Dialogue manager, transitions, epilogue.  
**Daily:**
- **Day 1:** Build `DialogueManager` autoload with dictionary and typewriter effect. (3h).
- **Day 2:** Integrate dialogue into Level 1; replace placeholders with the real lines. (3h).
- **Day 3:** Build Level 2 hilltop scene with wind zone (push Her back). (3h).
- **Day 4:** Add Handwritten Note, storm pedestal, star bridge. (3h).
- **Day 5:** Build Epilogue scene – hug, final message, photo. (3h).
- **Day 6:** Chain all scenes with fade transitions. (3h).
- **Day 7:** Playtest entire game, note any bugs, tweak jump heights and timing.

**Checkpoint:** A complete, playable game with all mechanics, dialogue, and the emotional arc.

### Week 4 (Jun 4‑10) – Art & UI Polish
**Learning focus:** Pixel art, UI design.  
**Daily:**
- **Day 1‑2:** Design and animate both characters (pixel art). (4h).
- **Day 3:** Draw memory item icons (Cat Doodle, Note) and basic tiles. (3h).
- **Day 4:** Create backgrounds (café blur, starry night). (2h) + style title screen (1h).
- **Day 5:** Style all in‑game UI (buttons, dialogue box, heart switch). (3h).
- **Day 6:** Replace all placeholders with final art. (3h).
- **Day 7:** Polish transitions, add small visual effects (fireflies, sparkles on item pickup). (3h).

**Checkpoint:** The game now looks like a real, charming product.

### Week 5 (Jun 11‑17) – Audio & Final Testing
**Learning focus:** Audio integration, bug fixing.  
**Daily:**
- **Day 1‑2:** Find background music, cut/loop in Audacity, import. Add SFX. (4h total).
- **Day 3‑5:** Playtest on your phone exhaustively. Adjust touch controls, fix all collision bugs, puzzle logic holes. (9h).
- **Day 6:** Add any optional personal touches (whispered audio, photo save feature). (3h).
- **Day 7:** Ask a friend to test if possible; final adjustments.

**Checkpoint:** The game is fully polished and feels great on mobile.

### Week 6 (Jun 18‑24) – Export & Buffer
**Daily:**
- **Day 1‑2:** Configure Android export, create a keystore, export signed APK. (3h). Create a simple game icon. (1h).
- **Day 3:** Test APK on another Android device if possible. Fix any last‑minute issues. (3h).
- **Day 4‑6:** Buffer days. Only emergency fixes. Write the personal note to accompany the gift. (3h).
- **Day 7 (Jun 24):** Final APK stored safely. Back up your project.

### Jun 25‑27 – Relax
You are done. Happy birthday to her.

---

## 4. Master Checklist (Learning + Development)

Copy this section into your task manager. Tick them off one by one.

### Week 1 (May 14‑20)
- [/] Install Godot 4.x and Android export template
- [/] Complete "Dodge the Creeps" official tutorial
- [/] Understand scenes, nodes, inspector, signals
- [ ] Set up on‑screen touch buttons (left, right, jump, action)
- [/] Create a test character (rectangle) that moves with touch
- [ ] Test on phone – movement works
- [/] Create a second character scene
- [/] Implement character switch via heart button
- [/] Camera pans to active character on switch
- [ ] Add pushable block mechanic (rectangle pushes another)
- [ ] Add breakable wall (rectangle destroys wall on touch)
- [ ] Add PointLight2D to "Her" and dark/light test area
- [ ] All mechanics proven with rectangles

### Week 2 (May 21‑27)
- [ ] Learn TileMap basics (terrain, collision)
- [ ] Build Level 1 café layout with TileMap
- [ ] Place characters, sack, switch, dark area, alcove
- [ ] Code push‑sack‑onto‑switch puzzle
- [ ] Code dim light reveals after switch
- [ ] Create Cat Doodle pickup item
- [ ] Implement floating cat platform (summon + ride)
- [ ] Place Music Box in alcove
- [ ] Activate Music Box → full light + bridge
- [ ] Add Memory Stone with collision detection
- [ ] Add all Level 1 dialogue triggers (start, item found, puzzle solved, end)
- [ ] Test full Level 1 flow

### Week 3 (May 28‑Jun 3)
- [ ] Build DialogueManager autoload (dictionary, typewriter effect)
- [ ] Integrate dialogue into Level 1
- [ ] Build Level 2 hilltop scene (grass, wind zone, stars)
- [ ] Implement wind zone (Area2D pushes Her back)
- [ ] Add cracked rock wall (breakable)
- [ ] Place Handwritten Note behind wall
- [ ] Implement storm pedestal – use note → wind stops, star bridge appears
- [ ] Add Level 2 dialogue triggers
- [ ] Build Epilogue scene (characters together, hug prompt)
- [ ] Final message + personal photo display
- [ ] Link all scenes with fade transitions
- [ ] Playtest full game – note bugs

### Week 4 (Jun 4‑10)
- [ ] Learn pixel art tool (Piskel/LibreSprite)
- [ ] Design "You" character sprite (idle, run, jump frames)
- [ ] Design "Her" character sprite (idle, run, jump frames)
- [ ] Draw Cat Doodle item icon
- [ ] Draw Handwritten Note item icon
- [ ] Create café tiles (counter, floor, wall)
- [ ] Create hilltop tiles (grass, rock, tree)
- [ ] Create background images (café blur, night sky)
- [ ] Style title screen (locket button, title text)
- [ ] Style in‑game UI (switch button, jump/action buttons, dialogue box)
- [ ] Replace all placeholder art with final assets
- [ ] Add particle effects (fireflies, sparkles on pickup)

### Week 5 (Jun 11‑17)
- [ ] Find royalty‑free background music loop
- [ ] Edit music in Audacity (trim, loop, export OGG)
- [ ] Add background music to main scene
- [ ] Find/create SFX: item pickup chime, puzzle solved ding, footsteps (optional)
- [ ] Add SFX triggers in Godot
- [ ] Record optional whispered "Happy birthday, I love you"
- [ ] Playtest on phone – adjust touch control size/placement
- [ ] Fix all collision bugs
- [ ] Fix puzzle logic bugs
- [ ] Ensure dialogue doesn't block gameplay incorrectly
- [ ] Polish jump feel, speeds, gravity

### Week 6 (Jun 18‑24)
- [ ] Set up Android export preset in Godot
- [ ] Create debug or release keystore
- [ ] Export APK
- [ ] Test APK on a second Android device (if possible)
- [ ] Create a simple app icon
- [ ] Final playtest – full game
- [ ] Write personal note/instructions for her
- [ ] Backup entire project folder
- [ ] **Jun 25‑27: Buffer. Relax. Be proud.**

---

> You have all the directions. The next step is just to start – even if it's just installing Godot today.  
> You're building a love letter in the shape of a game. That's already magic.  
> Good luck. 🎂

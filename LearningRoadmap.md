# The Pieces of Us · Together

**Complete Learning & Development Roadmap · Roguelike Edition**

*A top-down exploration-puzzle roguelike in Godot · Portrait Android APK*

*Made for her 18th birthday · June 27*

**May 15 → June 27 · 43 days · ~129 hours**

---

## 1. What You Are Building

This is a top-down exploration-puzzle game with roguelike room generation — viewed from the same angle as Stardew Valley (a 3/4 perspective, portrait orientation on mobile). The player controls two characters who must work together across procedurally arranged rooms. Each run tells a new path through shared memories. There are no enemies — only puzzles, locked doors, and items hidden in hand-crafted rooms that shuffle each time.

| **Core loop (one run = ~10 minutes)** |
|----------------------------------------|
| Enter a room → notice the environment → use items and character abilities to solve a puzzle → unlock the exit → move to the next room. After clearing 5 rooms, a Memory Stone triggers a personal dialogue moment. Clear 3 Memory Stones to reach the Epilogue. |

| **Engine & Platform** | **Camera & View** |
|----------------------|-------------------|
| Godot 4.x → Android APK (portrait, 9:16) | Top-down 3/4 perspective · Stardew-style · Camera2D follows active character |
| **Total days** | **Scope** |
| 43 days · ~3h/day · ~129 total hours | 8–12 hand-crafted rooms · procedural shuffle · personal dialogue · epilogue |

---

## 2. How the Camera & View Works (Stardew Style)

Stardew Valley uses an orthographic top-down 3/4 camera: the world is viewed slightly from above, characters face in 4 directions, and tiles are drawn slightly wider than tall to give depth. In Godot you recreate this with:

- TileMap with 16×16 or 32×32 tiles — stretched slightly (e.g. 16×12) to fake the 3/4 angle
- CharacterBody2D with 8-direction sprite sheets — down, up, left, right — 3-4 frames each
- Camera2D on the active character — smooth following, clamped to room bounds
- Portrait viewport — 480×854 or 540×960 — set in Project Settings under Display → Window
- Y-sort enabled on your main scene — this makes characters appear "behind" objects lower on screen — gives depth

> **Y-Sort is the secret ingredient**  
> In Godot 4, add a Node2D with "Y Sort Enabled" checked as the parent of all world objects. Items and characters lower on screen (higher Y value) draw on top — which is what makes top-down games look 3D. Enable it early and never remove it.

---

## 3. Skill Map & Time Budget

*Learn only what you need. Build as you learn. Every skill below is directly used in the game.*

### 3.1 Godot Fundamentals (8–10 h)

| Sub-skill | What you build / do | Time | How to learn |
|-----------|---------------------|------|---------------|
| Interface & Scene system | Navigate editor, create 2D scenes, save and run | 2h | Godot docs "Step by Step" + GDQuest intro |
| Nodes & Scenes | TileMap, CharacterBody2D, Camera2D, Area2D, CollisionShape2D, YSort | 2h | Official node docs — add each to a test scene |
| Signals & connections | Detect area overlaps, button presses, room transitions | 1.5h | "Dodge the Creeps" tutorial covers signals well |
| Touch input map | On-screen D-pad, action button, character switch button | 1.5h | TouchScreenButton nodes — YouTube "Godot mobile touch" |
| Export to APK | Android template, debug APK, USB test on phone | 1h | Godot docs "Exporting for Android" |

### 3.2 GDScript Essentials (10–12 h)

| Sub-skill | What you build / do | Time | How to learn |
|-----------|---------------------|------|---------------|
| Variables, @export, @onready | Player speed, current room ref, item held | 1h | GDScript beginner series (GDQuest) |
| Functions & _process/_physics_process | Movement each frame, state checks | 1.5h | Write a script that moves a sprite with arrow keys |
| If statements & state machines | Active character, item held, door locked/unlocked | 1h | Toggle a variable; change sprite color on press |
| Vectors, velocity, move_and_slide | Top-down 8-direction movement | 2h | Copy the 2D movement template from Godot docs |
| Custom signals | puzzle_solved, memory_collected, room_cleared | 1.5h | Define and emit a signal from Area2D |
| Autoloads / Singletons | GameManager (run state), DialogueManager | 1.5h | Create a singleton that stores which rooms are cleared |
| Tween & create_tween() | Door open animation, UI fade, item float | 1h | Animate a sprite's position with one tween call |
| Collision layers & masks | Which character triggers which object | 1h | Layer 1 = world, Layer 2 = You, Layer 3 = Her |

### 3.3 Top-Down Movement & Character Switching (5–6 h)

| Sub-skill | What you build / do | Time | How to learn |
|-----------|---------------------|------|---------------|
| 8-direction movement | WASD / D-pad, normalize diagonal, set gravity=off | 1h | Use CharacterBody2D + move_and_slide(); no gravity needed |
| Character switching | Heart button toggles active_player in GameManager; camera jumps | 2h | Two CharacterBody2D scenes; only the active one reads input |
| Pushable objects | Crates, switches — push by walking into them | 1h | StaticBody2D with MoveAndSlide on contact |
| Interactable objects | Press action button near item → pick up or trigger | 1.5h | Area2D "is_overlapping" + input action check |
| Room-bound camera | Camera2D clamped to current room rect; smooth pan on switch | 0.5h | Set camera limit_left/right/top/bottom in code |

### 3.4 Roguelike Room System (8–10 h)

| Sub-skill | What you build / do | Time | How to learn |
|-----------|---------------------|------|---------------|
| Hand-crafted room scenes | 8–12 individual room .tscn files — each a self-contained puzzle | 3h | Design each room as a scene; export variables for door positions |
| Room graph / shuffle | Array of room paths shuffled with randomize(); pick 5 per run | 2h | rooms.shuffle() in GameManager; store current_room_index |
| Room loader / transition | load() or preload() a room scene; instance it; free old room | 2h | Use a RoomManager autoload that swaps scenes smoothly |
| Door & exit triggers | Area2D at room edge; when entered, load next room | 1.5h | Emit room_exit signal → RoomManager.go_to_next_room() |
| Run state persistence | Track items collected, memory stones found across rooms | 1.5h | Dictionary in GameManager — survives room transitions |

### 3.5 Puzzle Mechanics (6–8 h)

| Sub-skill | What you build / do | Time | How to learn |
|-----------|---------------------|------|---------------|
| Key + locked door | Collect key item → door Area2D checks if player holds key → door.open() | 1.5h | GameManager.has_item("key") check |
| Pressure switch | Push crate onto Area2D switch → emit signal → unlock door | 1.5h | Area2D body_entered checks if body is in "pushable" group |
| Light puzzle (Her ability) | Her character emits PointLight2D; hidden tiles visible only in light | 2h | Set TileMap light_mask; PointLight2D on Her scene |
| Symbol match | Interact with two matching objects in correct order → open path | 1.5h | Array tracks interaction order; compare to solution array |
| Memory item pickup | Collect special item → trigger dialogue → record in run state | 1h | Area2D + is_held check + DialogueManager.show() |

### 3.6 UI & Dialogue System (5–6 h)

| Sub-skill | What you build / do | Time | How to learn |
|-----------|---------------------|------|---------------|
| Control nodes & CanvasLayer | HUD, dialogue box, inventory indicator always on top | 1h | Put all UI under a CanvasLayer node |
| Portrait touch buttons | D-pad bottom left, action + switch bottom right, anchored | 1h | Use TouchScreenButton; anchor to bottom corners |
| Dialogue manager | Dictionary of lines; typewriter reveal; tap to advance | 2.5h | DialogueManager.show(trigger_id) → typewriter Timer autoload |
| Pause & memory gallery | Button opens overlay listing collected memory items | 1h | get_tree().paused = true; show CanvasLayer overlay |
| Scene fade transitions | Fade to black on room exit; fade in on room enter | 0.5h | ColorRect modulate.a via Tween |

### 3.7 Pixel Art & Animation — Top-Down Style (8–10 h)

| Sub-skill | What you build / do | Time | How to learn |
|-----------|---------------------|------|---------------|
| Pixel art editor basics | Aseprite / LibreSprite / Piskel — canvas, layers, palette | 1h | YouTube: Brandon James Greer "pixel art for beginners" |
| Top-down character (32×32) | 4 directions · silhouette first · 3–5 colour palette | 2.5h | Draw a top oval for head, smaller oval for body; add hair |
| Walk animation (4 dirs × 3 frames) | Step left foot, neutral, step right foot — per direction | 2.5h | Aseprite Tags: down_walk, up_walk, left_walk, right_walk |
| Environment tiles (16×16) | Floor, wall, door, chest, pressure plate, rug, window | 2h | Use a grid; draw wall tops slightly lighter for 3/4 feel |
| Item & object sprites | Memory items, keys, switches, crates — small (16×16) | 1h | Simple shapes; recognisable silhouette matters most |
| Backgrounds | Room background (dark stone, warm café, hilltop grass) | 1h | Solid tile fill + a darker border tile for walls |

### 3.8 Audio (3–4 h)

| Sub-skill | What you build / do | Time | How to learn |
|-----------|---------------------|------|---------------|
| Find royalty-free music | 1 soft looping track; maybe 1 warmer track for memory moments | 1h | Pixabay Music, Incompetech — search "calm lo-fi loop" |
| Edit in Audacity | Trim to clean loop point; export as .ogg | 1h | YouTube: "Audacity perfect loop" tutorial |
| Godot AudioStreamPlayer | Background music; SFX on item pickup, door open, room clear | 1h | AudioStreamPlayer (music) + AudioStreamPlayer2D (SFX) |
| Optional personal touch | Whispered "happy birthday, I love you" on epilogue screen | 0.5h | Record with phone mic; import as .ogg; trigger on epilogue |

---

## 4. Week-by-Week Plan

*43 days · ~3 hours per day · May 15 → June 27*

### Week 1 (May 15–21)  
**🎯 Theme: Foundation**

*Learning focus: Godot basics · portrait setup · top-down movement · character switch*

- **Day 1–2:** Install Godot 4. Set viewport to 480×854 (portrait). Complete "Dodge the Creeps" for signals & nodes. (3h)
- **Day 3:** Build a test room: TileMap floor, a CharacterBody2D that moves in 8 directions. Enable Y-Sort. Test on phone. (3h)
- **Day 4:** Add a second character scene. Create a switch button that toggles active_player. Camera follows the active one. (3h)
- **Day 5:** Add a pushable crate and a pressure switch (crate on switch → "door" disappears). (3h)
- **Day 6:** Add PointLight2D to "Her" character. Create a dark room where hidden tiles only appear in her light. (3h)
- **Day 7:** Review all code. Test on phone. Fix movement feel — adjust speed, diagonals. Rest.

**✦ Checkpoint:** Two rectangles can switch, push, and light up. The core tech is proven in portrait.

---

### Week 2 (May 22–28)  
**🎯 Theme: Room System**

*Learning focus: Hand-crafted rooms · room loader · roguelike shuffle · door transitions*

- **Day 1–2:** Design 3 room scenes using TileMap (floor + walls). Add exit Area2D triggers at edges. (3h each)
- **Day 3:** Build RoomManager autoload: array of room paths, shuffle on run start, load next room on exit. (3h)
- **Day 4:** Add fade transition between rooms. Preserve GameManager run state across loads. (3h)
- **Day 5:** Design 3 more rooms. Total: 6 rooms, all loadable in random order. Test a full 6-room run. (3h)
- **Day 6:** Add a key + locked door puzzle to one room. Add a crate + pressure switch to another. (3h)
- **Day 7:** Playtest the full shuffle loop. Note any loading bugs. Rest.

**✦ Checkpoint:** A shuffled 6-room run playable from start to finish with two working puzzle types.

---

### Week 3 (May 29–Jun 4)  
**🎯 Theme: Story & Puzzles**

*Learning focus: DialogueManager · Memory Stones · all puzzle types · epilogue scene*

- **Day 1:** Build DialogueManager autoload: dictionary of lines, typewriter reveal, tap to advance. (3h)
- **Day 2:** Add Memory Stone to every 5th room. Trigger personal dialogue on touch. (3h)
- **Day 3:** Write all dialogue lines — room intros, item finds, Memory Stone moments, epilogue. (3h)
- **Day 4:** Add light puzzle room (Her only), symbol match room. Now 8 total rooms. (3h)
- **Day 5:** Build Epilogue scene: 3 Memory Stones collected → final room → characters unite → personal message. (3h)
- **Day 6:** Add memory item pickup in 2 rooms (special collectibles that appear in gallery). (3h)
- **Day 7:** Playtest full game with all dialogue. Note pacing issues. Rest.

**✦ Checkpoint:** Complete playable game with story, all puzzle types, and epilogue.

---

### Week 4 (Jun 5–11)  
**🎯 Theme: Art & Visuals**

*Learning focus: Top-down character sprites · tiles · backgrounds · UI polish*

- **Day 1–2:** Draw "You" character: 4-direction walk animation (32×32, 3 frames each). (4h)
- **Day 3:** Draw "Her" character: same structure, different palette, hair, PointLight2D glow. (3h)
- **Day 4:** Create tileset: floor, wall, wall-top, door open/closed, pressure switch, crate. (3h)
- **Day 5:** Draw memory item icons and collectible sprites. Style dialogue box and HUD buttons. (3h)
- **Day 6:** Create backgrounds for 3 room types (stone dungeon, warm café room, hilltop). (3h)
- **Day 7:** Replace all placeholder rectangles with final art. Add sparkle particle on item pickup. (3h)

**✦ Checkpoint:** The game looks like a real charming product — no more colored rectangles.

---

### Week 5 (Jun 12–18)  
**🎯 Theme: Audio & Testing**

*Learning focus: Music · SFX · bug fixing · touch control polish*

- **Day 1–2:** Find 2 music tracks, loop them in Audacity, import as .ogg. Add to game + memory moment track. (4h)
- **Day 3:** Add SFX: item pickup chime, door open, puzzle solved ding, room clear jingle. (3h)
- **Day 4–5:** Deep playtest on phone: fix touch button size, fix collision bugs, test room shuffle edge cases. (6h)
- **Day 6:** Optional: record whispered birthday message for epilogue. Polish epilogue screen. (3h)
- **Day 7:** Ask someone to test if possible. Final sound balance pass. Rest.

**✦ Checkpoint:** Game is fully polished, feels great on mobile, all bugs squashed.

---

### Week 6 (Jun 19–24)  
**🎯 Theme: Export & Buffer**

*Learning focus: APK export · keystore · icon · personal note · backup*

- **Day 1–2:** Set up Android export preset, create a keystore, export debug APK, test on second device. (3h)
- **Day 3:** Create app icon (512×512 pixel art, heart / puzzle piece motif). Final APK test. (2h)
- **Day 4–6:** Buffer. Emergency fixes only. Write her a personal note explaining how to install and play. (3h)
- **Day 7:** Final APK saved safely. Project backed up to Google Drive or USB. Done.

**✦ Checkpoint:** APK in hand. Backed up. Ready to give.

---

### Jun 25–27

You are done. Rest. Be proud. Happy birthday to her.

---

## 5. Room Design Reference

Design 8 rooms total — 5 clear a "set," then a Memory Stone room appears. Repeat twice, then the Epilogue. Each room should be solvable in 1–3 minutes.

| # | Room type | Puzzle mechanic | Personal memory theme |
|---|-----------|----------------|------------------------|
| 1 | Café room | Push crate onto switch → unlock back door | Where you first talked — the corner table |
| 2 | Dark alcove | Her light reveals a hidden path | A night you stayed up together watching nothing |
| 3 | Library stacks | Key behind locked shelf — find key in pile | You lending her a book she still has |
| 4 | Hilltop (outdoor) | Symbol match — two lanterns to light in order | A walk with no destination |
| ★ | **Memory Stone 1** | **Touch stone → personal dialogue (3–4 lines)** | **"The first time I realised..."** |
| 5 | Rainy room | Crate + switch + light combo | A day she was sad and you just stayed |
| 6 | Garden path | Collect 3 flowers in order — colour puzzle | Something small you always notice about her |
| 7 | Locked attic | Push 2 crates, light hidden symbol, use key | A secret she told you |
| ★ | **Memory Stone 2** | **Touch stone → personal dialogue** | **"The moment I knew..."** |
| 8 | Starfield room | Navigate light path — only Her can see route | A wish you have for her future |
| ★ | **Memory Stone 3** | **Touch stone → Epilogue trigger** | **"Happy birthday..."** |

---

## 6. Master Checklist

*Copy this into Notion, Google Keep, or print it. Tick off one item at a time.*

### Week 1 — Foundation (May 15–21)

- [ ] Install Godot 4.x and Android export template
- [ ] Set viewport to 480×854 portrait in Project Settings
- [ ] Complete "Dodge the Creeps" tutorial
- [ ] Build test scene with TileMap floor + CharacterBody2D top-down movement
- [ ] Enable Y-Sort on main scene node
- [ ] Set up on-screen touch buttons (D-pad, action, switch)
- [ ] Test movement on phone
- [ ] Create second character scene (Her)
- [ ] Implement character switch via heart button (GameManager.active_player)
- [ ] Camera2D follows active character, smooth pan
- [ ] Pushable crate + pressure switch prototype
- [ ] PointLight2D on Her — dark tile reveal prototype

### Week 2 — Room System (May 22–28)

- [ ] Design 3 room .tscn files with TileMap + exit Area2D
- [ ] Build RoomManager autoload with shuffled room array
- [ ] Implement room loading (load + instance + free old)
- [ ] Add fade transition between rooms
- [ ] GameManager persists run state across room transitions
- [ ] Design 3 more rooms (6 total)
- [ ] Add key + locked door puzzle to 1 room
- [ ] Add crate + pressure switch puzzle to 1 room
- [ ] Playtest full 6-room shuffled run end-to-end

### Week 3 — Story & Puzzles (May 29–Jun 4)

- [ ] Build DialogueManager autoload (dictionary, typewriter, tap to advance)
- [ ] Add Memory Stone to every 5th room — triggers dialogue
- [ ] Write all dialogue lines (room intros, items, memory stones, epilogue)
- [ ] Add light puzzle room (Her light only)
- [ ] Add symbol match room
- [ ] Total rooms: 8 (plus 3 Memory Stone rooms)
- [ ] Build Epilogue scene (characters meet, final message, personal photo)
- [ ] Add memory item collectibles (2 rooms)
- [ ] Link all scenes with fade transitions
- [ ] Playtest full game — note any pacing issues

### Week 4 — Art & Visuals (Jun 5–11)

- [ ] Design "You" sprite: 4-direction walk (32×32, 3 frames each)
- [ ] Design "Her" sprite: same structure, different palette + light glow
- [ ] Create tileset: floor, wall, wall-top, door, switch, crate
- [ ] Draw memory item icons and pickup sprites
- [ ] Style dialogue box, HUD buttons, memory gallery overlay
- [ ] Create backgrounds for 3 room environments
- [ ] Replace all placeholder art with final assets
- [ ] Add particle effect on item pickup
- [ ] Title screen — game name, start button, portrait layout

### Week 5 — Audio & Testing (Jun 12–18)

- [ ] Find 2 royalty-free music tracks (main loop + memory/epilogue)
- [ ] Edit and loop both tracks in Audacity, export as .ogg
- [ ] Add music to Godot with AudioStreamPlayer
- [ ] SFX: item pickup chime, door open, puzzle solved, room clear
- [ ] Optional: record whispered birthday message for epilogue
- [ ] Deep playtest on phone — adjust touch button size and placement
- [ ] Fix all collision bugs
- [ ] Fix any room shuffle edge cases
- [ ] Ensure dialogue never blocks gameplay
- [ ] Polish jump feel and movement speed

### Week 6 — Export & Buffer (Jun 19–24)

- [ ] Set up Android export preset in Godot
- [ ] Create debug or release keystore
- [ ] Export signed APK
- [ ] Test APK on a second Android device
- [ ] Create 512×512 app icon
- [ ] Final full playtest on phone
- [ ] Write personal note / install instructions for her
- [ ] Back up entire project folder (Google Drive or USB)

---

**Jun 25–27: Buffer. Relax. Be proud.**

You built a love letter in the shape of a game. That's already magic.  
Happy birthday to her.

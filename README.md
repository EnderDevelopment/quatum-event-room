# Roblox Script: QUATUM: EVENT ROOM

QUATUM: EVENT ROOM is a Roblox script package built with Luau for a multiplayer concert hangout game. It creates a 3D event venue, runtime system UI, dance controls, music effects, contests, activities, a custom inventory, and an unlockable power panel.

## Install

1. Open the experience in Roblox Studio.
2. In Explorer, create a `Script` inside `ServerScriptService`.
3. Rename it `QuantumEventRoom.server.lua`.
4. Copy the server script from `ServerScriptService/QuantumEventRoom.server.lua` into it.
5. Create a `LocalScript` inside `StarterPlayer > StarterPlayerScripts`.
6. Rename it `QuantumEventRoom.client.lua`.
7. Copy the client script from `StarterPlayer/StarterPlayerScripts/QuantumEventRoom.client.lua` into it.
8. Press Play or Start Server in Roblox Studio.

The scripts automatically create the `ReplicatedStorage.QuantumEvent` RemoteEvent, the `Workspace.QuantumVenue` venue folder, the runtime interface, leaderstats, and the concert music Sound object. No models, RemoteEvents, folders, or UI objects need to be created manually.

## Use

1. Explore the generated concert venue after spawning.
2. Press the DANCE button or the Space key to play the dance animation, restore energy, and score during active activities.
3. Press CONTEST to start a 45-second dance contest. Players earn points by dancing, and the highest scorer receives 100 tokens.
4. Press RHYTHM to start a 30-second rhythm station. Each successful dance action awards points, and the winner receives 75 tokens.
5. Open the inventory with the INVENTORY button or the Q key.
6. Buy, equip, and activate Prism Trail, Pulse Burst, Spotlight Aura, and Confetti Cannon.
7. Watch the top-right HUD for tokens and energy. Energy regenerates automatically.
8. Use Start Server with multiple players to test multiplayer scoring, winners, shared notices, and activity rewards.

Activities also start automatically at intervals while players are present. Tokens and inventory use session memory and reset when the server session ends. The included music and dance animation use Roblox asset references and may require replacement with approved assets if they do not load in your experience.

---

More Roblox script projects by EnderDevelopment: https://github.com/EnderDevelopment

Project page: https://dash.enderdevelopment.com/community/474e50e4-bfc4-4f22-a751-c48c8c21352f?utm_source=github&utm_medium=readme&utm_campaign=auto_publish&utm_content=474e50e4-bfc4-4f22-a751-c48c8c21352f

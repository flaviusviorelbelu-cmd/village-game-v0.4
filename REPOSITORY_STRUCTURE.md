# Village Game v0.4 - Clean Repository Structure

## 📋 Overview

This document explains the reorganized repository structure. The previous setup had files scattered across multiple folders causing initialization order issues.

## 🗂️ Current Structure

```
ServerScriptService/
├── 1_Initialization.lua      ← Master script - RUNS FIRST
├── 2_BaseGame.lua            ← Creates world/ground
├── 3_EconomySystem.lua       ← Creates wallet & RemoteEvents
└── 4_GameManager.lua         ← Builds villages & houses

ServerScriptManager/
├── HouseInteriorManager.lua  ← Manages house interiors (RUNS AFTER MAIN)
├── NPCSystem.lua             ← NPC AI & dialogue
├── PlayerDataService.lua     ← Player data management
├── TradingSystem.lua         ← Trading mechanics
└── VillageBuilder.lua        ← Village customization

StarterPlayer/
└── StarterPlayerScripts/
    └── WalletUI.lua          ← Client: Displays wallet (RUNS LAST)

StarterGui/
└── (Other client UI goes here)
```

## ✅ Why This Structure Works

### Loading Order (CRITICAL)

1. **1_Initialization.lua** (Master Controller)
   - Runs `require()` on each script in order
   - Ensures proper initialization sequence
   - Prints progress for debugging

2. **2_BaseGame.lua** (World Creation)
   - Creates ground, platforms, lighting
   - No dependencies on other systems

3. **3_EconomySystem.lua** (Economy Foundation)
   - Creates RemoteEvents folder
   - Initializes player wallets with default values (Gold: 100, Silver: 10)
   - Sends wallet data to clients via `UpdateCurrency` event

4. **4_GameManager.lua** (Game Content)
   - Builds village, houses, shops
   - Waits for RemoteEvents from EconomySystem
   - Sets up click detectors and event handlers

5. **HouseInteriorManager.lua + NPCSystem.lua** (Additional Systems)
   - Runs after main game is built
   - Can safely reference village objects

6. **WalletUI.lua** (Client Display)
   - Waits for `UpdateCurrency` event from server
   - Displays wallet that was already initialized
   - Never shows 0 because economy was initialized first

## 🔴 Problems Solved

### Problem 1: Wallet Showing 0
**Cause**: WalletUI connected before EconomySystem initialized wallets
**Solution**: Initialization.lua ensures EconomySystem runs before GameManager, which runs before client scripts connect

### Problem 2: Missing RemoteEvents
**Cause**: Multiple GameManagers trying to use RemoteEvents that didn't exist yet
**Solution**: EconomySystem creates RemoteEvents first (step 3), GameManager uses them (step 4)

### Problem 3: Script Conflicts
**Cause**: Too many files in too many locations with unclear execution order
**Solution**: Numbered files in ServerScriptService show exact execution order

## 🚀 How to Extend

### Adding a New Server System

1. Create script in ServerScriptService with number prefix:
   ```
   5_MyNewSystem.lua
   ```

2. Add require() call in Initialization.lua:
   ```lua
   print("📋 STEP 5/5: Loading my new system...")
   require(script.Parent:WaitForChild("MyNewSystem"))
   ```

3. New system can safely use:
   - RemoteEvents (created in step 3)
   - Village objects (created in step 4)
   - Player wallets (initialized in step 3)

## 📊 File Status

| File | Location | Status | Purpose |
|------|----------|--------|----------|
| 1_Initialization.lua | ServerScriptService | ✅ Active | Master controller |
| 2_BaseGame.lua | ServerScriptService | ✅ Active | World creation |
| 3_EconomySystem.lua | ServerScriptService | ✅ Active | Currency system |
| 4_GameManager.lua | ServerScriptService | ✅ Active | Game content |
| HouseInteriorManager.lua | ServerScriptManager | ✅ Active | House systems |
| NPCSystem.lua | ServerScriptManager | ✅ Active | NPC AI |
| WalletUI.lua | StarterPlayer/StarterPlayerScripts | ✅ Active | Client wallet display |

## 🧹 Cleanup Notes

- Old files in `ServerScriptManager/` can be deleted after testing
- Keep numbered files in `ServerScriptService/` for clarity
- Always add new systems to Initialization.lua

## ⚡ Testing Checklist

After making changes, verify:

- [ ] Wallet shows correct starting value (100 Gold, 10 Silver)
- [ ] No "RemoteEvents not found" errors
- [ ] Village builds without errors
- [ ] House clicks work
- [ ] Shop UI displays correctly
- [ ] Players spawn correctly

---

**Last Updated**: December 9, 2025
**Version**: v0.4 (Clean)

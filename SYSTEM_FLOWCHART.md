# System Flowchart & Data Flow

## High-Level System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                         PLAYER ENTERS SERVER                     │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
         ┌───────────────────────────────┐
         │   Check Player Cooldowns      │
         │   Check Player Heat Level     │
         │   Load Player History         │
         └───────────┬───────────────────┘
                     │
                     ▼
    ┌────────────────────────────────────────┐
    │     PHASE 1: INTEL GATHERING           │
    │  ┌──────────────────────────────────┐  │
    │  │ Option A: Hack Computer          │  │
    │  │ Option B: Bribe Worker           │  │
    │  │ Option C: Steal Manifest         │  │
    │  │ Option D: Call Insider           │  │
    │  └──────────┬───────────────────────┘  │
    │             │                           │
    │             ▼                           │
    │  ┌──────────────────────────────────┐  │
    │  │  Generate Intel Data             │  │
    │  │  - Cargo Type                    │  │
    │  │  - Value (±accuracy)             │  │
    │  │  - Location                      │  │
    │  │  - Security Level                │  │
    │  │  - Expiry Time (1 hour)          │  │
    │  └──────────┬───────────────────────┘  │
    └─────────────┼───────────────────────────┘
                  │
                  ▼
    ┌────────────────────────────────────────┐
    │     PHASE 2: PLANNING BOARD            │
    │  ┌──────────────────────────────────┐  │
    │  │ Leader Opens Planning UI         │  │
    │  │ Invites Crew Members             │  │
    │  │ Assigns Roles                    │  │
    │  │ Selects Approach Method          │  │
    │  │ Verifies Equipment               │  │
    │  │ Sets Cut Distribution            │  │
    │  └──────────┬───────────────────────┘  │
    │             │                           │
    │             ▼                           │
    │  ┌──────────────────────────────────┐  │
    │  │  Validation Checks               │  │
    │  │  ✓ Minimum crew met?             │  │
    │  │  ✓ Required items present?       │  │
    │  │  ✓ Enough cops online?           │  │
    │  │  ✓ Not on cooldown?              │  │
    │  │  ✓ All crew ready?               │  │
    │  └──────────┬───────────────────────┘  │
    └─────────────┼───────────────────────────┘
                  │
                  ▼
    ┌─────────────────────────────────────────────────┐
    │          APPROACH SELECTION FORK                │
    └────┬────────────────────────────────────────┬───┘
         │                                        │
         ▼                                        ▼
┌────────────────────────┐         ┌────────────────────────┐
│  GROUND APPROACH       │         │  AIR APPROACH          │
├────────────────────────┤         ├────────────────────────┤
│ 1. Breach Perimeter    │         │ 1. Track Flight Path   │
│ 2. Locate Plane        │         │ 2. Intercept w/ Heli   │
│ 3. Thermite Cargo Door │         │ 3. Parachute Drop      │
│ 4. Load Cargo to Truck │         │ 4. Subdue Crew         │
│ 5. Exit Airport        │         │ 5. Land/Transfer       │
└────────┬───────────────┘         └───────────┬────────────┘
         │                                     │
         │         ┌───────────────────────────┘
         │         │
         └────┬────┘
              │
              ▼
    ┌─────────────────────────────────────────┐
    │     PHASE 3: HEIST EXECUTION            │
    │  ┌──────────────────────────────────┐   │
    │  │  Police Dispatch Triggered       │   │
    │  │  Timer Started                   │   │
    │  │  Cargo Loading Progress          │   │
    │  │  NPC Guards/Crew React           │   │
    │  └──────────┬───────────────────────┘   │
    │             │                            │
    │             ▼                            │
    │  ┌──────────────────────────────────┐   │
    │  │  Dynamic Events                  │   │
    │  │  - Police arrive (waves)         │   │
    │  │  - Security alarms               │   │
    │  │  - Environmental hazards         │   │
    │  │  - Cargo damage checks           │   │
    │  └──────────┬───────────────────────┘   │
    └─────────────┼────────────────────────────┘
                  │
                  ▼
    ┌─────────────────────────────────────────┐
    │     PHASE 4: ESCAPE                     │
    │  ┌──────────────────────────────────┐   │
    │  │  GPS to Random Delivery Zone     │   │
    │  │  Police Pursuit Active           │   │
    │  │  Roadblocks Spawn                │   │
    │  │  Helicopter Pursuit (if air)     │   │
    │  └──────────┬───────────────────────┘   │
    │             │                            │
    │             ▼                            │
    │  ┌──────────────────────────────────┐   │
    │  │  Evasion Mechanics               │   │
    │  │  - Break line of sight           │   │
    │  │  - Lose wanted level             │   │
    │  │  - Timer: 30s clean              │   │
    │  └──────────┬───────────────────────┘   │
    └─────────────┼────────────────────────────┘
                  │
                  ▼
    ┌─────────────────────────────────────────┐
    │     PHASE 5: DELIVERY                   │
    │  ┌──────────────────────────────────┐   │
    │  │  Arrive at Drop Zone             │   │
    │  │  Meet Buyer NPC                  │   │
    │  │  Cargo Inspection                │   │
    │  └──────────┬───────────────────────┘   │
    │             │                            │
    │             ▼                            │
    │  ┌──────────────────────────────────┐   │
    │  │  Calculate Final Payout          │   │
    │  │  Base Value × Multipliers        │   │
    │  │  - Approach (1.0x or 1.5x)       │   │
    │  │  - Condition (0-100%)            │   │
    │  │  - Heat Penalty (-10% per lvl)   │   │
    │  │  - Speed Bonus (+10% if fast)    │   │
    │  │  - Stealth Bonus (+20% no alert) │   │
    │  └──────────┬───────────────────────┘   │
    └─────────────┼────────────────────────────┘
                  │
                  ▼
    ┌─────────────────────────────────────────┐
    │     PHASE 6: COMPLETION                 │
    │  ┌──────────────────────────────────┐   │
    │  │  Distribute Money to Crew        │   │
    │  │  Update Statistics               │   │
    │  │  Log to History Table            │   │
    │  │  Set Cooldowns                   │   │
    │  │  Increase Heat Level             │   │
    │  │  Send Discord Webhook            │   │
    │  └──────────────────────────────────┘   │
    └─────────────────────────────────────────┘
```

---

## Data Flow Diagram

```
┌──────────────┐
│   PLAYER     │
└──────┬───────┘
       │
       │ 1. Request Intel
       ▼
┌──────────────────────────────────────┐
│         CLIENT                       │
│  ┌────────────────────────────────┐  │
│  │  Trigger Intel Source          │  │
│  │  (Hack/Bribe/Steal)            │  │
│  └────────┬───────────────────────┘  │
└───────────┼──────────────────────────┘
            │
            │ 2. Request Intel Data
            ▼
┌──────────────────────────────────────┐
│         SERVER                       │
│  ┌────────────────────────────────┐  │
│  │  Validate Request              │  │
│  │  - Check player cooldown       │  │
│  │  - Check required items        │  │
│  │  - Roll success chance         │  │
│  └────────┬───────────────────────┘  │
│           │                           │
│           ▼                           │
│  ┌────────────────────────────────┐  │
│  │  Generate/Fetch Intel          │  │
│  │  - Query active cargo          │  │
│  │  - OR create new cargo         │  │
│  │  - Apply quality modifier      │  │
│  └────────┬───────────────────────┘  │
│           │                           │
│           ▼                           │
│  ┌────────────────────────────────┐  │
│  │  Store Intel in Database       │  │
│  │  (cargo_heist_intel table)     │  │
│  └────────┬───────────────────────┘  │
└───────────┼──────────────────────────┘
            │
            │ 3. Return Intel Data
            ▼
┌──────────────────────────────────────┐
│         CLIENT                       │
│  ┌────────────────────────────────┐  │
│  │  Display Intel to Player       │  │
│  │  Store locally for planning    │  │
│  └────────────────────────────────┘  │
└──────────────────────────────────────┘
```

---

## Database Relationships

```
┌─────────────────────────┐
│   cargo_heist_intel     │
├─────────────────────────┤
│ id (PK)                 │
│ cargo_id (UNIQUE)       │─────┐
│ cargo_type              │     │
│ value                   │     │
│ location                │     │
│ available_time          │     │
│ expires_time            │     │
│ is_active               │     │
│ difficulty              │     │
└─────────────────────────┘     │
                                │
                                │ Referenced by
                                │
                                ▼
┌─────────────────────────────────────┐
│      cargo_heist_history            │
├─────────────────────────────────────┤
│ id (PK)                             │
│ cargo_id (FK) ──────────────────────┘
│ leader_citizenid                    │
│ crew_members (JSON)                 │
│ approach_method                     │
│ success (BOOLEAN)                   │
│ payout                              │
│ police_response                     │
│ completion_time                     │
│ heist_timestamp                     │
└─────────────────────────────────────┘
        │
        │ Links to
        ▼
┌─────────────────────────┐
│   players (QBCore)      │
├─────────────────────────┤
│ citizenid (PK)          │◄───────┐
│ ...                     │        │
└─────────────────────────┘        │
                                   │
                                   │ References
                                   │
┌──────────────────────────────────┴──┐
│      cargo_heist_cooldowns          │
├─────────────────────────────────────┤
│ id (PK)                             │
│ citizenid (FK)                      │
│ heist_type                          │
│ cooldown_until                      │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│      cargo_heist_heat               │
├─────────────────────────────────────┤
│ citizenid (PK, FK)                  │
│ heat_level                          │
│ last_updated                        │
└─────────────────────────────────────┘
```

---

## State Management Flow

### Server-Side State

```lua
-- Active heists in progress
ActiveHeists = {
    [heist_id] = {
        leader = citizenid,
        crew = {
            {citizenid = "ABC123", role = "pilot", cut = 20},
            {citizenid = "DEF456", role = "hacker", cut = 15},
            -- ...
        },
        cargo = {
            id = "CARGO_001",
            type = "gold_bars",
            value = 180000,
            condition = 100, -- Degrades if damaged
        },
        approach = "air", -- or "ground"
        status = "execution", -- planning/execution/escape/delivery
        started_at = timestamp,
        police_notified = true,
        delivery_zone = vector3(...),
    }
}

-- Available cargo intel (generated dynamically)
AvailableCargo = {
    {
        cargo_id = "CARGO_001",
        spawn_time = timestamp,
        expires_at = timestamp + 3600,
        claimed_by = nil, -- or citizenid when heist starts
    },
    -- ...
}

-- Player cooldowns
PlayerCooldowns = {
    [citizenid] = {
        last_heist = timestamp,
        can_heist_at = timestamp + cooldown_duration,
    }
}
```

### Client-Side State

```lua
-- Local player state
LocalPlayer = {
    in_heist = false,
    role = nil, -- "leader", "pilot", etc.
    crew_id = nil,
    has_intel = false,
    intel_data = {}, -- Stored intel information
}

-- UI State
UIState = {
    planning_board_open = false,
    crew_members = {},
    selected_approach = "ground",
    equipment_check = {
        thermite = true,
        parachute = false,
        -- ...
    }
}
```

---

## Event Flow (Client ↔ Server)

### Intel Gathering

```
CLIENT                                  SERVER
   |                                       |
   | qb-cargoheist:client:requestIntel     |
   |-------------------------------------->|
   |                                       |
   |                          Validate request
   |                          Check cooldowns
   |                          Generate intel
   |                                       |
   | qb-cargoheist:client:receiveIntel     |
   |<--------------------------------------|
   |                                       |
Display to player                         |
Store locally                             |
   |                                       |
```

### Planning Board

```
CLIENT (Leader)                         SERVER                    CLIENT (Crew)
      |                                    |                           |
      | qb-cargoheist:server:createHeist   |                           |
      |----------------------------------->|                           |
      |                          Create heist entry                    |
      |                          Assign heist_id                       |
      |                                    |                           |
      | qb-cargoheist:server:inviteCrew    |                           |
      |----------------------------------->|                           |
      |                          Validate crew member                  |
      |                          Check proximity                       |
      |                                    |                           |
      |                                    | qb-cargoheist:client:inviteReceived
      |                                    |-------------------------->|
      |                                    |                           |
      |                                    |         Player accepts    |
      |                                    |<--------------------------|
      |                                    |                           |
      | qb-cargoheist:client:crewUpdate    |                           |
      |<-----------------------------------|                           |
      |                                    |                           |
Update UI with crew                       |                           |
      |                                    |                           |
      | qb-cargoheist:server:startHeist    |                           |
      |----------------------------------->|                           |
      |                          Validate all checks                   |
      |                          Remove items                          |
      |                          Set active heist                      |
      |                                    |                           |
      | qb-cargoheist:client:heistStarted  |                           |
      |<-----------------------------------|                           |
      |                                    | qb-cargoheist:client:heistStarted
      |                                    |-------------------------->|
      |                                    |                           |
Begin heist                               |                    Begin heist
      |                                    |                           |
```

### Heist Completion

```
CLIENT                                  SERVER
   |                                       |
   | qb-cargoheist:server:deliverCargo     |
   |-------------------------------------->|
   |                                       |
   |                          Validate delivery
   |                          Calculate payout
   |                          Apply multipliers
   |                          Distribute money
   |                          Update database
   |                          Set cooldowns
   |                          Increase heat
   |                                       |
   | qb-cargoheist:client:heistComplete    |
   |<--------------------------------------|
   |                                       |
Display success                           |
Show earnings                             |
   |                                       |
```

---

## Minigame Integration Points

```
┌─────────────────────────────────────────────────────────────┐
│                    HEIST EXECUTION                          │
└────────────┬────────────────────────────────────────────────┘
             │
             ▼
    ┌────────────────────┐
    │  Need to hack?     │
    └────┬───────────┬───┘
         │ YES       │ NO
         ▼           │
    ┌────────────┐   │
    │ Launch     │   │
    │ Hacking    │   │
    │ Minigame   │   │
    └────┬───────┘   │
         │           │
         ▼           │
    Success?         │
    ├─ YES ──────────┤
    └─ NO → Alarm    │
         │           │
         └───────────┼────────┐
                     ▼        │
            ┌────────────────────┐
            │  Need thermite?    │
            └────┬───────────┬───┘
                 │ YES       │ NO
                 ▼           │
            ┌────────────┐   │
            │ Launch     │   │
            │ Thermite   │   │
            │ Minigame   │   │
            └────┬───────┘   │
                 │           │
                 ▼           │
            Success?         │
            ├─ YES ──────────┤
            └─ NO → Retry    │
                 │           │
                 └───────────┼────────┐
                             ▼        │
                    ┌────────────────────┐
                    │  Loading cargo?    │
                    └────┬───────────┬───┘
                         │ YES       │ NO
                         ▼           │
                    ┌────────────┐   │
                    │ Launch     │   │
                    │ Loading    │   │
                    │ Skillcheck │   │
                    └────┬───────┘   │
                         │           │
                         ▼           │
                    Success?         │
                    ├─ YES ──────────┤
                    └─ NO → Slower   │
                         │           │
                         └───────────┘
                                │
                                ▼
                    Continue to next phase
```

---

## Police Integration Flow

```
                    HEIST TRIGGERS ALERT
                            │
                            ▼
            ┌───────────────────────────────┐
            │  Calculate Alert Level        │
            │  - Intel phase: Low (1-2)     │
            │  - Ground heist: High (4)     │
            │  - Air heist: Max (5)         │
            └───────────┬───────────────────┘
                        │
                        ▼
            ┌───────────────────────────────┐
            │  Check Online Police          │
            │  - Count players with cop job │
            │  - If < minimum: Cancel/Reduce│
            └───────────┬───────────────────┘
                        │
                        ▼
            ┌───────────────────────────────┐
            │  Send Dispatch Alert          │
            │  - ps-dispatch integration    │
            │  - OR qb-policejob alert      │
            │  - Include blip on map        │
            └───────────┬───────────────────┘
                        │
                        ▼
            ┌───────────────────────────────┐
            │  Notify All Police            │
            │  - Alert message              │
            │  - Location/type              │
            │  - Recommended units          │
            └───────────┬───────────────────┘
                        │
                        ▼
            ┌───────────────────────────────┐
            │  Dynamic Response             │
            │  - Spawn roadblocks           │
            │  - Call Air-1                 │
            │  - SWAT (if high alert)       │
            └───────────────────────────────┘
```

---

## Configuration Impact Map

```
Config Setting              Affects
─────────────────────────────────────────────────────────
RequiredCops            →   Can heist start?
                        →   Payout multiplier

Cooldowns               →   Personal cooldown check
                        →   Server-wide cooldown

MinCrew/MaxCrew         →   Planning board validation
                        →   UI crew slots

Cargo.spawnChance       →   Intel generation
                        →   Cargo variety

Rewards.multipliers     →   Final payout calculation
                        →   Approach incentives

Locations               →   Blip placement
                        →   Zone triggers
                        →   Delivery spawns

Items.required          →   Planning board validation
                        →   Item removal on start

Heat.decay              →   Heat level reduction
                        →   Long-term economy balance

Police.alertLevel       →   Dispatch intensity
                        →   NPC police spawns
```

---

## Performance Optimization Points

### Client-Side
```
✓ Use distance checks before rendering
✓ Limit DrawText calls (pool method)
✓ Debounce input handlers
✓ Unload UI when not in use
✓ Remove event handlers on cleanup
```

### Server-Side
```
✓ Cache QBCore object (don't fetch every call)
✓ Batch database queries
✓ Use server-side timers (not CreateThread loops)
✓ Clean up expired cargo intel automatically
✓ Limit simultaneous heists (server config)
```

### Database
```
✓ Index on citizenid columns
✓ Auto-delete old history (> 30 days)
✓ Use prepared statements
✓ Connection pooling
```

---

This flowchart provides a visual reference for understanding how all systems interconnect. Use it alongside the main planning document for implementation.

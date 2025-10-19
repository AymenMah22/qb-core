# 🛩️ Cargo Plane Heist - Planning Document

## Project Overview

**Script Name**: qb-cargoheist  
**Framework**: QBCore  
**Difficulty**: Advanced (End-Game Content)  
**Player Requirement**: 2-6 players  
**Estimated Development Time**: 3-4 weeks  
**Target Price**: $75-$150

---

## 1. Core Gameplay Loop

```
Intel Gathering → Planning Board → Equipment Preparation → Heist Execution → Escape → Fence/Launder → Cooldown
```

### Phase Breakdown

#### **Phase 1: Intel Gathering (15-30 mins)**
- Players must obtain cargo manifest information
- Intel sources:
  - Hack airport computers (minigame)
  - Bribe airport workers (NPC interaction)
  - Steal documents from cargo offices
  - Police/government insider (rare, expensive)

#### **Phase 2: Planning Board (5-10 mins)**
- Visual UI interface to plan the heist
- Select approach method
- Assign crew roles
- Choose equipment loadout
- Set timing (some cargo only available certain times)

#### **Phase 3: Equipment Preparation (10-20 mins)**
- Acquire necessary tools:
  - Thermite/C4 for cargo doors
  - Hacking laptops
  - Parachutes (if mid-air approach)
  - Getaway vehicles
  - Weapons/armor
  - Bolt cutters for containers

#### **Phase 4: Heist Execution (10-15 mins)**
- Two approach methods (see below)
- Timer-based completion
- Police response system
- Dynamic difficulty

#### **Phase 5: Escape & Delivery (5-10 mins)**
- Evade police pursuit
- Deliver cargo to buyer location
- Multiple drop-off points (random selection)

#### **Phase 6: Payout & Cooldown**
- Crew receives payment split
- Server-wide cooldown (30-60 minutes)
- Heat/wanted level increase

---

## 2. Approach Methods

### **Method A: Ground - Airport Heist** (Easier, Lower Payout)

**Requirements:**
- 2-4 players
- Basic thermite or lockpicks
- Ground vehicles for escape

**Flow:**
1. Breach airport security perimeter
2. Locate cargo plane on tarmac
3. Hack/thermite cargo door
4. Load cargo into truck (multiple trips)
5. Escape via ground routes
6. Evade police pursuit

**Advantages:**
- Easier coordination
- More forgiving timing
- Can use armored trucks

**Disadvantages:**
- Higher police response
- Security cameras
- Multiple checkpoints

**Payout Multiplier**: 1.0x

---

### **Method B: Air - Mid-Flight Hijack** (Harder, Higher Payout)

**Requirements:**
- 3-6 players minimum
- Helicopter or plane
- Parachutes for crew
- Pilot with flying skill
- Second plane for cargo transfer OR ground team

**Flow:**
1. Track cargo plane flight path
2. Intercept with helicopter/plane
3. Players parachute onto moving cargo plane
4. Fight/subdue NPC crew
5. Either:
   - **Option A**: Land plane at remote airstrip, load cargo to ground vehicles
   - **Option B**: Transfer cargo mid-air to second plane (advanced)
6. Escape before military jets scramble

**Advantages:**
- Lower initial police presence
- Higher payout
- More prestigious/unique

**Disadvantages:**
- Requires pilot skills
- Timing critical
- Weather affects difficulty
- Can crash and lose everything

**Payout Multiplier**: 1.5x

---

## 3. Technical Architecture

### **File Structure**
```
qb-cargoheist/
├── fxmanifest.lua
├── config.lua                    # All configurable options
├── README.md
├── server/
│   ├── main.lua                 # Core server logic
│   ├── intel.lua                # Intel gathering system
│   ├── heist.lua                # Heist execution logic
│   ├── police.lua               # Police dispatch integration
│   ├── callbacks.lua            # Server callbacks
│   └── version.lua              # Update checker
├── client/
│   ├── main.lua                 # Core client logic
│   ├── intel.lua                # Intel gathering interactions
│   ├── planning.lua             # Planning board UI
│   ├── ground_heist.lua         # Ground approach logic
│   ├── air_heist.lua            # Air approach logic
│   ├── minigames.lua            # Hacking/skillcheck minigames
│   ├── blips.lua                # Map markers
│   └── zones.lua                # PolyZone interactions
├── shared/
│   ├── config.lua               # Shared config
│   └── locale.lua               # Localization
├── html/
│   ├── index.html               # Planning board UI
│   ├── css/
│   │   └── style.css
│   └── js/
│       ├── app.js               # Main UI logic
│       └── planning.js          # Planning board
└── locales/
    ├── en.lua
    └── es.lua
```

### **Database Schema**

```sql
-- Table: cargo_heist_intel
CREATE TABLE IF NOT EXISTS `cargo_heist_intel` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `cargo_id` VARCHAR(50) UNIQUE NOT NULL,
  `cargo_type` VARCHAR(50) NOT NULL,
  `value` INT NOT NULL,
  `location` VARCHAR(100) NOT NULL,
  `available_time` TIMESTAMP NOT NULL,
  `expires_time` TIMESTAMP NOT NULL,
  `is_active` TINYINT(1) DEFAULT 1,
  `difficulty` INT DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table: cargo_heist_cooldowns
CREATE TABLE IF NOT EXISTS `cargo_heist_cooldowns` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `citizenid` VARCHAR(50) NOT NULL,
  `heist_type` VARCHAR(50) NOT NULL,
  `cooldown_until` TIMESTAMP NOT NULL,
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table: cargo_heist_history
CREATE TABLE IF NOT EXISTS `cargo_heist_history` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `cargo_id` VARCHAR(50),
  `leader_citizenid` VARCHAR(50),
  `crew_members` TEXT,
  `approach_method` VARCHAR(50),
  `success` TINYINT(1),
  `payout` INT,
  `police_response` INT,
  `completion_time` INT,
  `heist_timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  KEY `leader_citizenid` (`leader_citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table: cargo_heist_heat
CREATE TABLE IF NOT EXISTS `cargo_heist_heat` (
  `citizenid` VARCHAR(50) PRIMARY KEY,
  `heat_level` INT DEFAULT 0,
  `last_updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

---

## 4. Cargo Types & Rewards

### **Cargo Classifications**

| Cargo Type | Base Value | Weight | Difficulty | Required Crew | Special Notes |
|------------|------------|--------|------------|---------------|---------------|
| Electronics | $80K-$120K | Light | Easy (1) | 2-3 | Quick to load, multiple boxes |
| Pharmaceuticals | $100K-$150K | Light | Medium (2) | 2-4 | Temperature sensitive, timed |
| Gold Bars | $150K-$250K | Heavy | Hard (3) | 3-5 | Slow loading, need truck |
| Weapons Cache | $120K-$200K | Medium | Hard (3) | 3-4 | Police priority, high heat |
| Diamonds | $200K-$350K | Light | Very Hard (4) | 3-6 | Rare spawn, max police |
| Prototype Tech | $250K-$500K | Medium | Extreme (5) | 4-6 | Military response, story item |
| Cash Pallets | $100K-$180K | Heavy | Medium (2) | 3-4 | Marked bills, must launder |
| Art/Artifacts | $150K-$300K | Medium | Hard (3) | 2-4 | Need specific buyer |

### **Dynamic Pricing Factors**
- Server economy (adjusts based on inflation)
- Cargo condition (damaged = lower value)
- Heat level (higher heat = lower fence prices)
- Approach method multiplier
- Crew size split
- Launder fee (15-25% for marked goods)

---

## 5. Crew Roles & Skills

### **Role System**

#### **1. Leader/Mastermind**
- Initiates heist
- Accesses planning board
- Distributes cuts
- Makes final decisions

#### **2. Pilot** (Required for Air Approach)
- Flies intercept aircraft
- Lands cargo plane (if applicable)
- Must have flying skill > 50

#### **3. Hacker**
- Faster hack times
- Can disable security systems
- Bonus: +10% on minigames

#### **4. Gunman/Muscle**
- Handles NPC resistance
- Protects crew during loading
- Better weapon handling

#### **5. Driver**
- Handles getaway vehicle
- Better at evasion
- Plans escape routes

#### **6. Loader** (Generic)
- Loads cargo
- Can perform basic tasks
- No special bonuses

### **Skill System Integration**
```lua
-- Skills affect success rates
Skills = {
    flying = 0-100,      -- Affects air approach success
    hacking = 0-100,     -- Faster hacks, less fails
    driving = 0-100,     -- Better pursuit evasion
    shooting = 0-100,    -- Combat effectiveness
    strength = 0-100     -- Cargo loading speed
}
```

---

## 6. Intel System Design

### **Intel Sources**

#### **A. Airport Computer Hack**
- **Location**: Airport office building
- **Method**: Hack terminal (minigame)
- **Cost**: Free (but risky)
- **Intel Quality**: 70% - reveals cargo type, location, rough value
- **Risk**: Security alerts police if failed

#### **B. Bribe Airport Worker**
- **Location**: Random NPC at airport
- **Method**: Approach and pay
- **Cost**: $5,000-$10,000
- **Intel Quality**: 85% - reveals type, value, security level
- **Risk**: Worker might be undercover cop (5% chance)

#### **C. Steal Cargo Manifest**
- **Location**: Cargo office
- **Method**: Break-in and steal documents
- **Cost**: Lockpicks/thermite
- **Intel Quality**: 95% - full information
- **Risk**: Triggers alarm, police response

#### **D. Government Insider**
- **Location**: Special contact (unlocked via reputation)
- **Method**: Phone call
- **Cost**: $15,000-$25,000
- **Intel Quality**: 100% - complete details + best time to hit
- **Risk**: None, but expensive

### **Intel Data Structure**
```lua
Intel = {
    cargo_id = "CARGO_001",
    type = "gold_bars",
    value = 180000,
    location = "LSIA", -- Los Santos International Airport
    plane_model = "cargo_plane",
    security_level = 3,
    available_start = "14:00",
    available_end = "16:00",
    flight_path = {...}, -- coordinates for air approach
    npc_guards = 4,
    quality = 85, -- 0-100, affects accuracy
    acquired_time = timestamp,
    expires_time = timestamp + 1 hour
}
```

### **Intel Degradation**
- Intel expires after 1 hour (real-time)
- Quality affects accuracy:
  - 100%: All info accurate
  - 85%: Value ±10%, security might be +1 level
  - 70%: Value ±20%, security unknown, guard count ±2
  - <50%: Unreliable, might be wrong cargo entirely

---

## 7. Planning Board System

### **UI Design Concept**

```
┌─────────────────────────────────────────────────────────────┐
│  CARGO HEIST PLANNING BOARD                           [X]    │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────────┐  ┌──────────────────────────────────┐ │
│  │  INTEL SUMMARY   │  │      CREW ROSTER                 │ │
│  │                  │  │  • Leader: [PlayerName]          │ │
│  │  Cargo: Gold     │  │  • Pilot: [Empty] [Invite]       │ │
│  │  Value: ~$180K   │  │  • Hacker: [PlayerName2]         │ │
│  │  Security: ★★★☆☆ │  │  • Gunman: [Empty] [Invite]      │ │
│  │  Time: 14:00     │  │  • Driver: [PlayerName3]         │ │
│  │  Expires: 42m    │  │  • Loader: [Empty] [Invite]      │ │
│  └──────────────────┘  └──────────────────────────────────┘ │
│                                                               │
│  ┌──────────────────────────────────────────────────────────┐│
│  │  APPROACH METHOD                                         ││
│  │  ○ Ground Attack (Airport)      [Est. $180K] [Easier]   ││
│  │  ● Air Intercept (Mid-Flight)   [Est. $270K] [Harder]   ││
│  └──────────────────────────────────────────────────────────┘│
│                                                               │
│  ┌──────────────────────────────────────────────────────────┐│
│  │  EQUIPMENT CHECKLIST                                     ││
│  │  [✓] Parachutes x6                                       ││
│  │  [✓] Hacking Laptop                                      ││
│  │  [✗] Thermite Charges x3                                 ││
│  │  [✓] Weapons & Armor                                     ││
│  │  [✗] Transport Helicopter (Maverick required)            ││
│  │  [✓] Ground Getaway Vehicle                              ││
│  └──────────────────────────────────────────────────────────┘│
│                                                               │
│  ┌──────────────────────────────────────────────────────────┐│
│  │  CUT DISTRIBUTION                                        ││
│  │  Leader: 25%  Pilot: 20%  Hacker: 15%                   ││
│  │  Gunman: 15%  Driver: 15%  Loader: 10%                  ││
│  │  [Adjust Cuts] [Equal Split] [Custom]                   ││
│  └──────────────────────────────────────────────────────────┘│
│                                                               │
│          [Cancel]              [START HEIST]                  │
└─────────────────────────────────────────────────────────────┘
```

### **Planning Board Features**

1. **Crew Management**
   - Invite players nearby or from phone contacts
   - See player skills/stats
   - Kick members (leader only)
   - Must meet minimum crew requirements

2. **Approach Selection**
   - Visual comparison of difficulty/reward
   - Equipment requirements highlighted
   - Estimated payout shown
   - Can't select if requirements not met

3. **Equipment Check**
   - Real-time inventory verification
   - Shows who has what items
   - Purchase button (if available nearby)
   - Red X for missing items

4. **Cut Distribution**
   - Leader sets percentage splits
   - Must total 100%
   - Crew must accept before starting
   - Pre-sets: Equal, Role-based, Custom

5. **Ready Check**
   - All crew must click "Ready"
   - 30-second countdown before start
   - Last chance to back out

---

## 8. Required Items/Equipment

### **Intel Phase Items**
```lua
Items = {
    -- Intel gathering
    {item = "laptop", label = "Laptop", required_for = "hacking"},
    {item = "lockpick", label = "Lockpick", required_for = "manifest_theft"},
    {item = "thermite", label = "Thermite", required_for = "office_breach"},
}
```

### **Heist Execution Items**

#### **Ground Approach**
```lua
GroundItems = {
    {item = "thermite", amount = 2, required = true},
    {item = "security_card", amount = 1, required = false}, -- Alternative
    {item = "armor", amount = 1, required = true},
    {item = "weapon", required = true},
    {item = "portable_radio", amount = 1, required = true},
}
```

#### **Air Approach**
```lua
AirItems = {
    {item = "parachute", amount = 1, required = true}, -- Per player
    {item = "thermite", amount = 1, required = true},
    {item = "armor", amount = 1, required = true},
    {item = "weapon", required = true},
    {item = "portable_radio", amount = 1, required = true},
    {item = "gps_tracker", amount = 1, required = false}, -- Helps track plane
}
```

### **Vehicle Requirements**

#### **Ground Approach**
- Transport truck (Benson, Mule, Pounder)
- Fast getaway car (optional but recommended)

#### **Air Approach**
- Helicopter (Maverick, Buzzard) OR Small plane (Velum, Cuban800)
- Ground vehicle for final delivery
- Optional: Second aircraft for cargo transfer

---

## 9. Police Integration

### **Dispatch System**

```lua
PoliceAlerts = {
    -- Alert Types
    intel_hack = {
        alert_level = 2,
        message = "10-31: Unauthorized computer access at airport",
        blip_time = 30, -- seconds
    },
    
    manifest_theft = {
        alert_level = 3,
        message = "10-31: Breaking and entering at cargo office",
        blip_time = 45,
    },
    
    ground_breach = {
        alert_level = 4,
        message = "10-90: Active robbery at LSIA - Cargo Theft",
        blip_time = 120,
        backup_called = true,
    },
    
    air_intercept = {
        alert_level = 5,
        message = "10-90: Aircraft hijacking in progress",
        blip_time = 180,
        backup_called = true,
        air_support = true, -- Police helicopters
    }
}
```

### **Response Scaling**

**Alert Level 1-2**: Basic units
- 1-2 police vehicles
- Standard equipment
- Can be avoided

**Alert Level 3**: Moderate response
- 2-4 police vehicles
- Roadblocks possible
- Air-1 (police heli) might respond

**Alert Level 4**: Heavy response
- 4-6 vehicles
- SWAT/interceptors
- Air-1 guaranteed
- Roadblocks guaranteed

**Alert Level 5**: Maximum response
- 6+ vehicles
- SWAT teams
- Multiple helicopters
- Military might be called (if enabled)

### **Heat System**
```lua
HeatLevels = {
    [0] = "Clean", -- No heat
    [1] = "Known", -- Police aware but low priority
    [2] = "Wanted", -- Active investigation
    [3] = "Hot", -- High priority target
    [4] = "Hunted", -- Shoot on sight
    [5] = "Notorious", -- Server-wide manhunt
}

-- Heat affects:
-- - Police response time (faster at higher heat)
-- - Number of units responding
-- - Fence willingness to buy (higher cut at high heat)
-- - Heat decays 1 level per 30 minutes (real-time)
```

---

## 10. Minigames/Skillchecks

### **1. Hacking Minigame**
**Type**: Pattern matching or code breaking
**Used For**: Computer hacks, security systems
**Difficulty Scaling**: More complex patterns for higher security

**Implementation Ideas**:
- Memory game (Simon Says style)
- Code sequence matching
- Timed typing challenge
- Custom circuit board game

### **2. Thermite Placement**
**Type**: Temperature control
**Used For**: Breaching doors, vaults
**Mechanic**: Keep temperature in "green zone"

### **3. Lockpicking**
**Type**: Pin tumbler simulation
**Used For**: Doors, containers
**Mechanic**: Rotate and find sweet spots

### **4. Cargo Loading**
**Type**: Skillcheck circles (like GTA V)
**Used For**: Loading cargo boxes
**Mechanic**: Hit the white section, multiple rounds

### **5. Piloting Challenge**
**Type**: Maintain proximity/altitude
**Used For**: Air intercept approach
**Mechanic**: Keep plane within 50m range while crew parachutes

---

## 11. Escape & Delivery System

### **Escape Phase**

**Ground Escape**:
1. Police pursuit starts immediately
2. Roadblocks spawn dynamically on likely routes
3. GPS shows "delivery zone" (randomized from pool)
4. Must shake police (break line of sight for 30s)
5. Deliver cargo to drop point

**Air Escape**:
1. Police helicopters pursue
2. If landed: Ground pursuit begins
3. If staying airborne: Must evade Air-1
4. Delivery to remote airstrip or ground drop point
5. Parachute drop option (risky, might damage cargo)

### **Delivery Zones**

```lua
DeliveryLocations = {
    {name = "Sandy Shores Warehouse", coords = vector3(...)},
    {name = "Paleto Bay Dock", coords = vector3(...)},
    {name = "Abandoned Factory", coords = vector3(...)},
    {name = "Desert Airstrip", coords = vector3(...)},
    {name = "Mountain Drop Point", coords = vector3(...)},
    {name = "Boat Pier", coords = vector3(...)},
    -- Randomly selected to prevent camping
}
```

### **Delivery Mechanics**
- Park vehicle in designated zone
- Interact with buyer NPC
- Cargo inspection (checks condition)
- Payment calculated based on:
  - Base cargo value
  - Condition (100% if undamaged)
  - Heat level penalty
  - Launder fee if applicable
  - Time bonus (faster = better)

---

## 12. Configuration System

### **config.lua Structure**

```lua
Config = {}

-- GENERAL SETTINGS
Config.Debug = false
Config.Locale = 'en'

-- CREW SETTINGS
Config.MinimumCrew = {
    ground = 2,
    air = 3
}
Config.MaximumCrew = 6

-- COOLDOWNS (minutes)
Config.Cooldowns = {
    personal = 60,      -- Per player
    server = 30,        -- Server-wide
    failed = 30,        -- If heist failed
}

-- INTEL SETTINGS
Config.IntelExpiry = 60 -- minutes
Config.IntelSources = {
    hack = {enabled = true, cost = 0, quality = 70},
    bribe = {enabled = true, cost = 7500, quality = 85},
    manifest = {enabled = true, quality = 95},
    insider = {enabled = true, cost = 20000, quality = 100},
}

-- PAYOUT SETTINGS
Config.PayoutMultipliers = {
    ground = 1.0,
    air = 1.5,
    no_cops = 0.7,      -- Reduced if no cops online
    perfect = 1.2,      -- No damage, no alarms
}

-- POLICE SETTINGS
Config.RequiredCops = 3
Config.PoliceJobs = {'police', 'sheriff', 'state'}
Config.EnablePoliceAlerts = true
Config.EnableAirSupport = true

-- HEAT SYSTEM
Config.EnableHeat = true
Config.HeatDecayTime = 30 -- minutes per level
Config.HeatPenalty = 0.1 -- 10% reduction per heat level

-- CARGO TYPES
Config.CargoTypes = {
    electronics = {
        label = "Electronics",
        minValue = 80000,
        maxValue = 120000,
        weight = 'light',
        difficulty = 1,
        spawnChance = 30,
    },
    -- ... more cargo types
}

-- LOCATIONS
Config.AirportCoords = vector3(-1037.44, -2385.12, 13.94)
Config.IntelLocations = {
    computer = vector3(...),
    office = vector3(...),
    worker_spawn = {...}, -- Multiple possible locations
}

-- VEHICLES
Config.AllowedHelicopters = {
    'maverick',
    'buzzard',
    -- Military helicopters disabled by default
}

Config.TransportTrucks = {
    'benson',
    'mule',
    'pounder',
}

-- ITEMS
Config.RequiredItems = {
    intel = {
        'laptop',
        -- Optional thermite or lockpick
    },
    ground = {
        'thermite',
        'armor',
        'portable_radio',
    },
    air = {
        'parachute',
        'thermite',
        'armor',
        'portable_radio',
    }
}

-- MINIGAME SETTINGS
Config.Minigames = {
    hack = {
        type = 'pattern', -- or 'code', 'typing'
        difficulty = 'medium',
        timeout = 60, -- seconds
    },
    thermite = {
        lives = 3,
        duration = 10,
    },
    lockpick = {
        attempts = 3,
    }
}

-- REWARDS
Config.BonusRewards = {
    speed_bonus = {
        enabled = true,
        time_limit = 600, -- 10 minutes
        bonus_percent = 10,
    },
    no_damage = {
        enabled = true,
        bonus_percent = 15,
    },
    stealth = {
        enabled = true,
        bonus_percent = 20,
    }
}
```

---

## 13. Dependencies

### **Required**
- qb-core (obviously)
- qb-target OR ox_target (interaction system)
- oxmysql OR mysql-async (database)
- qb-policejob OR custom police script (for alerts)
- qb-menu OR ox_lib (for menus)

### **Recommended**
- qb-inventory OR ox_inventory (item checks)
- ps-dispatch OR cd_dispatch (better police alerts)
- qb-skillsystem (if implementing skill bonuses)
- PolyZone (for zone-based triggers)
- qb-phone (for intel contacts)

### **Optional Integrations**
- qb-banking (for laundering)
- qb-houses (stash cargo temporarily)
- qb-gangs (gang reputation bonuses)
- discord-api (logging and webhooks)

---

## 14. Anti-Cheat & Exploits

### **Prevention Measures**

1. **Server-Side Validation**
   - All critical checks done server-side
   - Validate player positions
   - Verify item ownership
   - Check cooldowns server-side

2. **Item Duplication Prevention**
   - Remove items before heist starts
   - Validate inventory on each action
   - Log all item transactions

3. **Teleport Detection**
   - Check distance traveled vs time
   - Validate zone entry
   - Kick/ban if suspicious

4. **Payout Manipulation**
   - All calculations server-side
   - Encrypted cargo values
   - Log all payouts for review

5. **Crew Slot Abuse**
   - Lock crew once heist starts
   - Validate all crew members online
   - Check player proximity

6. **Cooldown Bypass**
   - Database-backed cooldowns
   - Check across restarts
   - Shared cooldown table

---

## 15. Localization Support

### **Locale Files**

```lua
-- locale/en.lua
Locale = {
    -- UI
    ['planning_board'] = 'Planning Board',
    ['start_heist'] = 'Start Heist',
    ['invite_player'] = 'Invite Player',
    
    -- Intel
    ['intel_acquired'] = 'Intel acquired: %s',
    ['intel_expired'] = 'Your intel has expired',
    ['hack_success'] = 'Successfully hacked computer',
    ['hack_failed'] = 'Hack failed! Security alerted',
    
    -- Heist
    ['heist_started'] = 'Cargo heist in progress!',
    ['cargo_loaded'] = 'Cargo loaded: %s%%',
    ['escape_now'] = 'Escape to the delivery point!',
    
    -- Completion
    ['heist_success'] = 'Heist successful! $%s earned',
    ['heist_failed'] = 'Heist failed!',
    ['cut_received'] = 'You received your cut: $%s',
    
    -- Errors
    ['not_enough_cops'] = 'Not enough police online',
    ['on_cooldown'] = 'You must wait %s minutes',
    ['missing_items'] = 'Missing required items',
    ['crew_full'] = 'Crew is full',
    
    -- Police
    ['dispatch_cargo'] = 'Cargo theft in progress at LSIA',
    ['dispatch_hijack'] = 'Aircraft hijacking reported',
}
```

---

## 16. Testing Checklist

### **Phase 1: Intel System**
- [ ] All intel sources functional
- [ ] Intel data saves correctly
- [ ] Expiry system works
- [ ] Quality affects accuracy
- [ ] Police alerts trigger correctly

### **Phase 2: Planning Board**
- [ ] UI loads correctly
- [ ] Crew invites work
- [ ] Role assignment functional
- [ ] Equipment detection works
- [ ] Cut distribution calculates correctly
- [ ] Can't start without requirements

### **Phase 3: Ground Heist**
- [ ] Zone triggers work
- [ ] Security systems activate
- [ ] Cargo loading mechanics
- [ ] Police dispatch triggers
- [ ] Timer system accurate
- [ ] Escape routes functional

### **Phase 4: Air Heist**
- [ ] Plane spawns correctly
- [ ] Flight path accurate
- [ ] Parachute mechanics
- [ ] Mid-air interactions
- [ ] Landing system
- [ ] Air pursuit works

### **Phase 5: Completion**
- [ ] Delivery zones spawn
- [ ] Buyer interaction works
- [ ] Payout calculates correctly
- [ ] Money distributed properly
- [ ] Cooldowns activate
- [ ] Heat system updates
- [ ] History logs correctly

### **Phase 6: Edge Cases**
- [ ] Player disconnects mid-heist
- [ ] Server restart handling
- [ ] All crew dies
- [ ] Cargo destroyed
- [ ] Vehicle destroyed
- [ ] Timeout scenarios

---

## 17. Marketing & Sales Strategy

### **Pre-Launch**
1. Create teaser video (30-60 seconds)
2. Post screenshots on Discord/forums
3. Offer beta testing to community
4. Build hype with feature reveals

### **Launch**
1. Professional showcase video (3-5 minutes)
   - Show both approaches
   - Highlight unique features
   - Show UI/planning board
   - Demonstrate police interaction

2. Pricing tiers:
   - **Basic**: $75 (core heist)
   - **Premium**: $100 (+ updates + support)
   - **Ultimate**: $150 (+ custom features + priority support)

3. Launch discount (15-20% off first week)

### **Post-Launch**
1. Regular updates (bug fixes, features)
2. Customer support via Discord
3. Collect feedback for v2
4. Offer customization services

### **Sales Platforms**
- Tebex store (most common)
- FiveM Forums
- Discord servers
- GTA V Modding websites

---

## 18. Development Roadmap

### **Week 1: Foundation**
- [ ] Project structure setup
- [ ] Database schema implementation
- [ ] Config system
- [ ] Basic intel gathering (hack computer)
- [ ] Simple planning board UI

### **Week 2: Ground Heist**
- [ ] Airport zone setup
- [ ] Cargo loading mechanics
- [ ] Police dispatch integration
- [ ] Escape system
- [ ] Delivery mechanics
- [ ] Payout system

### **Week 3: Air Heist**
- [ ] Plane spawning system
- [ ] Flight path tracking
- [ ] Parachute mechanics
- [ ] Air intercept logic
- [ ] Advanced escape options

### **Week 4: Polish & Testing**
- [ ] All minigames implemented
- [ ] Full UI polish
- [ ] Localization
- [ ] Bug fixes
- [ ] Performance optimization
- [ ] Documentation (README, wiki)
- [ ] Video creation

---

## 19. Success Metrics

### **Technical Goals**
- Zero exploits/duplication bugs
- < 0.03ms average resource usage
- Works with 200+ players online
- No server crashes
- Clean resmon output

### **Gameplay Goals**
- 70%+ success rate for organized crews
- 15-45 minute completion time
- Balanced risk/reward
- Engaging for all crew roles
- Replayability through randomization

### **Business Goals**
- 50+ sales in first month
- 4.5+ star rating
- < 5% refund rate
- Active community feedback
- Potential for expansion packs

---

## 20. Future Expansion Ideas

### **DLC Concepts**
1. **Military Cargo Expansion**
   - Military base heists
   - Tank/helicopter cargo
   - Higher difficulty, higher reward

2. **International Expansion**
   - Cayo Perico cargo runs
   - Yacht interceptcargo
   - Cross-map delivery missions

3. **Heist Creator**
   - Let server owners create custom cargo types
   - Custom delivery locations
   - Modular approach system

4. **Gang Territory System**
   - Control delivery zones
   - Passive income from controlled areas
   - Rival gang conflicts

---

## Final Notes

**Estimated Total Development Time**: 80-120 hours

**Revenue Potential**: 
- Conservative: $3,750 (50 sales @ $75)
- Moderate: $10,000 (100 sales @ $100)
- Optimistic: $22,500 (150 sales @ $150)

**Risk Factors**:
- Competition (check existing cargo heist scripts)
- Framework updates breaking compatibility
- Player server performance issues
- Complex air mechanics might be difficult

**Success Factors**:
- Unique air intercept approach (differentiator)
- High configurability for server owners
- Professional presentation/videos
- Excellent documentation
- Active support

---

**Next Steps**: 
1. Review this plan
2. Decide on feature priorities
3. Set up development environment
4. Start with Week 1 tasks
5. Create GitHub repository for version control


# Project Structure Template

When you're ready to start development, create this folder structure:

```
qb-cargoheist/
│
├── fxmanifest.lua              # Resource manifest
├── config.lua                  # Main configuration file
├── README.md                   # Installation & setup guide
├── CHANGELOG.md                # Version history
├── LICENSE                     # Your license terms
│
├── server/
│   ├── main.lua               # Core server initialization
│   ├── intel.lua              # Intel gathering system
│   ├── heist.lua              # Heist execution logic
│   ├── police.lua             # Police dispatch integration
│   ├── callbacks.lua          # Server callbacks
│   ├── commands.lua           # Admin/debug commands
│   └── version.lua            # Update checker
│
├── client/
│   ├── main.lua               # Core client initialization
│   ├── intel.lua              # Intel gathering UI/interactions
│   ├── planning.lua           # Planning board logic
│   ├── ground_heist.lua       # Ground approach
│   ├── air_heist.lua          # Air approach
│   ├── minigames.lua          # Hacking/skillcheck games
│   ├── blips.lua              # Map markers
│   ├── zones.lua              # Zone management
│   └── utils.lua              # Helper functions
│
├── shared/
│   ├── config.lua             # Shared configuration
│   └── locale.lua             # Locale handler
│
├── html/
│   ├── index.html             # Planning board UI
│   ├── css/
│   │   ├── style.css          # Main styles
│   │   └── planning.css       # Planning board specific
│   ├── js/
│   │   ├── app.js             # Main UI logic
│   │   ├── planning.js        # Planning board
│   │   └── utils.js           # Helper functions
│   └── img/
│       ├── cargo/             # Cargo type images
│       ├── icons/             # UI icons
│       └── background.png     # UI background
│
├── locales/
│   ├── en.lua                 # English
│   ├── es.lua                 # Spanish
│   ├── fr.lua                 # French
│   └── de.lua                 # German
│
├── sql/
│   └── install.sql            # Database schema
│
└── docs/
    ├── installation.md        # Installation guide
    ├── configuration.md       # Config documentation
    ├── troubleshooting.md     # Common issues
    └── api.md                 # Export functions (if any)
```

## File Size Estimates

```
fxmanifest.lua        ~1 KB
config.lua            ~15 KB (highly configurable)
server/               ~25 KB total
client/               ~35 KB total
shared/               ~5 KB total
html/                 ~50 KB total (including images)
locales/              ~20 KB total (4 languages)
sql/                  ~3 KB
docs/                 ~10 KB

TOTAL: ~165 KB (very lightweight!)
```

## Basic fxmanifest.lua Template

```lua
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'YourName'
description 'Advanced Cargo Plane Heist System'
version '1.0.0'

shared_scripts {
    'config.lua',
    'shared/*.lua',
    'locales/*.lua'
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/css/*.css',
    'html/js/*.js',
    'html/img/**/*.png'
}

dependencies {
    'qb-core',
    'qb-target', -- or ox_target
    'oxmysql',
    'PolyZone'
}

escrow_ignore {
    'config.lua',
    'locales/*.lua',
    'README.md',
    'sql/*.sql'
}
```

## Starter Code Templates

### server/main.lua (skeleton)
```lua
local QBCore = exports['qb-core']:GetCoreObject()

-- State management
local ActiveHeists = {}
local CargoIntel = {}
local PlayerCooldowns = {}

-- Initialize on resource start
CreateThread(function()
    print('^2[qb-cargoheist]^7 Loading...')
    
    -- Load data from database
    LoadCargoIntel()
    LoadCooldowns()
    
    print('^2[qb-cargoheist]^7 Successfully loaded!')
end)

-- Core functions
function LoadCargoIntel()
    -- Load active cargo intel from database
end

function LoadCooldowns()
    -- Load player cooldowns
end

-- Exports
exports('GetActiveHeists', function()
    return ActiveHeists
end)
```

### client/main.lua (skeleton)
```lua
local QBCore = exports['qb-core']:GetCoreObject()

-- Local state
local PlayerData = {}
local InHeist = false
local CurrentCrew = {}

-- Initialize
CreateThread(function()
    PlayerData = QBCore.Functions.GetPlayerData()
    
    -- Setup blips
    SetupBlips()
    
    -- Setup zones
    SetupZones()
end)

-- Event handlers
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = {}
end)
```

### config.lua (starter template)
```lua
Config = {}

-- DEBUG
Config.Debug = false

-- GENERAL
Config.Locale = 'en'
Config.RequiredCops = 3
Config.PoliceJobs = {'police', 'sheriff'}

-- CREW
Config.MinCrew = {
    ground = 2,
    air = 3
}
Config.MaxCrew = 6

-- COOLDOWNS (minutes)
Config.Cooldowns = {
    personal = 60,
    server = 30,
    failed = 30
}

-- LOCATIONS
Config.Locations = {
    airport = vector3(-1037.44, -2385.12, 13.94),
    
    intel = {
        computer = vector3(-1042.12, -2386.57, 14.50),
        office = vector3(-1048.23, -2392.84, 13.95),
    },
    
    deliveryZones = {
        {coords = vector3(1733.64, 3310.51, 41.22), radius = 15.0},
        {coords = vector3(-1118.76, 4914.51, 218.35), radius = 15.0},
        -- Add more
    }
}

-- CARGO TYPES
Config.Cargo = {
    electronics = {
        label = "Electronics",
        minValue = 80000,
        maxValue = 120000,
        weight = 'light',
        difficulty = 1,
        spawnChance = 30,
        boxes = 5,
        model = 'prop_box_wood02a'
    },
    -- Add more types
}

-- ITEMS
Config.Items = {
    intel = {
        {item = 'laptop', label = 'Laptop'},
    },
    ground = {
        {item = 'thermite', amount = 2},
        {item = 'armor', amount = 1},
    },
    air = {
        {item = 'parachute', amount = 1},
        {item = 'thermite', amount = 1},
    }
}

-- REWARDS
Config.Rewards = {
    approach_multipliers = {
        ground = 1.0,
        air = 1.5
    },
    bonus = {
        speed = {enabled = true, time = 600, percent = 10},
        stealth = {enabled = true, percent = 20},
        perfect = {enabled = true, percent = 15}
    }
}
```

## Database Schema (sql/install.sql)

```sql
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

CREATE TABLE IF NOT EXISTS `cargo_heist_cooldowns` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `citizenid` VARCHAR(50) NOT NULL,
  `heist_type` VARCHAR(50) NOT NULL,
  `cooldown_until` TIMESTAMP NOT NULL,
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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

CREATE TABLE IF NOT EXISTS `cargo_heist_heat` (
  `citizenid` VARCHAR(50) PRIMARY KEY,
  `heat_level` INT DEFAULT 0,
  `last_updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

## README.md Template

```markdown
# QB-CargoHeist

Advanced cargo plane heist system for QBCore Framework.

## Features
- Dual approach system (ground & air)
- Intel gathering mechanics
- Interactive planning board
- Crew role system
- Heat/wanted system
- Police integration
- Highly configurable

## Requirements
- QBCore Framework
- oxmysql
- qb-target or ox_target
- qb-policejob (or compatible)
- PolyZone

## Installation
1. Download and extract to your resources folder
2. Add `ensure qb-cargoheist` to server.cfg
3. Import `sql/install.sql` to your database
4. Configure `config.lua` to your liking
5. Restart server

## Configuration
See `config.lua` for all options.

## Support
Discord: [your-discord]
Documentation: [your-docs-link]

## License
All Rights Reserved - No redistribution allowed
```

## Git Ignore Template (.gitignore)

```
# IDE
.vscode/
.idea/
*.code-workspace

# OS
.DS_Store
Thumbs.db

# Temp files
*.log
*.tmp

# Don't commit personal config changes during development
config_personal.lua
```

---

## Development Workflow

### Step 1: Setup
```bash
# Create project folder
mkdir qb-cargoheist
cd qb-cargoheist

# Initialize git
git init
git add .
git commit -m "Initial project structure"

# Create development branch
git checkout -b development
```

### Step 2: Week 1 (Foundation)
- [ ] Set up file structure
- [ ] Create database tables
- [ ] Build config system
- [ ] Implement basic intel (computer hack)
- [ ] Create simple planning UI

### Step 3: Week 2 (Ground Heist)
- [ ] Airport zones
- [ ] Cargo loading
- [ ] Police integration
- [ ] Escape mechanics
- [ ] Payout system

### Step 4: Week 3 (Air Heist)
- [ ] Plane spawning
- [ ] Flight tracking
- [ ] Parachute mechanics
- [ ] Mid-air interactions

### Step 5: Week 4 (Polish)
- [ ] All minigames
- [ ] Full UI polish
- [ ] Bug fixes
- [ ] Documentation
- [ ] Video creation

### Step 6: Launch
- [ ] Final testing
- [ ] Set up Tebex
- [ ] Release announcement
- [ ] Support monitoring

---

## File Priority (What to Build First)

### Critical Path (MVP)
1. `config.lua` - Set up all configs
2. `sql/install.sql` - Database foundation
3. `server/main.lua` - Core server logic
4. `client/main.lua` - Core client logic
5. `server/intel.lua` - Intel system
6. `client/intel.lua` - Intel UI
7. `server/heist.lua` - Heist logic (ground only)
8. `client/ground_heist.lua` - Ground execution
9. `html/index.html` - Planning board
10. `server/callbacks.lua` - Money/completion

### Secondary
11. `client/minigames.lua` - Better UX
12. `server/police.lua` - Police alerts
13. `client/air_heist.lua` - Air approach
14. `locales/` - Translations
15. `client/blips.lua` - Map markers

### Polish
16. Documentation
17. Video tutorials
18. Community feedback integration

---

Ready to start coding? Let me know which file you want to begin with!

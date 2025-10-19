# 🎯 Cargo Plane Heist - Quick Reference

## Core Concept
A 2-6 player heist where crews steal high-value cargo from planes, either at the airport or mid-flight.

## Key Differentiators (What Makes This Unique)
1. **Dual Approach System** - Ground vs Air (mid-flight hijack is rare/unique)
2. **Dynamic Intel System** - Multiple ways to gather info with varying quality
3. **Interactive Planning Board** - Visual crew management and strategy
4. **Skill-Based Roles** - Different crew members matter
5. **Heat System** - Repeated heists increase difficulty and reduce payouts

## Revenue Model
- **Target Price**: $75-$150
- **Expected Sales**: 50-150 copies (first 3 months)
- **Projected Revenue**: $3,750 - $22,500

## Development Timeline
- **Week 1**: Foundation + Intel System + Basic UI
- **Week 2**: Ground Heist (full loop)
- **Week 3**: Air Heist (advanced mechanics)
- **Week 4**: Polish, testing, documentation, marketing

**Total**: ~100 hours of development

## Technical Stack
```
Framework: QBCore
Database: oxmysql
UI: HTML/CSS/JS (NUI)
Dependencies: qb-target, qb-policejob, qb-menu
Optional: ps-dispatch, PolyZone, qb-skillsystem
```

## Gameplay Flow (60-Second Overview)
```
1. Buy/Steal Intel (15-30m) → Learn about cargo
2. Planning Board (5m) → Assemble crew, choose approach
3. Get Equipment (10m) → Gather required items
4. Execute Heist (10-15m) → Steal cargo (ground or air)
5. Escape (5-10m) → Evade police, deliver cargo
6. Get Paid (instant) → Split rewards, activate cooldown
```

## Two Approaches

### Ground Attack (Easier)
- 2-4 players minimum
- Attack plane at airport
- More police response
- $150K-$250K payout
- Good for beginners

### Air Intercept (Harder)
- 3-6 players minimum
- Parachute onto flying plane
- Requires pilot skill
- $225K-$375K payout (1.5x multiplier)
- Prestige/bragging rights

## Cargo Types (8 Total)
| Type | Value | Difficulty | Special |
|------|-------|------------|---------|
| Electronics | $80K-$120K | ★☆☆☆☆ | Quick |
| Pharmaceuticals | $100K-$150K | ★★☆☆☆ | Timed |
| Gold Bars | $150K-$250K | ★★★☆☆ | Heavy |
| Weapons | $120K-$200K | ★★★☆☆ | High heat |
| Diamonds | $200K-$350K | ★★★★☆ | Rare |
| Prototype Tech | $250K-$500K | ★★★★★ | Military response |
| Cash | $100K-$180K | ★★☆☆☆ | Must launder |
| Art | $150K-$300K | ★★★☆☆ | Specific buyer |

## Crew Roles
1. **Leader** - Starts heist, distributes cuts
2. **Pilot** - Flies (air approach only)
3. **Hacker** - Faster hacks, security bypass
4. **Gunman** - Combat, protection
5. **Driver** - Getaway, evasion
6. **Loader** - Generic role

## Config Highlights (What Server Owners Can Change)
✅ Payout amounts  
✅ Required police count  
✅ Cooldown timers  
✅ Cargo spawn chances  
✅ Difficulty scaling  
✅ Item requirements  
✅ Police alert types  
✅ Heat system on/off  
✅ Locations (airport, delivery zones)  
✅ Allowed vehicles  

## Marketing Strategy

### Pre-Launch
- Teaser videos/screenshots
- Beta testing phase
- Community feedback

### Launch
- Professional 3-5 min showcase video
- Show both approaches
- Highlight unique features
- Launch discount (15-20% off)

### Sales Channels
- Tebex (primary)
- FiveM Forums
- Discord communities
- GTA V modding sites

## Competitive Analysis

### Existing Competition
Most FiveM heists are:
- Static locations (banks, stores)
- Ground-only approaches
- Simple execution (hack → grab → run)

### Your Advantages
✅ **Moving target** (plane in flight)  
✅ **Dual approach** system  
✅ **Deep planning** phase  
✅ **Intel gathering** mini-game loop  
✅ **Skill-based** crew roles  
✅ **Heat/reputation** system  
✅ **High configurability**  

## Risk Assessment

### Low Risk
- Basic ground heist (proven concept)
- QBCore is stable framework
- Clear market demand for heists

### Medium Risk
- Air mechanics complexity
- Testing with multiple players
- Performance optimization

### High Risk
- Over-engineering features
- Competition releases similar script
- Framework breaking changes

### Mitigation
- Start with MVP (ground heist only)
- Add air approach in v1.1
- Regular testing with community
- Modular code design

## MVP (Minimum Viable Product)

If you need to launch quickly, start with:

### Phase 1 (Core - 2 weeks)
✅ Intel system (hack computer)  
✅ Basic planning board  
✅ Ground heist only  
✅ Simple police alerts  
✅ Delivery system  
✅ Payout distribution  

### Phase 2 (Polish - 1 week)
✅ Multiple intel sources  
✅ Better UI  
✅ Heat system  
✅ More cargo types  

### Phase 3 (Premium - 1 week)
✅ Air intercept approach  
✅ Advanced minigames  
✅ Skill system  
✅ Full localization  

**Launch with Phase 1+2, release Phase 3 as free update = builds goodwill**

## Development Tips

1. **Start Simple**: Get ground heist working perfectly first
2. **Test Often**: Bugs in heists ruin gameplay
3. **Server-Side Logic**: Prevent exploits from the start
4. **Performance First**: Use 0.00ms resmon as goal
5. **Documentation**: Good docs = fewer support tickets
6. **Community Input**: Beta test with real players

## Support Strategy

### Documentation
- Installation guide
- Configuration guide
- Troubleshooting FAQ
- Video tutorials

### Support Channels
- Discord server (primary)
- Ticket system
- Email (secondary)

### Update Schedule
- Bug fixes: Within 24-48 hours
- Minor features: Monthly
- Major updates: Quarterly

## Legal/License

Consider:
- **All Rights Reserved** (no reselling)
- **Escrow** option (builds trust, costs 10-15%)
- **Updates** policy (lifetime vs 1 year)
- **Support** terms (how long, what channels)

## Success Indicators

### Week 1
- 10-20 sales
- No major bugs reported
- 4+ star reviews

### Month 1
- 50+ sales
- Active Discord community
- Feature requests coming in

### Month 3
- 100+ sales
- Version 1.2+ released
- Considering expansion packs

## Next Steps (Right Now)

1. ✅ Review planning document (you're here)
2. ⏭️ Decide: MVP or full version?
3. ⏭️ Set up development environment
4. ⏭️ Create GitHub repo
5. ⏭️ Start Week 1 tasks

---

**Questions to Answer Before Starting:**

1. **Scope**: MVP (2-3 weeks) or Full (4 weeks)?
2. **Price Point**: Budget ($50-75) or Premium ($100-150)?
3. **Support Level**: Basic (Discord) or Premium (Ticket system)?
4. **Updates**: Free forever or paid expansions later?
5. **Launch Date**: Soft launch (beta) or hard launch?

**Recommended**: Start with MVP, price at $75, free updates for 6 months, Discord support, soft launch with beta testers.

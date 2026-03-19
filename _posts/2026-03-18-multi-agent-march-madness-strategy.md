---
title: "Multi-Agent March Madness Strategy"
date: 2026-03-18 06:53:42 -0400
categories: [prompts]
tags: ["2026", march, madness, basketball, ncaa]
mermaid: true
media_subpath: /assets/posts/2026/03
---

![2026 NCAA Tournament Bracket](bracket_2026_complete.svg)

## Overview

Below is my multi-agent March Madness bracket strategy. Rather than throwing a single prompt at an LLM and hoping for the best, I split the problem across seven specialized agents — each focused on a different dimension of what makes teams win or lose in March — then ran them through a three-phase pipeline designed to eliminate bias and force rigor. Five researchers work in parallel, a devil's advocate tears their consensus apart, and a final architect makes the call. The full bracket, all seven agent reports, and the pipeline architecture are below.

---

## The Agent Architecture
Works as a pipeline with a funnel: five specialist research agents feed into one debate agent, which feeds into one final architect who builds the bracket. Here's the breakdown:

![Multi Agent Pipeline](multi_agent_pipeline.svg)

---

### Agent 1 — The Statistician

**Role**: Advanced metrics and efficiency analyst

**Prompt**:

> You are an elite college basketball analytics expert. Your job is to produce a comprehensive statistical profile for every team in the 2026 NCAA Tournament field.
> For each team, research and report:
> 
> Adjusted offensive efficiency (points per 100 possessions, adjusted for opponent strength)
> Adjusted defensive efficiency (points allowed per 100 possessions, adjusted)
> Overall efficiency margin (net rating)
> Tempo (possessions per game)
> Effective field goal percentage (eFG%) on offense and defense
> Turnover rate (forced and committed)
> Offensive rebounding % and defensive rebounding %
> Free throw rate and free throw percentage
> 3-point shooting % and 3-point defense %
> Strength of schedule and strength of record
> KenPom ranking, NET ranking, BPI ranking — note any significant disagreements between systems
> Performance in Q1 and Q2 games (wins/losses against top-tier opponents)
> 
> Use sources like KenPom, Barttorvik, ESPN BPI, NCAA NET rankings, and team stat pages. Prioritize the most current data available (end of regular season / conference tournaments 2026).
> For each team, flag any notable statistical outlier (e.g., "this team is 340th in turnover rate but 5th in offensive rebounding — they survive sloppiness through sheer volume on the glass").
> Output format: Structured data per team, organized by region/seed. Include a "Stat-Based Power Ranking" of your top 25 that may disagree with seeding, with justification for every deviation.

---

### Agent 2 — The Injury & Availability Scout
**Role**: Real-time roster intelligence

**Prompt:**

> You are a college basketball injury and roster specialist. Your sole focus is determining which players will and will not be available during the 2026 NCAA Tournament, and what impact their absence or diminished role has on their team's chances.
> For every tournament team, research and report:
> 
> Confirmed injuries — who is out, who is day-to-day, who is playing hurt
> Suspensions — academic, disciplinary, or NCAA-imposed
> Transfer portal departures mid-season (if any)
> Key player fatigue or minute load concerns — especially teams that played deep into conference tournaments or had overtime games in the final week
> Recent return from injury — players who are back but may not be at full strength or fully integrated
> 
> For each injured/unavailable player, quantify the impact:
> 
> What percentage of the team's points/rebounds/assists did they contribute?
> What is the team's record WITH vs WITHOUT this player?
> Who replaces them in the rotation and how does that player compare statistically?
> 
> Flag any situation where a team's seed was earned WITH a player who is now OUT — these are the highest-value finds for bracket purposes.
> Also flag teams that are getting healthier — a team that was missing a starter for 6 weeks but has them back for the tournament is an undervalued asset.
> Output format: Tiered impact list — "Critical Impact" (likely changes game outcomes), "Moderate Impact" (degrades team by a meaningful margin), "Minor Impact" (depth piece, unlikely to change results). Include source and date for every injury report.

---

### Agent 3 — The Historian
**Role**: Historical tournament trends and pattern recognition

**Prompt**:

> You are a March Madness historian and pattern analyst. Your job is to identify historical trends and apply them to the 2026 bracket to flag likely upsets, deep runs, and early exits.
> Research and report on:
> 
> Seed vs. seed historical win rates for every first-round and second-round matchup in this year's bracket (e.g., 5v12 upsets occur ~35% of the time historically — which specific 12-seeds this year fit the profile?)
> Conference performance trends — which conferences are historically overseeded or underseeded? Which conferences' teams tend to overperform or underperform their seed in the tournament?
> Cinderella indicators — what statistical and profile characteristics do teams share that have made surprise Final Four or Elite Eight runs as 7-seeds or worse? (e.g., strong defense, experienced roster, mid-major with a dominant player)
> Blue blood / big brand upset vulnerability — identify historically when top-seeded power conference teams are most likely to lose early (first tournament game in years, roster turnover, coach's first tournament, etc.)
> Coaching tournament records — which coaches in this year's field have strong/weak tournament track records? First-time tournament coaches?
> "Survive and advance" vs. "flame out" profiles — teams that win tight games vs. teams that haven't been tested in close games all season
> Geography and travel — does site location historically matter? Teams playing close to home vs. cross-country
> 
> Apply each trend specifically to the 2026 field. Don't just list historical facts — map them onto this year's teams and matchups.
> Output format: For each region, provide a "Historical Risk Assessment" — which seeds/teams are historically vulnerable, which are historically undervalued, and which matchups have the highest upset probability based on pattern matching.

---

### Agent 4 — The Matchup Specialist
**Role**: Head-to-head style and scheme analysis

**Prompt**:

> You are a basketball tactician and matchup analyst. Your job is to analyze HOW teams play — not just how well — and identify specific matchup advantages and disadvantages in every potential tournament pairing through the Sweet Sixteen.
> For each first-round and projected second-round game, analyze:
> 
> Pace mismatch — what happens when a fast team meets a slow team? Who controls tempo and why?
> Size vs. speed — does one team have a significant frontcourt advantage that the opponent can't counter? Or does a smaller, quicker team have the perimeter advantage to pull bigs out of position?
> 3-point dependency vs. 3-point defense — teams that live and die by the three against elite perimeter defense (high variance = upset risk)
> Press/trap vulnerability — teams with high turnover rates facing teams that force turnovers
> Free throw shooting in context — teams that foul a lot facing teams that make free throws at elite rates (and vice versa — poor FT teams in likely close games)
> Style of play compatibility — which teams play a style that historically gives their opponent's style trouble? (e.g., pack-line defense vs. drive-heavy offense, zone defense vs. poor 3-point shooting)
> Best player matchup — can the favored team's best player be neutralized? Does the underdog have a player who exploits a specific weakness?
> 
> For potential upsets: identify the specific tactical path to victory for the lower seed. It's not enough to say "they could win" — explain HOW they win (e.g., "If Team X can hold tempo below 65 possessions per game and force Team Y into a half-court game, their zone defense neutralizes Y's transition attack").
> Output format: For each projected matchup through the Sweet Sixteen, provide a "Matchup Edge" rating (Strong Favorite / Lean Favorite / Toss-Up / Lean Underdog Upset / Strong Upset Candidate) with the tactical reasoning behind it.

---

### Agent 5 — The Momentum Tracker
**Role**: Recent form, hot streaks, and intangibles

**Prompt**:

> You are a momentum and recency analyst for college basketball. Your job is to assess which teams are peaking at the right time and which are faltering — the kind of trajectory data that raw season stats don't capture.
> For every tournament team, research and report:
> 
> Last 10 games record and margin of victory/defeat — are they trending up or down?
> Conference tournament results — did they win their conference tournament (momentum boost)? Lose early (shaken confidence)? Play extra games (fatigue)?
> Point differential trend — are wins getting more comfortable or tighter? Are losses getting worse?
> Key player hot/cold streaks — is their best player shooting well or in a slump entering the tournament?
> Lineup stability — have they had a consistent rotation, or have injuries/suspensions forced changes they're still adjusting to?
> Quality of recent opponents — a 10-game win streak against weak opponents means less than going 7-3 against ranked teams
> Close game performance — record in games decided by 5 or fewer points. Do they execute in crunch time?
> First-round bye or play-in implications — teams coming off a bye week vs. teams that had to win a play-in game (rust vs. rhythm)
> 
> Assign each team a "Momentum Score" from 1-10 with justification. Flag any team with a major momentum mismatch vs. their seed (e.g., a 3-seed that's lost 4 of their last 6, or an 11-seed on a 12-game win streak).
> Output format: Tiered momentum rankings — "Peaking" (best possible form entering tournament), "Steady" (consistent, no major trend), "Cooling" (declining form, potential vulnerability), "Concerning" (significant late-season struggles).

---

### Agent 6 — The Devil's Advocate
**Role**: Challenge assumptions, stress-test picks, and force rigor

**Prompt**:

> You are a contrarian analyst and debate moderator. You will receive the outputs from five specialist agents (Statistician, Injury Scout, Historian, Matchup Specialist, Momentum Tracker). Your job is NOT to build the bracket — it is to challenge, pressure-test, and poke holes in the consensus before the final bracket is built.
> For each region, do the following:
> 
> Identify where the specialists agree — where 4 or 5 agents point the same direction, flag it as high-confidence
> Identify where the specialists disagree — where agents conflict (e.g., stats say Team A wins but matchup analysis says Team B has the edge), highlight the tension and analyze which factor is more predictive in tournament settings
> Challenge every upset pick — for every upset the agents suggest, ask: "What has to go RIGHT for the underdog AND what has to go WRONG for the favorite?" If the upset requires multiple unlikely things to happen simultaneously, downgrade it
> Challenge every chalk pick — for every game where the higher seed is picked, ask: "Is there a realistic path for the underdog that the agents may have underweighted?"
> Flag groupthink — if all agents are high on a team, ask whether that's because the data genuinely supports it or because public narrative has biased the analysis
> Identify the 2-3 "swing games" per region — the games where the pick could reasonably go either way and where getting it right/wrong cascades through the bracket
> Rate confidence level for each pick — High (85%+), Medium (65-84%), Low (50-64%), Coin Flip (<50%)
> 
> Your output should make the final Bracket Architect's job easier by clearly separating the "locks" from the "judgment calls" and providing the strongest possible argument for BOTH sides of every close call.
> Output format: Region-by-region analysis with a "Confidence Matrix" for every game and a "Key Debates" section highlighting the 3-4 most consequential decisions in the bracket.

---

### Agent 7 — The Bracket Architect
**Role**: Final decision-maker and bracket builder

**Prompt**:

> You are the final decision-maker. You will receive all outputs from the six agents above: statistical profiles, injury reports, historical patterns, matchup analyses, momentum assessments, and the Devil's Advocate's stress-test.
> Your job is to produce the complete 2026 NCAA Tournament bracket, every game from Round of 64 through the National Championship.
> Rules:
> 
> Every pick must have a 1-2 sentence justification citing which agent inputs drove the decision
> Upset picks require stronger justification — at minimum two agents must support an upset, or one agent must provide overwhelming evidence
> Where the Devil's Advocate flagged a "coin flip," make a clear decision anyway but note the uncertainty
> Optimize for expected bracket score, not individual game accuracy — in a bracket pool, picking the right Final Four and Champion is worth far more than getting every first-round game right. Weight your risky picks toward the early rounds and be more conservative in later rounds UNLESS the data strongly supports an unconventional pick
> No emotional or brand-name bias — seed, reputation, and uniform color are not factors. Only data.
> Identify your "highest conviction upset" in each region — the one upset you'd bet on if forced to pick just one
> Identify your "most likely to bust" — the highest-seeded team most likely to exit before the Elite Eight
> 
> Output format:
> 
> Complete bracket, round by round, all 63 games with picks and brief justifications
> Final Four matchups and reasoning
> Championship game pick and reasoning
> National Champion with a confidence rating
> "Bracket Identity Summary" — a 3-sentence description of what makes this bracket distinctive (e.g., "This bracket is bullish on the Big 12, bets against traditional blue bloods with coaching turnover, and rides two mid-major Cinderellas to the Sweet Sixteen")

---

### Execution Order

The pipeline runs in three phases:

**Phase 1** — **Parallel Research**: Agents 1-5 all run simultaneously, each doing independent research with no knowledge of the others' findings. This prevents anchoring bias.

**Phase 2** — **Stress Test**: Agent 6 (Devil's Advocate) receives all five outputs, synthesizes, challenges, and produces the confidence matrix.

**Phase 3** — **Build**: Agent 7 (Bracket Architect) receives everything from Phases 1 and 2 and produces the final bracket.

--- 
---

## Results

### 🏀 2026 March Madness Bracket

**Multi-Agent Analysis:** Statistician · Injury Scout · Historian · Matchup Specialist · Momentum Tracker · Devil's Advocate · Bracket Architect

*Data as of March 18, 2026 — First Four games played: Howard beat UMBC, Texas beat NC State*

---

### 🏆 National Champion: (1) Michigan Wolverines

**Big Ten · Confidence: 72%**

Michigan owns the #1 defense in the nation (opponents shoot 30.2% from 3), a top-8 offense, and the most dominant frontcourt in college basketball with Yaxel Lendeborg, Aday Mara, and Morez Johnson Jr. Their length suffocates teams at the rim, and they play their regional in Chicago — essentially a home game. In the championship, Michigan's two-way dominance overwhelms UConn's elite defense but anemic offense (138th in scoring). The Big Ten hasn't produced a champion since Michigan State in 2000, and this Wolverine team is the most analytically complete squad in the field.

---

### 🏟️ Final Four — Indianapolis, April 4

#### Semifinal 1: (2) UConn *(KenPom #12 · East)* vs (2) Houston *(KenPom #5 · South)*

**Winner: UConn (55%)** — A defensive slugfest in the low 60s. UConn's #11 defense matches Houston's physicality, and Dan Hurley's tournament DNA (2 titles in 4 years) is the tiebreaker. UConn's deeper rotation outlasts Houston in a grind. The risk: UConn's 71.6% free throw shooting (222nd nationally) in a close game. But Hurley's late-game adjustments and Karaban's veteran composure edge it.

#### Semifinal 2: (1) Arizona *(KenPom #3 · West)* vs (1) Michigan *(KenPom #2 · Midwest)*

**Winner: Michigan (55%)** — The real title game. Both teams are fully healthy with elite two-way profiles. Michigan's #1 defense holds Arizona's #5 offense in check. Lendeborg (14.4 PPG, 7 RPG, 51% FG) dominates the paint. Cadeau's 38% from deep stretches Arizona just enough. The #1 defense is the tiebreaker in a razor-thin matchup.

#### 🏆 Championship: Michigan vs UConn

**Winner: Michigan (60%)** — UConn's defense is elite, but their 138th-ranked scoring offense is their fatal flaw. Against Michigan's #1 defense, UConn's scoring problems become terminal. Michigan holds UConn under 60 points. Lendeborg, Mara, and Johnson Jr. overwhelm Tarris Reed inside. UConn's 71.6% free throw shooting costs them 4-6 points in a game decided by single digits. Michigan wins 65-58 and captures its first national title since 1989, ending the Big Ten's 26-year drought.

---

### 🚨 Critical Injury Report

*Agent 2: Injury & Availability Scout*

| Severity | Team | Injury | Impact |
|---|---|---|---|
| 🔴 CRITICAL | **Duke** | Caleb Foster OUT (foot surgery). Patrick Ngongba II questionable (foot soreness) | Two starters missing. Duke won ACC title without them, but roster is thinner |
| 🔴 CRITICAL | **Texas Tech** | JT Toppin OUT (torn ACL, Feb 17) | Best player, All-American candidate. Team has lost 3 straight since. Anderson carrying heavy load |
| 🔴 CRITICAL | **North Carolina** | Caleb Wilson OUT (broken thumb) | Star freshman, projected top-5 NBA pick. UNC 0-2 without him, efficiency plummeted |
| 🔴 CRITICAL | **Alabama** | Aden Holloway questionable (arrested, felony marijuana possession) | Team's #2 scorer. Coach Oats preparing to play without him |
| 🟠 HIGH | **Gonzaga** | Braden Huff OUT first weekend (knee, missed 15 games) | Averaging 17.8 PPG before injury. Could return Sweet 16 if Zags advance |
| 🟠 HIGH | **BYU** | Richie Saunders OUT (season-ending knee injury, mid-February) | BYU is 2-4 since he went down |
| 🟡 MODERATE | **Louisville** | Mikel Brown Jr. questionable (back) | 18.2 PPG in 21 games. Dynamic scorer when healthy |
| 🟡 MODERATE | **UCLA** | Tyler Bilodeau questionable (knee strain). Donovan Dent questionable (calf strain) | Two key players banged up |
| 🟡 MODERATE | **Kentucky** | Matt Hodge OUT (torn ACL). Jayden Quaintance OUT (knee) | Two rotation players gone |
| 🟡 MODERATE | **Michigan** | L.J. Cason OUT (torn ACL) | Team hasn't covered since his injury per Yahoo. Depth concern |

---

### 🔵 EAST REGION — Washington, D.C.

**Regional Champion: (2) UConn · Confidence: Medium-High**

#### Round of 64

| Pick | Loser | Conf. | Reasoning |
|---|---|---|---|
| ✅ **(1) Duke** | (16) Siena | 95% | KenPom #1 vs #192. Even down two starters, Cameron Boozer (22.5 PPG, 10.2 RPG) is the best player in the country. Massive talent gap |
| ↑ **(9) TCU** | (8) Ohio State | 52% | TCU's #22 defense can stifle Ohio State. True coin-flip game; 8/9 games go to the lower seed ~48% historically. TCU's defensive identity gives them the edge in a grind |
| ✅ **(5) St. John's** | (12) N. Iowa | 70% | Big East champions under Pitino. St. John's #12 defense is elite. UNI's defense (#24) is strong but their offense (#153) can't keep up |
| ✅ **(4) Kansas** | (13) Cal Baptist | 80% | Self's pedigree and #10 defense. Cal Baptist (#106 KenPom) doesn't have the firepower. Kansas advances but is vulnerable later |
| ↑ **(11) S. Florida** | (6) Louisville | 45% | Brown's back injury is the key factor. Without him, Louisville is 3-6 vs Top 25. USF is KenPom #49 with a balanced profile (#58 O, #48 D) |
| ✅ **(3) Michigan St.** | (14) N. Dakota St. | 85% | KenPom #9, balanced profile (#24 O, #13 D). Tom Izzo in March. NDSU is #113 KenPom |
| ↑ **(10) UCF** | (7) UCLA | 48% | UCLA's double injury (Bilodeau knee, Dent calf) makes this live. UCF's #40 offense exploits a compromised UCLA. A healthy UCLA wins; a hobbled one doesn't |
| ✅ **(2) UConn** | (15) Furman | 90% | UConn KenPom #12 with elite defense (#11). Hurley's pedigree (back-to-back titles 2023-24). Furman is #190 KenPom |

#### Round of 32

| Pick | Loser | Conf. | Reasoning |
|---|---|---|---|
| **(1) Duke** | (9) TCU | 78% | Boozer dominates inside against TCU's physical defense. Duke's #2 KenPom defense limits TCU's modest offense |
| **(4) Kansas** | (5) St. John's | 60% | Battle of elite defenses (#10 vs #12). Self's tournament experience and a potentially healthy Peterson tips the balance. Close — this is a swing pick |
| **(3) Michigan St.** | (11) S. Florida | 75% | Izzo's Spartans have the two-way profile to handle USF. Michigan State's frontcourt is significantly bigger and more talented |
| **(2) UConn** | (10) UCF | 80% | UConn's defensive intensity and tournament DNA overwhelm UCF. Hurley's team raises its level in March |

#### Sweet 16 & Elite Eight

| Round | Pick | Loser | Conf. | Reasoning |
|---|---|---|---|---|
| Sweet 16 | **(1) Duke** | (4) Kansas | 65% | Boozer vs Kansas's interior defense is the matchup of the round. Duke's talent advantage prevails, especially if Ngongba returns |
| Sweet 16 | **(2) UConn** | (3) Michigan St. | 58% | Toss-up game. UConn's #11 defense edges Michigan State's #13. Hurley's championship experience is the tiebreaker. Izzo's teams tend to peak in the S16 but often fall in the E8 |
| **Elite 8** | **(2) UConn** | (1) Duke | 58% | Duke's 7-man rotation finally breaks against UConn's depth and defensive intensity. Hurley doubles Boozer and dares Duke's supporting cast to shoot — they've hit just 26.9% from 3 in Q1/Q2 with Cayden/Ngongba. UConn's deeper rotation grinds Duke down over 40 minutes |

**East Region Champion: (2) UConn**

---

### 🟠 WEST REGION — San Jose, CA

**Regional Champion: (1) Arizona · Confidence: High**

#### Round of 64

| Pick | Loser | Conf. | Reasoning |
|---|---|---|---|
| ✅ **(1) Arizona** | (16) LIU | 98% | KenPom #3 vs #216. Arizona won the Big 12 tournament and is healthy |
| ↑ **(9) Utah State** | (8) Villanova | 48% | Villanova hasn't been in the tournament since 2022 and lost starter Matt Hodge (ACL). Utah State (#30 KenPom) is more balanced (#28 O, #44 D). Coin flip goes to the healthier team |
| ✅ **(5) Wisconsin** | (12) High Point | 68% | Wisconsin's #11 offense and Greg Gard's defensive system. High Point (#92 KenPom) has a good offense (#66) but poor defense (#161) |
| ✅ **(4) Arkansas** | (13) Hawai'i | 82% | #6 offense nationally, conference tournament champs. Hawai'i (#107) doesn't have the defensive tools |
| ↑ **(11) Texas** | (6) BYU | 45% | BYU is 2-4 since losing Saunders (season-ending knee). Even with Dybantsa, they lack complementary pieces. Texas (#37 KenPom) won a gritty First Four game and has momentum, plus a #13 offense |
| ✅ **(3) Gonzaga** | (14) Kennesaw St. | 85% | Gonzaga KenPom #10 even without Huff. Still far superior to Kennesaw State (#163) |
| ✅ **(7) Miami FL** | (10) Missouri | 58% | Miami FL (#31 KenPom) more balanced than Missouri (#52). Two-way profile (#33 O, #38 D) is tighter than Missouri's (#50 O, #77 D) |
| ✅ **(2) Purdue** | (15) Queens | 95% | #2 offense, just won Big Ten tournament. Queens (#181 KenPom) is massively overmatched |

#### Round of 32 → Elite Eight

| Round | Pick | Loser | Conf. | Reasoning |
|---|---|---|---|---|
| R32 | **(1) Arizona** | (9) Utah State | 80% | — |
| R32 | **(4) Arkansas** | (5) Wisconsin | 55% | Arkansas's #6 offense is a nightmare matchup for Wisconsin's slower pace. The Razorbacks have the athletes to break Wisconsin's structure |
| R32 | **(3) Gonzaga** | (11) Texas | 72% | — |
| R32 | **(2) Purdue** | (7) Miami FL | 78% | — |
| Sweet 16 | **(1) Arizona** | (4) Arkansas | 65% | Arizona's #3 defense contains Arkansas's explosive offense. Arizona is elite on both ends; Arkansas is one-dimensional (#52 defense) |
| Sweet 16 | **(2) Purdue** | (3) Gonzaga | 62% | Without Huff, Gonzaga's frontcourt can't match Purdue's. Purdue's #2 offense generates more quality looks. If Huff were healthy, this flips |
| **Elite 8** | **(1) Arizona** | (2) Purdue | 60% | Arizona's two-way dominance (#5 O, #3 D) overwhelms Purdue, whose #36 defense is the weak link. Arizona's length mirrors what Michigan does — and Purdue couldn't handle Michigan's frontcourt in the Big Ten title game either |

**West Region Champion: (1) Arizona**

---

### 🟡 MIDWEST REGION — Chicago, IL

**Regional Champion: (1) Michigan · Confidence: High**

#### Round of 64

| Pick | Loser | Conf. | Reasoning |
|---|---|---|---|
| ✅ **(1) Michigan** | (16) Howard | 97% | Howard won the First Four but KenPom #207 is no match for #2. Michigan's #1 defense will be suffocating |
| ↑ **(9) Saint Louis** | (8) Georgia | 48% | Georgia's #80 defense is a liability. Saint Louis (#41 KenPom) is more balanced (#51 O, #41 D) and plays in St. Louis — home-court advantage |
| ↑ **(12) Akron** ★ | (5) Texas Tech | 42% | **Highest-conviction upset in the bracket.** JT Toppin (torn ACL) was Texas Tech's best player. Since his injury, Tech has lost 3 straight. Akron has won 19 of 20, owns a top-55 KenPom offense, and both teams rely on the 3-ball. Without Toppin, Tech's defensive anchor is gone. ESPN gives this 30%+ upset probability |
| ✅ **(4) Alabama** | (13) Hofstra | 68% | Alabama's #3 offense (91.7 PPG) is overwhelming even without Holloway. But lower confidence than typical 4-13 — Alabama gives up 83.5 PPG and allows 30.4% offensive rebounding |
| ✅ **(6) Tennessee** | (11) SMU | 65% | Tennessee's #15 defense is among the best in the field. SMU (#42 KenPom) is competitive but Tennessee's defensive identity prevails in a low-scoring grind |
| ✅ **(3) Virginia** | (14) Wright State | 85% | Virginia KenPom #13, Wright State #140. Ryan Odom's first year has been impressive. The Cavaliers' trademark defense (#16) shuts down Wright State |
| ↑ **(10) Santa Clara** | (7) Kentucky | 45% | Kentucky is missing Matt Hodge (ACL) and Jayden Quaintance (knee). Santa Clara has a #23-ranked offense and shoots well from deep. Multiple SI experts pick this upset |
| ✅ **(2) Iowa State** | (15) Tennessee St. | 95% | Iowa State KenPom #6 with the #4 defense. Momcilovic and Jefferson lead a battle-tested roster. Tennessee State (#187 KenPom) is massively overmatched |

#### Round of 32 → Elite Eight

| Round | Pick | Loser | Conf. | Reasoning |
|---|---|---|---|---|
| R32 | **(1) Michigan** | (9) Saint Louis | 85% | — |
| R32 | **(4) Alabama** | (12) Akron | 62% | Akron's Cinderella run likely ends here. Alabama's sheer offensive volume (91.7 PPG, #3 offense) is too much, even with defensive concerns. But if Holloway is unavailable AND Akron shoots lights-out, watch out |
| R32 | **(3) Virginia** | (6) Tennessee | 55% | Battle of defensive titans. Virginia's slightly better offense (#27 vs #37) is the tiebreaker in an ugly, low-scoring game |
| R32 | **(2) Iowa State** | (10) Santa Clara | 78% | — |
| Sweet 16 | **(1) Michigan** | (4) Alabama | 75% | Michigan's #1 defense is the antidote to Alabama's chaotic, turnover-prone offense. Bama's #67 defense won't contain Lendeborg and Mara inside. Michigan's length creates havoc |
| Sweet 16 | **(2) Iowa State** | (3) Virginia | 60% | Iowa State's #4 defense matches Virginia's style, but the Cyclones have more offensive weapons. Momcilovic's shooting stretches Virginia. A grinding game that Iowa State's depth eventually wins |
| **Elite 8** | **(1) Michigan** | (2) Iowa State | 62% | Michigan in the United Center (Chicago) — essentially a home game. The Wolverines' frontcourt dominance overwhelms Iowa State's perimeter-oriented attack. Michigan's defensive length forces Iowa State into contested jumpers. Lendeborg feasts inside |

**Midwest Region Champion: (1) Michigan**

---

### 🔴 SOUTH REGION — Houston, TX

**Regional Champion: (2) Houston · Confidence: Medium**

> ⚠️ **Key factor:** The South Regional is played at Houston's Toyota Center. This gives Houston a massive home-court advantage if they reach the Sweet 16 and Elite Eight.

#### Round of 64

| Pick | Loser | Conf. | Reasoning |
|---|---|---|---|
| ✅ **(1) Florida** | (16) Lehigh | 97% | Florida KenPom #4, defending national champions. Not competitive |
| ↑ **(9) Iowa** | (8) Clemson | 48% | Clemson lost Carter Welling to a torn ACL in the ACC tournament. Iowa (#25 KenPom) is more balanced. Clemson's #20 defense is strong but their #71 offense can't generate enough without Welling |
| ✅ **(5) Vanderbilt** | (12) McNeese | 75% | Vanderbilt is massively underseeded — KenPom #11 as a 5-seed. Tyler Tanner (19.1 PPG) leads the #7 offense. Beat Florida by 17 in SEC semis. McNeese leads the nation in points off turnovers (22.3 PPG), but Vandy handles the ball well. The efficiency gap here is more like a 2-seed vs a 10-seed |
| ✅ **(4) Nebraska** | (13) Troy | 80% | Nebraska's #7 defense holds opponents to 30% from 3. This is the program's chance to win its first-ever NCAA Tournament game. Pryce Sandfort (17.9 PPG, 40% from 3) leads a balanced attack. Troy (#143) doesn't have the offensive weapons |
| ↑ **(11) VCU** | (6) N. Carolina | 37% | **Cleanest upset spot in the bracket.** UNC without Caleb Wilson (broken thumb, projected top-5 pick) is a fundamentally different team — 0-2 since the injury with efficiency plummeting. VCU has won 16 of 17, just won the A-10 tournament, features 8 rotation players who can each hit 3s, and gets to the free throw line at the 15th-highest rate nationally. ESPN gives this a 37% upset chance. Terrence Hill Jr. (36.1% from 3 on 5.9 attempts) exploits UNC's #242-ranked 3-point defense |
| ✅ **(3) Illinois** | (14) Penn | 85% | Illinois has the #1 offense in the nation (131.2 adjusted points per 100 possessions). Five players in double figures led by Keaton Wagler (17.9 PPG). Penn won the Ivy title but can't defend at the level needed |
| ✅ **(7) Saint Mary's** | (10) Texas A&M | 55% | Close game. Saint Mary's #18 defense is excellent, and KenPom #24 vs #39 gives them the edge. Both teams play slow, physical basketball |
| ✅ **(2) Houston** | (15) Idaho | 95% | Houston KenPom #5 with the #5 defense. Added Flemings to a roster that returned the core of last year's Final Four team. Idaho (#145) is not competitive |

#### Round of 32 → Elite Eight

| Round | Pick | Loser | Conf. | Reasoning |
|---|---|---|---|---|
| R32 | **(1) Florida** | (9) Iowa | 72% | — |
| R32 | ↑ **(5) Vanderbilt** | (4) Nebraska | 58% | Vanderbilt's #7 offense is too much for Nebraska. The Cornhuskers' elite defense (#7) will make this competitive, but Vanderbilt has the firepower and SEC Tournament momentum. Tanner is the best player on the floor |
| R32 | **(3) Illinois** | (11) VCU | 72% | VCU's Cinderella run ends against the nation's #1 offense. Illinois is too potent offensively for VCU's defense over 40 minutes |
| R32 | **(2) Houston** | (7) Saint Mary's | 75% | — |
| **Sweet 16** | ↑ **(5) Vanderbilt** ★ | (1) Florida | 45% | **Boldest pick in the bracket.** Vanderbilt beat Florida 91-74 in the SEC Tournament semis — a 17-point demolition. The Commodores are KenPom #11 masquerading as a 5-seed. Four seniors starting, Tyler Tanner playing the best ball of his career. Florida lost in the SEC semis and comes in shaken. This isn't a fluke — Vandy is the better team right now |
| Sweet 16 | **(2) Houston** | (3) Illinois | 62% | Houston's #5 defense vs Illinois's #1 offense is the ultimate test. Toyota Center home-court advantage tips the scales. Houston's physicality grinds down Illinois's tempo and forces them into half-court sets where their #28 defense becomes a liability |
| **Elite 8** | **(2) Houston** | (5) Vanderbilt | 60% | Vanderbilt's magical run ends at Toyota Center. Houston's #5 defense makes every Vandy possession a battle, and the home crowd provides the edge on every loose ball and contested rebound. Tanner will score, but Houston's defense and home court are too much in combination |

**South Region Champion: (2) Houston**

---

### 📊 Bracket Identity Summary

**This bracket is built on three pillars:**

1. **Injury-driven decisions at every level.** Teams missing key players (Texas Tech without Toppin, UNC without Wilson, BYU without Saunders, Duke without Foster) are downgraded regardless of seed. Duke's depleted roster is why UConn takes the East — a 7-man rotation shooting 26.9% from three in big games can't survive Houston's #5 defense in the semifinal.

2. **Two-way balance wins in March.** Teams in the top 25 of both KenPom offense and defense are the championship contenders. Michigan, Arizona, Houston, and UConn all qualify. One-dimensional teams (Alabama's offense-only, Nebraska's defense-only) hit ceilings.

3. **Houston's Toyota Center advantage is underpriced.** Playing the Sweet 16 and Elite Eight in your home arena is one of the biggest edges in tournament history. Houston reaches the Final Four partly because of talent and partly because of geography.

---

### 🎯 Key Picks At A Glance

| Category | Pick | Confidence |
|---|---|---|
| National Champion | **(1) Michigan** | 72% |
| Runner-Up | (2) UConn | — |
| Final Four | UConn · Houston · Arizona · Michigan | — |
| Highest-Conviction Upset | (12) Akron over (5) Texas Tech | 58% |
| Best Cinderella | (5) Vanderbilt to Elite Eight | Medium |
| Most Likely to Bust | (6) BYU (lost Saunders, 2-4 since) | High |
| Underseeded Team | Vanderbilt (KenPom #11, seeded 5th) | High |
| Overseeded Team | BYU (KenPom #23, seeded 6th but crippled) | High |
| Sleeper Dark Horse | Iowa State to Elite Eight | Medium |

---

### ⚡ All Upsets Called

| Round | Upset | Key Reason |
|---|---|---|
| R64 | (9) TCU over (8) Ohio State | Coin flip; TCU's #22 defense |
| R64 | (11) South Florida over (6) Louisville | Brown injury; USF #49 KenPom |
| R64 | (10) UCF over (7) UCLA | UCLA double injury (Bilodeau + Dent) |
| R64 | (9) Utah State over (8) Villanova | Villanova rust + Hodge ACL; Utah State more balanced |
| R64 | (11) Texas over (6) BYU | BYU 2-4 since Saunders season-ending injury |
| R64 | (9) Saint Louis over (8) Georgia | Georgia's #80 defense liability |
| R64 | **(12) Akron over (5) Texas Tech** ★ | **Toppin ACL, Tech 3-game losing streak, Akron 19 of 20** |
| R64 | (10) Santa Clara over (7) Kentucky | Kentucky missing Hodge + Quaintance; Santa Clara #23 offense |
| R64 | (9) Iowa over (8) Clemson | Clemson lost Welling (ACL); Iowa more balanced |
| R64 | (11) VCU over (6) North Carolina | Wilson OUT; VCU 16 of 17; ESPN 37% upset chance |
| R32 | (5) Vanderbilt over (4) Nebraska | Vandy's #7 offense overcomes Nebraska |
| **S16** | **(5) Vanderbilt over (1) Florida** ★ | **Beat Florida by 17 in SEC; KenPom #11 as 5-seed** |
| E8 | (2) UConn over (1) Duke | Duke's 7-man rotation breaks vs UConn depth |

---

*Analysis compiled March 18, 2026. Sources: KenPom, ESPN BPI, Barttorvik, CBS Sports, SI, Yahoo Sports, FOX Sports, RotoWire, DraftKings Network, SportsBettingDime, NCAA.com. First Four results included (Howard beat UMBC, Texas beat NC State). Remaining First Four games (Prairie View A&M vs Lehigh, Miami OH vs SMU) pending — bracket assumes Lehigh and SMU advance.*



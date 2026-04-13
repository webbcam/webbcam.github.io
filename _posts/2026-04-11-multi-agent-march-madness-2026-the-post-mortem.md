---
title: "Multi-Agent March Madness 2026: The Post Mortem"
date: 2026-04-11 23:50:47 -0400
categories: []
tags: []
---

48 of 63 games correct. 1,560 ESPN points (81.25%). The multi-agent pipeline called the champion, the runner-up, and 3 of 4 Final Four teams — including Michigan over UConn in the title game.

It wasn't perfect. The bracket also called Akron over Texas Tech as its highest-conviction upset and got blown out by 20. And one buzzer-beater 3 from Alvaro Folgueiras wrecked the entire South region.

Still, this was a strong result. Here's what worked, what didn't, and what I'm changing next year.

───

The numbers at a glance


| Round        | Correct | Accuracy | Points  |
| ------------ | ------- | -------- | ------- |
| Round of 64  | 26/32   | 81.2%    | 26/32   |
| Round of 32  | 11/16   | 68.8%    | 22/32   |
| Sweet 16     | 5/8     | 62.5%    | 20/32   |
| Elite 8      | 3/4     | 75.0%    | 24/32   |
| Final Four   | 2/2     | 100%     | 32/32   |
| Championship | 1/1     | 100%     | 32/32   |
| Total        | 48/63   | 76.2%    | 156/192 |


By region: West was the best (13/15). East was solid (12/15). Midwest called Michigan's path correctly (11/15). South was the disaster (9/15).

───

What the pipeline got right

The big calls. Michigan as champion at 72% confidence. UConn as runner-up. Arizona vs. Michigan in the Final Four. The Duke-over-Florida injury downgrade. The TCU-over-Ohio-State upset. VCU over UNC in OT.

The most consequential correct call: flipping Duke to UConn in the East after the Caleb Foster injury analysis. UConn beat Duke 73-72 on a Braylon Mullins buzzer-beater in the Elite Eight. That was the bracket's smartest call, and it came directly from the injury scout agent doing its job.

The pipeline also landed several quality upset picks:

- TCU over Ohio State
- Iowa over Clemson
- VCU over UNC (OT)
- Texas over BYU
- Utah State over Villanova
- Saint Louis over Georgia

The injury-downgrade framework mostly worked. Every team flagged for missing a key starter underperformed — Louisville being the exception. The framework was right; but in a few cases, the confidence was too high.

───

Five lessons

1. The single-elimination problem is real.
Iowa beating Florida 73-72 on an open corner 3 with 5 seconds left was a coin flip. The Folgueiras shot probably falls 30-40% of the time. The pipeline correctly identified it as a toss-up game and picked Florida anyway. Florida lost. That's not a pipeline failure — that's variance in a 63-game single-elimination tournament. A 76% accuracy rate means roughly 15 games will go the other way, and some of them will cascade.

2. The pipeline's worst pick was its most confident one.
Akron over Texas Tech — the highest-conviction upset — lost by 20 points. The pipeline overweighted the Toppin ACL injury and Akron's late-season hot streak. Texas Tech regrouped and played their best game of the year. The lesson: when the pipeline is more confident than prediction markets on a contrarian pick, that's a signal the Devil's Advocate agent should push back harder. Outlier confidence should require outlier evidence.

3. Geographic advantages are overrated.
Houston losing in Houston killed the "home court matters" hypothesis. Illinois beat Houston 65-55 at the Toyota Center in the Sweet 16. Home court doesn't matter when your offense shoots 27% in the first half. The geographic-edge framework needs a serious rethink next year.

4. Star injuries are partially priced in by tournament time.
Texas Tech without Toppin still won handily. UCLA played their injured players and won. The Vegas market had already adjusted. The injury downgrade magnitude was too aggressive — the direction was right but the degree was wrong.

5. The high-leverage picks are the whole game.

Michigan as champion. UConn over Duke. The Final Four matchups. These were worth far more than getting every first-round game right. A bracket that nails the championship game and 3 of 4 Final Four spots will always score in the top percentile. The early rounds are noise; the multi-agent pipeline worked because it got the big calls right.

Appendix: All 15 incorrect picks

| Round | Region  | Seed | Picked       | Actual          | What happened                                               |
| ----- | ------- | ---- | ------------ | --------------- | ----------------------------------------------------------- |
| R64   | East    | (11) | S. Florida   | (6) Louisville  | Brown injury didn't matter as projected                     |
| R64   | East    | (10) | UCF          | (7) UCLA        | Bilodeau and Dent both played; injury risk overweighted     |
| R64   | South   | (7)  | Saint Mary's | (10) Texas A&M  | A&M outscored SMC 63-50 in a slow grinder                   |
| R64   | West    | (5)  | Wisconsin    | (12) High Point | 12-5 upset the pipeline missed entirely (83-82)             |
| R64   | Midwest | (12) | Akron ★      | (5) Texas Tech  | Highest-conviction upset; lost by 20                        |
| R64   | Midwest | (10) | Santa Clara  | (7) Kentucky    | Kentucky won 89-84 in OT after Oweh's 35-point night        |
| R32   | East    | (4)  | Kansas       | (5) St. John's  | St. John's 67-65; Pitino over Self in a one-possession game |
| R32   | South   | (1)  | Florida      | (9) Iowa        | Folgueiras buzzer-beater; biggest game of the tournament    |
| R32   | South   | (5)  | Vanderbilt   | (4) Nebraska    | Nebraska 74-72 on a layup with 2 seconds left               |
| R32   | West    | (3)  | Gonzaga      | (11)            | Texas                                                       |
| R32   | Midwest | (3)  | Virginia     | (6)             | Tennessee                                                   |
| S16   | South   | (5)  | Vanderbilt ★ | (9) Iowa        | "Boldest pick" never happened — Vandy lost in R32           |
| S16   | South   | (2)  | Houston      | (3)             | Illinois                                                    |
| S16   | Midwest | (2)  | Iowa State   | (6)             | Tennessee                                                   |
| E8    | South   | (2)  | Houston      | (3)             | Illinois                                                    |

★ = highest conviction or boldest pick callout

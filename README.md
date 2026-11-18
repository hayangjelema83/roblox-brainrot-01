# Brainrot Bay

![make.fun](https://make.fun/badge/roblox-brainrot-01.svg)
![rank](https://make.fun/badge/roblox-brainrot-01/hayangjelema83/roblox-brainrot-01/rank.svg)
![reward](https://make.fun/badge/roblox-brainrot-01/hayangjelema83/roblox-brainrot-01/reward.svg)

A 3D brainrot collector for make.fun's "Make the best AI Roblox brainrot game" bounty
(`roblox-brainrot-01`). A tropical bay island where absurd meme characters walk out of a
cave on a conveyor, players buy them, park them on a base, and climb the rarity ladder —
while thieves and tsunamis keep everyone honest.

## The game

- **The conveyor:** every few seconds a brainrot walks out of the Brainrot Cave and
  strolls down the central lane. Walk up, hold the buy prompt, and it walks to your plot.
- **The cast:** 12 brainrots across 6 rarities — Common (Noodle Ned $2/s, Pickle Pete $3/s),
  Rare (DJ Turnip $8/s, Captain Crumb $10/s), Epic (Sir Reginald Toaster $25/s, Disco Duck
  $30/s), Legendary (Professor Bubblegum $70/s, Sardine Samurai $90/s), Mythic (Waffle
  Wizard $200/s, Turbo Turnip Prime $250/s), Secret (The Golden Gondola $600/s, CEO of
  Naps $800/s). Each is built in 3D from Parts driven by the roster data.
- **Mutations:** Golden x2, Diamond x5, Rainbow x10 and Lava x4, rolled on spawn with
  decreasing chances.
- **The loop:** placed brainrots pay their money per second into your cash, once a second,
  server-side. Cash buys rarer brainrots. 8 plots around the island, 6 slots each.
- **Stealing:** steal a brainrot off another player's plot while their lock is down — the
  victim gets an alert. A lock costs $500 and lasts 60 seconds.
- **Rebirth:** at the altar, trade all your cash and brainrots for a permanent x2 income
  multiplier. Each rebirth costs more than the last.
- **Tsunami:** every ~3 minutes the tower flashes a 20-second warning, then a wave sweeps
  the island — uncollected conveyor brainrots wash away and players are knocked back to
  spawn. Hold Shift to run home.

## Structure

- `src/shared/BrainrotConfig.luau` — the roster, rarities, mutations, prices, conveyor constants.
- `src/shared/BrainrotModelBuilder.luau` — builds each brainrot's 3D Part model from its config.
- `src/server/DataService.luau` — player state and leaderstats (Cash, IncomePerSec, Rebirths).
- `src/server/PlotService.luau` — the 8 plots, slot pads, placing and clearing brainrots.
- `src/server/BrainrotSpawner.luau` — conveyor spawning, walking, buying.
- `src/server/MoneyService.luau` — the one-second income payout.
- `src/server/StealService.luau` — stealing and plot locks.
- `src/server/WaveService.luau` — tsunami warning and sweep.
- `src/server/RebirthService.luau` — rebirth at the altar.
- `src/server/init.server.luau` — creates the RemoteEvents and starts every service.
- `src/client/HUDController.client.luau` — cash, $/s, rebirths, wave timer, Lock and Rebirth buttons.
- `src/client/ShopUI.client.luau` — the conveyor shop panel.
- `src/client/Notifications.client.luau` — toast feed for buys, steals and waves.
- `src/client/Game.client.luau` — camera, run key, welcome tip.

## Build and hand in

Build the place with Rojo:

    ~/workspace/make-fun/bin/rojo build default.project.json --output game.rbxl

Run it as the grader does, writing `out/` in place of `/output`:

    mkdir -p out && MAKEFUN_OUTPUT_DIR=out node main.ts

`main.ts` (Node 22, standard library only) copies `game.rbxl`, `src/`, `screenshots/` and
`PLAY.json` to `/output`, leaving out every name that starts with a dot, and writes
`/output/dossier.json` with `vendor/makefun-roblox.ts`, the kit's copy, unchanged.

`screenshots/` holds three images of the game; the first by name is the cover and the
thumbnail uploaded for the game on Roblox. `PLAY.json` is filled in by the account owner
with the published place's ids after publishing on Roblox — the starter's zeros are left
until then. `TOUR.json` maps each screenshot to the keys and server function that reach it.

The rules are on the bounty's page (/bounty/roblox-brainrot-01) and in the kit's RULES.txt.

# O.P.M. Portfolio Dashboard

A self-hosted, zero-backend portfolio tracker for investors running a **covered-call income strategy** alongside long-term accumulation. Everything runs locally in your browser — no account, no login, no server. Your data lives in `localStorage` and can be backed up to your own GitHub repo.

Originally built as a personal tool, it's now fully generic — plug in your own holdings, goal, and milestones on the Dashboard and the whole app adapts.

---

## What's inside

| Page | What it does |
|---|---|
| **Portfolio Dashboard** | Home base. Set your goal + start value, add holdings, view live prices via Finnhub, track premium collected, and see a DTE-sorted action feed for any open options. |
| **Premium Log** | Log every covered call cycle (open / assigned / expired / rolled). Charts premium against per-ticker targets and cumulative progress. |
| **Active Options Tracker** | Full lifecycle tracker for CCs, CSPs, long calls, long puts. Surfaces live ITM / OTM status from Finnhub quotes. |
| **CC Calculator** | Model any covered call — premium, annualized return, break-even, P&L curve, scenarios. Three example presets (low / mid / high cost) or build your own. |
| **Monthly Review** | Month-by-month scorecard. Fills automatically from your portfolio history, premium cycles, and holdings — one click. |
| **Portfolio Roadmap** | Dynamic timeline generated from your milestones. Shows which month targets are achieved, current, or upcoming. |
| **Deployment Planner** | Scratchpad for "where do I put the next $N of cash." |

---

## Quick Start

**1. Clone and open.**
```bash
git clone https://github.com/YOUR_USERNAME/opm-portfolio.git
cd opm-portfolio
```

**macOS:** double-click `launch_dashboard.command` — it starts a local server on port 8765 and opens Chrome. That's it.

**Other OS / manual:**
```bash
python3 -m http.server 8765
# then open http://localhost:8765/portfolio_dashboard.html
```

> Why a local server and not just `file://`? Finnhub CORS and localStorage scoping behave more reliably on `http://localhost`.

**2. Get a free Finnhub API key** (optional but recommended — enables live prices, news sentiment, and the morning digest).
- Sign up at [finnhub.io](https://finnhub.io/) → free tier is 60 API calls/minute, more than enough.
- Paste it into the **Settings** panel on the Dashboard.

**3. Set your goal.**
On the Dashboard, open Settings and enter:
- **Starting portfolio value** — what you had on day one of tracking.
- **Goal value** — where you want to land.
- **Goal date** — the deadline (drives the countdown).

**4. Add your holdings.**
In the Portfolio Editor (same settings panel), add each position:
- Ticker, shares, average cost.
- Tag as `Hold`, `CC Engine`, `OTC`, or `Cash` — this affects which sentiment feeds pull and which bars appear on the CC Engine panel.

**5. Set your milestones** (optional).
Open the milestone editor from the Goal Progress section. Add month labels + dollar targets (e.g. `MAR → $86,600`). These drive the chart, the roadmap page, and the monthly review targets.

**6. You're live.** Log your first premium cycle on the Premium Log page, then fire up the Monthly Review at the end of the month and hit **⚡ Auto-fill from Portfolio**.

---

## Setting CC Targets

The Dashboard's **Covered Call Engine** panel shows per-ticker progress bars. It will auto-infer a target from your logged cycles (premium × contracts × 9 cycles), but you can pin an exact target per ticker by running this in the browser console (F12):

```js
localStorage.setItem('cc_targets', JSON.stringify({
  RKLB: 21600,
  TSLA: 12000,
  // …
}));
```

---

## Optional: GitHub Backup

Your data is in `localStorage`, which is tied to one browser on one machine. To back it up (and sync across devices), you can push snapshots to a private GitHub repo.

**Setup:**
1. Create a private repo (e.g. `opm-data`).
2. Generate a fine-grained PAT with **Contents: read + write** scoped to that repo.
3. In the Dashboard's Settings, paste the PAT and repo slug (`owner/repo`).
4. Click **💾 Backup Now**. Your data lands in `/data/*.json`.

Restore on a new machine: clone the data repo, open the dashboard, click **⬆ Restore from GitHub**.

---

## Optional: Morning Briefing (Claude Routines)

If you're running Claude Code and want a 7:15 AM weekday briefing in the CLI:

```bash
# Creates a scheduled task that reads data/*.json and summarises goal progress + DTE alerts
```

The skill lives at `~/.claude/scheduled-tasks/opm-morning-briefing/` — inspect and customise the cron (`15 7 * * 1-5`) as needed.

---

## Customising

Everything user-facing is driven from `localStorage` keys:

| Key | Shape | Set from |
|---|---|---|
| `goal_settings` | `{ goal, startValue, goalDate }` | Dashboard → Settings |
| `custom_holdings` | `[{ ticker, shares, avgCost, tag }]` | Dashboard → Portfolio Editor |
| `custom_milestones` | `[{ id, label, value, month }]` | Dashboard → Milestone Editor |
| `premium_cycles` | `[{ ticker, strike, premium, contracts, outcome, open, expiry, notes }]` | Premium Log page |
| `options_positions` | `[{ ticker, type, strike, premium, ... }]` | Options Tracker page |
| `monthly_reviews` | `{ jan: {value, premium, ...}, feb: {...} }` | Monthly Review page |
| `cc_targets` | `{ TICKER: totalDollarGoal }` | Browser console |
| `premium_monthly_targets` | `{ feb: 2410, mar: 2400, ... }` | Browser console |
| `accumulation_config` | `{ ticker, monthlyTargets: {feb: 20, mar: 25, ...} }` | Browser console — optional, enables "Share Accumulation" scorecard |
| `finnhub_api_key` | string | Dashboard → Settings |

Everything is editable by hand if you prefer to bulk-import. No database, no schema migrations, no drama.

---

## What this is not

- **Not financial advice.** Just a dashboard.
- **Not a broker integration.** You manually log your cycles and share counts. The upside is nothing touches your brokerage account; the tradeoff is discipline.
- **Not cloud-synced.** Browser localStorage only, plus optional GitHub backup of your choosing.

---

## License / fork freely

Originally built for personal use; generalised so anyone can fork it and track their own portfolio. Rip out anything, rename anything, change the colors — it's all static HTML + vanilla JS, no build step, no framework.

Pull requests welcome if you add something useful (new scorecards, better charts, etc.).

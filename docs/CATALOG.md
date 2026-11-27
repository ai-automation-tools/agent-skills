# Org skill catalog

Every `SKILL.md` in every public, non-archived repo of [`ai-automation-tools`](https://github.com/ai-automation-tools), generated 2026-11-27 by [`scripts/scan-org-skills.py`](../scripts/scan-org-skills.py). Don't edit by hand: rerun it.

**Kinds:** `Core` / `Domain` / `Projects` are this repo's tiers. `portable` = a repo's `skills/` (travels; installable elsewhere). `wired` = `.claude/skills/` (loads only inside that repo; `+ .agents` = also mirrored for Codex and Antigravity). `bundled` = shipped inside app source. **Copies:** `=` the other repo's folder is byte-identical, `≠` it has drifted.

**84 skills** (93 folders) in **8 of 19 repos**. Drifted copies: **3** (`agent-chat-run-triage`, `humanizer`, `recipe-validator`).

## agent-skills (public)

| Skill | Kind | Copies | What it does |
|:---|:---|:---|:---|
| [**agent-workspace-builder**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/core/automation/agent-workspace-builder) | Core | — | Create, adopt, or audit a specialized agent workspace repo, a GitHub repo that gives an AI or CLI agent one field's skills, agents, commands, rules,… |
| [**automated-dev-pipeline**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/core/automation/automated-dev-pipeline) | Core | — | Design, stand up, audit, or operate scheduled AI agents that do development work unattended. |
| [**html-email-templates**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/core/automation/html-email-templates) | Core | — | Three reusable HTML email templates for automated systems, built to survive the email clients that strip your CSS |
| [**task-router**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/core/automation/task-router) | Core | — | Decide how much machinery a request deserves before starting it |
| [**business-plan-builder**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/core/business/business-plan-builder) | Core | — | Take a business idea — a one-line hunch, a napkin pitch, or a finished proposal — and run the whole business-analysis pipeline over it, writing the… |
| [**recipe-validator**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/core/cooking/recipe-validator) | Core | ≠ `ai-automation-recipes` | Validate food recipes for quality and safety. |
| [**repo-docs-builder**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/core/documentation/repo-docs-builder) | Core | — | Build or restructure an entire git repo, project folder, doc library, or Obsidian vault so it is professional and navigable top to bottom |
| [**debugging-methodology**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/core/engineering/debugging-methodology) | Core | — | Debug systematically instead of by guessing |
| [**full-stack-feature**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/core/engineering/full-stack-feature) | Core | — | Use when delivering a feature that crosses layers |
| [**performance-optimization**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/core/engineering/performance-optimization) | Core | — | Make a slow app faster without guessing where the time goes |
| [**testing-strategy**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/core/engineering/testing-strategy) | Core | — | Decide what to test and at which level so the suite catches real regressions without becoming slow and brittle |
| [**news-images**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/core/image-gen/news-images) | Core | — | Generate cartoon-editorial news imagery |
| [**project-hub-scaffold**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/core/web/project-hub-scaffold) | Core | = `project-hub` | Stand up a browsable HTML console over a folder of project documents |
| [**web-house-style**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/core/web/web-house-style) | Core | — | For ai-automation-tools org pages, or pages meant to match them |
| [**api-client-resilience**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/domain/api/api-client-resilience) | Domain | — | Write HTTP clients for third-party APIs that fail predictably instead of hanging |
| [**api-integration-testing**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/domain/api/api-integration-testing) | Domain | — | Test code that calls third-party APIs without hammering live services or writing tests that pass against a fantasy |
| [**api-response-normalization**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/domain/api/api-response-normalization) | Domain | — | Turn heterogeneous API payloads into one consistent envelope that carries its own provenance |
| [**public-api-evaluation**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/domain/api/public-api-evaluation) | Domain | — | Vet a third-party or public API before writing code against it |
| [**rate-limit-and-quota-management**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/domain/api/rate-limit-and-quota-management) | Domain | — | Stay inside a third-party API's rate limits and quotas on purpose rather than by accident |
| [**customer-discovery**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/domain/business/customer-discovery) | Domain | — | Design and run customer interviews that produce evidence instead of encouragement |
| [**go-to-market**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/domain/business/go-to-market) | Domain | — | Plan how a product actually reaches buyers |
| [**pricing-strategy**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/domain/business/pricing-strategy) | Domain | — | Set or change a price with an argument behind it |
| [**captions-and-accessibility**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/domain/media/captions-and-accessibility) | Domain | — | Make media usable by everyone and verify it, rather than assuming it |
| [**media-rights-and-licensing**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/domain/media/media-rights-and-licensing) | Domain | — | Establish that every element in a piece of media is actually cleared to use, and record it, instead of assuming |
| [**post-publish-analytics**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/domain/media/post-publish-analytics) | Domain | — | Read what happened after a piece of media published and turn it into the next decision, instead of vanity-metric theater |
| [**myth-and-motif-analysis**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/domain/religion/myth-and-motif-analysis) | Domain | — | Use when analyzing myths, sacred stories, legends or folktales across cultures, such as finding parallels, tracing a motif, classifying a tale type,… |
| [**religious-calendars**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/domain/religion/religious-calendars) | Domain | — | Use when converting dates between religious calendars and the Gregorian calendar, or when giving the date of a religious holiday, such as Easter… |
| [**writing-about-religion**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/domain/religion/writing-about-religion) | Domain | — | Use when writing anything for a general audience that touches religion, such as an article, explainer, lesson, report, product copy, game or story… |
| [**critical-appraisal**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/domain/science/critical-appraisal) | Domain | — | Appraise a single scientific paper or claim, asking what question it answers, whether the design can answer it, how much bias could explain the… |
| [**research-data-management**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/domain/science/research-data-management) | Domain | — | Plan and run the life of research data so it stays findable, understandable and reusable, applying the FAIR principles, folder and file naming,… |
| [**scientific-figures**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/domain/science/scientific-figures) | Domain | — | Make scientific figures that show the data honestly and read clearly in print and on screen, by choosing the plot for the comparison, showing… |
| [**security-metrics-and-posture**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/domain/security/security-metrics-and-posture) | Domain | — | Measure a security program over time instead of one point in it |
| [**security-report-writing**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/domain/security/security-report-writing) | Domain | — | Turn verified findings into a client-ready security report that gets read and acted on |
| [**vulnerability-disclosure**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/domain/security/vulnerability-disclosure) | Domain | — | Run a coordinated vulnerability disclosure the right way |
| [**cronsole-claude-routines**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/projects/cronsole/cronsole-claude-routines) | Projects | — | Design, create and track a Claude Code cloud routine (now called a scheduled task) |
| [**cronsole-windows-jobs**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/projects/cronsole/cronsole-windows-jobs) | Projects | — | Design, register and verify a Windows Task Scheduler job by picking one of four proven archetypes |
| [**edge-radar-strategy-evidence**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/projects/edge-radar/edge-radar-strategy-evidence) | Projects | — | Decide whether an Edge-Radar betting strategy, sport, parameter or claimed edge is actually supported by outcomes |
| [**edge-radar-strategy-profiles**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/projects/edge-radar/edge-radar-strategy-profiles) | Projects | — | Design, launch, compare and retire an Edge-Radar betting strategy as a `.env.<name>` profile overlay rather than a fork |
| [**edge-spectrum-dataset**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/projects/edge-spectrum/edge-spectrum-dataset) | Projects | — | Change, audit or debug the Edge Spectrum dataset |
| [**edge-spectrum-endpoint**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/projects/edge-spectrum/edge-spectrum-endpoint) | Projects | — | Add, change or debug an Edge Spectrum API endpoint across its two entry points |
| [**edge-spectrum-hub-tool**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/projects/edge-spectrum/edge-spectrum-hub-tool) | Projects | — | Add, change, retire or debug a tool on the Edge Spectrum hub |
| [**edge-spectrum-registry**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/projects/edge-spectrum/edge-spectrum-registry) | Projects | — | Add, change or debug Edge Spectrum's Cronsole templates and the line-archive scripts they run |
| [**project-hub-client**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/projects/project-hub/project-hub-client) | Projects | = `project-hub` | Work on Project Hub's interface |
| [**project-hub-demo**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/projects/project-hub/project-hub-demo) | Projects | = `project-hub` | Work on Project Hub's hosted demo at project-hub-demo.ai-automation-tools.dev |
| [**project-hub-scan**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/projects/project-hub/project-hub-scan) | Projects | = `project-hub` | Change what Project Hub's scanner walks, indexes or serves |
| [**agent-chat-conv-types**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/projects/roundtable/agent-chat-conv-types) | Projects | = `roundtable` | Add or change a conversation format in the Roundtable repo |
| [**agent-chat-delivery**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/projects/roundtable/agent-chat-delivery) | Projects | = `roundtable` | Work on Roundtable's push half |
| [**agent-chat-run-triage**](https://github.com/ai-automation-tools/agent-skills/tree/main/skills/projects/roundtable/agent-chat-run-triage) | Projects | ≠ `roundtable` | Diagnose a live Roundtable conversation that is stuck, silent, ending early, or behaving wrong |

## ai-automation-recipes (public)

| Skill | Kind | Copies | What it does |
|:---|:---|:---|:---|
| [**character-sim**](https://github.com/ai-automation-tools/ai-automation-recipes/tree/main/.claude/skills/character-sim) | wired | — | Speak as a specified character from their current knowledge, voice, and emotional state. |
| [**creative-writing-craft**](https://github.com/ai-automation-tools/ai-automation-recipes/tree/main/.claude/skills/creative-writing-craft) | wired | — | Craft references for writing fiction well |
| [**creative-writing-modes**](https://github.com/ai-automation-tools/ai-automation-recipes/tree/main/.claude/skills/creative-writing-modes) | wired | — | Creative-writing addendum to /llm-writing. |
| [**game-design**](https://github.com/ai-automation-tools/ai-automation-recipes/tree/main/.claude/skills/game-design) | wired | — | Design the game itself — the core loop, the moment-to-moment verbs, how difficulty and reward ramp over a session, and how to pitch it in a brief. |
| [**humanizer**](https://github.com/ai-automation-tools/ai-automation-recipes/tree/main/.claude/skills/humanizer) | wired | ≠ `roundtable` | Remove signs of AI-generated writing from text. |
| [**image-prompt-craft**](https://github.com/ai-automation-tools/ai-automation-recipes/tree/main/.claude/skills/image-prompt-craft) | wired | — | Write image-generation prompts that produce the picture you actually asked for. |
| [**llm-writing**](https://github.com/ai-automation-tools/ai-automation-recipes/tree/main/.claude/skills/llm-writing) | wired | — | Load before writing or revising human-facing text. |
| [**reader-sim**](https://github.com/ai-automation-tools/ai-automation-recipes/tree/main/.claude/skills/reader-sim) | wired | — | Read as a specified first-time reader persona and report the felt experience. |
| [**recipe-validator**](https://github.com/ai-automation-tools/ai-automation-recipes/tree/main/.claude/skills/recipe-validator) | wired | ≠ `agent-skills` | Validate food recipes for quality and safety. |
| [**single-file-game-dev**](https://github.com/ai-automation-tools/ai-automation-recipes/tree/main/.claude/skills/single-file-game-dev) | wired | — | Build a playable game as ONE self-contained `index.html` |
| [**songwriting-craft**](https://github.com/ai-automation-tools/ai-automation-recipes/tree/main/.claude/skills/songwriting-craft) | wired | — | Lyric craft for AI-generated songs |
| [**story-planning**](https://github.com/ai-automation-tools/ai-automation-recipes/tree/main/.claude/skills/story-planning) | wired | — | Planning work before prose |
| [**story-review**](https://github.com/ai-automation-tools/ai-automation-recipes/tree/main/.claude/skills/story-review) | wired | — | Review work after prose exists |
| [**writing-principles**](https://github.com/ai-automation-tools/ai-automation-recipes/tree/main/.claude/skills/writing-principles) | wired | — | What fiction readers want (reader reward channels) and the specific ways LLM training damages them. |

## ai-security-command-center (public)

| Skill | Kind | Copies | What it does |
|:---|:---|:---|:---|
| [**cedar-policy**](https://github.com/ai-automation-tools/ai-security-command-center/tree/main/.claude/skills/cedar-policy) | wired | — | Add, change or debug a Cedar policy in ASCC, together with the schema, registry and fixtures it depends on. |
| [**fail-closed-review**](https://github.com/ai-automation-tools/ai-security-command-center/tree/main/.claude/skills/fail-closed-review) | wired | — | Check a change in ASCC against its security invariants (default deny, fail closed, no secret at rest, zero network, the audit chain, the kill switch,… |
| [**hook-feature**](https://github.com/ai-automation-tools/ai-security-command-center/tree/main/.claude/skills/hook-feature) | wired | — | Add or change a parsed command feature in ASCC's Claude Code hook (the context attributes path_in_repo, network, touches_secret_path,… |
| [**threat-trace**](https://github.com/ai-automation-tools/ai-security-command-center/tree/main/.claude/skills/threat-trace) | wired | — | Tie a change in ASCC to the threat it mitigates, the requirement and ADR behind it and the test that proves it, and record a changed architecture… |

## bot-arena (public)

| Skill | Kind | Copies | What it does |
|:---|:---|:---|:---|
| [**bot-arena**](https://github.com/ai-automation-tools/bot-arena/tree/main/skills/bot-arena) | portable | — | Play chess, Connect Four or tic-tac-toe in a local Bot Arena through its MCP tools (create_match, wait_for_turn, make_move, resign, list_matches,… |

## cronsole (public)

| Skill | Kind | Copies | What it does |
|:---|:---|:---|:---|
| [**cronsole**](https://github.com/ai-automation-tools/cronsole/tree/main/skills/cronsole) | portable | — | Expert knowledge of Cronsole, the unified scheduled-task management system |
| [**source-doctor**](https://github.com/ai-automation-tools/cronsole/tree/main/skills/source-doctor) | portable | — | Run a full test-and-fix session across every Cronsole source (Windows, Cronsole-native, Claude Code, Gemini Triggers, n8n, GitHub Actions, Vercel… |
| [**api-architect**](https://github.com/ai-automation-tools/cronsole/tree/main/.claude/skills/api-architect) | wired | — | Design RESTful and GraphQL APIs with proper resource modeling, versioning, pagination, error handling, and OpenAPI documentation. |
| [**release-engineering**](https://github.com/ai-automation-tools/cronsole/tree/main/.claude/skills/release-engineering) | wired | — | Cut a Cronsole release — semantic versioning across four independently-versioned components on three release trains, prefixed tags, the agent wire… |
| [**connect-pack**](https://github.com/ai-automation-tools/cronsole/tree/main/backend/src/tools/connect-pack) | bundled | — | Create, run, and manage scheduled tasks through a running Cronsole instance |

## edge-radar (public)

| Skill | Kind | Copies | What it does |
|:---|:---|:---|:---|
| [**betting-logic-review**](https://github.com/ai-automation-tools/edge-radar/tree/master/skills/betting-logic-review) | portable | — | Audit Edge-Radar's betting math, risk gates, sizing, sport-specific models, and market-data handling for errors that can lose money, then save a… |
| [**edge-radar**](https://github.com/ai-automation-tools/edge-radar/tree/master/skills/edge-radar) | portable | — | Unified Edge-Radar skill for scanning markets, placing wagers, managing portfolio, settling bets, and researching edge across Kalshi sports and… |
| [**edge-radar-analysis**](https://github.com/ai-automation-tools/edge-radar/tree/master/skills/edge-radar-analysis) | portable | — | Generate a comprehensive post-hoc betting performance report from local Kalshi settlement data. |

## project-hub (public)

| Skill | Kind | Copies | What it does |
|:---|:---|:---|:---|
| [**project-hub-scaffold**](https://github.com/ai-automation-tools/project-hub/tree/main/skills/project-hub-scaffold) | portable | = `agent-skills` | Stand up a browsable HTML console over a folder of project documents |
| [**project-hub-client**](https://github.com/ai-automation-tools/project-hub/tree/main/.claude/skills/project-hub-client) | wired | = `agent-skills` | Work on Project Hub's interface |
| [**project-hub-demo**](https://github.com/ai-automation-tools/project-hub/tree/main/.claude/skills/project-hub-demo) | wired | = `agent-skills` | Work on Project Hub's hosted demo at project-hub-demo.ai-automation-tools.dev |
| [**project-hub-scan**](https://github.com/ai-automation-tools/project-hub/tree/main/.claude/skills/project-hub-scan) | wired | = `agent-skills` | Change what Project Hub's scanner walks, indexes or serves |

## roundtable (public)

| Skill | Kind | Copies | What it does |
|:---|:---|:---|:---|
| [**agent-chat**](https://github.com/ai-automation-tools/roundtable/tree/main/skills/agent-chat) | portable | — | Use when joining a multi-CLI roundtable conversation via the roundtable MCP server. |
| [**battleground**](https://github.com/ai-automation-tools/roundtable/tree/main/skills/battleground) | portable | — | Use when the operator asks you to argue in AgentBattleground |
| [**collaborate-mode**](https://github.com/ai-automation-tools/roundtable/tree/main/skills/collaborate-mode) | portable | — | Use when joining a conversation whose kickoff reports conversation_type "collaborate" |
| [**debate-mode**](https://github.com/ai-automation-tools/roundtable/tree/main/skills/debate-mode) | portable | — | Use when joining a conversation framed as a debate, being asked to argue a position or defend a stance, being assigned a side, or when the kickoff… |
| [**humanizer**](https://github.com/ai-automation-tools/roundtable/tree/main/skills/humanizer) | portable | ≠ `ai-automation-recipes` | Remove signs of AI-generated writing from text. |
| [**podcast-mode**](https://github.com/ai-automation-tools/roundtable/tree/main/skills/podcast-mode) | portable | — | Use when joining a conversation whose kickoff reports conversation_type "podcast" |
| [**start-debate**](https://github.com/ai-automation-tools/roundtable/tree/main/skills/start-debate) | portable | — | Use when the operator asks you to KICK OFF / launch / start / run a new multi-agent debate (as opposed to participating in one). |
| [**agent-chat-add-cli**](https://github.com/ai-automation-tools/roundtable/tree/main/.claude/skills/agent-chat-add-cli) | wired | — | Add support for a new CLI agent (Claude Code / Codex / OpenCode style) to Roundtable from a pasted repo URL. |
| [**agent-chat-conv-types**](https://github.com/ai-automation-tools/roundtable/tree/main/.claude/skills/agent-chat-conv-types) | wired | = `agent-skills` | Add or change a conversation format in the Roundtable repo |
| [**agent-chat-delivery**](https://github.com/ai-automation-tools/roundtable/tree/main/.claude/skills/agent-chat-delivery) | wired | = `agent-skills` | Work on Roundtable's push half |
| [**agent-chat-export-contract**](https://github.com/ai-automation-tools/roundtable/tree/main/.claude/skills/agent-chat-export-contract) | wired | — | Use before changing anything about the Roundtable export bundle |
| [**agent-chat-run-triage**](https://github.com/ai-automation-tools/roundtable/tree/main/.claude/skills/agent-chat-run-triage) | wired | ≠ `agent-skills` | Diagnose a live Roundtable conversation that is stuck, silent, ending early, or behaving wrong |
| [**agent-chat-schema**](https://github.com/ai-automation-tools/roundtable/tree/main/.claude/skills/agent-chat-schema) | wired | — | Use when changing the Roundtable SQLite schema |
| [**agent-chat-web-ui**](https://github.com/ai-automation-tools/roundtable/tree/main/.claude/skills/agent-chat-web-ui) | wired | — | Use when editing the Roundtable web UI |


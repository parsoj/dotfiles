# Warp-Like Claude Code Terminal Interface

## Goal

A terminal-native interface that enables seamless switching between interacting
with Claude Code and running normal terminal commands. Similar to Warp's UX but
open-source and built on existing tools.

### Key Requirements

- Fast switching between AI conversation and shell commands
- Terminal output does NOT automatically enter agent context
- Optional mechanism to pipe specific output into Claude's context
- Works with existing stack: fish shell, Ghostty, skhd
- Prefix symbol or keybind to distinguish AI vs shell input is acceptable

---

## Prior Art Research

### Full Terminal Emulators with Integrated AI

**Wave Terminal** — https://www.waveterm.dev/ (https://github.com/wavetermdev/waveterm)
- Open-source (Apache-2.0), cross-platform (Mac, Linux, Windows)
- Built with Go + Electron. Drag-and-drop "blocks": terminals, AI chat, file previews, web browsers
- Can pipe terminal output directly to an AI block
- BYOK for OpenAI, Claude, Gemini, Azure, local models via Ollama/LM Studio
- Very active, v0.14.1 released March 2026. Polished product
- **Verdict**: Closest open-source analog to Warp. Means switching from Ghostty though

**cmux** — https://www.cmux.dev/ (https://github.com/manaflow-ai/cmux)
- Native macOS terminal built on **libghostty** for GPU-accelerated rendering
- Vertical tabs, split panes, embedded browser, socket API
- Notification rings when agents need attention
- Sidebar shows git branch, PR status, working directory, ports per workspace
- Works with any terminal-based agent (Claude Code, Codex, Aider, Gemini CLI, etc.)
- **Verdict**: Closest to Warp's polish on macOS. Newer project, macOS-only

**Chaterm** — https://chaterm.ai/ (https://github.com/chaterm/Chaterm)
- Open-source (GPL-3.0) AI terminal and SSH client
- AI agent accepts natural language, smart completion, voice input, MCP support
- **Verdict**: More "command suggestion" than true conversational split

**warp-clone** — https://github.com/mycosavant/warp-clone
- Rust-based attempt to replicate Warp. `?` prefix for help, `??` for error explanations
- **Verdict**: Early/experimental, not yet usable

### Unified Frontend TUIs for Multiple AI Agents

**Toad** — https://github.com/batrachianai/toad
- By Will McGugan (creator of Rich/Textual for Python)
- Unified front-end for 12+ AI coding agents via Agent Communication Protocol (ACP)
- **Integrates a fully working shell** with full-color output, interactive commands, tab completion
- You interleave AI prompts with regular terminal commands in the same session
- Jupyter-inspired: navigate previous blocks, reuse, copy, export as SVG
- McGugan uses it as daily driver, hopes to make it full-time work in 2026
- **Verdict**: Most explicitly solving the "seamless switching" problem. Still early but promising

**Agent Deck** — https://github.com/asheshgoplani/agent-deck
- Go + Bubble Tea TUI on tmux. Smart status detection, session forking with context inheritance
- MCP management, global search across conversations, socket pooling (85-90% memory reduction)
- **Verdict**: Management layer for multiple agents, not a hybrid shell/AI interface

**Claude Squad** — https://github.com/smtg-ai/claude-squad
- Go TUI managing multiple agents in isolated tmux sessions + git worktrees
- Auto-accept/yolo mode for background tasks. Install via `brew install claude-squad`
- **Verdict**: Session manager, not a hybrid shell/AI

**NTM (Named Tmux Manager)** — https://github.com/Dicklesworthstone/ntm
- Go CLI transforming tmux into multi-agent command center
- Spawn, tile, coordinate Claude/Codex/Gemini in tmux panes
- Broadcast prompts, context limit detection/recovery, pane output copying with regex
- **Verdict**: Power-user coordination layer, not shell/AI hybrid

**Agent of Empires** — https://github.com/njbrake/agent-of-empires
- Rust-based session manager on tmux. Parallel agents across git worktrees
- Optional Docker sandboxing, auto status detection
- **Verdict**: Session manager, not hybrid interface

### AI Assistants Inside Terminal Multiplexers

**TmuxAI** — https://tmuxai.dev/ (https://github.com/alvinunreal/tmuxai)
- Go TUI running as a tmux pane, **observes all other panes in real-time**
- Reads displayed content, understands context from SSH, DB CLIs, logs
- Chat in dedicated "Chat Pane", executes in dedicated "Exec Pane"
- Modes: Observe (default), Prepare (tracks commands), Watch (proactive suggestions)
- Works with any shell, nested sessions, even network equipment CLIs
- **Verdict**: Very relevant. Closest to "optionally share terminal output with AI" requirement

**ShellSage** — https://github.com/AnswerDotAI/shell_sage
- By Answer.AI (Jeremy Howard's lab). Python CLI using tmux `capture-pane`
- Pipe output: `cat error.log | ssage explain this`
- Target specific panes: `ssage --pid %3 what is happening here?`
- **Verdict**: Explicit invocation model, good tmux context awareness

**Claude Code Bridge** — https://github.com/bfly123/claude_code_bridge
- Split-pane terminal (WezTerm/tmux) with panes for Claude, Codex, Gemini
- 50-200 tokens per inter-agent call vs 5,000-20,000 traditional
- **Verdict**: Multi-agent orchestration, not shell/AI hybrid

**Microsoft AI Shell** — https://github.com/PowerShell/AIShell
- Official Microsoft project. AI in side pane next to PowerShell 7
- Rich pane communication, pipeline integration
- Now supports macOS via iTerm2
- **Verdict**: Exactly this workflow by design. PowerShell-centric though

### Terminal-Based AI Coding Agents with Shell Access

**Aider** — https://aider.chat/ (https://github.com/Aider-AI/aider)
- AI pair programming in terminal. Git-native. `/run` executes shell commands
- Multiline mode, editor integration, vi/emacs keybindings
- **Verdict**: You're "in aider's world" rather than in your shell with AI alongside

**gptme** — https://gptme.org/ (https://github.com/gptme/gptme)
- Personal AI agent with shell, code, file, web, vision tools
- Plugin system, REST API, web UI. One of the first agent CLIs (2023)
- **Verdict**: Agent REPL, not shell hybrid

### Shell-Level AI Integrations (Inline)

**fish-ai** — https://github.com/Realiserad/fish-ai
- **Fish-native** Fisher plugin with Python backend
- `Ctrl+P`: convert `# comment` to command (or command to explanation)
- `Ctrl+Space`: fzf completions powered by LLM, or fix failed commands
- LLM-agnostic: Anthropic, OpenAI, Cohere, DeepSeek, Groq, Google, self-hosted
- ~2000 lines, zero telemetry
- **Verdict**: Zero-friction inline AI in existing fish. Limited to command generation though, not conversational

**Butterfish** — https://github.com/bakks/butterfish
- Go shell wrapper. Capital letter = AI prompt, lowercase = normal command
- AI sees shell history. `!` prefix = goal mode (agent). `!!` = unsafe goal mode
- Tab-based LLM autosuggestion
- **Verdict**: Best seamless switching design. **No fish support** (bash/zsh only)

**Shell-GPT (sgpt)** — https://github.com/TheR1D/shell_gpt
- Python CLI. `Ctrl+L` hotkey replaces input with AI-suggested command
- Chat mode, custom functions, piping support
- **Verdict**: Moderate integration, invoked as command rather than transparent wrapper

**claude-esp** — https://github.com/phiat/claude-esp
- Go TUI streaming Claude Code's hidden output (thinking, tool calls, subagents)
  to a separate terminal in real-time
- Uses filesystem notifications to watch session files
- **Verdict**: Useful companion tool for observing Claude Code activity

### Claude Code's Built-in tmux Integration

- Agent Teams supports tmux and iTerm2 for split-pane mode
- `claude --worktree --tmux` for isolated parallel agents
- Zellij support requested: https://github.com/anthropics/claude-code/issues/24122
- tmux popup pattern: https://www.devas.life/how-to-run-claude-code-in-a-tmux-popup-window-with-persistent-sessions/

---

## Building Blocks Available

### Claude Code CLI Modes

| Mode | Command | Use Case |
|---|---|---|
| Interactive | `claude` | Normal conversational use |
| Non-interactive | `claude -p "message"` | Scripted/headless |
| Streaming JSON | `claude -p "msg" --output-format stream-json` | Real-time structured output |
| Resume session | `claude -p "msg" --resume $session_id` | Multi-turn from scripts |
| Continue last | `claude -p "msg" --continue` | Continue previous session |
| System prompt | `claude -p "msg" --append-system-prompt "..."` | Custom instructions |

### Claude Code Hooks (Context Injection)

- `UserPromptSubmit` hook stdout gets added to Claude's context alongside the prompt
- `SessionStart` hook can inject dynamic context at session start
- `PreToolUse` hooks can modify tool inputs before execution
- `PostToolUse` hooks can append `additionalContext` to tool results
- Hooks configured in `~/.claude/settings.json` or `.claude/settings.json`

### Claude Agent SDK

- **TypeScript**: `query()` for one-shot, async generator for streaming
- **Python**: `query()` for stateless, `ClaudeSDKClient` for stateful multi-turn
- **V2 Preview (TS)**: `createSession()` -> `send()` -> `stream()` pattern
- Custom tools via `@tool` decorator (Python) or SDK MCP server

### Terminal Multiplexer Primitives

**tmux:**
- `tmux capture-pane -t %42 -p` — capture visible pane content to stdout
- `tmux pipe-pane -t %42 'command'` — stream new output to a command
- `tmux send-keys -t %42 'command' Enter` — send input to a pane
- `tmux display-popup` — overlay popup with persistent session

**Zellij:**
- `zellij action new-pane --name "name" -- command args` — create panes
- `zellij action write-chars "text"` — write to focused pane
- `zellij action write 13` — send Enter key
- `zellij action focus-next-pane` — switch focus
- WASM plugin system with `pipe_message_to_plugin()` for inter-pane communication

---

## Design Options

### Option A: tmux/zellij Popup + Fish Functions (Minimal Effort)

**Effort**: ~1 hour | **Seamlessness**: Good | **Stack fit**: Perfect

```
+---------------------------------------+
|  Ghostty (full screen)                |
|  +-----------------------------------+|
|  |  tmux session                     ||
|  |  +-------------------------------+||
|  |  |  fish shell (main pane)       |||
|  |  |  $ normal commands here       |||
|  |  |                               |||
|  |  |  [hotkey] -> popup overlay    |||
|  |  |  +-------------------------+  |||
|  |  |  |  claude --resume        |  |||
|  |  |  |  (persistent session)   |  |||
|  |  |  +-------------------------+  |||
|  |  +-------------------------------+||
|  +-----------------------------------+|
+---------------------------------------+
```

**How it works:**
- tmux keybind (or skhd) toggles a Claude Code popup overlay
- Claude session persists across popup open/close
- Terminal output stays in shell by default (no auto-context)

**Fish functions to build:**
- `cc_toggle` — toggle the tmux Claude popup
- `cc_send <message>` — send a one-shot message to Claude via `claude -p --continue`
- `cc_pipe` — capture current pane content and send to Claude as context
- `cc_last` — send last command's stdout to Claude for analysis

**Context sharing (opt-in only):**
```fish
# Pipe last command output to Claude
function cc_last
    set -l output (tmux capture-pane -p -S -50)
    claude -p --continue "Here is recent terminal output:\n$output\n\nAnalyze this."
end

# Or pipe specific command output
function cc_run
    set -l cmd (string join " " $argv)
    set -l output (eval $cmd 2>&1)
    echo $output
    claude -p --continue "Output of '$cmd':\n$output"
end
```

### Option B: Fish `>` Prefix Wrapper (Moderate Effort)

**Effort**: ~1 day | **Seamlessness**: Excellent | **Stack fit**: Perfect

```
+-------------------------------------+
|  Single terminal                    |
|                                     |
|  $ ls -la              <- shell cmd |
|  > explain this error  <- to Claude |
|  $ git status          <- shell cmd |
|  > fix the test        <- to Claude |
|  >+ (include output)   <- Claude    |
|     with last cmd output as context |
+-------------------------------------+
```

**How it works:**
- Fish `commandline` function + key binding intercepts input before execution
- `>` prefix routes to Claude Code via `claude -p --continue`
- `>+` prefix means "include last command's stdout in the prompt"
- `>>` prefix could mean "start new Claude session"
- Everything else goes to fish normally
- Claude's response prints inline, then you're back in your prompt

**Implementation approach:**
```fish
# In fish config or as a plugin
function __claude_intercept --on-event fish_preexec
    set -l cmd $argv[1]

    if string match -q '>+*' $cmd
        # Include last command output
        set -l prompt (string sub -s 3 $cmd)
        set -l last_output (eval $__fish_last_command 2>&1 | head -200)
        claude -p --continue "Terminal output:\n$last_output\n\n$prompt"
        return 1  # prevent fish from executing
    else if string match -q '>*' $cmd
        # Just send to Claude
        set -l prompt (string sub -s 2 $cmd)
        claude -p --continue "$prompt"
        return 1
    end
end
```

**Advantages:**
- Single interface, no pane switching
- You never leave your shell
- Context is opt-in per-message
- Fish completions still work for normal commands
- Session persists via `--continue`

**Disadvantages:**
- Claude's streaming TUI doesn't render (you get plain text via `-p`)
- No interactive Claude features (tool approval, etc.)
- Need to handle session management (new session, resume specific, etc.)

### Option C: Zellij WASM Plugin (Ambitious)

**Effort**: ~1 week+ | **Seamlessness**: Best | **Stack fit**: Good (requires Zellij)

```
+-------------------------------------+
|  Zellij                             |
|  +-------------------------------+  |
|  |  Shell pane (fish)            |  |
|  |  $ commands here              |  |
|  +-------------------------------+  |
|  |  Claude pane (plugin-managed) |  |
|  |  Streaming response...        |  |
|  +-------------------------------+  |
|  |  Input bar (plugin UI)        |  |
|  |  [Tab] switch mode | >_ ...   |  |
|  +-------------------------------+  |
+-------------------------------------+
```

**How it works:**
- Rust WASM plugin manages both a shell pane and a Claude pane
- Unified input bar at the bottom, `Tab` toggles shell vs Claude mode
- Plugin uses `pipe_message_to_plugin` to capture shell output
- Plugin can forward shell output to Claude pane on demand
- Zellij `action` CLI handles pane creation and text injection

**Advantages:**
- Deeply integrated, true unified experience
- Full Claude Code interactive mode (tool approval, etc.)
- Plugin can add visual indicators (which mode you're in, Claude status)

**Disadvantages:**
- Significant engineering effort
- Zellij plugin API has limitations (can't embed PTYs directly)
- WASM sandbox adds complexity
- Requires switching from tmux to Zellij (or using both)

### Option D: Try Toad (Minimal Effort)

**Effort**: 10 minutes | **Seamlessness**: Unknown | **Stack fit**: Maybe

- Install Toad: `pip install toad-terminal` (or similar)
- It already integrates a working shell + AI conversation via ACP
- Supports Claude Code as a backend agent
- Works with any shell including fish

**Advantages:**
- Already exists, actively developed by Will McGugan
- Solves the exact problem statement

**Disadvantages:**
- Still early, may have rough edges
- Replaces Ghostty as your terminal (or runs inside it)
- Dependent on ACP protocol support from Claude Code

---

## Recommendation

### Phase 1: Option A (tmux popup + fish functions)
- Immediate, ~1 hour of setup
- Gets 80% of the Warp-like experience
- Zero new dependencies beyond tmux
- Key insight: tmux popup gives instant keyboard-driven switching;
  fish functions give opt-in "pipe output to Claude"

### Phase 2: Option B (fish `>` prefix wrapper)
- If Option A feels too disconnected (two separate UIs)
- Build a fish plugin that routes `>` prefixed input to Claude
- Single interface, never leave your shell
- Trade-off: lose Claude Code's interactive TUI (tool approval, streaming render)

### Phase 3: Evaluate Toad
- Keep an eye on Toad's development
- If it matures and supports Claude Code well via ACP,
  it could replace the custom solution entirely

### Not Recommended (for now)
- Option C (Zellij plugin): Too much effort for uncertain benefit
- Switching to Wave Terminal or cmux: Means abandoning Ghostty

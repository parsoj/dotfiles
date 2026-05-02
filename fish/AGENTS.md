# Fish configuration — conventions for agents and humans

This directory holds Jeff's fish shell configuration. The `functions/` tree
follows a **feature/role** convention that is load-bearing: tooling depends on
folder names, not just filenames. Read this whole document before adding or
moving fish functions here.

## 1. Mental model

Every interactive shell utility decomposes into three roles:

- **Producer** — pure function that emits candidates to stdout, one per line.
  No UI, no prompting, no side effects. Easy to test, compose, and call from
  other tools (including non-fish ones like a Raycast extension).
- **Action** — takes a single candidate (typically as `$argv[1]` or stdin) and
  performs a side effect: open a file, switch a context, send a request, etc.
- **Flow** — terminal entry point a human types at a prompt. Composes a
  producer + an interactive selector (usually `fzf`) + an action. `fzf`
  lives only inside flows; producers and actions are selector-agnostic.

The **api layer** is producers + actions — selector-agnostic, callable by
any frontend. The **cli layer** is flows — what a human types.

Keeping these separate means the same producer/action pair can be driven by
`fzf` from a terminal *or* by a Raycast `<List>` extension that shells out to
`fish -c "<producer>"` and `fish -c "<action> <choice>"`. Don't put fzf or
prompts inside producers or actions.

## 2. Folder structure

```
~/.config/fish/
    config.fish             # registers every functions/**/  on $fish_function_path
    conf.d/                 # vendor + plugin init only — do NOT add custom code here
    completions/            # standard fish completions location
    functions/
        _lib/               # internal helpers — do not call directly from prompts
            _lib_role.fish
            _lib_meta.fish
        shared/             # cross-feature, user-callable utilities
            producers/      # list all producers/actions/flows
            actions/        # generic actions (notify, copy, open_in_editor, …)
            flows/          # cross-feature flows (e.g. "select anything")
        <feature>/
            producers/      # *_list, *_search, *_candidates
            actions/        # *_open, *_archive, *_set, *_send, …
            flows/          # the bare feature verb (e.g. `repo`, `proj`)
        <plugin-managed flat files>   # __fzf_*, _nvm_*, fisher.fish, etc.
                                       # leave these alone, plugins own them
```

**Hard rules:**

- Every `.fish` file must define a function whose name matches its basename.
  Fish autoload depends on this.
- Every directory under `functions/` is registered on `$fish_function_path` by
  the recursive glob in `config.fish`. There is no per-folder import; fish
  sees one global function namespace regardless of nesting.
- Function names are globally unique. Use the feature name as a prefix
  (`repo_list`, not `list`) to prevent collisions.
- The `_lib_` prefix means "internal — don't call from a prompt." It's social,
  not enforced; fish will happily run any function regardless.

**Why feature/role and not role/feature:**

The axis you iterate on most often goes on top. Today, working on one feature
at a time is more common than operating on "all actions" wholesale. If that
ever flips (lots of cross-feature actions, lots of role-keyed grepping), the
inversion is a mechanical migration — `_lib_role`, `_lib_meta`, and all
function names stay valid. See section 9.

## 3. Naming conventions

Folder placement is the source of truth for role. Filenames follow
`<subject>_<role-or-verb>` consistently — **subject first, role/verb last**.
This makes tab completion group by subject (`workspace_<TAB>` shows
everything related to workspaces) and reinforces the feature/role folder
structure.

| Role     | Folder       | Filename shape                              | Examples                          |
|----------|--------------|---------------------------------------------|-----------------------------------|
| producer | `producers/` | `<subject>_list` (or `_search`, `_candidates`) | `repo_list`, `workspace_list`, `k8s_namespace_list` |
| producer | `producers/` | `<subject>` for single-value queries        | `workspace_root`                  |
| action   | `actions/`   | `<subject>_<verb>`                          | `repo_open`, `workspace_clean`, `aws_profile_set`, `k8s_namespace_set` |
| flow     | `flows/`     | open-ended; English-friendly is fine        | `con`, `kns`, `pg_connect`, `open_workspace`, `cd_workspace_directory` |
| internal | `_lib/`      | `_lib_*` prefix                             | `_lib_role`, `_lib_meta`, `_lib_terminal_window` |

**Hard rules:**

- **Underscores throughout. No hyphens.** Fish accepts hyphens in function
  names but they're a typing hazard and inconsistent with the codebase.
- **For actions, verb goes last.** `aws_profile_set`, not `set_aws_profile`
  or `aws_set_profile`. Subject (potentially compound) first; verb last.
- **For producers emitting lists, `_list` is the convention** even if
  more specific words exist. `repo_list`, not `repos`. Single-value
  producers (e.g. `workspace_root`) drop the `_list` suffix.
- **Flows are exempt** from the subject-first rule — they're human entry
  points and English readability wins. `open_workspace` reads naturally;
  `workspace_open` does not. Flows can also be idiomatic short aliases
  (`gm`, `gs`, `cc`, `kns`, `ax`, `rr`).
- **The role suffix is a hint, not the type tag.** The folder is the type
  tag. Don't classify a function by suffix regex.

## 4. Metadata DSL

Beyond the folder (= role), structured metadata lives in `# @<key> <value>`
header comments above the `function` line. These are inert comments that any
caller can read via `_lib_meta`. Add new keys as needed.

```fish
# @cache       60s
# @destructive yes
# @inputs      path:string
function repo_archive --argument-names path --description "archive a repo"
    ...
end
```

Conventional keys (extend as needed; no enforcement):

- `@cache <duration>` — producer output may be cached for this long.
- `@destructive yes|no` — action mutates remote/shared state; flows should
  confirm before invoking.
- `@inputs <name>:<type>, ...` — action's expected argv shape (documentation).
- `@runs-in <terminal|background|window>` — where this action expects to
  run. See § 7.1.
- `@raycast yes` (and the `@raycast-*` family) — opt a flow into the
  Raycast extension. See § 7.3.

## 5. Query helpers

Three filesystem-walking listers (themselves producers, living in
`shared/producers/`):

```fish
producers   # echoes every name in functions/*/producers/*.fish
actions     # echoes every name in functions/*/actions/*.fish
flows       # echoes every name in functions/*/flows/*.fish
```

Two metadata accessors (in `_lib/`):

```fish
_lib_role <fn>           # returns the role (parent-folder name) of a loaded fn
_lib_meta <fn> <key>     # returns the value of `# @<key> ...` from fn's file
```

`_lib_role` only works for currently-loaded functions (it uses
`functions --details`). `producers`/`actions`/`flows` walk the filesystem and
return everything regardless of load state — use those for "operate on every
X" loops.

Examples:

```fish
# wrap every action with a toast on completion
for fn in (actions)
    # … your wrapper logic …
end

# only act on destructive actions
for fn in (actions)
    test (_lib_meta $fn destructive) = yes; and echo $fn
end

# what role is this function?
_lib_role repo_open   # → "actions"
```

## 6. Adding a new feature — checklist

1. `mkdir -p functions/<feature>/{producers,actions,flows}`
2. Write the producer first. It must:
   - Take no input, or take a single optional filter arg.
   - Emit one candidate per line on stdout.
   - Be free of prompts, fzf, and side effects.
3. Write each action. It must:
   - Take its candidate as `$argv[1]` (or read stdin for free-form input).
   - Use `--argument-names` to document the calling shape.
   - Add `# @destructive yes` if it mutates shared state.
4. Write the flow last. It composes producer + `fzf` + action. Bare verb
   names the file (e.g. `flows/repo.fish` defines `function repo`).
5. (Optional) Mirror the api in the Raycast extension at
   `~/code/workspaces/raycast/<ext>/src/<feature>.tsx` — render `<List>`
   from the producer, run actions on Enter.

The flow is terminal-only; the Raycast extension never calls it. Both
frontends call the same producer + action pair.

## 7. Raycast layer (brief)

The Raycast TypeScript extension is a separate code project at
`~/code/workspaces/raycast/odd-bits/raycast/fish-flows/` (a sibling of this
config tree, not part of it). It:

- Lists candidates by running `fish -c "<producer>"` and parsing stdout.
- Runs the chosen action via `fish -c "<action> <args…>"`.
- Never invokes flows (they assume a tty for fzf and would hang in Raycast).

State that lives in your shell (cwd, exported env vars) cannot cross the
Raycast boundary. Actions that `cd` or modify the parent shell are
terminal-only by definition.

### 7.1 Action portability — `@runs-in`

Actions fall into three categories, marked with the `@runs-in` metadata
header so frontends know how to invoke them:

| `@runs-in`   | Meaning                                                     | Examples                                  |
|--------------|-------------------------------------------------------------|-------------------------------------------|
| `background` | Spawns a process detached from any tty. Runs anywhere.      | `chrome_open`, `clipboard_set`, API calls |
| `terminal`   | Needs a tty.                                                | `config_open` (nvim), `htop`, `less`      |
| `window`     | Spawns its own GUI window of some kind. Runs anywhere.      | `cursor_open`, future `claude_desktop_in` |

**There is one action per behavior**, not one per frontend. Frontends decide
how to invoke based on `@runs-in`:

- **Terminal frontend** (fish flows): always invokes the action directly —
  the user already has a tty, so no wrapping is needed.
- **Raycast frontend** (TSX): invokes `background` and `window` actions
  directly. For `@runs-in terminal` actions, wraps via
  `_lib_terminal_window <action> <args>` so the action runs in a freshly
  spawned terminal window.

Rules:

- Actions do **one thing**. Don't add context-detection (`if Raycast …`)
  inside an action — that conflates "what" with "where." If two contexts
  legitimately want different behavior (e.g. claude TUI vs claude desktop
  app), make them separate, named actions.
- Don't create per-frontend variants of the same action (no
  `config_open_in_window` next to `config_open`). Wrapping is a frontend
  concern; do it at the call site.

### 7.2 The `_lib_terminal_window` interface

`_lib/_lib_terminal_window` is the primitive for "open a new terminal
window running this command." It's an **interface** that dispatches to a
configurable **adapter**:

```
$FISH_TERMINAL=ghostty   →   _lib_terminal_window_ghostty
$FISH_TERMINAL=iterm     →   _lib_terminal_window_iterm     (not yet implemented)
```

The default `$FISH_TERMINAL=ghostty` is set in `config.fish`. To add a new
terminal app, drop a sibling function `_lib_terminal_window_<name>` in
`_lib/`. The dispatcher discovers it automatically. No core changes.

Usage:

```fish
_lib_terminal_window nvim /path/to/file
_lib_terminal_window htop
_lib_terminal_window fish -c 'long_command --with --args'
```

Argument shape: command name first, then its args. The adapter is
responsible for shell-safe quoting when handing the command to the OS.

This is the primitive frontends use to wrap `@runs-in terminal` actions
when they need to spawn a terminal first. Example: a Raycast TSX command
running a terminal-class fish action shells out as

```ts
fish -c "_lib_terminal_window config_open '<path>'"
```

The fish process started by Raycast loads `config.fish` (which sets
`$FISH_TERMINAL`), `_lib_terminal_window` dispatches to the configured
adapter, and the adapter spawns a new terminal window running
`fish -c 'config_open …'`. That inner fish autoloads `config_open` and
runs it with a real tty. The action itself is unchanged.

### 7.3 Exposing a flow as a Raycast command — the `@raycast-*` headers

The Raycast extension at `~/code/workspaces/raycast/odd-bits/raycast/fish-flows/`
generates its `package.json` `commands[]` and per-command TSX files from
metadata headers on flow files. Each Raycast command corresponds to one
fish flow file marked `# @raycast yes`.

**Headers** (all `# @<key> <value>`, placed above the `function …` line):

| Header                  | Required? | Meaning                                                                                              |
|-------------------------|-----------|------------------------------------------------------------------------------------------------------|
| `@raycast`              | yes       | Set to `yes` to opt this flow into the Raycast extension. Anything else is ignored.                  |
| `@raycast-title`        | yes       | Human-readable title (Title Case). Shown in Raycast root search.                                     |
| `@raycast-description`  | recommended | One-line subtitle in Raycast root search.                                                          |
| `@raycast-producer`     | yes       | Name of the producer fish function that emits candidates (one per line on stdout).                   |
| `@raycast-action`       | yes       | Name of the action fish function that runs on Enter. The action's `@runs-in` decides wrapping.       |
| `@raycast-name`         | optional  | Internal Raycast command slug. Defaults to the flow's filename (e.g. `con` from `con.fish`).         |
| `@raycast-display`      | optional  | `path` shows `basename(item)` as title with full path as subtitle. Default `item` shows the line as-is. |

**Example (`config/flows/con.fish`):**

```fish
# @raycast              yes
# @raycast-title        Open Config File
# @raycast-description  Pick a file under ~/.config and open it
# @raycast-producer     config_list
# @raycast-action       config_open
# @raycast-display      path
function con --description "pick a file under ~/.config and open it in nvim"
    set -l file (config_list | fzf --prompt="~/.config> ")
    test -n "$file"; and config_open $file
end
```

**Workflow to add or remove a Raycast command:**

1. Edit headers on a flow file (add/remove `@raycast yes` and the rest).
2. From the extension folder, run `pnpm generate-fish-flow-commands`.
3. The generator rewrites `package.json` `commands[]`, regenerates
   `src/<name>.tsx`, and removes any orphaned TSX files.
4. If `npm run dev` is running, it hot-reloads automatically.

**What the generator does NOT touch:**

- Any non-`commands[]` field in `package.json` (deps, scripts, name, etc.).
- TSX files for commands that aren't in the discovered set (they're deleted
  if they exist at the top level of `src/`, but anything under `src/lib/`
  or other subdirectories is preserved).
- The fish files themselves.

**What translates cleanly to Raycast and what doesn't:**

| Translates                                                              | Doesn't                                                                              |
|-------------------------------------------------------------------------|--------------------------------------------------------------------------------------|
| Producer + action where the action mutates persistent state (file, kubeconfig, remote API). | Actions that `cd` or modify the parent shell — Raycast can't change your terminal cwd. |
| Producer + `@runs-in terminal` action — wraps via `_lib_terminal_window`. | Actions that export shell env vars (e.g. `set -gx AWS_PROFILE`) — those vanish when the spawned fish process exits. |
| Producer + `@runs-in background` action — runs silently with a HUD blip. | Heavily interactive flows (multiple `read -P` prompts, branching dialogs) — better as terminal-only. |
| Producer + `@runs-in window` action — spawns its own GUI.                | Composition flows that orchestrate multiple producers/actions internally — refactor first. |

## 8. Anti-patterns

- **Don't** classify a function by suffix regex. Action suffixes are
  open-ended (`_open`, `_archive`, `_send`, …). Use `_lib_role` or the
  filesystem listers.
- **Don't** put non-function scripts under `functions/`. Use
  `~/.config/scripts/` or `~/bin/`.
- **Don't** put your own startup code in `conf.d/`. That directory is for
  vendor/plugin init. User-owned startup belongs in `config.fish`.
- **Don't** gate `PATH` setup, env vars, or anything a non-interactive shell
  needs behind `if status is-interactive`. That block does not run for fish
  processes spawned by Raycast/cron/scripts. Only put prompt theming, key
  bindings, abbreviations, and other reader-layer concerns there.
- **Don't** put fzf, `read`, or any prompting inside a producer or action.
  That collapses the api/cli split and breaks the Raycast frontend.
- **Don't** rely on abbreviations inside functions. Abbreviations are a
  reader-layer expansion that only fires in interactive shells; they are
  invisible to scripts and to functions calling them. Always call the real
  command (`git`, not `g`).

## 9. Migration history

The migration into the feature/role layout is **complete**. This section
captures the remaining tidies + history.

### Status

- [x] `config.fish` recursively registers `functions/**/` on
      `$fish_function_path`.
- [x] `_lib/` infrastructure (`_lib_role`, `_lib_meta`,
      `_lib_terminal_window`, `_lib_terminal_window_ghostty`).
- [x] `shared/producers/{producers,actions,flows}.fish` query helpers.
- [x] Every fzf-using function migrated into `<feature>/{producers,actions,flows}/`.
- [x] Every inline function in `config.fish` extracted into a feature
      folder (only `nvm` remains inline; load-order sensitive).
- [x] `workspaces/`, `kubernetes/` flat folders restructured into role
      subfolders.
- [x] `utils/` removed; sole occupant moved to `phone/`.
- [x] Naming convention pass: producers and actions follow
      `<subject>_<role-or-verb>` consistently. Flows stay open-ended.
- [x] Raycast extension at
      `~/code/workspaces/raycast/odd-bits/raycast/fish-flows/`. Commands
      generated from `@raycast yes` headers via
      `pnpm generate-fish-flow-commands`.

### Pending tidies (small things)

- Dependency-check blocks (`if not command -q fzf … brew install`) appear in
  `pagerduty_bulk_*` and elsewhere. A single `_lib/_lib_require` helper
  would replace ~40 lines of repeated boilerplate.
- `pagerduty_bulk_triage` bundles `_pd_triage_batch_cmd` and
  `_pd_triage_relative_time` inline at the bottom of its file. They
  could move to `pagerduty/_lib/`.
- `pagerduty_bulk_*` could be decomposed further (categorize step
  extractable into a producer). Not blocking.
- `workspaces/producers/list_workspace_containing_directories.fish` and
  `list_subfolders_in_ws_dirs.fish` appear unused. Candidates for
  deletion or rename to convention.
- `gs`, `gms` are flows that produce formatted human output, not
  candidate lists. The role classification is a best fit, not a great
  fit.
- A handful of trivial flat files remain at the top of `functions/` per
  the "ad-hoc when touched" rule: `!!`, `authme`, `clear_empty_spaces`,
  `envsource`, `gtc`, `gtm`, `pgcli_add_connection`, `pop_space`,
  `push_space`, `tf`, `vaultssh`, `vl`, `y`. Categorize these only when
  you happen to be editing them.
- Plugin-managed flat files stay flat by design: `__fzf_*`, `_nvm_*`,
  `bass`, `fisher`, `fzf_key_bindings`, `nvm`, `fish_user_key_bindings`
  (the last has a special filename fish loads unconditionally).

### Historical migration tables

The detailed tables that previously lived here (mapping pre-migration
filenames → final names) have been removed now that migration is
complete. See git history for the original mapping if needed.

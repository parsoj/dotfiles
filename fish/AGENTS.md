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

Suffixes carry meaning **but are not the source of truth** (the folder is).
The suffix is a hint for tab completion and human reading.

| Role     | Folder       | Typical suffix(es)                          | Example       |
|----------|--------------|---------------------------------------------|---------------|
| producer | `producers/` | `_list`, `_search`, `_candidates`           | `repo_list`   |
| action   | `actions/`   | `_open`, `_archive`, `_set`, `_send`, etc.  | `repo_open`   |
| flow     | `flows/`     | bare feature name                           | `repo`        |
| internal | `_lib/`      | `_lib_*` prefix                             | `_lib_role`   |

Action suffixes are open-ended on purpose — the role lookup uses the folder,
not a suffix regex, so verbs can be whatever reads best.

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
- `@raycast yes|no` — explicit opt-in/out for exposure to the Raycast
  extension layer (default: yes for producers/actions, no for flows because
  flows are tty-only).

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
`~/code/workspaces/raycast/<ext>/` (not in this directory). It:

- Lists candidates by running `fish -c "<producer>"` and parsing stdout.
- Runs the chosen action via `fish -c "<action>"`, passing the selection on
  stdin to avoid quoting issues.
- Never invokes flows (they assume a tty for fzf and would hang in Raycast).

State that lives in your shell (cwd, exported env vars) cannot cross the
Raycast boundary. Actions that `cd` or modify the parent shell are
terminal-only by definition.

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

## 9. Migration plan

The structure above is partially in place. This section tracks what still
needs to move.

### Status

- [x] `config.fish` recursively registers `functions/**/` on
      `$fish_function_path`.
- [x] `_lib/_lib_role.fish` + `_lib/_lib_meta.fish` exist.
- [x] `shared/producers/{producers,actions,flows}.fish` exist.
- [x] Pilot feature `config/` migrated (`cf` deleted as dead code,
      `config_list`, `con`).
- [x] Remaining fzf-using functions migrated into feature/role folders
      (`rd`, `pg_connect`, `pagerduty_bulk_*`, `tmux_watch_ci`, `lports`,
      echo servers, `ip_lookup`, `send_to_*`, `rand_string`, phone lookup).
- [x] Remaining inline functions in `config.fish` extracted (`cc`, `ccp`,
      `ecr_login`, `workspace_root`, `run_steampipe_service`, `kns`, `kx`,
      `pick_pod`, `ax`, `gs`, `ga`, `git-hard-reset`, `gm`, `gms`,
      `git_add_github_fork`, `rr`, `kill_port_listeners`).
- [x] Existing `workspaces/`, `kubernetes/`, `utils/` flat folders
      restructured into `<feature>/{producers,actions,flows}/` (utils
      removed entirely; reverse-phone-lookup moved to `phone/`).
- [ ] Raycast extension scaffolded at
      `~/code/workspaces/raycast/fish-flows/`.

### Caveats (things still to clean up later)

- Dependency-check blocks (`if not command -q fzf … brew install`) appear in
  `pagerduty_bulk_*` and elsewhere. A single `_lib/_lib_require` helper
  would replace ~40 lines.
- `gs`, `gms` are flows that produce formatted human output, not candidate
  lists. The role classification is a best fit, not a great fit.
- A handful of trivial flat files were left flat per the "ad-hoc when
  touched" rule: `!!`, `authme`, `clear_empty_spaces`, `envsource`, `gtc`,
  `gtm`, `pgcli_add_connection`, `pop_space`, `push_space`, `tf`,
  `vaultssh`, `vl`, `y`.
- Plugin-managed flat files were intentionally left flat: `__fzf_*`,
  `_nvm_*`, `bass`, `fisher`, `fzf_key_bindings`, `nvm`,
  `fish_user_key_bindings` (the last has a special filename fish loads
  unconditionally, so it must stay flat).
- `pagerduty_bulk_triage` still bundles `_pd_triage_batch_cmd` and
  `_pd_triage_relative_time` inline at the bottom of its file. They could
  move to `pagerduty/_lib/`. Faithful for now.

### Functions to migrate

#### From `functions/` flat → feature folders

| Current file                          | Target feature | Producer            | Action(s)              | Flow              | Notes                                         |
|---------------------------------------|----------------|---------------------|------------------------|-------------------|-----------------------------------------------|
| `cf.fish` (+ `cfls.fish`)             | `config/`      | `config_list`       | `config_open`          | `cf`              | `cfls` becomes the producer; `cf` the flow.   |
| `rd.fish`                             | `git/`         | `git_dir_list`      | `git_dir_cd`*          | `rd`              | *cd is tty-only; action sets a global var or echoes path; flow does the cd. Likely keep flow-only. |
| `pg_connect.fish`                     | `postgres/`    | `pgpass_list`       | `pg_connect_to`        | `pg_connect`      | Action takes a host:port:db:user tuple.       |
| `pagerduty_bulk_resolve.fish`         | `pagerduty/`   | `pd_service_list`   | `pd_resolve_service`   | `pd_resolve`      | Confirmation stays in the flow, not action.   |
| `pagerduty_bulk_triage.fish`          | `pagerduty/`   | `pd_service_list` (shared) | `pd_triage_service` | `pd_triage`     | Helper `_pd_triage_*` → `pagerduty/_lib_*`.   |
| `tmux_watch_ci.fish`                  | `ci/` or `tmux/` | n/a (action only) | `tmux_watch_ci`        | n/a               | Already action-shaped.                        |
| `lports.fish`                         | `network/`     | `lports`            | n/a                    | n/a               | Pure list output → producer.                  |
| `localhost_echo_server.fish`          | `network/`     | n/a                 | `echo_server_local`    | n/a               | Action only.                                  |
| `public_echo_server.fish`             | `network/`     | n/a                 | `echo_server_public`   | n/a               | Action only.                                  |
| `ip_lookup.fish`                      | `network/`     | n/a                 | `ip_lookup`            | n/a               | Action that echoes; producer-action hybrid OK as action. |
| `send_to_inbox.fish`                  | `inbox/`       | n/a                 | `send_to_inbox`        | n/a               | Already action-shaped.                        |
| `send_to_work_inbox.fish`             | `inbox/`       | n/a                 | `send_to_work_inbox`   | n/a               | Same.                                         |
| `rand_string.fish`                    | `shared/`      | `rand_string`       | n/a                    | n/a               | Generic; lives in `shared/producers/`.        |
| Plugin-owned (`__fzf_*`, `_nvm_*`, `fisher.fish`, `bass.fish`, `fzf_key_bindings.fish`, `fish_user_key_bindings.fish`, `nvm.fish`) | — | — | — | — | **Leave flat.** Plugins own these. |
| Trivial (`!!.fish`, `q`, `y.fish`, `vl.fish`, `tf.fish`, `gtc.fish`, `gtm.fish`, `clear_empty_spaces.fish`, `authme.fish`, `vaultssh.fish`, `pop_space.fish`, `push_space.fish`, `envsource.fish`, `pgcli_add_connection.fish`) | varies | — | — | — | Categorize ad-hoc when touched; not blocking. |

#### From `config.fish` inline → feature folders

| Current inline fn      | Target feature  | Producer            | Action               | Flow         |
|------------------------|-----------------|---------------------|----------------------|--------------|
| `con`                  | `config/`       | reuse `config_list` | reuse `config_open`  | `con`        |
| `kns`                  | `kubernetes/`   | `k8s_namespace_list` | `k8s_set_namespace` | `kns`        |
| `kx`                   | `kubernetes/`   | `k8s_context_list`  | `k8s_set_context`    | `kx`         |
| `pick_pod`             | `kubernetes/`   | `k8s_pod_list`      | n/a                  | `pick_pod` (echoes) |
| `ax`                   | `aws/`          | `aws_profile_list`  | `aws_set_profile`    | `ax`         |
| `ecr_login`            | `aws/`          | n/a                 | `ecr_login`          | n/a          |
| `workspace_root`       | `workspaces/`   | `workspace_root`    | n/a                  | n/a          |
| `rr`                   | `git/`          | n/a                 | `git_root_cd`*       | n/a          | *Same cd-is-tty caveat as `rd`. |
| `kill_port_listeners`  | `network/`      | n/a                 | `kill_port_listeners`| n/a          |
| `gs`, `ga`, `gm`, `gms`, `git-hard-reset`, `git_add_github_fork` | `git/` | n/a | each an action | n/a | Many are workflow flows (compose multiple git ops) but no fzf — call them flows. |
| `run_steampipe_service`| `steampipe/`    | n/a                 | `steampipe_restart`  | n/a          |
| `cc`, `ccp`            | `claude/`       | n/a                 | `cc`, `ccp`          | n/a          |
| `nvm`                  | leave inline    | —                   | —                    | —            | Sources bass; load-order sensitive. Keep in `config.fish`. |

#### Existing subfolder restructuring

**`functions/workspaces/`** has 27 files and is the largest group. Already
naturally aligned with our convention; just needs to split into subfolders:

| Current file                                  | Role     |
|-----------------------------------------------|----------|
| `list_workspaces.fish`                        | producer |
| `list_workspace_directories.fish`             | producer |
| `list_workspace_files.fish`                   | producer |
| `list_workspace_containing_directories.fish`  | producer |
| `list_subfolders_in_ws_dirs.fish`             | producer |
| `list_cwd_child_directories.fish`             | producer |
| `list_cwd_child_files.fish`                   | producer |
| `print_workspace_root.fish`                   | producer |
| `add_repo.fish`                               | action   |
| `cd_cwd_child_directory.fish`                 | action (tty-only) |
| `cd_workspace_directory.fish`                 | action (tty-only) |
| `cd_workspace_root.fish`                      | action (tty-only) |
| `clean_workspaces.fish`                       | action   |
| `create_new_workspace.fish`                   | action   |
| `open_cwd_child_file.fish`                    | action   |
| `open_repo.fish`                              | action   |
| `open_workspace_file.fish`                    | action   |
| `open_workspace.fish`                         | action   |
| `rename_workspace.fish`                       | action   |
| `spinout.fish`                                | action   |
| `tmux_create_workspace.fish`                  | action   |
| `tmux_open_workspace.fish`                    | action   |
| `pick_repo.fish`                              | flow     |
| `go_to_workspace.fish`                        | flow     |
| `new_project.fish`                            | flow     |
| `wat.fish`                                    | flow (inspect) |
| `rprt.fish`                                   | flow (inspect) |

**`functions/kubernetes/`**: merge with the inline `kns`/`kx`/`pick_pod`
extractions above. Existing `kubectl_set_namespace` / `kubectl_set_cluster`
become `actions/k8s_set_namespace.fish` / `actions/k8s_set_context.fish`.

**`functions/utils/`**: `reverse-phone-lookup.fish` → its own `phone/`
feature as `actions/phone_lookup.fish`.

### Migration order (suggested)

1. **Pilot — one small feature.** `config/` (just `cf` + `cfls` + `con`).
   Validates the structure end-to-end with low risk.
2. **`pagerduty/`** — well-bounded, complex enough to exercise `_lib/`
   helpers and `@destructive`.
3. **`kubernetes/`** — folds inline `kns`/`kx`/`pick_pod` into the existing
   subfolder.
4. **`workspaces/`** — biggest, save for last when the pattern is solid.
5. **Cleanup pass on `config.fish`** — extract remaining inline functions.
6. **Scaffold the Raycast extension** and port the first flow.

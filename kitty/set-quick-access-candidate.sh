#!/usr/bin/env bash
set -euo pipefail

key="${1:?usage: $0 <kitty-key-spec>}"
label="CANDIDATE_${key//[^A-Za-z0-9]/_}"
conf="/Users/jeff/.config/kitty/kitty.conf"
log="/Users/jeff/.cache/kitty/quick-access-shell.log"

python3 - "$conf" "$key" "$label" <<'PY'
import pathlib, sys
path = pathlib.Path(sys.argv[1])
key = sys.argv[2]
label = sys.argv[3]
line = f"map {key} launch --type=background /Applications/kitty.app/Contents/MacOS/kitten quick-access-terminal /Users/jeff/.config/kitty/quick-access-shell.sh {label}\n"
text = path.read_text()
lines = text.splitlines(True)
for i, existing in enumerate(lines):
    if "quick-access-shell.sh CANDIDATE_" in existing:
        lines[i] = line
        break
else:
    raise SystemExit("candidate line not found")
path.write_text("".join(lines))
PY

for socket in /tmp/mykitty /tmp/mykitty-*; do
  [[ -S "$socket" ]] || continue
  /Applications/kitty.app/Contents/MacOS/kitten @ --to "unix:$socket" load-config >/dev/null 2>&1 || true
done

pkill -f 'kitty-quick-access.*instance-group=quick-access' 2>/dev/null || true
mkdir -p "$(dirname "$log")"
: > "$log"

echo "armed $key ($label)"

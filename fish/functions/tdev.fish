function tdev --description 'ssh to tmac and attach (or create) the dev tmux session'
  ssh -t $argv tmac -- tmux new-session -A -s dev
end

function tdev --description 'mosh to tmac and attach (or create) the dev tmux session'
  mosh tmac $argv -- tmux new-session -A -s dev
end

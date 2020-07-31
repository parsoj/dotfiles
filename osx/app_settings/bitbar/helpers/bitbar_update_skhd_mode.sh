#!/bin/sh

SKHD_STATE_FILE=~/.config/osx/app_settings/skhd/state.txt

function skhd_bitbar_update {
    echo $1 > $SKHD_STATE_FILE
    open 'bitbar://refreshPlugin?name=skhd_state.sh'
}

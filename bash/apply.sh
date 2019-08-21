#!/usr/bin/env bash

rm -rf ~/.bashrc ; ln -s $(pwd)/bashrc ~/.bashrc
rm -rf ~/.bash_profile ; ln -s $(pwd)/bash_profile ~/.bash_profile

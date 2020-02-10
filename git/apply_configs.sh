#!/usr/bin/env bash

rm ~/.gitconfig ; ln -s $(pwd)/gitconfig ~/.gitconfig
rm ~/.gitignore_global ; ln -s $(pwd)/gitignore_global ~/.gitignore_global

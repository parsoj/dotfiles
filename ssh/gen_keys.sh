#!/usr/bin/env fish

set email (read -p "Enter your email: ")

# Github Key
echo "Generate key for GitHub (y/n)? "
set generate_github (read)
if test "$generate_github" = "y"
  rm -f ~/.ssh/github_ed25519
  ssh-keygen -t ed25519 -C "$email" -f ~/.ssh/github_ed25519
end

# Gitlab Key
echo "Generate key for GitLab (y/n)? "
set generate_gitlab (read)
if test "$generate_gitlab" = "y"
  rm -f ~/.ssh/gitlab_ed25519
  ssh-keygen -t ed25519 -C "$email" -f ~/.ssh/gitlab_ed25519
end

# Bitbucket Key
echo "Generate key for Bitbucket (y/n)? "
set generate_bitbucket (read)
if test "$generate_bitbucket" = "y"
  rm -f ~/.ssh/bitbucket_rsa
  ssh-keygen -t rsa -b 4096 -C "$email" -f ~/.ssh/bitbucket_rsa
end

# create ssh config if it doesn't exist
touch ~/.ssh/config

# append base_config to ~/.ssh/config
cat ./base_config >> ~/.ssh/config

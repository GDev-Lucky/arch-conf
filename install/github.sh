#!/usr/bin/env bash

echo "Enter your email"
read email
ssh-keygen -t ed25519 -C $email

echo "Add this public key to github"
cat ~/.ssh/id_ed25519.pub

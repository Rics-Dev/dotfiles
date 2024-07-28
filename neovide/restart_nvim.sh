#!/bin/bash

# Close Neovim if it's running

echo "executing close"
echo "closing"
pkill neovide &
echo "closed"
echo "close executed"
# Wait a moment to ensure Neovim has closed
sleep 1
echo "opening nvim"
# Reopen Neovim
neovide
echo "echo nvim opened"

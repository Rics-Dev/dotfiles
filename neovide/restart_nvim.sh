#!/bin/bash

# Close Neovim if it's running

echo "executing close"
echo "closing"
pkill neovide &
echo "nvim closed"
echo "close executed"

# Wait until Neovim is definitely closed
sleep 1
echo "opening nvim"
# Reopen Neovide
neovide &
echo "neovide opened"

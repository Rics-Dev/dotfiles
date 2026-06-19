#!/usr/bin/env bash

sudo ln -sf ~/dotfiles/keyd/default.conf /etc/keyd/default.conf

sudo systemctl enable --now keyd.service
systemctl status keyd.service

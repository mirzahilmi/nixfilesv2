#!/usr/bin/env bash

# modified version from https://github.com/SylvanFranklin/.config/blob/5684cf6dd5d39dc6aa07c45daa77590bfc93c2d3/scripts/open-github.sh

cd $(tmux run "echo #{pane_current_path}")
url=$(git remote get-url origin) 

if [[ $url != *github.com* ]]; then
    echo "This repository is not hosted on GitHub"
    exit 1
fi

if [[ $url == git@* ]]; then
    url="${url#git@}"
    url="${url/:/\/}"
    url="https://$url"

elif [[ $url == ssh://git@* ]]; then
    url="${url#ssh://git@}"
    url="${url#*/}"
    url="https://github.com/$url"
fi

xdg-open "$url"

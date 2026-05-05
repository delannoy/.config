#!/usr/bin/env bash

# [Copy a Cinnamon configuration](https://superuser.com/a/1378471)
# [What is dconf, what is its function, and how do I use it?](https://askubuntu.com/a/191013)

CINNAMON_CONF='cinnamon.conf'

function list_schemas(){
    gsettings list-schemas
}

function list_recursively(){
    gsettings list-recursively | less
}

function export_cinnamon_setttings(){
    dconf dump /org/cinnamon/ > "${CINNAMON_CONF}"
    dconf dump /org/cinnamon/desktop/keybindings/ >> "${CINNAMON_CONF}"
}

function import_cinnamon_settings(){
    dconf load /org/cinnamon/ < "${CINNAMON_CONF}"
    dconf load /org/cinnamon/desktop/keybindings/ > "${CINNAMON_CONF}"
}

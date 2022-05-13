fx_version "cerulean"
game "gta5"

author "Fujino Ns"
description "KC Launcher Service API Create by Kroekchai KC (Fujino Ns) - https://fujinons.web.app/web/new/"
version "2.0.0"

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "server.lua",
    "service.lua",
    "config.lua"
}

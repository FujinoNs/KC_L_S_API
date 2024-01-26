fx_version "cerulean"
game "gta5"

name 'KC_L_S_API'
author "Fujino Ns https://github.com/FujinoNs"
description "KC Launcher Service API Create by Kroekchai KC (Fujino Ns)"
version "4.0.0"
url 'https://github.com/FujinoNs/KC_L_S_API'

server_scripts {"@mysql-async/lib/MySQL.lua", "server.lua", "function.lua", "service.lua", "config.lua"}

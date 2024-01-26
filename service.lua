-- ESX = nil
SERVICE = {}

local connected = 0
local _DateTime
local _DateTimeInt
-- Get Date and Time Now
Citizen.CreateThread(function()
    while true do
        _DateTime = os.date("%d/%m/%Y-%H:%M")
        _DateTimeInt = os.date("%d%m%Y%H%M")
        Citizen.Wait(1000)
    end
end)

ROUTES = {
    ["/404.html"] = function(req, res)
        res.send("404")
    end,
    ["/"] = function(req, res)
        connected = connected + 1
        res.send(json.encode({
            _connected = connected,
            kc_playercount = GetNumPlayerIndices(),
            kc_playermax = GetConvarInt("sv_maxclients")
        }))
    end,
    ["/setlauncherstatus"] = function(req, res)
        local body = req.body
        local query = req.query
        local key_api = ""
        local steamId = ""
        local status = ""
        local message = ""

        if body and req.method == "POST" then
            key_api = body.key_api
            steamId = body.steamId
            status = body.status
            message = body.message
        end

        if ((key_api and query.key_api) or key_api) == Config.KeyAPI then
            if ((query and query.steamId) or steamId) == "" then
                res.send("steamId_null")
            else
                if ((query and query.status) or status) == "" then
                    res.send("status_null")
                else
                    if Config.UseSetLauncherStatusAPI == true then
                        Wait(100)
                        SetLauncherStatus_UpdatekdataSQL(((query and query.steamId) or steamId),
                            ((query and query.status) or status), ((query and query.message) or message), os.time())
                        res.send(((query and query.steamId) or steamId) .. " | " .. ((query and query.status) or status))
                    else
                        res.send("setlauncherstatus_api_is_not_enabled")
                    end
                end
            end
        else
            res.send("key_is_invalid")
        end

        key_api = ""
        status = ""
        steamId = ""
        message = ""
    end,
    ["/getplayer"] = function(req, res)
        local body = req.body
        local query = req.query
        local key_api = ""
        local steamId = ""

        if body and req.method == "GET" then
            key_api = body.key_api
            steamId = body.steamId
        end
        if ((key_api and query.key_api) or key_api) == Config.KeyAPI then
            if ((query and query.steamId) or steamId) == "" then
                res.send("steamId_null")
            else
                Wait(100)

                MySQL.ready(function()
                    MySQL.Async.fetchAll("SELECT * FROM kc_launcher_service WHERE identifier = @data", {
                        ["@data"] = (query and query.steamId) or steamId
                    }, function(result)
                        local dataPlayer = result[1]
                        res.send(json.encode(dataPlayer))
                    end)
                end)
            end
        else
            res.send("key_is_invalid")
        end

        key_api = ""
        steamId = ""

    end
}

-- DropPlayer API
function DropPlayer_GetNameBySteamId(steamId, mes, mescmd)
    MySQL.Async.fetchAll("SELECT name FROM users WHERE identifier = @data", {
        ["@data"] = steamId
    }, function(result)
        local jsondata = json.encode(result)
        DropPlayer_GetNamePlayerByJsonData(jsondata, mes, mescmd)
    end)
end

function DropPlayer_GetNamePlayerByJsonData(data, mes, mescmd)
    local removingcharacters
    local removingcharacters2

    if data == "[]" then
    elseif data == "" then
    else
        removingcharacters = data:gsub('%[{"name":"', "")
        removingcharacters2 = removingcharacters:gsub('%"}]', "")
        DropPlayer_GetIdPlayerByNamePlayer(removingcharacters2, mes, mescmd)
    end
end

function DropPlayer_GetIdPlayerByNamePlayer(name, mes, mescmd)
    for _, playerId in ipairs(GetPlayers()) do
        local nameIngame = GetPlayerName(playerId)
        if nameIngame == name then
            DropPlayerById(playerId, name, mes, mescmd)
        end
    end
end

function DropPlayerById(id, name, mes, mescmd)
    if mes == "exitlauncher" then
        DropPlayer(id, "[ " .. Config.Title .. " ] - " .. Config.Message_PlayerConnecting_ExitLauncher)
    else
        DropPlayer(id, "[ " .. Config.Title .. " ] - " .. mes)
    end

    if Config.EnabledLog == true then
        print("^3DropPlayer.DropPlayerById: Player name: '" .. name .. "' ID: '" .. id ..
                  "' was kicked from server for reason: '" .. mescmd .. "'^7")
    end
end

-- Set Launcher Status
function SetLauncherStatus_UpdatekdataSQL(steamId, status, message, timestamp)
    MySQL.ready(function()
        MySQL.Async.execute(
            "UPDATE kc_launcher_service SET launcher_status =  @status, messages = @message, timestamp = @timestamp WHERE identifier = @steamId",
            {
                ["status"] = status,
                ["message"] = message,
                ["steamId"] = steamId,
                ["timestamp"] = timestamp
            }, function(success)
                if success == 1 then
                    if Config.EnabledLog == true then
                        print("^3SetLauncherStatus.UpdatedataSQL: Updated SteamID: '" .. steamId .. "' Status: '" ..
                                  status .. "' TimeStamp: " .. timestamp .. " success^7")
                    end
                elseif success == 0 then
                    MySQL.Async.execute(
                        "INSERT INTO kc_launcher_service (identifier, launcher_status, first_connect, messages, timestamp) VALUES (@steamId, @status, @datetime, @message, @timestamp)",
                        {
                            ["steamId"] = steamId,
                            ["status"] = status,
                            ["datetime"] = _DateTime,
                            ["message"] = message,
                            ["timestamp"] = timestamp
                        }, function(success)
                            if success == 1 then
                                if Config.EnabledLog == true then
                                    print("^3SetLauncherStatus.InsertdataSQL: Inserted SteamID: '" .. steamId ..
                                              "' Status: '" .. status .. "' TimeStamp: " .. timestamp .. " success^7")
                                end
                            else
                                if Config.EnabledLog == true then
                                    print("^3SetLauncherStatus.InsertdataSQL: Insert SteamID: '" .. steamId ..
                                              "' Status: '" .. status .. "' TimeStamp: " .. timestamp ..
                                              " failed | Error ID:'" .. success .. "'^7")
                                end
                            end
                        end)
                else
                    if Config.EnabledLog == true then
                        print("^3SetLauncherStatus.UpdatedataSQL: Update SteamID: '" .. steamId .. "' Status: '" ..
                                  status .. "' TimeStamp: " .. timestamp .. " failed | Error ID:'" .. success .. "'^7")
                    end
                end
            end)
    end)
end

-- Player Connecting
local function OnPlayerConnecting(name, setKickReason, deferrals)
    if Config.UseCheckStatusLauncher == true then
        local player = source
        local steamIdentifier
        local identifiers = GetPlayerIdentifiers(player)
        local ostime = os.time()
        deferrals.defer()

        -- mandatory wait!
        Wait(0)

        deferrals.update(string.format(
            "สวัสดี %s กำลังตรวจสอบสถานะ Launcher ของคุณ...",
            name))
        for _, v in pairs(identifiers) do
            if string.find(v, "steam") then
                steamIdentifier = v
                break
            end
        end
        -- mandatory wait!
        Wait(0)
        if not steamIdentifier then
            deferrals.done("คุณไม่ได้เชื่อมต่อกับ Steam")
        else
            MySQL.ready(function()
                MySQL.Async.fetchAll("SELECT * FROM kc_launcher_service WHERE identifier = @data", {
                    ["@data"] = steamIdentifier
                }, function(result)
                    -- print(json.encode(result))
                    local dataPlayer = result[1]
                    local getTime = ostime - dataPlayer.timestamp
                    if getTime > Config.TimeLimitLauncherOffline then
                        SetLauncherStatus_UpdatekdataSQL(steamIdentifier, 'timeout', 'Timeout', dataPlayer.timestamp)

                        deferrals.done(Config.Message_Player_Timeout)

                        if Config.EnabledLog == true then
                            print("^3PlayerConnecting.ConnectFailed: SteamID: " .. steamIdentifier ..
                                      " Reason:  Timeout " .. getTime .. " second (Time limit: " ..
                                      Config.TimeLimitLauncherOffline .. " second)^7")
                        end
                    else
                        if dataPlayer.launcher_status == "connectbylauncher" then
                            SetLauncherStatus_UpdatekdataSQL(steamIdentifier, 'connecting', dataPlayer.messages,
                                os.time())
                            deferrals.done()
                            if Config.EnabledLog == true then
                                print("^2PlayerConnecting: SteamID: '" .. steamIdentifier .. "'^7")
                            end
                        elseif dataPlayer.status == "offline" then

                            deferrals.done(string.format("[ " .. Config.Title .. " ] - " ..
                                                             Config.Message_PlayerConnecting_Offline))
                            if Config.EnabledLog == true then
                                print("^3PlayerConnecting.ConnectFailed: SteamID: '" .. steamIdentifier ..
                                          "' Status Launcher: 'Launcher offline'^7")
                            end
                        elseif dataPlayer.status == "exitgame" then
                            deferrals.done(string.format("[ " .. Config.Title .. " ] - " ..
                                                             Config.Message_PlayerConnecting_ExitGame))
                            if Config.EnabledLog == true then
                                print("^3PlayerConnecting.ConnectFailed: SteamID: '" .. steamIdentifier ..
                                          "' Status Launcher: 'Player exit game'^7")
                            end
                        elseif dataPlayer.status == "exitlauncher" then
                            deferrals.done(string.format("[ " .. Config.Title .. " ] - " ..
                                                             Config.Message_PlayerConnecting_ExitLauncher))
                            if Config.EnabledLog == true then
                                print("^3PlayerConnecting.ConnectFailed: SteamID: '" .. steamIdentifier ..
                                          "' Status Launcher: 'Player leaves launcher while FiveM is running'^7")
                            end
                        elseif dataPlayer.status == "detectedblacklist" then
                            if (Config.UseCheckCitizenBlacklist == true) then
                                deferrals.done(string.format(
                                    "[ " .. Config.Title .. " ] - " .. Config.Message_PlayerConnecting_DetectedBlacklist,
                                    dataPlayer.messages))
                                if Config.EnabledLog == true then
                                    print("^3PlayerConnecting.ConnectFailed: SteamID: '" .. steamIdentifier ..
                                              "' Status Launcher: 'Detected on blacklist (" .. dataPlayer.messages ..
                                              ")'^7")
                                end
                                DetectedBlacklist_Connecting(steamIdentifier, dataPlayer.messages)
                            else
                                deferrals.done()
                            end
                        elseif dataPlayer.status == "timeout" then
                            deferrals.done(string.format("[ " .. Config.Title .. " ] - " ..
                                                             Config.Message_Player_Timeout))
                            if Config.EnabledLog == true then
                                print("^3PlayerConnecting.ConnectFailed: SteamID: '" .. steamIdentifier ..
                                          "' Status Launcher: 'Timeout'^7")

                            end
                        else
                            deferrals.done(Config.Message_PlayerConnecting_StatusNotMatch)
                        end
                    end
                end)
            end)
        end
    end
end

AddEventHandler("playerConnecting", OnPlayerConnecting)

-- Player Disconnect
AddEventHandler("playerDropped", function(reason)
    if Config.UseCheckStatusLauncher == true then
        local player = source
        local steamIdentifier
        local identifiers = GetPlayerIdentifiers(player)
        local status = "exitgame"
        Wait(0)

        for _, v in pairs(identifiers) do
            if string.find(v, "steam") then
                steamIdentifier = v
                break
            end
        end

        MySQL.ready(function()
            MySQL.Async.execute(
                "UPDATE kc_launcher_service SET launcher_status =  @status, disconnect = @discon  WHERE identifier = @steamId",
                {
                    ["status"] = status,
                    ["discon"] = _DateTime,
                    ["steamId"] = steamIdentifier
                }, function(success)
                    if Config.EnabledLog == true then
                        print("^3PlayerDropped.UpdateStatusSQL: SteamID: '" .. steamIdentifier .. "' Status: '" ..
                                  status .. "'^7")
                    end
                end)
        end)
    end
end)

-- Loop check player and dropplayer exitlauncher
Citizen.CreateThread(function()
    if Config.UseCheckStatusLauncher == true then
        while true do
            for _, playerId in ipairs(GetPlayers()) do
                local nameIngame = GetPlayerName(playerId)
                local steamIdentifier
                local identifiers = GetPlayerIdentifiers(playerId)
                local ostime = os.time()

                for _, v in pairs(identifiers) do
                    if string.find(v, "steam") then
                        steamIdentifier = v
                        break
                    end
                end

                MySQL.ready(function()
                    MySQL.Async.fetchAll("SELECT * FROM kc_launcher_service WHERE identifier = @data", {
                        ["@data"] = steamIdentifier
                    }, function(result)
                        local dataPlayer = result[1]
                        local getTime = ostime - dataPlayer.timestamp

                        if getTime > Config.TimeLimitLauncherOffline then
                            SetLauncherStatus_UpdatekdataSQL(steamIdentifier, 'timeout', 'Timeout', dataPlayer.timestamp)

                            DropPlayer(playerId, Config.Message_Player_Timeout)
                            if Config.EnabledLog == true then
                                print("^3LoopCheckPlayer.DropPlayer: Player name: '" .. nameIngame .. "' ID: '" ..
                                          playerId .. "' was kicked from server for reason: Timeout " .. getTime ..
                                          " second (Time limit: " .. Config.TimeLimitLauncherOffline .. " second)^7")
                            end
                        else
                            if dataPlayer.launcher_status == "connected" then
                                -- SetLauncherStatus_UpdatekdataSQL(steamIdentifier, 'connected', '', os.time())

                            elseif dataPlayer.launcher_status == "connecting" then
                                SetLauncherStatus_UpdatekdataSQL(steamIdentifier, 'connected', dataPlayer.messages,
                                    dataPlayer.timestamp)

                            elseif dataPlayer.launcher_status == "exitlauncher" then
                                DropPlayer(playerId, "[ " .. Config.Title .. " ] - " ..
                                    Config.Message_PlayerConnecting_ExitLauncher)
                                if Config.EnabledLog == true then
                                    print("^3LoopCheckPlayer.DropPlayer: Player name: '" .. nameIngame .. "' ID: '" ..
                                              playerId ..
                                              "' was kicked from server for reason: 'Player leaves launcher while FiveM is running'^7")
                                end
                            elseif dataPlayer.launcher_status == "detectedblacklist" then
                                if (Config.UseCheckCitizenBlacklist == true) then
                                    DropPlayer(playerId, string.format(
                                        "[ " .. Config.Title .. " ] - " ..
                                            Config.Message_PlayerConnecting_DetectedBlacklist, dataPlayer.messages))
                                    if Config.EnabledLog == true then
                                        print(
                                            "^3LoopCheckPlayer.DropPlayer: Player name: '" .. nameIngame .. "' ID: '" ..
                                                playerId ..
                                                "' was kicked from server for reason: 'Detected on blacklist (" ..
                                                dataPlayer.messages .. ")'^7")
                                    end
                                    DetectedBlacklist_Ingame(steamIdentifier, nameIngame, playerId, dataPlayer.messages)
                                end
                            else
                                DropPlayer(playerId,
                                    "[ " .. Config.Title .. " ] - " .. Config.Message_PlayerPlaying_NotAllowed)
                                if Config.EnabledLog == true then
                                    print("^3LoopCheckPlayer.DropPlayer: Player name: '" .. nameIngame .. "' ID: '" ..
                                              playerId .. "' was kicked from server for reason: 'Status not allowed'^7")
                                end
                            end
                        end
                    end)
                end)
            end
            Citizen.Wait(5000)
        end
    end
end)

print("^8======================================================================^5")
print("KC Launcher Service API (V4.0.0) Created by Kroekchai KC (Fujino N's)")
print("Website https://github.com/FujinoNs/KC_L_S_API")
print("Thank you for using KC Launcher :)")
print("Powered by https://github.com/throwarray/fivem-http-server")
print("^8======================================================================^7")

ESX = nil
SERVICE = {}

local connected = 0
local _DateTime
local _DateTimeInt
local _resourcepath = GetResourcePath(GetCurrentResourceName())
local _path_data_blacklist = string.sub(_resourcepath, 0, -12) .. GetCurrentResourceName() .. "/data/checkcitizen_blacklist.txt"
-- Get Date and Time Now
Citizen.CreateThread(function()
    while true do
        _DateTime = os.date("%d/%m/%Y-%H:%M")
        _DateTimeInt = os.date("%d%m%Y%H%M")
        Citizen.Wait(1000)
    end
end)

ROUTES = {
    ["/datablacklist"] = function(req, res)
        if (Config.UseCheckCitizenBlacklist == true) then
            res.send(readAll(_path_data_blacklist))
        else
            res.send("")
        end
    end,
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
    ["/dropplayer"] = function(req, res)
        local body = req.body
        local query = req.query
        local key_api = ""
        local steamId = ""
        local mes = ""
        local mescmd = ""

        if body and req.method == "POST" then
            key_api = body.key_api
            steamId = body.steamId
            mes = body.mes
            mescmd = body.mescmd
        end

        if ((key_api and query.key_api) or key_api) == Config.KeyAPI then
            if ((query and query.steamId) or steamId) == "" then
                res.send("steamId_null")
            else
                if Config.UseDropPlayerAPI == true then
                    Wait(100)
                    DropPlayer_GetNameBySteamId(((query and query.steamId) or steamId), ((query and query.mes) or mes),
                        ((query and query.mescmd) or mescmd))
                    res.send(((query and query.steamId) or steamId))
                else
                    res.send("dropplayer_api_is_not_enabled")
                end
            end
        else
            res.send("key_is_invalid")
        end

        steamId = ""
        key_api = ""
        mes = ""
        mescmd = ""
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
                            ((query and query.status) or status), ((query and query.message) or message))
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
    ["/getlauncherstatus"] = function(req, res)
        local body = req.body
        local query = req.query
        local key_api = ""
        local steamId = ""

        if body and req.method == "POST" then
            key_api = body.key_api
            steamId = body.steamId
        end

        if ((key_api and query.key_api) or key_api) == Config.KeyAPI then
            if ((query and query.steamId) or steamId) == "" then
                res.send("steamId_null")
            else
                Wait(100)
                MySQL.Async.fetchScalar("SELECT launcher_status FROM kc_launcher_service WHERE identifier = @data", {
                    ["@data"] = (query and query.steamId) or steamId
                }, function(status)
                    if status == nil then
                        res.send(json.encode({
                            _status = true,
                            steamID = (query and query.steamId) or steamId,
                            launcherstatus="null"
                        }))
                    else
                        res.send(json.encode({
                            _status = true,
                            steamID = (query and query.steamId) or steamId,
                            launcherstatus = status
                        }))
                    end
                end)
            end
        else
            res.send("key_is_invalid")
        end

        key_api = ""
        steamId = ""
    end
}

-- Get data black list
function readAll(file)
    local f = assert(io.open(file, "rb"))
    local content = f:read("*all")
    f:close()
    return content
end

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
        print("^3DropPlayer.DropPlayerById: Player name: '" .. name .. "' ID: '" .. id .. "' was kicked from server for reason: '" .. mescmd .. "'^7")
    end
end

-- Set Launcher Status
function SetLauncherStatus_UpdatekdataSQL(steamId, status, message)
    MySQL.Async.execute(
        "UPDATE kc_launcher_service SET launcher_status =  @status, messages = @message WHERE identifier = @steamId", {
            ["status"] = status,
            ["message"] = message,
            ["steamId"] = steamId
        }, function(success)
            if success == 1 then
                if Config.EnabledLog == true then
                    print("^3SetLauncherStatus.UpdatedataSQL: Updated SteamID: '" .. steamId .. "' Status: '" .. status .. "' success^7")
                end
            elseif success == 0 then
                MySQL.Async.execute(
                    "INSERT INTO kc_launcher_service (identifier, launcher_status, first_connect, messages) VALUES (@steamId, @status, @datetime, @message)",
                    {
                        ["steamId"] = steamId,
                        ["status"] = status,
                        ["datetime"] = _DateTime,
                        ["message"] = message
                    }, function(success)
                        if success == 1 then
                            if Config.EnabledLog == true then
                                print("^3SetLauncherStatus.InsertdataSQL: Inserted SteamID: '" .. steamId .. "' Status: '" .. status .. "' success^7")
                            end
                        else
                            if Config.EnabledLog == true then
                                print("^3SetLauncherStatus.InsertdataSQL: Insert SteamID: '" .. steamId .. "' Status: '" .. status .. "' failed | Error ID:'" .. success .. "'^7")
                            end
                        end
                    end)
            else
                if Config.EnabledLog == true then
                    print("^3SetLauncherStatus.UpdatedataSQL: Update SteamID: '" .. steamId .. "' Status: '" .. status .. "' failed | Error ID:'" .. success .. "'^7")
                end
            end
        end)
end

-- Player Connecting
local function OnPlayerConnecting(name, setKickReason, deferrals)
    if Config.UseCheckStatusLauncher == true then
        local player = source
        local steamIdentifier
        local identifiers = GetPlayerIdentifiers(player)
        deferrals.defer()

        Wait(0)

        for _, v in pairs(identifiers) do
            if string.find(v, "steam") then
                steamIdentifier = v
                break
            end
        end

        MySQL.Async.fetchScalar("SELECT launcher_status FROM kc_launcher_service WHERE identifier = @data", {
            ["@data"] = steamIdentifier
        }, function(status)
            if status == "connectbylauncher" then
                deferrals.done()
                if Config.EnabledLog == true then
                    print("^3PlayerConnecting.ConnectSuccess: SteamID: '" .. steamIdentifier .. "' Player Status: 'Connecting to Server'^7")
                end
                MySQL.Async.execute(
                    "UPDATE kc_launcher_service SET last_connect = @datetime WHERE identifier = @steamId", {
                        ["steamId"] = steamIdentifier,
                        ["datetime"] = _DateTime
                    }, function(success)
                    end)
            elseif status == "offline" then
                deferrals.done(string.format("[ " .. Config.Title .. " ] - " .. Config.Message_PlayerConnecting_Offline))
                if Config.EnabledLog == true then
                    print("^3PlayerConnecting.ConnectFailed: SteamID: '" .. steamIdentifier .. "' Status Launcher: 'Launcher offline'^7")
                end
            elseif status == "exitgame" then
                deferrals.done(
                    string.format("[ " .. Config.Title .. " ] - " .. Config.Message_PlayerConnecting_ExitGame))
                if Config.EnabledLog == true then
                    print("^3PlayerConnecting.ConnectFailed: SteamID: '" .. steamIdentifier .. "' Status Launcher: 'Player exit game'^7")
                end
            elseif status == "exitlauncher" then
                deferrals.done(string.format("[ " .. Config.Title .. " ] - " .. Config.Message_PlayerConnecting_ExitLauncher))
                if Config.EnabledLog == true then
                    print("^3PlayerConnecting.ConnectFailed: SteamID: '" .. steamIdentifier .. "' Status Launcher: 'Player leaves launcher while FiveM is running'^7")
                end
            elseif status == "detectedblacklist" then
                if (Config.UseCheckCitizenBlacklist == true) then
                    MySQL.Async.fetchScalar("SELECT messages FROM kc_launcher_service WHERE identifier = @data", {
                        ["@data"] = steamIdentifier
                    }, function(message)
                        deferrals.done(string.format("[ " .. Config.Title .. " ] - " .. Config.Message_PlayerConnecting_DetectedBlacklist, message))
                        if Config.EnabledLog == true then
                            print("^3PlayerConnecting.ConnectFailed: SteamID: '" .. steamIdentifier .. "' Status Launcher: 'Detected on blacklist (" .. message .. ")'^7")
                        end
                        DetectedBlacklist_Connecting(steamIdentifier, message)
                    end)
                else
                    deferrals.done()
                end
            elseif status == "datablacklistischange" then
                if (Config.UseCheckCitizenBlacklist == true) then
                    deferrals.done(string.format("[ " .. Config.Title .. " ] - " .. Config.Message_PlayerConnecting_FileBlacklistIsChange))
                    if Config.EnabledLog == true then
                        print("^3PlayerConnecting.ConnectFailed: SteamID: '" .. steamIdentifier .. "' Status Launcher: 'Detected file data blacklist is schange'^7")
                    end
                    FileBlacklistIsChange_Connecting(steamIdentifier)
                else
                    deferrals.done()
                end
            elseif status == "serviceRuntimeMD5Error" then
                deferrals.done(string.format("[ " .. Config.Title .. " ] - " .. Config.Message_ServiceRuntimeMD5Error))
                if Config.EnabledLog == true then
                    print("^3PlayerConnecting.ConnectFailed: SteamID: '" .. steamIdentifier .. "' Status Launcher: 'Service Runtime File MD5 does not match!'^7")
                end
            elseif status == "serviceRuntimeFileNotFound" then
                deferrals.done(string.format("[ " .. Config.Title .. " ] - " .. Config.Message_ServiceRuntimeFileNotFound))
                if Config.EnabledLog == true then
                    print("^3PlayerConnecting.ConnectFailed: SteamID: '" .. steamIdentifier .. "' Status Launcher: 'File Service Runtime not found!'^7")
                end
            elseif status == "serviceRuntimeStartError" then
                deferrals.done(string.format("[ " .. Config.Title .. " ] - " .. Config.Message_ServiceRuntimeStartError))
                if Config.EnabledLog == true then
                    print("^3PlayerConnecting.ConnectFailed: SteamID: '" .. steamIdentifier .. "' Status Launcher: 'Failed to run file Service Runtime'^7")
                end
            elseif status == "serviceRuntimeNotRuning" then
                deferrals.done(string.format("[ " .. Config.Title .. " ] - " .. Config.Message_ServiceRuntimeNotRuning))
                if Config.EnabledLog == true then
                    print("^3PlayerConnecting.ConnectFailed: SteamID: '" .. steamIdentifier .. "' Status Launcher: 'Service Runtime Not Runing'^7")
                end
            elseif status == "serviceRuntimeOffline" then
                deferrals.done(string.format("[ " .. Config.Title .. " ] - " .. Config.Message_ServiceRuntimeOffline))
                if Config.EnabledLog == true then
                    print("^3PlayerConnecting.ConnectFailed: SteamID: '" .. steamIdentifier .. "' Status Launcher: 'Service Runtime Offline'^7")
                end
            else
                deferrals.done(string.format("[ " .. Config.Title .. " ] - " .. Config.Message_PlayerConnecting_StatusNotMatch))
                if Config.EnabledLog == true then
                    print("^3PlayerConnecting.ConnectFailed: SteamID: '" .. steamIdentifier .. "' Status Launcher: 'Status does not match!'^7")
                end
            end
        end)
    end
end

AddEventHandler("playerConnecting", OnPlayerConnecting)

-- Player Disconnect
AddEventHandler("playerDropped", function(reason)
    if Config.UseCheckStatusLauncher == true then
        local player = source
        local steamIdentifier
        local identifiers = GetPlayerIdentifiers(player)

        Wait(0)

        for _, v in pairs(identifiers) do
            if string.find(v, "steam") then
                steamIdentifier = v
                break
            end
        end
        PlayerDropped_UpdateStatusSQL("exitgame", steamIdentifier)
    end
end)

function PlayerDropped_UpdateStatusSQL(status, steamId)
    MySQL.Async.execute(
        "UPDATE kc_launcher_service SET launcher_status =  @status, disconnect = @discon  WHERE identifier = @steamId",
        {
            ["status"] = status,
            ["discon"] = _DateTime,
            ["steamId"] = steamId
        }, function(success)
            if Config.EnabledLog == true then
                print("^3PlayerDropped.UpdateStatusSQL: SteamID: '" .. steamId .. "' Status: '" .. status .. "'^7")
            end
        end)
end

-- Loop check player and dropplayer exitlauncher
Citizen.CreateThread(function()
    if Config.UseCheckStatusLauncher == true then
        while true do
            for _, playerId in ipairs(GetPlayers()) do
                local nameIngame = GetPlayerName(playerId)
                local steamIdentifier
                local identifiers = GetPlayerIdentifiers(playerId)

                for _, v in pairs(identifiers) do
                    if string.find(v, "steam") then
                        steamIdentifier = v
                        break
                    end
                end

                MySQL.Async.fetchScalar("SELECT launcher_status FROM kc_launcher_service WHERE identifier = @data", {
                    ["@data"] = steamIdentifier
                }, function(status)
                    if status == "connectbylauncher" then
                        
                    elseif status == "exitlauncher" then
                        DropPlayer(playerId,"[ " .. Config.Title .. " ] - " .. Config.Message_PlayerConnecting_ExitLauncher)
                        if Config.EnabledLog == true then
                            print( "^3LoopCheckPlayer.DropPlayer: Player name: '" .. nameIngame .. "' ID: '" .. playerId .. "' was kicked from server for reason: 'Player leaves launcher while FiveM is running'^7")
                        end
                    elseif status == "detectedblacklist" then
                        if (Config.UseCheckCitizenBlacklist == true) then
                            MySQL.Async.fetchScalar("SELECT messages FROM kc_launcher_service WHERE identifier = @data",
                                {
                                    ["@data"] = steamIdentifier
                                }, function(message)
                                    DropPlayer(playerId, string.format("[ " .. Config.Title .. " ] - " .. Config.Message_PlayerConnecting_DetectedBlacklist, message))
                                    if Config.EnabledLog == true then
                                        print( "^3LoopCheckPlayer.DropPlayer: Player name: '" .. nameIngame .. "' ID: '" .. playerId .. "' was kicked from server for reason: 'Detected on blacklist (" .. message .. ")'^7")
                                    end
                                    DetectedBlacklist_Ingame(steamIdentifier, nameIngame, playerId, message)
                                end)
                        end
                    elseif status == "datablacklistischange" then
                        if (Config.UseCheckCitizenBlacklist == true) then
                            DropPlayer(playerId, "[ " .. Config.Title .. " ] - " .. Config.Message_PlayerConnecting_FileBlacklistIsChange)
                            if Config.EnabledLog == true then
                                print("^3LoopCheckPlayer.DropPlayer: Player name: '" .. nameIngame .. "' ID: '" .. playerId .. "' was kicked from server for reason: 'Detected file data blacklist is schange'^7")
                            end
                            FileBlacklistIsChange_Ingame(steamIdentifier, nameIngame, playerId)
                        end
                    elseif status == "serviceRuntimeMD5Error" then
                        DropPlayer(playerId, "[ " .. Config.Title .. " ] - " .. Config.Message_ServiceRuntimeMD5Error)
                        if Config.EnabledLog == true then
                            print( "^3LoopCheckPlayer.DropPlayer: Player name: '" .. nameIngame .. "' ID: '" .. playerId .. "' was kicked from server for reason: 'Service Runtime File MD5 does not match!'^7")
                        end 
                    elseif status == "serviceRuntimeFileNotFound" then
                        DropPlayer(playerId, "[ " .. Config.Title .. " ] - " .. Config.Message_ServiceRuntimeFileNotFound)
                        if Config.EnabledLog == true then
                            print( "^3LoopCheckPlayer.DropPlayer: Player name: '" .. nameIngame .. "' ID: '" .. playerId .. "' was kicked from server for reason: 'File Service Runtime not found!'^7")
                        end 
                    elseif status == "serviceRuntimeStartError" then
                        DropPlayer(playerId, "[ " .. Config.Title .. " ] - " .. Config.Message_ServiceRuntimeStartError)
                        if Config.EnabledLog == true then
                            print( "^3LoopCheckPlayer.DropPlayer: Player name: '" .. nameIngame .. "' ID: '" .. playerId .. "' was kicked from server for reason: 'Failed to run file Service Runtime'^7")
                        end 
                    elseif status == "serviceRuntimeNotRuning" then
                        DropPlayer(playerId, "[ " .. Config.Title .. " ] - " .. Config.Message_ServiceRuntimeNotRuning)
                        if Config.EnabledLog == true then
                            print( "^3LoopCheckPlayer.DropPlayer: Player name: '" .. nameIngame .. "' ID: '" .. playerId .. "' was kicked from server for reason: 'Service Runtime Not Runing'^7")
                        end 
                    elseif status == "serviceRuntimeOffline" then
                        DropPlayer(playerId, "[ " .. Config.Title .. " ] - " .. Config.Message_ServiceRuntimeOffline)
                        if Config.EnabledLog == true then
                            print( "^3LoopCheckPlayer.DropPlayer: Player name: '" .. nameIngame .. "' ID: '" .. playerId .. "' was kicked from server for reason: 'Service Runtime Offline'^7")
                        end 
                    else
                        DropPlayer(playerId, "[ " .. Config.Title .. " ] - " .. Config.Message_PlayerPlaying_NotAllowed)
                        if Config.EnabledLog == true then
                            print( "^3LoopCheckPlayer.DropPlayer: Player name: '" .. nameIngame .. "' ID: '" .. playerId .. "' was kicked from server for reason: 'Status not allowed'^7")
                        end 
                    end
                end)
            end
            Citizen.Wait(5000)
        end
    end
end)

print("^8======================================================================^5")
print("KC Launcher Service API (V2.1.0) Created by Kroekchai KC (Fujino N's)")
print("Website https://fujinons.web.app/web/new/")
print("Thank you for using KC Launcher :)")
print("Powered by https://github.com/throwarray/fivem-http-server")
print("^8======================================================================^7")

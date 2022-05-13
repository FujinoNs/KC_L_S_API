--[[
  SERVER HTTP CREATE BY https://github.com/throwarray/fivem-http-server
  SERVER HTTP EDIT BY Kroekchai KC (Fujino Ns) https://github.com/FujinoNs/KC_L_S_API
]] --

ESX = nil
ROUTES = {}
local scriptname = GetCurrentResourceName()

local function _decodeQuery1(h)
    return string.char(tonumber(h, 16))
end

local function _decodeQuery(s)
    s = s:gsub("+", " "):gsub("%%(%x%x)", _decodeQuery1)
    return s
end

function DecodeQueryParams(str)
    local query = {}

    for k, v in str:gmatch("([^&=?]-)=([^&=?]+)") do
        query[k] = _decodeQuery(v)
    end

    return query
end

function SplitQueryString(s)
    local url = {
        path = s,
        query = nil
    }

    for k, v in s:gmatch("(.+)?(.+)") do
        url.path = k
        url.query = v

        break
    end

    return url
end

function PageNotFound(req, res, ...)
    local handler = ROUTES["/404.html"]

    if handler then
        handler(req, res, ...)
    else
        res.writeHead(404)
        res.send("error")
    end
end

function SendFile(req, res, ...)
    local data
    local file

    if file then
        res.writeHead(200)
        io.input(file)
        data = io.read("*a")
        io.close(file)
    end

    if not data then
        PageNotFound(req, res, ...)
    else
        res.send("" .. data)
    end
end

function HandleRoute(req, res, ...)
    local extra = {...}

    if req.query ~= nil then
        req.query = DecodeQueryParams(req.query)
    end

    if req.method == "POST" then
        req.setDataHandler(
            function(body)
                req.body = json.decode(body)
                ROUTES[req.path](req, res, table.unpack(extra))
            end
        )
    else
        ROUTES[req.path](req, res, table.unpack(extra))
    end
end

SetHttpHandler(
    function(req, res)
        local url = SplitQueryString(req.path)

        if scriptname == "KC_L_S_API" then
            req.path = url.path
            req.query = url.query
            req.path = req.path:gsub("%.%.", "")

            if ROUTES[req.path] then
                HandleRoute(req, res)
                return
            end

            if ROUTES[req.path] then
                HandleRoute(req, res)
            else
                Citizen.CreateThread(
                    function()
                        Wait(0)
                        SendFile(req, res)
                    end
                )
            end
        else
            print("^8INVALID SCRIPT NAME PLEASE CHANGE '" .. scriptname .. "' TO 'KC_L_S_API' :(^7")
        end
    end
)

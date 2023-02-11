-- FileBlacklistIsChange_Ingame จะทำงานเมื่อตรวจพบไฟล์หรือโฟลเดอร์ที่ตรงกับที่ Admin ใส่ไว้ ขณะที่ผู้เล่นอยู่ในเซิร์ฟเวอร์
function DetectedBlacklist_Ingame(steamIdentifier, nameIngame, playerId, message)
    --[[
        steamIdentifier = Steam ID HEX ของผู้เล่น
        nameIngame = ชื่อของผู้เล่น
        playerId = ID ของผู้เล่น
        message = ไฟล์หรือโฟลเดอร์ที่ตรวจพบ
    ]]--
    -- เพิ่มโค้ดของคุณด้านล่างบรรทัดนี้ --
end

-- DetectedBlacklist_Connecting จะทำงานเมื่อตรวจพบไฟล์หรือโฟลเดอร์ที่ตรงกับที่ Admin ใส่ไว้ ขณะที่ผู้เล่นกำลังเซื่อมต่อกับเซิร์ฟเวอร์
function DetectedBlacklist_Connecting(steamIdentifier, message)
    --[[
        steamIdentifier = Steam ID HEX ของผู้เล่น
        message = ไฟล์หรือโฟลเดอร์ที่ตรวจพบ
    ]]--
    -- เพิ่มโค้ดของคุณด้านล่างบรรทัดนี้ --
end

-- FileBlacklistIsChange_Ingame จะทำงานเมื่อตรวจพบมีการเปลี่ยนแปลงไฟล์ blacklist ในขณะที่ผู้เล่นอยู่ในเซิร์ฟเวอร์
function FileBlacklistIsChange_Ingame(steamIdentifier, nameIngame, playerId)
    --[[
        steamIdentifier = Steam ID HEX ของผู้เล่น
        nameIngame = ชื่อของผู้เล่น
        playerId = ID ของผู้เล่น
    ]]--
    -- เพิ่มโค้ดของคุณด้านล่างบรรทัดนี้ --
end

-- FileBlacklistIsChange_Connecting จะทำงานเมื่อตรวจพบมีการเปลี่ยนแปลงไฟล์ blacklist ในขณะที่ผู้เล่นกำลังเซื่อมต่อกับเซิร์ฟเวอร์
function FileBlacklistIsChange_Connecting(steamIdentifier)
    --[[
        steamIdentifier = Steam ID HEX ของผู้เล่น
    ]]--
    -- เพิ่มโค้ดของคุณด้านล่างบรรทัดนี้ --
end
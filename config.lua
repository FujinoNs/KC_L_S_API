--[[
  SERVER HTTP CREATE BY https://github.com/throwarray/fivem-http-server
  SERVER HTTP EDIT BY Kroekchai KC (Fujino Ns) https://github.com/FujinoNs/KC_L_S_API
]] --
Config = {}

-- สคริปนี้ต้องการ: mysql-async

-- Service Settings (ตั้งค่า Service หลัก) --
Config.Title = "KC Launcher Service API (V4.0.0)" -- กำหนดชื่อหัวเรื่องในหน้าการแจ้งเตือนบน FiveM
Config.KeyAPI = "78CCbq36YIv7ABrR4576TtQi2tPM8g8R7AHJw9F9Pe70Jro3g2" -- โปรดกำหนด KeyAPI สำหรับการใช้งาน API
Config.EnabledLog = true -- เปิดการใช้งานแสดง Log ของ Service บน CMD เซิร์ฟเวอร์หรือไม่
Config.UseCheckStatusLauncher = true -- เปิดใช้งานระบบ ตรวจสอบสถานะ Launcher หรือไม่ (ปรับ UseSetLauncherStatusAPI เป็น true เพื่อใช้งานระบบ ตรวจสอบสถานะ Launcher และกำหนดเวลา Timeout ที่ TimeLimitLauncherOffline)
Config.TimeLimitLauncherOffline = 300 -- วินาที กำหนดเวลาสูงสุดที่อนุญาติให้ Launcher สามารถขาดการติดต่อกับ Server ได้ 60 Timeout = 1 นาที

-- API Settings (ปิด/เปิด ใช้งาน API) --
Config.UseSetLauncherStatusAPI = true -- เปิดใช้งาน SetLauncherStatus API หรือไม่ (ใช้งานคู่กับ UseCheckStatusLauncher)

--  Message for show Player (ข้อความสำหรับแจ้งเตือนผู้เล่นบน FiveM) --
local DiscordURL = "https://discord.gg/" -- ลิงค์ Discord สำหรับติดต่อ Admin
local DownloadLauncherURL = "http://kc-launcher.com/download" -- ลิงค์ดาวน์โหลด Launcher
Config.Message_PlayerConnecting_Offline =
    "สถานะ Launcher ของคุณออฟไลน์! กรุณาเข้าเซิร์ฟเวอร์ผ่านโปรแกรม Launcher! สามารถดาวน์โหลดโปรแกรม Launcher ได้ที่: " ..
        DownloadLauncherURL .. " หรือติดต่อผู้ดูแลระบบได้ที่: " ..
        DiscordURL
Config.Message_PlayerConnecting_ExitGame =
    "คุณ Disconnect ออกจากเซิร์ฟเวอร์ กรุณาเข้าเซิร์ฟเวอร์ผ่านโปรแกรม Launcher ใหม่อีกครั้ง! สามารถดาวน์โหลดโปรแกรม Launcher ได้ที่: " ..
        DownloadLauncherURL .. " หรือติดต่อผู้ดูแลระบบได้ที่: " ..
        DiscordURL

Config.Message_PlayerConnecting_ExitLauncher =
    "สถานะโปรแกรม Launcher ของคุณออฟไลน์ หรือโปรแกรมอาจถูกปิดตัวลงในขณะที่คุณอยู่ในเซิร์ฟเวอร์! กรุณาเข้าเซิร์ฟเวอร์ผ่านโปรแกรม Launcher ใหม่อีกครั้ง! สามารถดาวน์โหลดโปรแกรม Launcher ได้ที่: " ..
        DownloadLauncherURL .. " หรือติดต่อผู้ดูแลระบบได้ที่: " ..
        DiscordURL
Config.Message_PlayerConnecting_DetectedBlacklist =
    "ระบบตรวจพบไฟล์หรือโฟลเดอร์ ( %s ) ที่อยู่ใน FiveM ของคุณ ซึ่งตรงกับฐานข้อมูล Blacklist ของเซิร์ฟเวอร์ โปรดลบไฟล์หรือโฟลเดอร์ในตำแหน่งดังกล่าวออกจาก FiveM ของคุณ เพื่อให้สามารถเข้าเล่นได้อีกครั้ง! หากคุณต้องการความช่วยเหลือกรุณาติดต่อผู้ดูแลระบบได้ที่: " ..
        DiscordURL
Config.Message_PlayerConnecting_StatusNotMatch =
    "เราไม่พบข้อมูลสถานะ Launcher ของคุณ! หรือสถานะ Launcher ของคุณไม่ตรงกับที่กำหนด กรุณาเข้าเซิร์ฟเวอร์ผ่านโปรแกรม Launcher ใหม่อีกครั้ง! สามารถดาวน์โหลดโปรแกรม Launcher ได้ที่: " ..
        DownloadLauncherURL .. " หรือติดต่อผู้ดูแลระบบได้ที่: " ..
        DiscordURL
Config.Message_PlayerPlaying_NotAllowed =
    "สถานะ Launcher ของคุณปัจจุบันไม่ได้รับอนุญาตให้เข้าร่วมเซิร์ฟเวอร์! กรุณาเข้าเซิร์ฟเวอร์ผ่านโปรแกรม Launcher ใหม่อีกครั้ง! สามารถดาวน์โหลดโปรแกรม Launcher ได้ที่: " ..
        DownloadLauncherURL .. " หรือติดต่อผู้ดูแลระบบได้ที่: " ..
        DiscordURL
Config.Message_Player_Timeout =
    "หมดเวลาเชื่อมต่อเซิร์ฟเวอร์ โปรดเชื่อมต่อผ่าน Launcher ใหม่อีกครั้ง สามารถดาวน์โหลดโปรแกรม Launcher ได้ที่: " ..
        DownloadLauncherURL .. " หรือติดต่อผู้ดูแลระบบได้ที่: " ..
        DiscordURL

-- How to use API (วิธีใช้งาน API) --
-- UseSetLauncherStatusAPI เป็น API สำหรับกำหนดสถานะ Launcher ของผู้เล่นบน SQL โดยการสั่งผ่าน Launcher หรือลิ้งค์ API ดังนี้ http://127.0.0.1:30120/KC_L_S_API/setlauncherstatus?key_api=KEYAPI&steamId=STEAMHEX&status=STATUS

-- Status Launcher (สถานะของ Launcher) --
-- offline คือสถานะ Launcher ของผู้เล่นที่ออฟไลน์ หรือเป็นสถานะเริ่มต้นของ Column launcher_status ใน Table kc_launcher_service ของฐานข้อมูล Database หลัก ผู้เล่นที่มีสถานะ offline จะไม่สามารถเข้าร่วมเซิร์ฟเวอร์ได้โดยตรง จำเป็นต้องใช้โปรแกรม Launcher เพื่อเข้าเซิร์ฟเวอร์เท่านั้น
-- exitgame คือสถานะของผู้เล่นที่ Disconnect ออกจากเซิร์ฟเวอร์ ผู้เล่นที่มีสถานะ exitgame จะไม่สามารถเข้าร่วมเซิร์ฟเวอร์ได้โดยตรง จำเป็นต้องใช้โปรแกรม Launcher เพื่อเข้าเซิร์ฟเวอร์ใหม่อีกครั้ง
-- exitlauncher คือสถานะของผู้เล่นที่ปิดโปรแกรม Launcher ขณะที่ผู้เล่นคนนั้นยังอยู่ในเซิร์ฟเวอร์ ผู้เล่นที่มีสถานะ exitlauncher จะถูกเตะออกจากเซิร์ฟเวอร์ทันที และจำเป็นต้องใช้โปรแกรม Launcher เพื่อเข้าเซิร์ฟเวอร์ใหม่อีกครั้ง
-- connectbylauncher (หรือก็คือ Online) คือสถานะของผู้เล่นที่เข้าเซิร์ฟเวอร์ด้วยโปรแกรม Launcher ผู้เล่นที่มีสถานะ connectbylauncher จะสามารถเข้าเล่นบนเซิร์ฟเวอร์ได้ปกติ
-- detectedblacklist คือสถานะของผู้เล่นที่มีไฟล์ที่ตรงกันกับ Blacklist ที่อยู่ใน checkcitizen_blacklist.txt ตามที่ Admin ได้เพิ่มเอาไว้ ผู้เล่นที่มีสถานะ detectedblacklist จะไม่ได้รับอนุญาตให้เข้าร่วมเซิร์ฟเวอร์ ผู้เล่นจำเป็นต้องนำไฟล์หรือโฟลเดอร์ออกจาก FiveM ของผู้เล่นก่อนถึงจะสามารถเข้าเซิร์ฟเวอร์ได้
-- datablacklistischange คือสถานะของผู้เล่นที่แก้ไขหรือลบไฟล์ Data Blacklist ผู้เล่นที่มีสถานะ datablacklistischange จะไม่ได้รับอนุญาตให้เข้าร่วมเซิร์ฟเวอร์ และจำเป็นต้องใช้โปรแกรม Launcher เพื่อเข้าเซิร์ฟเวอร์ใหม่อีกครั้ง
-- fivemstopped คือสถานะ FiveM ของผู้เล่นที่หยุดการทำงานขณะเชื่อมต่อ Server ผู้เล่นที่มีสถานะ fivemstopped จะไม่ได้รับอนุญาตให้เข้าร่วมเซิร์ฟเวอร์และจำเป็นต้องกดเชื่อมต่อใหม่อีกครั้งเพื่อเข้าเซิร์ฟเวอร์ใหม่อีกครั้ง
-- สถานะที่นอกเหนือจากนี้ จะไม่ได้รับอนุญาตให้เข้าร่วมเซิร์ฟเวอร์

--[[
  SERVER HTTP CREATE BY https://github.com/throwarray/fivem-http-server
  SERVER HTTP EDIT BY Kroekchai KC (Fujino Ns) https://github.com/FujinoNs/KC_L_S_API
]] --
Config = {}

-- สคริปนี้ต้องการ: mysql-async

-- Service Settings (ตั้งค่า Service หลัก) --
Config.Title = "KC Launcher Service API (V3.0.0)" -- กำหนดชื่อหัวเรื่องในหน้าการแจ้งเตือนบน FiveM
Config.KeyAPI = "78CCbq36YIv7ABrR4576TtQi2tPM8g8R7AHJw9F9Pe70Jro3g2" -- โปรดกำหนด KeyAPI สำหรับการใช้งาน API
Config.EnabledLog = true -- เปิดการใช้งานแสดง Log ของ Service บน CMD เซิร์ฟเวอร์หรือไม่
Config.UseCheckStatusLauncher = true -- เปิดใช้งานระบบ ตรวจสอบสถานะ Launcher หรือไม่ (ปรับ UseSetLauncherStatusAPI เป็น true เพื่อใช้งานระบบ ตรวจสอบสถานะ Launcher และกำหนดเวลา Timeout ที่ TimeLimitLauncherOffline)
Config.TimeLimitLauncherOffline = 120 -- วินาที กำหนดเวลาสูงสุดที่อนุญาติให้ Launcher สามารถขาดการติดต่อกับ Server ได้ 60 Timeout = 1 นาที
Config.UseCheckCitizenBlacklist = true -- เปิดใช้งานระบบ ตรวจสอบไฟล์ CitizenBlacklist ของ FiveM ผู้เล่นหรือไม่ (หากใช้งานโปรดเข้าไปที่โฟลเดอร์ data ที่อยู่ในสคริปนี้ เพื่อเพิ่มรายชื่อไฟล์หรือโฟลเดอร์ต้องห้ามในไฟล์ checkcitizen_blacklist.txt)

-- API Settings (ปิด/เปิด ใช้งาน API) --
Config.UseDropPlayerAPI = false -- เปิดใช้งาน DropPlayer API หรือไม่ (ใน Database หลัก ใน Table users ต้องมี Column name ถึงจะใช้งานได้)
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
Config.Message_PlayerConnecting_FileBlacklistIsChange =
    "ระบบตรวจพบไฟล์ฐานข้อมูล Blacklist ของเซิร์ฟเวอร์ที่อยู่บน PC ของคุณถูกลบหรือถูกเปลี่ยนแปลง กรุณาอย่าเปลี่ยนแปลงหรือลบมัน! หากคุณต้องการเปลี่ยนแปลงหรือลบมันออก กรุณาติดต่อผู้ดูแลระบบได้ที่: " ..
        DiscordURL
Config.Message_PlayerConnecting_StatusNotMatch =
    "เราไม่พบข้อมูลสถานะ Launcher ของคุณ! หรือสถานะ Launcher ของคุณไม่ตรงกับที่กำหนด กรุณาเข้าเซิร์ฟเวอร์ผ่านโปรแกรม Launcher ใหม่อีกครั้ง! สามารถดาวน์โหลดโปรแกรม Launcher ได้ที่: " ..
        DownloadLauncherURL .. " หรือติดต่อผู้ดูแลระบบได้ที่: " ..
        DiscordURL
Config.Message_PlayerPlaying_NotAllowed =
    "สถานะ Launcher ของคุณปัจจุบันไม่ได้รับอนุญาตให้เข้าร่วมเซิร์ฟเวอร์! กรุณาเข้าเซิร์ฟเวอร์ผ่านโปรแกรม Launcher ใหม่อีกครั้ง! สามารถดาวน์โหลดโปรแกรม Launcher ได้ที่: " ..
        DownloadLauncherURL .. " หรือติดต่อผู้ดูแลระบบได้ที่: " ..
        DiscordURL
Config.Message_ServiceRuntimeMD5Error =
    "ระบบตรวจพบ MD5 ไฟล์ ServiceRuntimeForKCLV12.exe ไม่ตรงกับเวอร์ชั่นที่ใช้ปัจจุบัน! โปรดออกจาก FiveM และโปรแกรม Launcher และเข้าโปรแกรม Launcher ใหม่อีกครั้ง เพื่ออัพเดตโปรแกรมให้เป็นเวอร์ชั่นล่าสุดอัตโนมัติ หรือสามารถดาวน์โหลดโปรแกรม Launcher เวอร์ชั่นล่าสุดได้ที่: " ..
        DownloadLauncherURL .. " หรือติดต่อผู้ดูแลระบบได้ที่: " ..
        DiscordURL
Config.Message_ServiceRuntimeFileNotFound =
    "ระบบไม่พบไฟล์ ServiceRuntimeForKCLV12.exe โปรดออกจาก FiveM และโปรแกรม Launcher และถอนการติดตั้ง Launcher ออก และทำการติดตั้งโปรแกรม Launcher ใหม่อีกครั้ง! สามารถดาวน์โหลดโปรแกรม Launcher ได้ที่: " ..
        DownloadLauncherURL .. " หรือติดต่อผู้ดูแลระบบได้ที่: " ..
        DiscordURL
Config.Message_ServiceRuntimeStartError =
    "Launcher ไม่สามารถเริ่มการทำงานของ Service Runtime ได้! โปรดลองใหม่อีกครั้งภายหลัง หรือทำการ Restrat PC ของท่าน และลองใหม่อีกครั้ง หรือติดต่อผู้ดูแลระบบได้ที่: " ..
        DiscordURL
Config.Message_ServiceRuntimeNotRuning =
    "Service Runtime ไม่ทำงาน! โปรดลองใหม่อีกครั้งภายหลัง หรือทำการ Restrat PC ของท่าน และลองใหม่อีกครั้ง หรือติดต่อผู้ดูแลระบบได้ที่: " ..
        DiscordURL
Config.Message_ServiceRuntimeOffline =
    "ระบบตรวจพบ Service Runtime Offline! โปรดลองใหม่อีกครั้งภายหลัง หรือทำการ Restrat PC ของท่าน และลองใหม่อีกครั้ง หรือติดต่อผู้ดูแลระบบได้ที่: " ..
        DiscordURL
Config.Message_Player_Timeout =
    "หมดเวลาเชื่อมต่อเซิร์ฟเวอร์ โปรดเชื่อมต่อผ่าน Launcher ใหม่อีกครั้ง สามารถดาวน์โหลดโปรแกรม Launcher ได้ที่: " ..
        DownloadLauncherURL .. " หรือติดต่อผู้ดูแลระบบได้ที่: " ..
        DiscordURL

-- How to use API (วิธีใช้งาน API) --
-- UseDropPlayerAPI เป็น API สำหรับสั่งเตะผู้เล่นออกจากเซิร์ฟเวอร์ โดยการสั่งผ่านลิ้งค์ API ดังนี้ http://127.0.0.1:30120/KC_L_S_API/dropplayer?key_api=KEYAPI&steamId=STEAMHEX&mes=MESSAGESHOW&mescmd=MESSAGELOGSERVER
-- UseSetLauncherStatusAPI เป็น API สำหรับกำหนดสถานะ Launcher ของผู้เล่นบน SQL โดยการสั่งผ่าน Launcher หรือลิ้งค์ API ดังนี้ http://127.0.0.1:30120/KC_L_S_API/setlauncherstatus?key_api=KEYAPI&steamId=STEAMHEX&status=STATUS

-- Status Launcher (สถานะของ Launcher) --
-- offline คือสถานะ Launcher ของผู้เล่นที่ออฟไลน์ หรือเป็นสถานะเริ่มต้นของ Column launcher_status ใน Table kc_launcher_service ของฐานข้อมูล Database หลัก ผู้เล่นที่มีสถานะ offline จะไม่สามารถเข้าร่วมเซิร์ฟเวอร์ได้โดยตรง จำเป็นต้องใช้โปรแกรม Launcher เพื่อเข้าเซิร์ฟเวอร์เท่านั้น
-- exitgame คือสถานะของผู้เล่นที่ Disconnect ออกจากเซิร์ฟเวอร์ ผู้เล่นที่มีสถานะ exitgame จะไม่สามารถเข้าร่วมเซิร์ฟเวอร์ได้โดยตรง จำเป็นต้องใช้โปรแกรม Launcher เพื่อเข้าเซิร์ฟเวอร์ใหม่อีกครั้ง
-- exitlauncher คือสถานะของผู้เล่นที่ปิดโปรแกรม Launcher ขณะที่ผู้เล่นคนนั้นยังอยู่ในเซิร์ฟเวอร์ ผู้เล่นที่มีสถานะ exitlauncher จะถูกเตะออกจากเซิร์ฟเวอร์ทันที และจำเป็นต้องใช้โปรแกรม Launcher เพื่อเข้าเซิร์ฟเวอร์ใหม่อีกครั้ง
-- connectbylauncher (หรือก็คือ Online) คือสถานะของผู้เล่นที่เข้าเซิร์ฟเวอร์ด้วยโปรแกรม Launcher ผู้เล่นที่มีสถานะ connectbylauncher จะสามารถเข้าเล่นบนเซิร์ฟเวอร์ได้ปกติ
-- detectedblacklist คือสถานะของผู้เล่นที่มีไฟล์ที่ตรงกันกับ Blacklist ที่อยู่ใน checkcitizen_blacklist.txt ตามที่ Admin ได้เพิ่มเอาไว้ ผู้เล่นที่มีสถานะ detectedblacklist จะไม่ได้รับอนุญาตให้เข้าร่วมเซิร์ฟเวอร์ ผู้เล่นจำเป็นต้องนำไฟล์หรือโฟลเดอร์ออกจาก FiveM ของผู้เล่นก่อนถึงจะสามารถเข้าเซิร์ฟเวอร์ได้
-- datablacklistischange คือสถานะของผู้เล่นที่แก้ไขหรือลบไฟล์ Data Blacklist ผู้เล่นที่มีสถานะ datablacklistischange จะไม่ได้รับอนุญาตให้เข้าร่วมเซิร์ฟเวอร์ และจำเป็นต้องใช้โปรแกรม Launcher เพื่อเข้าเซิร์ฟเวอร์ใหม่อีกครั้ง
-- serviceRuntimeMD5Error คือสถานะ ServiceRuntime ของ Launcher ที่เวอร์ชั่นไม่ตรงกับปัจจุบัน ผู้เล่นที่มีสถานะ serviceRuntimeMD5Error จะไม่ได้รับอนุญาตให้เข้าร่วมเซิร์ฟเวอร์และจำเป็นต้องอัพเดตโปรแกรม Launcher ก่อนเพื่อเข้าเซิร์ฟเวอร์ใหม่อีกครั้ง
-- serviceRuntimeFileNotFound คือสถานะ ServiceRuntime ของ Launcher ที่ไม่มีไฟล์ ServiceRuntimeForKCLV12.exe ผู้เล่นที่มีสถานะ serviceRuntimeFileNotFound จะไม่ได้รับอนุญาตให้เข้าร่วมเซิร์ฟเวอร์และจำเป็นต้องอัพเดตโปรแกรม Launcher ก่อนเพื่อเข้าเซิร์ฟเวอร์ใหม่อีกครั้ง
-- serviceRuntimeStartError คือสถานะ ServiceRuntime ของ Launcher ที่ ServiceRuntime ไม่เริ่มการทำงานตามที่ควรจะเป็น ผู้เล่นที่มีสถานะ serviceRuntimeStartError จะไม่ได้รับอนุญาตให้เข้าร่วมเซิร์ฟเวอร์และจำเป็นออกจาก Launcher และเข้าใหม่ หรือ Restart PC ใหม่อีกครั้งเพื่อเข้าเซิร์ฟเวอร์ใหม่อีกครั้ง
-- serviceRuntimeNotRuning คือสถานะ ServiceRuntime ของ Launcher ที่ไม่พบการทำงานของ ServiceRuntime ผู้เล่นที่มีสถานะ serviceRuntimeNotRuning จะไม่ได้รับอนุญาตให้เข้าร่วมเซิร์ฟเวอร์และจำเป็นออกจาก Launcher และเข้าใหม่ หรือ Restart PC ใหม่อีกครั้งเพื่อเข้าเซิร์ฟเวอร์ใหม่อีกครั้ง
-- serviceRuntimeOffline คือสถานะ ServiceRuntime ของ Launcher ที่ไม่พบการทำงานของ ServiceRuntime ผู้เล่นที่มีสถานะ serviceRuntimeOffline จะไม่ได้รับอนุญาตให้เข้าร่วมเซิร์ฟเวอร์และจำเป็นออกจาก Launcher และเข้าใหม่ หรือ Restart PC ใหม่อีกครั้งเพื่อเข้าเซิร์ฟเวอร์ใหม่อีกครั้ง
-- fivemstopped คือสถานะ FiveM ของผู้เล่นที่หยุดการทำงานขณะเชื่อมต่อ Server ผู้เล่นที่มีสถานะ fivemstopped จะไม่ได้รับอนุญาตให้เข้าร่วมเซิร์ฟเวอร์และจำเป็นต้องกดเชื่อมต่อใหม่อีกครั้งเพื่อเข้าเซิร์ฟเวอร์ใหม่อีกครั้ง
-- สถานะที่นอกเหนือจากนี้ จะไม่ได้รับอนุญาตให้เข้าร่วมเซิร์ฟเวอร์

-- ระบบ Citizen Blacklist --
-- Citizen Blacklist คือระบบที่จะตรวจสอบไฟล์หรือโฟลเดอร์ใน FiveM ของผู้เล่น หากผู้เล่นมีไฟล์หรือโฟลเดอร์ที่ตรงกันกับที่ Admin เพิ่มไว้ในลิสต์ checkcitizen_blacklist.txt ผู้เล่นจะไม่สามารถเข้าเซิร์ฟเวอร์ได้

-- How to add a list of files or folders to Data Citizen Blacklist (วิธีเพิ่มรายชื่อไฟล์หรือโฟลเดอร์ใน Data Citizen Blacklist (checkcitizen_blacklist.txt)) --
-- คุณสามารถเพิ่มไฟล์หรือโฟลเดอร์ที่ต้องการ Blacklist ได้ด้วยวิธีการต่อไปนี้
-- วิธีเพิ่มโฟลเดอร์ ให้นำตำแหน่งโฟลเดอร์ที่ต้องการ Blacklist ใส่ไปในไฟล์ checkcitizen_blacklist.txt โดยสามารถเพิ่มได้ตั้งแต่ FiveM.app ลงไปทั้งหมด
-- ตัวอย่างเช่น หากต้องการ Blacklist โฟลเดอร์ action ซึ่งปกติตำแหน่งของโฟลเดอร์ action ที่อยู่ใน FiveM จะอยู่ใน C:\NAME\FiveM\FiveM.app\citizen\common\action ให้ทำการคัดลอกตั้งแต่ citizen\common\action ลงไป และนำไปใส่ในไฟล์ checkcitizen_blacklist.txt และเพิ่ม \ หลังชื่อโฟลเดอร์
-- เราจะได้ข้อความแบบนี้ citizen\common\action\ และหากต้องการเพิ่มโฟลเดอร์อีก 1 หรือ 2 หรือ 3 ให้ทำการกดปุ่ม Enter ให้ขึ้นบรรทัดใหม่ และเพิ่มโฟลเดอร์ที่ต้องต้องการเพิ่มได้เลย (ระวังอย่าใส่ต่อกันเป็นบรรทัดเดียว โปรแกรมจะไม่สามารถตรวจเจอได้ และตำแหน่งของโฟลเดอร์จะต้องถูกต้อง)

-- วิธีเพิ่มไฟล์ ให้นำตำแหน่งของไฟล์ที่ต้องการ Blacklist ใส่ไปในไฟล์ checkcitizen_blacklist.txt โดยสามารถเพิ่มได้ตั้งแต่ FiveM.app ลงไปทั้งหมด
-- ตัวอย่างเช่น หากต้องการ Blacklist ไฟล์ interrelations.meta ซึ่งปกติตำแหน่งของไฟล์ interrelations.meta ที่อยู่ใน FiveM จะอยู่ใน C:\NAME\FiveM\FiveM.app\citizen\common\action\interrelations.meta ให้ทำการคัดลอกตั้งแต่ \citizen\common\action ลงไป
-- และนำไปใส่ในไฟล์ checkcitizen_blacklist.txt และเพิ่ม \interrelations.meta หลัง \citizen\common\action  เราจะได้ข้อความแบบนี้ citizen\common\action\interrelations.meta และหากต้องการเพิ่มไฟล์อีก 1 หรือ 2 หรือ 3 ให้ทำการกดปุ่ม Enter ให้ขึ้นบรรทัดใหม่
-- และเพิ่มไฟล์ที่ต้องการเพิ่มได้เลย (ระวังอย่าใส่ต่อกันเป็นบรรทัดเดียว โปรแกรมจะไม่สามารถตรวจเจอได้ และตำแหน่งของไฟล์จะต้องถูกต้อง)

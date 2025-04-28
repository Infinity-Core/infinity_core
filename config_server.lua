--[[---------------------------------------------------------------------------------------------------------
    # CORETEAM: Shepard#1395, iiRedDev#4828
    # Website : https://infinitycore.com
    # infinitycore.COM - OFFICIAL FRAMEWORK
]]------------------------------------------------------------------------------------------------------------

-----
-- [ FRAMEWORK OPTIONS ]
-----
Config	                    = {}
Config.Debug                = false                 -- Only for devs
Config.APICheckOutdated     = true                  -- Check you [core] scripts is updated or no
Config.AntiFloodSQL         = 655                   -- Do not change this var
Config.AntiFloodSQL2        = 355                   -- Do not change this var
Config.PrintConsoleEntering = true                  -- show in your console the player enter or exit server
Config.IntervalSaveSQL      = 1                     -- Interval save sql datas (in minutes)
Config.LangManager          = "en"                  -- Current Lang Server (lang/*.lua)
Config.DisableRDOnotify     = true                  -- Remove Notifications from RDO challenges + Inventory I button (warning true add +0.2/0.3ms tick)

-----
-- [ CHAT ]
-----
Config.ProximityChatDistance = 20.0                 -- Proximity chat distance local ingame showing txt
Config.PriceAds              = 5.0                  -- Price for send ADS in Chat

-----
-- [ GLOBAL VARS ]
-----
Config.EnableWhitelist      = false
Config.Devise               = "$"
Config.DisableAutoRegen     = true
Config.EnablePVP            = true
Config.DisplayIconsCore     = true
Config.CoordsShow           = true
Config.DisableDeadEyes      = true
Config.MaxPayAmount         = 25000

-----
-- [ MAP ]
-----
Config.MapSnow              = false -- Enable map on Snow
Config.MapReveal            = true  -- Fog of War
Config.DisplayRadar         = true  -- Minimap Enabled
Config.TypeRadar            = 0     -- 0 = OFF // 1 Regular // 2 Advanced // 3 = Compass (the player use compass show entire map)
Config.TypeRadarCompass     = 1     -- Type of radar compass

-----
-- [ STAMINA CORES ]
-----
Config.RestoreStamina       = true -- If you use infinity_compt disable this
Config.MaxCoreStamina       = 10   -- Max core = 10
Config.StaminaIncreaseValue = 3    -- Increase Stamina from tick hud (1.7s add +3% Stamina)

-----
-- [ FIRST SPAWN SERVER ROLEPLAY / RPG ]
-----
Config.JobInit              = "vagabond"
Config.JobInitGrade         = 1
Config.GangInit             = "none"
Config.GangInitGrade        = 1
Config.HP                   = 100
Config.Cash                 = 500
Config.Golds                = 0.0
Config.Food                 = 100
Config.Drink                = 100
Config.InitXP               = 10

-- New Default Values for strict mode
Config.InitInventory        = '[{"amount":1,"meta":[],"name":"WEAPON_MELEE_TORCH"},{"amount":1,"meta":[],"name":"water"},{"amount":1,"meta":[],"name":"bread"}]'
--currently valentine
Config.DefaultCords         = '{"y":-7172.64,"x":1548.32,"h":360.00,"z":62.95}'
Config.DefaultSex           = 'male'
Config.DefaultRank          = 'player'
Config.DefaultBank          = 0.0
Config.DefaultBanned        = 0
Config.DefaultWhitelist     = 0
Config.DefaultCharID        = 1
Config.DefaultSource        = ''

--New Default Values for strict mode (nil values)
Config.DefaultLastname      = nil
Config.DefaultFirstname     = nil
Config.DefaultNationality   = nil
Config.DefaultYears         = 18
Config.DefaultReason        = nil
Config.DefaultLastOnline    = nil

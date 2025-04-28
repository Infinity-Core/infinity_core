--
-- [[ PLAYER CONNECTED ]]
--
FindSourceSteam = {}
function OnPlayerConnecting(playerName, setKickReason, deferrals)

    local player = source
    local SteamIdentifier
    local identifiers = GetPlayerIdentifiers(player)

    deferrals.defer()

    -- mandatory wait!
    Wait(0)

    deferrals.update(string.format("Welcome %s, Your Steam ID is being checked.", playerName))

    for _, v in pairs(identifiers) do
        if string.find(v, "steam") then
            SteamIdentifier = v
        end
        if string.find(v, "fivem") then
            FivemIdentifier = v
            break
        end
    end

    -- mandatory wait!
    Wait(1500)

    deferrals.update(string.format('Hello %s. We are checking if you are banned from server.', playerName))

    if not SteamIdentifier then
        deferrals.done("You are not connected to Steam !")
    end

    -- [[ VERIFICATION IDENTITY STEAM IN DATABASE ]] --
    if SteamIdentifier then

        deferrals.defer()
        Wait(1500)

        FindSourceSteam[player]   = SteamIdentifier
        deferrals.defer()
            deferrals.update("Loading in progress...")
            deferrals.update("Hello "..playerName..", your license [{licenseIdentifier}] is being checked");
        deferrals.defer()

        -- The player have an account
        exports.oxmysql:single('SELECT * FROM players WHERE steam_identifier = ?', {SteamIdentifier}, function(result)
            if result ~= nil then
                if result.banned == 1 then
                    deferrals.done(result.reason)
                end
                if result.whitelist == 0 and Config.EnableWhitelist then
                    WHITELIST       = false
                    deferrals.done("Your account are made, so you are not whitelisted!")
                else
                    WHITELIST = true
                end
                SteamFinded     = result.steam_identifier
            else
                SteamFinded     = nil
                WHITELIST       = false
            end

			if SteamFinded == FindSourceSteam[player] then
				connectChecked = true
			end

            deferrals.defer()
            if WHITELIST then
                if SteamIdentifier == SteamFinded and connectChecked then

                    if Config.PrintConsoleEntering then
                        print("Player "..playerName.." connected from Steam: "..SteamIdentifier.." and are find to the db")
                    end

                    Wait(Config.AntiFloodSQL)
                    TriggerClientEvent('infinity_core:loadDatasPlayer', player)
                end
            end
            -- Made Account if are not SteamFinded and make first charID
            if SteamIdentifier ~= SteamFinded  then
                if Config.PrintConsoleEntering then
                    print("MAKE ACCOUNT "..playerName.." - Steam : "..SteamIdentifier.." are not find in db, make account")
                end
                Wait(Config.AntiFloodSQL)
                exports.oxmysql:insert('INSERT INTO players (steam_identifier, fivem_identifier, hp, cash, golds, charid, job, jobgrade, gang, gangrank, xp, sex, rank, food, drink, bank, banned, whitelist, coords, inventory, lastname, firstname, nationality, years, reason, last_online) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', {
                    SteamIdentifier,
                    FivemIdentifier,
                    Config.HP,
                    Config.Cash,
                    Config.Golds,
                    Config.InitCharID,
                    Config.JobInit,
                    Config.JobInitGrade,
                    Config.GangInit,
                    Config.GangInitGrade,
                    Config.InitXP,
                    Config.DefaultSex,
                    Config.DefaultRank,
                    Config.Food,
                    Config.Drink,
                    Config.DefaultBank,
                    Config.DefaultBanned,
                    Config.DefaultWhitelist,
                    Config.DefaultCords,
                    Config.InitInventory,
                    Config.DefaultLastname,
                    Config.DefaultFirstname,
                    Config.DefaultNationality,
                    Config.DefaultYears,
                    Config.DefaultReason,
                    Config.DefaultLastOnline
                }, function(createPlayerDB)
                end)
                if WHITELIST == false and Config.EnableWhitelist then
                    deferrals.done("Your account are made, so you are not whitelisted!")
                end
            end
            deferrals.done()
        end)
    end
end
AddEventHandler("playerConnecting", OnPlayerConnecting)

-- [[ LOAD STEP 03 CHECKS ALL ACCOUNTS DB ]]
RegisterNetEvent("infinity_core:DatasPlayer")
AddEventHandler("infinity_core:DatasPlayer", function(source, temperature, kill)
    local _source       = source
    local SourceSteamID = GetPlayerSource(source)
    if SourceSteamID then
        exports.oxmysql:prepare('SELECT * FROM players WHERE steam_identifier = ?', {SourceSteamID}, function(result)
            if result ~= nil then
                exports.oxmysql:prepare('SELECT charid FROM skins_players WHERE steam_identifier = ?', {SourceSteamID}, function(totalchars)
                    if totalchars == nil then
                        TriggerEvent('infinity_skin:MakeIdentity', _source)
                    elseif totalchars then
                        TriggerClientEvent("infinity_chars:openmenu", _source, result, totalchars)
                    end
                end)
            end
        end)
    end
end)

-- [[ STEP 04 FINAL STEP LOAD ALL SESSIONS / ALL DATAS ]]
RegisterNetEvent("infinity_core:LoadDatasPlayerSelected")
AddEventHandler("infinity_core:LoadDatasPlayerSelected", function(source, CharSelected)
    local _source       = source
    local _charSelect   = CharSelected
    local SourceSteamID = GetPlayerSource(_source)
    if SourceSteamID then
        exports.oxmysql:prepare('SELECT * FROM players WHERE steam_identifier = ? AND charid = ?',
        {SourceSteamID, _charSelect}, function(result)

            local temperature   = 10
            local coords        = {
                x = json.decode(result.coords).x,
                y = json.decode(result.coords).y,
                z = json.decode(result.coords).z,
                h = json.decode(result.coords).h,
            }

            TriggerClientEvent(
                'infinity_core:hudDatas',
                _source,
                result.bank,
                result.cash,
                result.golds,
                result.xp,
                result.hp,
                temperature,
                result.food,
                result.drink,
                coords,
                result.charid
            )

            if result.charid == nil then
                charID = 1
            else
                charID = result.charid
            end

            -- Load RP Datas
            LoadPlayer(
                _source,
                charID,
                result
            )
        end)
    end
end)

--
-- [[ CHECK DTATAS LOOP FROM CLIENTSIDE ]]
--
local playerCoords  = {}
local playerID      = {}
local playerHP      = {}
local playerWater   = {}
local playerEat     = {}
local playerCharID  = {}

RegisterServerEvent("infinity_core:save_pos")
AddEventHandler("infinity_core:save_pos", function(source, x, y, z, h, water, eat, health, charid)
    local _source           = source
    playerID[_source]       = GetPlayerSource(source)
    lastPosition = {
        x = x,
        y = y,
        z = z,
        h = h
    }
    playerCoords[_source]   = json.encode(lastPosition)
    playerHP[_source]       = health
    playerWater[_source]    = water
    playerEat[_source]      = eat
    playerCharID[_source]   = charid
end)

--
-- [[ PLAYER CRASH OR QUIT OR DROPPED, SAVE PLAYER DATAS ]]
--
AddEventHandler('playerDropped',function (reason)
    local _source               = source
    local SourceSteamID         = GetPlayerSource(_source)
    local coords                = playerCoords[_source]
    local LastCharID            = playerCharID[_source]
    local PlayerLastID          = playerID[_source]
    local Life                  = playerHP[_source]
    local WaterJauge            = playerWater[_source]
    local EatJauge              = playerEat[_source]
    if SourceSteamID and LastCharID then
        local TargetDatas   = exports.infinity_core:GetPlayerTargetSession(tonumber(_source)) -- (( GET DATAS TARGET PLAYER ))
        if SourceSteamID and coords and PlayerLastID == SourceSteamID then
            if Config.PrintConsoleEntering then
                print("^6[infinitycore] The player ^0"..GetPlayerName(source).."^6 is dropped Reason: ^0"..reason)
            end
            -- Strict mode safe update: fetch DB row and merge
            exports.oxmysql:execute('SELECT * FROM players WHERE steam_identifier = ? AND charid = ?', {
                SourceSteamID,
                LastCharID
            }, function(dbRows)
                local dbRow = dbRows[1] or {}
                -- Safe Coords Coords (Valentine Sheriff Station)
                local safe_coords    = coords or dbRow.coords or Config.DefaultCords
                local safe_food      = tonumber(WaterJauge) or tonumber(dbRow.food) or Config.Food
                local safe_drink     = tonumber(EatJauge) or tonumber(dbRow.drink) or Config.Drink
                local safe_hp        = tonumber(Life) or tonumber(dbRow.hp) or Config.HP
                local safe_xp        = TargetDatas._XpT ~= nil and tonumber(TargetDatas._XpT) or tonumber(dbRow.xp) or Config.InitXP
                local safe_bank      = TargetDatas._BankT ~= nil and tonumber(TargetDatas._BankT) or tonumber(dbRow.bank) or Config.DefaultBank
                local safe_cash      = TargetDatas._CashT ~= nil and tonumber(TargetDatas._CashT) or tonumber(dbRow.cash) or Config.Cash
                local safe_golds     = TargetDatas._GoldT ~= nil and tonumber(TargetDatas._GoldT) or tonumber(dbRow.golds) or Config.Golds
                local safe_job       = TargetDatas._JobT or dbRow.job or Config.JobInit
                local safe_jobgrade  = TargetDatas._JobGradeT ~= nil and tonumber(TargetDatas._JobGradeT) or tonumber(dbRow.jobgrade) or Config.JobInitGrade
                local safe_gang      = TargetDatas._GangT or dbRow.gang or Config.GangInit
                local safe_gangrank  = TargetDatas._GangRankT ~= nil and tonumber(TargetDatas._GangRankT) or tonumber(dbRow.gangrank) or Config.GangInitGrade
                local safe_source    = SourceSteamID or dbRow.steam_identifier or Config.DefaultSource
                local safe_charid    = LastCharID or dbRow.charid or  Config.DefaultCharID
                exports.oxmysql:prepare('UPDATE players SET coords = ?, food = ?, drink = ?, hp = ?, xp = ?, bank = ?, cash = ?, golds = ?, job = ?, jobgrade = ?, gang = ?, gangrank = ? WHERE steam_identifier = ? and charid = ?', {
                    safe_coords,
                    safe_food,
                    safe_drink,
                    safe_hp,
                    safe_xp,
                    safe_bank,
                    safe_cash,
                    safe_golds,
                    safe_job,
                    safe_jobgrade,
                    safe_gang,
                    safe_gangrank,
                    safe_source,
                    safe_charid
                })
            end)
        end
    end
end)

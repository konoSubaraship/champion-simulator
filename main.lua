local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/preztel/AzureLibrary/master/uilib.lua", true))()

local MainTab = Library:CreateTab('Main', 'Champion Simulator')
local BuyTab = Library:CreateTab('Shop', 'Champion Simulator')
local HatchTab = Library:CreateTab('Hatch', 'Champion Simulator')
local MiscTab = Library:CreateTab('Misc', 'Champion Simulator')

local Tool = game.Players.LocalPlayer.Backpack:FindFirstChildWhichIsA('Tool') or game.Players.LocalPlayer.Character:FindFirstChildWhichIsA('Tool')

local WorldIndexes = {}

for i,v in pairs(require(game.ReplicatedStorage.Modules.Worlds)['Home World']) do 
    WorldIndexes[v] = i 
end 

local EggIndexes = {} 
local EggDropdown = {}

for i,v in pairs(require(game.ReplicatedStorage.Modules.Eggs)) do 
    table.insert(EggDropdown, v.Name)
    EggIndexes[v.Name] = i
end 

MainTab:CreateToggle('Auto Glove', function(t)
    if tostring(Tool.Parent) == 'Backpack' then 
        game.Players.LocalPlayer.Character.Humanoid:EquipTool(Tool)
    end 
    
    if t == false then 
        game.Players.LocalPlayer.Character.Humanoid:UnequipTools()
    end 
    
    _G.AutoGlove = t 
end) 

MainTab:CreateToggle('Auto Farm Coins', function(t)
    _G.AutoFarmCoins = t
end)

MainTab:CreateToggle('Auto Farm Gems', function(t)
    _G.AutoFarmGems = t 
end)

BuyTab:CreateToggle('Auto Buy Glove', function(t)
    _G.AutoBuyGlove = t
end)

BuyTab:CreateToggle('Auto Buy DNA', function(t)
    _G.AutoBuyDNA = t
end)

BuyTab:CreateDropDown('Select Area', require(game.ReplicatedStorage.Modules.Worlds)['Home World'], function(t)
    _G.SelectedArea = WorldIndexes[t]
end) 

HatchTab:CreateToggle('Auto Hatch Egg', function(t)
    _G.AutoHatchEgg = t 
end) 

HatchTab:CreateDropDown('Select Egg', EggDropdown, function(t)
    _G.SelectedEgg = EggIndexes[t]
end)

MiscTab:CreateButton('Infinite Jumps', function()
    game.Players.LocalPlayer.Others.DoubleJumps.Value = 9e9
end) 

task.spawn(function()
    while wait() do 
        if _G.AutoGlove then 
            Tool:Activate()
        end 
    end 
end) 

task.spawn(function()
    while wait() do 
        if _G.AutoBuyGlove and _G.SelectedArea then 
            game.ReplicatedStorage.Remotes.Events.Gloves:FireServer('purchaseall', _G.SelectedArea)
        end 
    end 
end) 

task.spawn(function()
    while wait() do 
        if _G.AutoBuyDNA and _G.SelectedArea then 
            game.ReplicatedStorage.Remotes.Events.DNA:FireServer('purchaseall', _G.SelectedArea)
        end 
    end
end)

task.spawn(function()
    while wait() do 
        if _G.AutoFarmCoins then
            for i,v in pairs(workspace.Pickups:GetChildren()) do 
                if v.Name == 'Stack' then 
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Stack:FindFirstChildWhichIsA('MeshPart').CFrame 
                elseif v.Name == 'Coin' then 
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Coin.CFrame
                end
            end 
        end
    end 
end)

task.spawn(function()
    while wait() do 
        if _G.AutoFarmGems then
            for i,v in pairs(workspace.Pickups:GetChildren()) do 
                if v.Name == 'Gem' then 
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Gem.CFrame 
                end
            end
        end 
    end 
end)

task.spawn(function()
    while wait(.1) do 
        if _G.AutoHatchEgg and _G.SelectedEgg then 
            game.ReplicatedStorage.Remotes.Functions.EggHatch:InvokeServer('single', _G.SelectedEgg)
        end 
    end 
end) 

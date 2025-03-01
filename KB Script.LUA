-- Discord UI Library
local DiscordLib = loadstring(game:HttpGet"https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/discord")()

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Camera = workspace.CurrentCamera

-- Language Settings
local language = {
    chinese = {
        windowTitle = "KB Script",
        mainSettings = "主要设置",
        characterSettings = "角色设置",
        walkSpeedSettings = "行走速度设置",
        fovSettings = "视场角(FOV)设置",
        inputSpeedPrompt = "输入速度值 (0-100)",
        inputFovPrompt = "输入FOV值 (10-120)",
        resetSpeedButton = "重置速度到默认",
        resetFovButton = "重置FOV到默认",
        presets = "预设配置",
        raceSpeed = "竞赛速度 (32)",
        slowMode = "慢速模式 (8)",
        wideAngleFov = "广角FOV (90)",
        competitiveFov = "竞技FOV (80)",
        info = "信息",
        creator = "制作者: ",
        version = "当前版本: ",
        updateTime = "更新时间: ",
        notification = "通知",
        error = "错误",
        confirm = "确定",
        speedSetTo = "速度已设置为: ",
        fovSetTo = "FOV已设置为: ",
        speedReset = "速度已重置为默认值 (16)",
        fovReset = "FOV已重置为默认值 (70)",
        invalidSpeed = "请输入0-100之间的有效数值",
        invalidFov = "请输入10-120之间的有效数值",
        speedRaceMode = "速度已设置为竞赛模式 (32)",
        speedSlowMode = "速度已设置为慢速模式 (8)",
        fovWideMode = "FOV已设置为广角模式 (90)",
        fovCompMode = "FOV已设置为竞技模式 (80)",
        language = "语言"
    },
    english = {
        windowTitle = "KB Script",
        mainSettings = "Main Settings",
        characterSettings = "Character Settings",
        walkSpeedSettings = "Walk Speed Settings",
        fovSettings = "Field of View (FOV) Settings",
        inputSpeedPrompt = "Enter Speed (0-100)",
        inputFovPrompt = "Enter FOV (10-120)",
        resetSpeedButton = "Reset Speed to Default",
        resetFovButton = "Reset FOV to Default",
        presets = "Presets",
        raceSpeed = "Race Speed (32)",
        slowMode = "Slow Mode (8)",
        wideAngleFov = "Wide Angle FOV (90)",
        competitiveFov = "Competitive FOV (80)",
        info = "Information",
        creator = "Creator: ",
        version = "Version: ",
        updateTime = "Update Time: ",
        notification = "Notification",
        error = "Error",
        confirm = "OK",
        speedSetTo = "Speed set to: ",
        fovSetTo = "FOV set to: ",
        speedReset = "Speed reset to default (16)",
        fovReset = "FOV reset to default (70)",
        invalidSpeed = "Please enter a valid number between 0-100",
        invalidFov = "Please enter a valid number between 10-120",
        speedRaceMode = "Speed set to race mode (32)",
        speedSlowMode = "Speed set to slow mode (8)",
        fovWideMode = "FOV set to wide angle mode (90)",
        fovCompMode = "FOV set to competitive mode (80)",
        language = "Language"
    }
}

-- Get saved language preference or default to Chinese
local currentLang = "chinese"
local success, savedLang = pcall(function()
    return game:GetService("HttpService"):JSONDecode(LocalPlayer:GetAttribute("KBScriptLang"))
end)
if success and savedLang then
    currentLang = savedLang
end

local function getText(key)
    return language[currentLang][key]
end

-- Create main window
local window = DiscordLib:Window(getText("windowTitle"))

-- Create main settings page
local mainPage = window:Server(getText("mainSettings"), "")

-- Create character settings channel
local characterChannel = mainPage:Channel(getText("characterSettings"))

-- Create language settings channel
local languageChannel = mainPage:Channel(getText("language"))

-- Language switcher
languageChannel:Button("English", function()
    currentLang = "english"
    LocalPlayer:SetAttribute("KBScriptLang", game:GetService("HttpService"):JSONEncode(currentLang))
    DiscordLib:Notification(getText("notification"), "Language set to English. Please reopen the script.", getText("confirm"))
    window:Close()
end)

languageChannel:Button("中文", function()
    currentLang = "chinese"
    LocalPlayer:SetAttribute("KBScriptLang", game:GetService("HttpService"):JSONEncode(currentLang))
    DiscordLib:Notification(getText("notification"), "语言已设置为中文，请重新打开脚本。", getText("confirm"))
    window:Close()
end)

-- Speed settings section
characterChannel:Label(getText("walkSpeedSettings"))
characterChannel:Textbox(getText("inputSpeedPrompt"), "", false, function(value)
    local speed = tonumber(value)
    if speed and speed >= 0 and speed <= 100 then
        if Humanoid then
            Humanoid.WalkSpeed = speed
        end
        DiscordLib:Notification(getText("notification"), getText("speedSetTo") .. speed, getText("confirm"))
    else
        DiscordLib:Notification(getText("error"), getText("invalidSpeed"), getText("confirm"))
    end
end)

-- FOV settings section
characterChannel:Label(getText("fovSettings"))
characterChannel:Textbox(getText("inputFovPrompt"), "", false, function(value)
    local fov = tonumber(value)
    if fov and fov >= 10 and fov <= 120 then
        Camera.FieldOfView = fov
        DiscordLib:Notification(getText("notification"), getText("fovSetTo") .. fov, getText("confirm"))
    else
        DiscordLib:Notification(getText("error"), getText("invalidFov"), getText("confirm"))
    end
end)

-- Reset buttons
characterChannel:Button(getText("resetSpeedButton"), function()
    if Humanoid then
        Humanoid.WalkSpeed = 16
    end
    DiscordLib:Notification(getText("notification"), getText("speedReset"), getText("confirm"))
end)

characterChannel:Button(getText("resetFovButton"), function()
    Camera.FieldOfView = 70
    DiscordLib:Notification(getText("notification"), getText("fovReset"), getText("confirm"))
end)

-- Presets channel
local presetsChannel = mainPage:Channel(getText("presets"))

-- Speed presets
presetsChannel:Button(getText("raceSpeed"), function()
    if Humanoid then
        Humanoid.WalkSpeed = 32
    end
    DiscordLib:Notification(getText("notification"), getText("speedRaceMode"), getText("confirm"))
end)

presetsChannel:Button(getText("slowMode"), function()
    if Humanoid then
        Humanoid.WalkSpeed = 8
    end
    DiscordLib:Notification(getText("notification"), getText("speedSlowMode"), getText("confirm"))
end)

-- FOV presets
presetsChannel:Button(getText("wideAngleFov"), function()
    Camera.FieldOfView = 90
    DiscordLib:Notification(getText("notification"), getText("fovWideMode"), getText("confirm"))
end)

presetsChannel:Button(getText("competitiveFov"), function()
    Camera.FieldOfView = 80
    DiscordLib:Notification(getText("notification"), getText("fovCompMode"), getText("confirm"))
end)

-- Info channel
local infoChannel = mainPage:Channel(getText("info"))

infoChannel:Label(getText("creator") .. "Baloksxin")
infoChannel:Label(getText("version") .. "v1.0.2")
infoChannel:Label(getText("updateTime") .. "2025-03-01")

-- Update character reference when respawning
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = Character:WaitForChild("Humanoid")
    if Humanoid then
        Humanoid.WalkSpeed = Humanoid.WalkSpeed
    end
end)

-- Add shortcut key support
local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.RightShift then
            window:Toggle()
        end
    end
end)

-- Discord UI Library
local DiscordLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/discord"))()

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Camera = workspace.CurrentCamera
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Initial Values Storage
local initialValues = {
    walkSpeed = nil,
    fieldOfView = nil,
    brightness = nil,
    ambient = nil,
    colorCorrection = nil
}

-- Lock Status Variables
local speedLocked = false
local fovLocked = false
local nightVisionEnabled = false
local lockedSpeed = 16
local lockedFOV = 70

-- Wallhack Status Variable
local wallHackEnabled = false

-- Infinite Jump Status Variable
local infiniteJumpEnabled = false

-- Store initial values when character loads
local function storeInitialValues()
    if Humanoid then
        initialValues.walkSpeed = Humanoid.WalkSpeed
    end
    initialValues.fieldOfView = Camera.FieldOfView
    initialValues.brightness = Lighting.Brightness
    initialValues.ambient = Lighting.Ambient
    if Lighting:FindFirstChild("ColorCorrection") then
        initialValues.colorCorrection = Lighting.ColorCorrection:Clone()
    end
end

storeInitialValues()

-- Auto-save function to persist language settings in the injector's local folder
local function autoSaveLanguage(lang)
    if writefile then
        pcall(function() 
            writefile("KBScriptLang.json", game:GetService("HttpService"):JSONEncode(lang))
        end)
    end
end

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
        resetSpeedButton = "重置速度到初始值",
        resetFovButton = "重置FOV到初始值",
        presets = "预设配置",
        raceSpeed = "竞赛速度 (32)",
        slowMode = "慢速模式 (8)",
        wideAngleFov = "广角FOV (90)",
        competitiveFov = "竞技FOV (80)",
        nightVision = "夜视功能",
        wallHack = "穿牆功能",
        infiniteJump = "無限跳躍",
        info = "信息",
        creator = "制作者: ",
        version = "当前版本: ",
        updateTime = "更新时间: ",
        notification = "通知",
        error = "错误",
        confirm = "确定",
        speedSetTo = "速度已设置为: ",
        fovSetTo = "FOV已设置为: ",
        speedReset = "速度已重置到初始值",
        fovReset = "FOV已重置到初始值",
        nightVisionEnabled = "夜视功能已启用",
        nightVisionDisabled = "夜视功能已禁用",
        invalidSpeed = "请输入0-100之间的有效数值",
        invalidFov = "请输入10-120之间的有效数值",
        speedRaceMode = "速度已设置为竞赛模式 (32)",
        speedSlowMode = "速度已设置为慢速模式 (8)",
        fovWideMode = "FOV已设置为广角模式 (90)",
        fovCompMode = "FOV已设置为竞技模式 (80)",
        wallHackEnabled = "穿牆功能已启用",
        wallHackDisabled = "穿牆功能已禁用",
        infiniteJumpEnabled = "無限跳躍已啟用",
        infiniteJumpDisabled = "無限跳躍已禁用",
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
        resetSpeedButton = "Reset Speed to Initial",
        resetFovButton = "Reset FOV to Initial",
        presets = "Presets",
        raceSpeed = "Race Speed (32)",
        slowMode = "Slow Mode (8)",
        wideAngleFov = "Wide Angle FOV (90)",
        competitiveFov = "Competitive FOV (80)",
        nightVision = "Night Vision",
        wallHack = "Wall Hack",
        infiniteJump = "Infinite Jump",
        info = "Information",
        creator = "Creator: ",
        version = "Version",
        updateTime = "Update Time",
        notification = "Notification",
        error = "Error",
        confirm = "OK",
        speedSetTo = "Speed set to: ",
        fovSetTo = "FOV set to: ",
        speedReset = "Speed reset to initial value",
        fovReset = "FOV reset to initial value",
        nightVisionEnabled = "Night Vision Enabled",
        nightVisionDisabled = "Night Vision Disabled",
        invalidSpeed = "Please enter a valid number between 0-100",
        invalidFov = "Please enter a valid number between 10-120",
        speedRaceMode = "Speed set to race mode (32)",
        speedSlowMode = "Speed set to slow mode (8)",
        fovWideMode = "FOV set to wide angle mode (90)",
        fovCompMode = "FOV set to competitive mode (80)",
        wallHackEnabled = "Wall Hack Enabled",
        wallHackDisabled = "Wall Hack Disabled",
        infiniteJumpEnabled = "Infinite Jump Enabled",
        infiniteJumpDisabled = "Infinite Jump Disabled",
        language = "Language"
    }
}

local currentLang = "chinese"
local savedLang = nil

-- Try to read the saved language from the local file first
if readfile then
    pcall(function()
        savedLang = game:GetService("HttpService"):JSONDecode(readfile("KBScriptLang.json"))
    end)
end

if savedLang then
    currentLang = savedLang
else
    -- Fallback: use player's attribute, if available
    local attr = LocalPlayer:GetAttribute("KBScriptLang")
    if attr then
        pcall(function()
            currentLang = game:GetService("HttpService"):JSONDecode(attr)
        end)
    end
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

-- Helper function to update notifications and, if needed, other UI elements after language change.
local function updateLanguage(newLang)
    currentLang = newLang
    LocalPlayer:SetAttribute("KBScriptLang", game:GetService("HttpService"):JSONEncode(currentLang))
    autoSaveLanguage(currentLang)
    DiscordLib:Notification(getText("notification"), "Language set to " .. newLang, getText("confirm"))
    -- Optionally update other UI texts if supported by the library.
end

-- Language switcher button for English
languageChannel:Button("English", function()
    updateLanguage("english")
end)

-- Language switcher button for Chinese
languageChannel:Button("中文", function()
    updateLanguage("chinese")
end)

-- Speed settings section
characterChannel:Label(getText("walkSpeedSettings"))
characterChannel:Textbox(getText("inputSpeedPrompt"), "", false, function(value)
    if speedLocked then return end
    local speed = tonumber(value)
    if speed and speed >= 0 and speed <= 100 then
        if Humanoid then
            Humanoid.WalkSpeed = speed
            lockedSpeed = speed
        end
        DiscordLib:Notification(getText("notification"), getText("speedSetTo") .. speed, getText("confirm"))
    else
        DiscordLib:Notification(getText("error"), getText("invalidSpeed"), getText("confirm"))
    end
end)

-- FOV settings section
characterChannel:Label(getText("fovSettings"))
characterChannel:Textbox(getText("inputFovPrompt"), "", false, function(value)
    if fovLocked then return end
    local fov = tonumber(value)
    print("Attempting to set FOV to:", fov) -- Debug print
    if fov and fov >= 10 and fov <= 120 then
        Camera.FieldOfView = fov
        lockedFOV = fov
        print("FOV set to:", fov) -- Debug print
        DiscordLib:Notification(getText("notification"), getText("fovSetTo") .. fov, getText("confirm"))
    else
        print("Invalid FOV value:", fov) -- Debug print
        DiscordLib:Notification(getText("error"), getText("invalidFov"), getText("confirm"))
    end
end)

-- Lock toggles
characterChannel:Toggle("锁定速度", false, function(value)
    speedLocked = value
    if speedLocked then
        lockedSpeed = Humanoid.WalkSpeed
        DiscordLib:Notification(getText("notification"), "速度已锁定", getText("confirm"))
    else
        DiscordLib:Notification(getText("notification"), "速度已解锁", getText("confirm"))
    end
end)

characterChannel:Toggle("锁定FOV", false, function(value)
    fovLocked = value
    if fovLocked then
        lockedFOV = Camera.FieldOfView
        DiscordLib:Notification(getText("notification"), "FOV已锁定", getText("confirm"))
    else
        DiscordLib:Notification(getText("notification"), "FOV已解锁", getText("confirm"))
    end
end)

-- Night vision toggle
characterChannel:Toggle(getText("nightVision"), false, function(value)
    nightVisionEnabled = value
    if nightVisionEnabled then
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        if not Lighting:FindFirstChild("ColorCorrection") then
            local colorCorrection = Instance.new("ColorCorrectionEffect")
            colorCorrection.Name = "ColorCorrection"
            colorCorrection.Parent = Lighting
        end
        Lighting.ColorCorrection.TintColor = Color3.fromRGB(255, 255, 255)
        DiscordLib:Notification(getText("notification"), getText("nightVisionEnabled"), getText("confirm"))
    else
        Lighting.Brightness = initialValues.brightness
        Lighting.Ambient = initialValues.ambient
        if Lighting:FindFirstChild("ColorCorrection") then
            Lighting.ColorCorrection:Destroy()
        end
        if initialValues.colorCorrection then
            initialValues.colorCorrection.Parent = Lighting
        end
        DiscordLib:Notification(getText("notification"), getText("nightVisionDisabled"), getText("confirm"))
    end
end)

-- Wall Hack toggle
local function updateWallHack(character)
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not wallHackEnabled
        end
    end
end

characterChannel:Toggle(getText("wallHack"), false, function(value)
    wallHackEnabled = value
    updateWallHack(Character)
    if wallHackEnabled then
        DiscordLib:Notification(getText("notification"), getText("wallHackEnabled"), getText("confirm"))
    else
        DiscordLib:Notification(getText("notification"), getText("wallHackDisabled"), getText("confirm"))
    end
end)

-- Infinite Jump toggle
characterChannel:Toggle(getText("infiniteJump"), false, function(value)
    infiniteJumpEnabled = value
    if infiniteJumpEnabled then
        DiscordLib:Notification(getText("notification"), getText("infiniteJumpEnabled"), getText("confirm"))
    else
        DiscordLib:Notification(getText("notification"), getText("infiniteJumpDisabled"), getText("confirm"))
    end
end)

-- Listen for jump requests to implement infinite jump
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Continuous application of night vision settings to counter resets
RunService.RenderStepped:Connect(function()
    if nightVisionEnabled then
        if Lighting.Brightness ~= 2 then
            Lighting.Brightness = 2
        end
        if Lighting.Ambient ~= Color3.fromRGB(255, 255, 255) then
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        end
        if not Lighting:FindFirstChild("ColorCorrection") then
            local colorCorrection = Instance.new("ColorCorrectionEffect")
            colorCorrection.Name = "ColorCorrection"
            colorCorrection.Parent = Lighting
            colorCorrection.TintColor = Color3.fromRGB(255, 255, 255)
        elseif Lighting.ColorCorrection.TintColor ~= Color3.fromRGB(255, 255, 255) then
            Lighting.ColorCorrection.TintColor = Color3.fromRGB(255, 255, 255)
        end
    end
    -- Force FOV update
    Camera.FieldOfView = lockedFOV
end)

-- Reset buttons with initial values
characterChannel:Button(getText("resetSpeedButton"), function()
    if speedLocked then return end
    if Humanoid and initialValues.walkSpeed then
        Humanoid.WalkSpeed = initialValues.walkSpeed
        lockedSpeed = initialValues.walkSpeed
    end
    DiscordLib:Notification(getText("notification"), getText("speedReset"), getText("confirm"))
end)

characterChannel:Button(getText("resetFovButton"), function()
    if fovLocked then return end
    if initialValues.fieldOfView then
        Camera.FieldOfView = initialValues.fieldOfView
        lockedFOV = initialValues.fieldOfView
    end
    DiscordLib:Notification(getText("notification"), getText("fovReset"), getText("confirm"))
end)

-- Presets channel
local presetsChannel = mainPage:Channel(getText("presets"))
presetsChannel:Button(getText("raceSpeed"), function()
    if speedLocked then return end
    if Humanoid then
        Humanoid.WalkSpeed = 32
        lockedSpeed = 32
    end
    DiscordLib:Notification(getText("notification"), getText("speedRaceMode"), getText("confirm"))
end)
presetsChannel:Button(getText("slowMode"), function()
    if speedLocked then return end
    if Humanoid then
        Humanoid.WalkSpeed = 8
        lockedSpeed = 8
    end
    DiscordLib:Notification(getText("notification"), getText("speedSlowMode"), getText("confirm"))
end)
presetsChannel:Button(getText("wideAngleFov"), function()
    if fovLocked then return end
    Camera.FieldOfView = 90
    lockedFOV = 90
    DiscordLib:Notification(getText("notification"), getText("fovWideMode"), getText("confirm"))
end)
presetsChannel:Button(getText("competitiveFov"), function()
    if fovLocked then return end
    Camera.FieldOfView = 80
    lockedFOV = 80
    DiscordLib:Notification(getText("notification"), getText("fovCompMode"), getText("confirm"))
end)

-- Info channel
local infoChannel = mainPage:Channel(getText("info"))
infoChannel:Label(getText("creator") .. "Baloksxin")
infoChannel:Label(getText("version") .. "v1.1.0")
infoChannel:Label(getText("updateTime") .. "2025-03-02 01:00:14")

-- Update locks periodically
RunService.Heartbeat:Connect(function()
    if speedLocked and Humanoid and Humanoid.WalkSpeed ~= lockedSpeed then
        Humanoid.WalkSpeed = lockedSpeed
    end
    if fovLocked and Camera.FieldOfView ~= lockedFOV then
        Camera.FieldOfView = lockedFOV
    end
end)

-- Update character reference when respawning
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = Character:WaitForChild("Humanoid")
    if not initialValues.walkSpeed then
        storeInitialValues()
    end
    if Humanoid then
        if speedLocked then
            Humanoid.WalkSpeed = lockedSpeed
        end
    end
    -- Reapply wallhack if enabled on respawn
    updateWallHack(Character)
end)

-- Shortcut key support to toggle the main window with RightShift
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.RightShift then
            window:Toggle()
        end
    end
end)

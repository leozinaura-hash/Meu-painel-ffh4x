--[[
    PAINEL FFH4X PREMIUM (VERSÃO COM BLOQUEIO TROLL)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local MarketplaceService = game:GetService("MarketplaceService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ==========================================
-- SISTEMA DE BANIMENTO (BLACKLIST TROLL)
-- ==========================================
local BannedUsers = {
    [11276489999] = true, -- COLOQUE O ID DO SEU AMIGO AQUI (Sem aspas, só os números)
    -- Para banir mais alguém, coloque uma vírgula e o ID na linha de baixo:
    -- [987654321] = true,
}

if BannedUsers[LocalPlayer.UserId] then
    -- Cria a tela de banimento
    local BanGui = Instance.new("ScreenGui")
    BanGui.Name = "BanGui"
    BanGui.ResetOnSpawn = false
    BanGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    local BanFrame = Instance.new("Frame")
    BanFrame.Size = UDim2.new(0, 350, 0, 120)
    BanFrame.Position = UDim2.new(0.5, -175, 0.5, -60)
    BanFrame.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
    BanFrame.Parent = BanGui
    Instance.new("UICorner", BanFrame).CornerRadius = UDim.new(0, 8)
    
    local BanStroke = Instance.new("UIStroke", BanFrame)
    BanStroke.Color = Color3.fromRGB(255, 0, 0)
    BanStroke.Thickness = 3
    
    local BanText = Instance.new("TextLabel")
    BanText.Size = UDim2.new(1, 0, 1, 0)
    BanText.BackgroundTransparency = 1
    BanText.Text = "🚫 O DONO TE BANIU DO PAINEL 🚫"
    BanText.TextColor3 = Color3.fromRGB(255, 0, 0)
    BanText.Font = Enum.Font.GothamBlack
    BanText.TextSize = 22
    BanText.Parent = BanFrame
    
    -- Toca um som de erro pra dar um susto
    local Sound = Instance.new("Sound")
    Sound.SoundId = "rbxassetid://131961136" 
    Sound.Volume = 2
    Sound.Parent = BanGui
    Sound:Play()
    
    task.wait(5) -- Espera 5 segundos e apaga a tela
    BanGui:Destroy()
    return 
end
-- ==========================================

-- Limpar painel antigo
pcall(function()
    if CoreGui:FindFirstChild("FFH4X_Leoo") then CoreGui.FFH4X_Leoo:Destroy() end
    if LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("FFH4X_Leoo") then LocalPlayer.PlayerGui.FFH4X_Leoo:Destroy() end
end)

-- ==========================================
-- SEU WEBHOOK CONFIGURADO AQUI
-- ==========================================
local WebhookURL = "https://discord.com/api/webhooks/1569140933772054620/w0PCVX7daT3A4W9SGfXj0-YK-ILYwiECZHamwvYRXs10WDXSBDHaLIR1lR_B-vLaB62t"

-- ==========================================
-- CONFIGURAÇÃO DAS KEYS
-- ==========================================
local KeysTable = {
    ["ffh4x-vip-leozin"] = { type = "perm" },
    ["lz-op-ffh4x"] = { type = "perm" },
    ["premium-acess-077"] = { type = "perm" },
    ["premium-access-077"] = { type = "perm" },
    ["lz-free-ffh4x"] = { type = "temp", duration = 3600 } 
}

-- ==========================================
-- VARIÁVEIS GLOBAIS
-- ==========================================
local FOVColor, ESPColor, HitboxColor = Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 0, 0)

local AimAtivado, SnapAtivado, RageAtivado = false, false, false
local ESPAtivado, ESPLinha, ESPBox, ESPNome, ESPVida, ESPEsqueleto, ESPArma, HitboxAtivada = false, false, false, false, false, false, false, false
local AimTargetPart, AimFOV, AimSmooth, MaxDistance = "Head", 120, 0.4, 600
local ESPBoxSize = 1.0
local HitboxSize, ModoInsta, AntiAFK, BypassAntiCheat = 60, false, false, false
local InfJumpAtivado, NoClipAtivado, SpinAtivado, FlyAtivado = false, false, false, false
local CurrentSpeed, CurrentJump, SpinSpeed, FlySpeed = 16, 50, 50, 50
local GeloInvertidoAtivado, GelosInvertidos, SpinAngle = false, {}, 0

-- ==========================================
-- INTERFACE GRÁFICA
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FFH4X_Leoo"
ScreenGui.ResetOnSpawn = false
local parentSuccess = pcall(function() ScreenGui.Parent = CoreGui end)
if not parentSuccess then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- BOTÕES FLUTUANTES DO FLY
local BtnFlyUp = Instance.new("TextButton")
BtnFlyUp.Size = UDim2.new(0, 60, 0, 60); BtnFlyUp.Position = UDim2.new(1, -90, 0.5, -80)
BtnFlyUp.BackgroundColor3 = Color3.fromRGB(200, 0, 0); BtnFlyUp.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnFlyUp.Text = "CIMA"; BtnFlyUp.Font = Enum.Font.GothamBold; BtnFlyUp.TextSize = 16; BtnFlyUp.Visible = false
BtnFlyUp.Parent = ScreenGui; Instance.new("UICorner", BtnFlyUp).CornerRadius = UDim.new(1, 0)

local BtnFlyDown = Instance.new("TextButton")
BtnFlyDown.Size = UDim2.new(0, 60, 0, 60); BtnFlyDown.Position = UDim2.new(1, -90, 0.5, 10)
BtnFlyDown.BackgroundColor3 = Color3.fromRGB(200, 0, 0); BtnFlyDown.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnFlyDown.Text = "BAIXO"; BtnFlyDown.Font = Enum.Font.GothamBold; BtnFlyDown.TextSize = 16; BtnFlyDown.Visible = false
BtnFlyDown.Parent = ScreenGui; Instance.new("UICorner", BtnFlyDown).CornerRadius = UDim.new(1, 0)

local flyUpPressed, flyDownPressed = false, false
BtnFlyUp.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then flyUpPressed = true end end)
BtnFlyUp.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then flyUpPressed = false end end)
BtnFlyDown.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then flyDownPressed = true end end)
BtnFlyDown.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then flyDownPressed = false end end)

local FOVCircle = Instance.new("Frame")
FOVCircle.BackgroundTransparency = 1; FOVCircle.Size = UDim2.new(0, 200, 0, 200)
FOVCircle.Position = UDim2.new(0.5, -100, 0.5, -100); FOVCircle.Visible = false; FOVCircle.Parent = ScreenGui
Instance.new("UICorner", FOVCircle).CornerRadius = UDim.new(1, 0)
local CircleStroke = Instance.new("UIStroke", FOVCircle); CircleStroke.Color = FOVColor; CircleStroke.Thickness = 2

-- TELA DE KEY
local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 280, 0, 200); KeyFrame.Position = UDim2.new(0.5, -140, 0.5, -100)
KeyFrame.BackgroundColor3 = Color3.fromRGB(10, 5, 5); KeyFrame.Parent = ScreenGui
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 8)
local KeyStroke = Instance.new("UIStroke", KeyFrame); KeyStroke.Color = Color3.fromRGB(200, 0, 0); KeyStroke.Thickness = 2

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40); Title.BackgroundTransparency = 1
Title.Text = "FFH4X PREMIUM"; Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Font = Enum.Font.GothamBold; Title.TextSize = 24; Title.Parent = KeyFrame

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0, 220, 0, 45); TextBox.Position = UDim2.new(0.5, -110, 0, 60)
TextBox.BackgroundColor3 = Color3.fromRGB(25, 10, 10); TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.PlaceholderText = "Digite a Key..."; TextBox.Font = Enum.Font.GothamBold; TextBox.TextSize = 16; TextBox.Parent = KeyFrame
Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 4)

local BtnValidar = Instance.new("TextButton")
BtnValidar.Size = UDim2.new(0, 220, 0, 45); BtnValidar.Position = UDim2.new(0.5, -110, 0, 120)
BtnValidar.BackgroundColor3 = Color3.fromRGB(150, 0, 0); BtnValidar.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnValidar.Text = "VALIDAR KEY"; BtnValidar.Font = Enum.Font.GothamBold; BtnValidar.TextSize = 16; BtnValidar.Parent = KeyFrame
Instance.new("UICorner", BtnValidar).CornerRadius = UDim.new(0, 4)

local MiniBtn = Instance.new("TextButton")
MiniBtn.Size = UDim2.new(0, 50, 0, 50); MiniBtn.Position = UDim2.new(0, 20, 0.5, -25)
MiniBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0); MiniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniBtn.Text = "FF"; MiniBtn.Font = Enum.Font.GothamBold; MiniBtn.TextSize = 20
MiniBtn.Visible = false; MiniBtn.Active = true; MiniBtn.Draggable = true; MiniBtn.Parent = ScreenGui
Instance.new("UICorner", MiniBtn).CornerRadius = UDim.new(1, 0)

-- PAINEL PRINCIPAL
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 650, 0, 420); MainFrame.Position = UDim2.new(0.5, -325, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 8); MainFrame.Visible = false
MainFrame.ClipsDescendants = true; MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local MainStroke = Instance.new("UIStroke", MainFrame); MainStroke.Color = Color3.fromRGB(150, 0, 0); MainStroke.Thickness = 2

-- HEADER
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 100); Header.BackgroundColor3 = Color3.fromRGB(5, 5, 5); Header.Parent = MainFrame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

local TextFFH4X = Instance.new("TextLabel")
TextFFH4X.Size = UDim2.new(0, 200, 0, 50); TextFFH4X.Position = UDim2.new(0, 60, 0, 5)
TextFFH4X.BackgroundTransparency = 1; TextFFH4X.Text = "FFH4X"; TextFFH4X.TextColor3 = Color3.fromRGB(255, 0, 0)
TextFFH4X.Font = Enum.Font.GothamBlack; TextFFH4X.TextSize = 42; TextFFH4X.TextXAlignment = Enum.TextXAlignment.Left; TextFFH4X.Parent = Header
local StrokeFFH4X = Instance.new("UIStroke", TextFFH4X); StrokeFFH4X.Color = Color3.fromRGB(0, 0, 0); StrokeFFH4X.Thickness = 2

local TextPremium = Instance.new("TextLabel")
TextPremium.Size = UDim2.new(0, 200, 0, 30); TextPremium.Position = UDim2.new(0, 60, 0, 45)
TextPremium.BackgroundTransparency = 1; TextPremium.Text = "PREMIUM"; TextPremium.TextColor3 = Color3.fromRGB(255, 255, 255)
TextPremium.Font = Enum.Font.GothamBlack; TextPremium.TextSize = 24; TextPremium.TextXAlignment = Enum.TextXAlignment.Left; TextPremium.Parent = Header
local StrokePremium = Instance.new("UIStroke", TextPremium); StrokePremium.Color = Color3.fromRGB(0, 0, 0); StrokePremium.Thickness = 2

local VertLine = Instance.new("Frame")
VertLine.Size = UDim2.new(0, 3, 0, 60); VertLine.Position = UDim2.new(0, 230, 0, 20)
VertLine.BackgroundColor3 = Color3.fromRGB(200, 0, 0); VertLine.BorderSizePixel = 0; VertLine.Parent = Header

local TextDev = Instance.new("TextLabel")
TextDev.Size = UDim2.new(0, 250, 0, 25); TextDev.Position = UDim2.new(0, 250, 0, 20)
TextDev.BackgroundTransparency = 1; TextDev.Text = "Desenvolvido por:"; TextDev.TextColor3 = Color3.fromRGB(200, 200, 200)
TextDev.Font = Enum.Font.GothamBold; TextDev.TextSize = 14; TextDev.TextXAlignment = Enum.TextXAlignment.Left; TextDev.Parent = Header

local TextDevName = Instance.new("TextLabel")
TextDevName.Size = UDim2.new(0, 150, 0, 25); TextDevName.Position = UDim2.new(0, 250, 0, 45)
TextDevName.BackgroundTransparency = 1; TextDevName.Text = "@Lz_scripts-077"; TextDevName.TextColor3 = Color3.fromRGB(255, 0, 0)
TextDevName.Font = Enum.Font.GothamBold; TextDevName.TextSize = 16; TextDevName.TextXAlignment = Enum.TextXAlignment.Left; TextDevName.Parent = Header

local DomineContainer = Instance.new("Frame")
DomineContainer.Size = UDim2.new(0, 170, 0, 85); DomineContainer.Position = UDim2.new(0, 390, 0, 5)
DomineContainer.BackgroundTransparency = 1; DomineContainer.Parent = Header

local CrownLabel = Instance.new("TextLabel")
CrownLabel.Size = UDim2.new(1, 0, 0, 30); CrownLabel.Position = UDim2.new(0, 0, 0, -5)
CrownLabel.BackgroundTransparency = 1; CrownLabel.Text = "v"; CrownLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
CrownLabel.Font = Enum.Font.GothamBlack; CrownLabel.TextSize = 24; CrownLabel.Parent = DomineContainer

local DomineText = Instance.new("TextLabel")
DomineText.Size = UDim2.new(1, 0, 0, 20); DomineText.Position = UDim2.new(0, 0, 0, 22)
DomineText.BackgroundTransparency = 1; DomineText.Text = "DOMINE O JOGO"; DomineText.TextColor3 = Color3.fromRGB(255, 255, 255)
DomineText.Font = Enum.Font.GothamBlack; DomineText.TextSize = 14; DomineText.Parent = DomineContainer

local ComText = Instance.new("TextLabel")
ComText.Size = UDim2.new(1, 0, 0, 20); ComText.Position = UDim2.new(0, 0, 0, 42)
ComText.BackgroundTransparency = 1; ComText.Text = '<font color="rgb(255,255,255)">COM </font><font color="rgb(255,0,0)">FFH4X</font>'
ComText.RichText = true; ComText.Font = Enum.Font.GothamBlack; ComText.TextSize = 14; ComText.Parent = DomineContainer

local BtnMinimize = Instance.new("TextButton")
BtnMinimize.Size = UDim2.new(0, 30, 0, 30); BtnMinimize.Position = UDim2.new(1, -75, 0, 15)
BtnMinimize.BackgroundColor3 = Color3.fromRGB(20, 20, 20); BtnMinimize.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnMinimize.Text = "-"; BtnMinimize.Font = Enum.Font.GothamBold; BtnMinimize.TextSize = 20; BtnMinimize.ZIndex = 5; BtnMinimize.Parent = Header
Instance.new("UICorner", BtnMinimize).CornerRadius = UDim.new(0, 4)

local BtnClose = Instance.new("TextButton")
BtnClose.Size = UDim2.new(0, 30, 0, 30); BtnClose.Position = UDim2.new(1, -40, 0, 15)
BtnClose.BackgroundColor3 = Color3.fromRGB(150, 0, 0); BtnClose.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnClose.Text = "X"; BtnClose.Font = Enum.Font.GothamBold; BtnClose.TextSize = 16; BtnClose.ZIndex = 5; BtnClose.Parent = Header
Instance.new("UICorner", BtnClose).CornerRadius = UDim.new(0, 4)

local HorizLine = Instance.new("Frame")
HorizLine.Size = UDim2.new(1, -20, 0, 2); HorizLine.Position = UDim2.new(0, 10, 0, 100)
HorizLine.BackgroundColor3 = Color3.fromRGB(100, 0, 0); HorizLine.BorderSizePixel = 0; HorizLine.Parent = MainFrame

local DragBar = Instance.new("Frame")
DragBar.Size = UDim2.new(1, 0, 0, 100); DragBar.Position = UDim2.new(0, 0, 0, 0)
DragBar.BackgroundTransparency = 1; DragBar.Active = true; DragBar.ZIndex = 1; DragBar.Parent = Header

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 160, 1, -135); Sidebar.Position = UDim2.new(0, 0, 0, 105)
Sidebar.BackgroundColor3 = Color3.fromRGB(8, 8, 8); Sidebar.Parent = MainFrame
local SideStroke = Instance.new("UIStroke", Sidebar); SideStroke.Color = Color3.fromRGB(50, 0, 0); SideStroke.Thickness = 1.5
local SidebarLayout = Instance.new("UIListLayout"); SidebarLayout.Padding = UDim.new(0, 8); SidebarLayout.Parent = Sidebar
Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0, 10)

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -160, 1, -135); ContentArea.Position = UDim2.new(0, 160, 0, 105)
ContentArea.BackgroundColor3 = Color3.fromRGB(10, 10, 10); ContentArea.Parent = MainFrame

local Pages = {}; local TabButtons = {}
local function CreatePage(name)
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -20, 1, -20); page.Position = UDim2.new(0, 10, 0, 10)
    page.BackgroundTransparency = 1; page.ScrollBarThickness = 4; page.ScrollBarImageColor3 = Color3.fromRGB(200, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y; page.Visible = false; page.Parent = ContentArea
    Pages[name] = page
end
local function CreateTabButton(name, layoutOrder)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40); btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    btn.TextColor3 = Color3.fromRGB(180, 180, 180); btn.Text = "  " .. name; btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15; btn.TextXAlignment = Enum.TextXAlignment.Left; btn.LayoutOrder = layoutOrder; btn.Parent = Sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function()
        for _, b in pairs(TabButtons) do TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(15, 15, 15), TextColor3 = Color3.fromRGB(180, 180, 180)}):Play() end
        for _, p in pairs(Pages) do p.Visible = false end
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(150, 0, 0), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        if Pages[name] then Pages[name].Visible = true end
    end)
    table.insert(TabButtons, btn)
end

CreatePage("Inicio"); CreatePage("Aimbot"); CreatePage("Visual"); CreatePage("Player"); CreatePage("Misc")
CreateTabButton("Inicio", 1); CreateTabButton("Aimbot", 2); CreateTabButton("Visual", 3); CreateTabButton("Player", 4); CreateTabButton("Misc", 5)
TabButtons[1].BackgroundColor3 = Color3.fromRGB(150, 0, 0); TabButtons[1].TextColor3 = Color3.fromRGB(255, 255, 255); Pages["Inicio"].Visible = true

-- FUNÇÕES DE UI
local function CreateSection(parent, text, yPos)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 30); lbl.Position = UDim2.new(0, 0, 0, yPos)
    lbl.BackgroundTransparency = 1; lbl.Text = text; lbl.TextColor3 = Color3.fromRGB(255, 50, 50)
    lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 18; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = parent
end
local function CreateToggle(parent, text, yPos, default, callback)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 40); holder.Position = UDim2.new(0, 0, 0, yPos)
    holder.BackgroundColor3 = Color3.fromRGB(15, 15, 15); holder.Parent = parent
    Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 6)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0); label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1; label.Text = text; label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold; label.TextSize = 15; label.TextXAlignment = Enum.TextXAlignment.Left; label.Parent = holder
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 45, 0, 22); toggleBtn.Position = UDim2.new(1, -55, 0.5, -11)
    toggleBtn.BackgroundColor3 = default and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(40, 40, 40)
    toggleBtn.Text = ""; toggleBtn.Parent = holder
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18); knob.Position = default and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255); knob.Parent = toggleBtn
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local isEnabled = default
    toggleBtn.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        if isEnabled then TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 0, 0)}):Play(); TweenService:Create(knob, TweenInfo.new(0.2), {Position = UDim2.new(1, -20, 0.5, -9)}):Play()
        else TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play(); TweenService:Create(knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -9)}):Play() end
        callback(isEnabled)
    end)
end
local function CreateSlider(parent, text, yPos, min, max, default, callback)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 50); holder.Position = UDim2.new(0, 0, 0, yPos)
    holder.BackgroundColor3 = Color3.fromRGB(15, 15, 15); holder.Parent = parent
    Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 6)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 0, 20); label.Position = UDim2.new(0, 15, 0, 5)
    label.BackgroundTransparency = 1; label.Text = text; label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold; label.TextSize = 15; label.TextXAlignment = Enum.TextXAlignment.Left; label.Parent = holder
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 40, 0, 20); valueLabel.Position = UDim2.new(1, -55, 0, 5)
    valueLabel.BackgroundTransparency = 1; valueLabel.Text = max <= 10 and string.format("%.2f", default) or tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(255, 50, 50); valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 15; valueLabel.TextXAlignment = Enum.TextXAlignment.Right; valueLabel.Parent = holder
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -30, 0, 8); bar.Position = UDim2.new(0, 15, 0, 32)
    bar.BackgroundColor3 = Color3.fromRGB(40, 40, 40); bar.Parent = holder
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 4)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0); fill.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    fill.Parent = bar; Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 4)
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16); knob.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255); knob.Parent = bar
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local dragging = false
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local percent = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(percent, 0, 1, 0); knob.Position = UDim2.new(percent, -8, 0.5, -8)
            local val = (percent * (max - min)) + min
            if max <= 10 then valueLabel.Text = string.format("%.2f", val) else val = math.floor(val); valueLabel.Text = tostring(val) end
            callback(val)
        end
    end)
end
local function CreateColorPicker(parent, text, yPos, callback)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 55); holder.Position = UDim2.new(0, 0, 0, yPos)
    holder.BackgroundColor3 = Color3.fromRGB(15, 15, 15); holder.Parent = parent
    Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 6)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20); label.Position = UDim2.new(0, 15, 0, 5)
    label.BackgroundTransparency = 1; label.Text = text; label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold; label.TextSize = 15; label.TextXAlignment = Enum.TextXAlignment.Left; label.Parent = holder
    local colors = {Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 0, 255), Color3.fromRGB(200, 0, 255), Color3.fromRGB(255, 255, 0), Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 255, 255)}
    local btnContainer = Instance.new("Frame")
    btnContainer.Size = UDim2.new(1, -30, 0, 20); btnContainer.Position = UDim2.new(0, 15, 0, 30)
    btnContainer.BackgroundTransparency = 1; btnContainer.Parent = holder
    Instance.new("UIListLayout", btnContainer).FillDirection = Enum.FillDirection.Horizontal
    btnContainer.UIListLayout.Padding = UDim.new(0, 10)
    for _, c in ipairs(colors) do
        local colorBtn = Instance.new("TextButton")
        colorBtn.Size = UDim2.new(0, 20, 0, 20); colorBtn.BackgroundColor3 = c; colorBtn.Text = ""
        colorBtn.Parent = btnContainer; Instance.new("UICorner", colorBtn).CornerRadius = UDim.new(1, 0)
        colorBtn.MouseButton1Click:Connect(function() callback(c) end)
    end
end
local function CreateButton(parent, text, yPos, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40); btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.BackgroundColor3 = color or Color3.fromRGB(150, 0, 0); btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text; btn.Font = Enum.Font.GothamBold; btn.TextSize = 15; btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback); return btn
end

-- ABA INICIO
CreateSection(Pages["Inicio"], "Informacoes", 5)
local GameName = "Desconhecido"; pcall(function() GameName = MarketplaceService:GetProductInfo(game.PlaceId).Name end)
local infoFrame = Instance.new("Frame"); infoFrame.Size = UDim2.new(1, 0, 0, 140); infoFrame.Position = UDim2.new(0, 0, 0, 35)
infoFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15); infoFrame.Parent = Pages["Inicio"]; Instance.new("UICorner", infoFrame).CornerRadius = UDim.new(0, 6)
local function CreateInfoText(title, text, yPos, color)
    local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(1, -20, 0, 25); lbl.Position = UDim2.new(0, 15, 0, yPos)
    lbl.BackgroundTransparency = 1; lbl.Text = title .. ": " .. text; lbl.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 15; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = infoFrame
end
CreateInfoText("Nick", LocalPlayer.Name, 15); CreateInfoText("Jogo", GameName, 45)
local lblKeyType = Instance.new("TextLabel"); lblKeyType.Size = UDim2.new(1, -20, 0, 25); lblKeyType.Position = UDim2.new(0, 15, 0, 75)
lblKeyType.BackgroundTransparency = 1; lblKeyType.Text = "Key: Nao Autenticada"; lblKeyType.TextColor3 = Color3.fromRGB(255, 50, 50)
lblKeyType.Font = Enum.Font.GothamBold; lblKeyType.TextSize = 15; lblKeyType.TextXAlignment = Enum.TextXAlignment.Left; lblKeyType.Parent = infoFrame
local lblKeyTime = Instance.new("TextLabel"); lblKeyTime.Size = UDim2.new(1, -20, 0, 25); lblKeyTime.Position = UDim2.new(0, 15, 0, 105)
lblKeyTime.BackgroundTransparency = 1; lblKeyTime.Text = "Validade: --"; lblKeyTime.TextColor3 = Color3.fromRGB(200, 200, 200)
lblKeyTime.Font = Enum.Font.GothamBold; lblKeyTime.TextSize = 15; lblKeyTime.TextXAlignment = Enum.TextXAlignment.Left; lblKeyTime.Parent = infoFrame
CreateInfoText("Dev", "@Lz_scripts-077", 135, Color3.fromRGB(255, 50, 50))

-- ABA AIMBOT
CreateSection(Pages["Aimbot"], "Aimbot", 5)
CreateToggle(Pages["Aimbot"], "Ativar Aimbot", 40, false, function(v) AimAtivado = v; FOVCircle.Visible = v end)
CreateToggle(Pages["Aimbot"], "Snap (Mira Travada)", 80, false, function(v) SnapAtivado = v end)
CreateToggle(Pages["Aimbot"], "Rage (Auto Atirar)", 120, false, function(v) RageAtivado = v end)
CreateSlider(Pages["Aimbot"], "FOV", 165, 50, 500, 120, function(v) AimFOV = v; FOVCircle.Size = UDim2.new(0, AimFOV, 0, AimFOV); FOVCircle.Position = UDim2.new(0.5, -(AimFOV/2), 0.5, -(AimFOV/2)) end)
CreateSlider(Pages["Aimbot"], "Smooth", 220, 0.1, 1.0, 0.40, function(v) AimSmooth = v end)
CreateSlider(Pages["Aimbot"], "Distancia Maxima", 275, 100, 1000, 600, function(v) MaxDistance = v end)

CreateSection(Pages["Aimbot"], "Escolher Alvo", 330)
local TargetFrame = Instance.new("Frame"); TargetFrame.Size = UDim2.new(1, 0, 0, 180); TargetFrame.Position = UDim2.new(0, 0, 0, 360)
TargetFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15); TargetFrame.Parent = Pages["Aimbot"]
Instance.new("UICorner", TargetFrame).CornerRadius = UDim.new(0, 6); Instance.new("UIStroke", TargetFrame).Color = Color3.fromRGB(100, 0, 0)
local BtnColumn = Instance.new("Frame"); BtnColumn.Size = UDim2.new(0, 140, 1, 0); BtnColumn.Position = UDim2.new(0, 10, 0, 0)
BtnColumn.BackgroundTransparency = 1; BtnColumn.Parent = TargetFrame
Instance.new("UIListLayout", BtnColumn).Padding = UDim.new(0, 10); Instance.new("UIPadding", BtnColumn).PaddingTop = UDim.new(0, 15)

local ModelContainer = Instance.new("Frame"); ModelContainer.Size = UDim2.new(0, 100, 0, 160); ModelContainer.Position = UDim2.new(1, -110, 0.5, -80)
ModelContainer.BackgroundTransparency = 1; ModelContainer.Parent = TargetFrame
local HeadUI = Instance.new("Frame"); HeadUI.Size = UDim2.new(0, 30, 0, 30); HeadUI.Position = UDim2.new(0.5, -15, 0, 5)
HeadUI.BackgroundColor3 = Color3.fromRGB(245, 205, 48); HeadUI.Parent = ModelContainer; Instance.new("UICorner", HeadUI).CornerRadius = UDim.new(1, 0)
local TorsoUI = Instance.new("Frame"); TorsoUI.Size = UDim2.new(0, 40, 0, 45); TorsoUI.Position = UDim2.new(0.5, -20, 0, 40)
TorsoUI.BackgroundColor3 = Color3.fromRGB(0, 162, 255); TorsoUI.Parent = ModelContainer; Instance.new("UICorner", TorsoUI).CornerRadius = UDim.new(0, 4)
local LeftLeg = Instance.new("Frame"); LeftLeg.Size = UDim2.new(0, 18, 0, 50); LeftLeg.Position = UDim2.new(0.5, -20, 0, 90)
LeftLeg.BackgroundColor3 = Color3.fromRGB(75, 151, 75); LeftLeg.Parent = ModelContainer; Instance.new("UICorner", LeftLeg).CornerRadius = UDim.new(0, 4)
local RightLeg = Instance.new("Frame"); RightLeg.Size = UDim2.new(0, 18, 0, 50); RightLeg.Position = UDim2.new(0.5, 2, 0, 90)
RightLeg.BackgroundColor3 = Color3.fromRGB(75, 151, 75); RightLeg.Parent = ModelContainer; Instance.new("UICorner", RightLeg).CornerRadius = UDim.new(0, 4)

local function UpdateDummyColors(part)
    HeadUI.BackgroundColor3 = Color3.fromRGB(245, 205, 48); TorsoUI.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    LeftLeg.BackgroundColor3 = Color3.fromRGB(75, 151, 75); RightLeg.BackgroundColor3 = Color3.fromRGB(75, 151, 75)
    if part == "Head" then HeadUI.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    elseif part == "Torso" then TorsoUI.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    elseif part == "Legs" then LeftLeg.BackgroundColor3 = Color3.fromRGB(255, 0, 0); RightLeg.BackgroundColor3 = Color3.fromRGB(255, 0, 0) end
end
local function CreateTargetBtn(text, partName)
    local btn = Instance.new("TextButton"); btn.Size = UDim2.new(1, 0, 0, 30); btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.Text = text; btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.Font = Enum.Font.GothamBold; btn.TextSize = 14; btn.Parent = BtnColumn
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function() AimTargetPart = partName; UpdateDummyColors(partName) end)
end
CreateTargetBtn("Cabeca", "Head"); CreateTargetBtn("Tronco", "Torso"); CreateTargetBtn("Pernas", "Legs"); UpdateDummyColors("Head")

-- ABA VISUAL
CreateSection(Pages["Visual"], "ESP", 5)
CreateToggle(Pages["Visual"], "Ativar ESP", 40, false, function(v) ESPAtivado = v end)
CreateToggle(Pages["Visual"], "ESP Linha", 80, false, function(v) ESPLinha = v end)
CreateToggle(Pages["Visual"], "ESP Box", 120, false, function(v) ESPBox = v end)
CreateToggle(Pages["Visual"], "ESP Nome", 160, false, function(v) ESPNome = v end)
CreateToggle(Pages["Visual"], "ESP Vida", 200, false, function(v) ESPVida = v end)
CreateToggle(Pages["Visual"], "ESP Arma", 240, false, function(v) ESPArma = v end)
CreateToggle(Pages["Visual"], "ESP Esqueleto", 280, false, function(v) ESPEsqueleto = v end)
CreateColorPicker(Pages["Visual"], "Cor dos ESP:", 320, function(c) ESPColor = c; FOVColor = c; CircleStroke.Color = c end)
CreateSlider(Pages["Visual"], "Tamanho do Box", 380, 0.5, 3.0, 1.0, function(v) ESPBoxSize = v end)

CreateSection(Pages["Visual"], "Hitbox", 430)
CreateToggle(Pages["Visual"], "Ativar Hitbox", 460, false, function(v) HitboxAtivada = v end)
CreateSlider(Pages["Visual"], "Tamanho da Hitbox", 500, 10, 100, 60, function(v) HitboxSize = v end)

-- ABA PLAYER
CreateSection(Pages["Player"], "Movimentacao", 5)
CreateSlider(Pages["Player"], "Speed", 35, 16, 250, 16, function(v) CurrentSpeed = v end)
CreateSlider(Pages["Player"], "Jump", 90, 50, 300, 50, function(v) CurrentJump = v end)
CreateToggle(Pages["Player"], "Infinite Jump", 145, false, function(v) InfJumpAtivado = v end)
CreateToggle(Pages["Player"], "No Clip", 190, false, function(v) 
    NoClipAtivado = v
    if LocalPlayer.Character then for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = not v end end end
end)

CreateSection(Pages["Player"], "Hacks", 235)
CreateToggle(Pages["Player"], "Ativar Fly", 265, false, function(v) FlyAtivado = v; BtnFlyUp.Visible = v; BtnFlyDown.Visible = v end)
CreateSlider(Pages["Player"], "Velocidade do Fly", 310, 10, 200, 50, function(v) FlySpeed = v end)
CreateToggle(Pages["Player"], "Ativar Spin Bot", 360, false, function(v) SpinAtivado = v end)
CreateSlider(Pages["Player"], "Velocidade do Spin", 405, 10, 300, 50, function(v) SpinSpeed = v end)

-- ABA MISC
CreateSection(Pages["Misc"], "Outras Funcoes", 5)
CreateToggle(Pages["Misc"], "Modo Insta", 40, false, function(v) ModoInsta = v end)
CreateToggle(Pages["Misc"], "Anti AFK", 80, false, function(v) AntiAFK = v end)
CreateToggle(Pages["Misc"], "BYPASS Anti-Cheat", 120, false, function(v) BypassAntiCheat = v end)

local btnGelo = Instance.new("TextButton")
btnGelo.Size = UDim2.new(1, 0, 0, 40); btnGelo.Position = UDim2.new(0, 0, 0, 170)
btnGelo.BackgroundColor3 = Color3.fromRGB(0, 150, 0); btnGelo.TextColor3 = Color3.fromRGB(255, 255, 255)
btnGelo.Text = "Gelo: NORMAL"; btnGelo.Font = Enum.Font.GothamBold; btnGelo.TextSize = 14
btnGelo.Parent = Pages["Misc"]; Instance.new("UICorner", btnGelo).CornerRadius = UDim.new(0, 6)

local geloNormal = true
btnGelo.MouseButton1Click:Connect(function()
    geloNormal = not geloNormal
    if geloNormal then btnGelo.Text = "Gelo: NORMAL"; btnGelo.BackgroundColor3 = Color3.fromRGB(0, 150, 0); GeloInvertidoAtivado = false
        for gelo, originalCFrame in pairs(GelosInvertidos) do if gelo and gelo.Parent then gelo.CFrame = originalCFrame end end; GelosInvertidos = {}
    else btnGelo.Text = "Gelo: INVERTIDO"; btnGelo.BackgroundColor3 = Color3.fromRGB(150, 0, 0); GeloInvertidoAtivado = true end
end)

CreateButton(Pages["Misc"], "PANIC BUTTON (DESLIGAR TUDO)", 230, Color3.fromRGB(255, 0, 0), function()
    AimAtivado = false; SnapAtivado = false; RageAtivado = false
    ESPAtivado = false; ESPLinha = false; ESPBox = false; ESPNome = false; ESPVida = false; ESPEsqueleto = false; ESPArma = false
    HitboxAtivada = false; SpinAtivado = false; FlyAtivado = false; ModoInsta = false; NoClipAtivado = false
    btnGelo.Text = "Gelo: NORMAL"; btnGelo.BackgroundColor3 = Color3.fromRGB(0, 150, 0); GeloInvertidoAtivado = false
    for gelo, originalCFrame in pairs(GelosInvertidos) do if gelo and gelo.Parent then gelo.CFrame = originalCFrame end end; GelosInvertidos = {}
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 16; hum.JumpPower = 50 end
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and hrp:FindFirstChild("FFH4X_Fly") then hrp.FFH4X_Fly:Destroy() end
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = true end end
    end
    MainFrame.Visible = false; MiniBtn.Visible = true; MiniBtn.BackgroundTransparency = 0.95; MiniBtn.TextTransparency = 0.95
    BtnFlyUp.Visible = false; BtnFlyDown.Visible = false
end)

-- ARRASTAR
local dragging, dragInput, dragStart, startPos
DragBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
DragBar.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ==========================================
-- SISTEMA DE LOG NO DISCORD
-- ==========================================
local function EnviarLog()
    local Dados = {
        ["content"] = "🚨 **NOVO USUÁRIO NO PAINEL!** 🚨",
        ["embeds"] = {{
            ["title"] = "FFH4X PREMIUM",
            ["color"] = 16711680,
            ["fields"] = {
                {["name"] = "👤 Nick:", ["value"] = LocalPlayer.Name, ["inline"] = true},
                {["name"] = "🆔 ID:", ["value"] = tostring(LocalPlayer.UserId), ["inline"] = true},
                {["name"] = "🎮 Jogo:", ["value"] = tostring(game.PlaceId), ["inline"] = false},
                {["name"] = "🔑 Key Usada:", ["value"] = TextBox.Text, ["inline"] = false}
            },
            ["footer"] = {["text"] = "Lz Scripts - " .. os.date("%d/%m/%Y %H:%M:%S")}
        }}
    }

    local JSONDados = HttpService:JSONEncode(Dados)

    pcall(function()
        if request then
            request({Url = WebhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = JSONDados})
        elseif syn and syn.request then
            syn.request({Url = WebhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = JSONDados})
        elseif http_request then
            http_request({Url = WebhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = JSONDados})
        end
    end)
end

-- ==========================================
-- VALIDAR KEY (COM SISTEMA DE TEMPO CORRIGIDO)
-- ==========================================
local function VerificarKey()
    TextBox:ReleaseFocus()
    local key = string.lower(TextBox.Text):gsub("%s+", "")
    
    if KeysTable[key] then
        if KeysTable[key].type == "temp" then
            local timeFile = "FFH4X_Time_" .. key .. ".txt"
            local tempoAtual = os.time()
            local successTime, savedTime = pcall(function() return readfile(timeFile) end)
            
            if successTime and savedTime and savedTime ~= "" then
                local dataExpiracao = tonumber(savedTime)
                if tempoAtual > dataExpiracao then
                    TextBox.Text = ""
                    TextBox.PlaceholderText = "Key Expirada! (Tempo acabou)"
                    return
                else
                    local formatada = os.date("%d/%m/%Y %H:%M:%S", dataExpiracao)
                    lblKeyType.Text = "Key: Temporaria"
                    lblKeyType.TextColor3 = Color3.fromRGB(255, 200, 0)
                    lblKeyTime.Text = "Validade: " .. formatada
                end
            else
                local dataExpiracao = tempoAtual + KeysTable[key].duration
                pcall(function() writefile(timeFile, tostring(dataExpiracao)) end)
                local formatada = os.date("%d/%m/%Y %H:%M:%S", dataExpiracao)
                lblKeyType.Text = "Key: Temporaria"
                lblKeyType.TextColor3 = Color3.fromRGB(255, 200, 0)
                lblKeyTime.Text = "Validade: " .. formatada
            end
        else
            lblKeyType.Text = "Key: Permanente"
            lblKeyType.TextColor3 = Color3.fromRGB(50, 255, 50)
            lblKeyTime.Text = "Validade: Nunca Expira"
        end
        
        EnviarLog() 
        
        KeyFrame.Visible = false; MainFrame.Visible = true
    else
        TextBox.Text = ""; TextBox.PlaceholderText = "Key Incorreta! Tente de novo."
    end
end
BtnValidar.MouseButton1Click:Connect(VerificarKey)
TextBox.FocusLost:Connect(function(enterPressed) if enterPressed then VerificarKey() end end)

BtnMinimize.MouseButton1Click:Connect(function() MainFrame.Visible = false; MiniBtn.Visible = true; MiniBtn.BackgroundTransparency = 0.85; MiniBtn.TextTransparency = 0.85 end)
BtnClose.MouseButton1Click:Connect(function() MainFrame.Visible = false; MiniBtn.Visible = true; MiniBtn.BackgroundTransparency = 0.85; MiniBtn.TextTransparency = 0.85 end)
MiniBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true; MiniBtn.Visible = false; MiniBtn.BackgroundTransparency = 0; MiniBtn.TextTransparency = 0 end)

-- ==========================================
-- SISTEMA DE PULO INFINITO
-- ==========================================
UserInputService.JumpRequest:Connect(function()
    if InfJumpAtivado and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- Função para achar a parte do corpo correta (R6 e R15)
local function GetTargetPart(character, partName)
    if partName == "Head" then return character:FindFirstChild("Head")
    elseif partName == "Torso" then return character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
    elseif partName == "Legs" then return character:FindFirstChild("LeftUpperLeg") or character:FindFirstChild("Left Leg")
    end
    return character:FindFirstChild("HumanoidRootPart")
end

-- LOOP PRINCIPAL
local hasDrawing = pcall(function() return Drawing.new("Line") end)
local ESP_Objects = {}

-- CONEXÃO PARA O NOCLIP
RunService.Stepped:Connect(function()
    if NoClipAtivado and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    local centroTela = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local MeuChar = LocalPlayer.Character
    local MeuHum = MeuChar and MeuChar:FindFirstChildOfClass("Humanoid")

    -- Hacks Locais
    if MeuHum then 
        if ModoInsta then MeuHum.WalkSpeed = 100; MeuHum.JumpPower = 100 else MeuHum.WalkSpeed = CurrentSpeed; MeuHum.UseJumpPower = true; MeuHum.JumpPower = CurrentJump end
    end

    if SpinAtivado and MeuChar then
        local hrp = MeuChar:FindFirstChild("HumanoidRootPart")
        if hrp then SpinAngle = SpinAngle + math.rad(SpinSpeed); hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, SpinAngle, 0) end
    end

    if FlyAtivado and MeuChar and MeuHum then
        local hrp = MeuChar:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bv = hrp:FindFirstChild("FFH4X_Fly") or Instance.new("BodyVelocity", hrp)
            bv.Name = "FFH4X_Fly"; bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            local velY = flyUpPressed and FlySpeed or (flyDownPressed and -FlySpeed or 0)
            bv.Velocity = (MeuHum.MoveDirection * FlySpeed) + Vector3.new(0, velY, 0)
        end
    elseif MeuChar then
        local hrp = MeuChar:FindFirstChild("HumanoidRootPart")
        if hrp and hrp:FindFirstChild("FFH4X_Fly") then hrp.FFH4X_Fly:Destroy() end
    end

    if GeloInvertidoAtivado then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Material == Enum.Material.Ice or string.find(string.lower(obj.Name), "gelo") or string.find(string.lower(obj.Name), "ice")) then
                if not GelosInvertidos[obj] then GelosInvertidos[obj] = obj.CFrame; obj.CFrame = obj.CFrame * CFrame.Angles(0, math.rad(180), 0) end
            end
        end
    end

    -- Aimbot Logic
    local closestTarget = nil; local shortestDist = AimFOV
    if AimAtivado then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local targetPart = GetTargetPart(player.Character, AimTargetPart)
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                
                if targetPart and hum and hum.Health > 0 then
                    local distFromMe = (Camera.CFrame.Position - targetPart.Position).Magnitude
                    if distFromMe <= MaxDistance then
                        local posTela, naTela = Camera:WorldToViewportPoint(targetPart.Position)
                        if naTela and posTela.Z > 0 then
                            local dist = (Vector2.new(posTela.X, posTela.Y) - centroTela).Magnitude
                            if dist < shortestDist then shortestDist = dist; closestTarget = targetPart end
                        end
                    end
                end
            end
        end
        
        if closestTarget then 
            if SnapAtivado then Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestTarget.Position)
            else Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, closestTarget.Position), AimSmooth) end

            if RageAtivado and MeuChar then
                local tool = MeuChar:FindFirstChildOfClass("Tool")
                if tool then
                    pcall(function() tool:Activate() end)
                end
            end
        end
    end

    -- ESP e Hitbox Logic
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local head = char:FindFirstChild("Head")
            
            if hum and hum.Health > 0 and hrp and head then
                local hitbox = char:FindFirstChild("FFH4X_Box")
                if HitboxAtivada then
                    if not hitbox then
                        hitbox = Instance.new("Highlight", char); hitbox.Name = "FFH4X_Box"
                        hitbox.FillTransparency = 0.7; hitbox.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        hrp.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize); hrp.Transparency = 0.5; hrp.CanCollide = false
                    end
                    hitbox.FillColor = HitboxColor; hitbox.OutlineColor = HitboxColor; hrp.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                elseif hitbox then
                    hitbox:Destroy(); hrp.Size = Vector3.new(2, 2, 1); hrp.Transparency = 1; hrp.CanCollide = true
                end

                if hasDrawing and ESPAtivado then
                    if not ESP_Objects[player] then 
                        ESP_Objects[player] = {Line = Drawing.new("Line"), Box = Drawing.new("Square"), Name = Drawing.new("Text"), Health = Drawing.new("Text"), Weapon = Drawing.new("Text"), Skel = {Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line")}}
                    end
                    local esp = ESP_Objects[player]
                    
                    local headPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    local isVisible = onScreen and headPos.Z > 0

                    if isVisible then
                        if ESPLinha then
                            local sp, _ = Camera:WorldToViewportPoint(head.Position)
                            esp.Line.Visible = true; esp.Line.Color = ESPColor; esp.Line.Thickness = 1.5; esp.Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y); esp.Line.To = Vector2.new(sp.X, sp.Y)
                        else esp.Line.Visible = false end

                        if ESPBox then
                            local sp, _ = Camera:WorldToViewportPoint(hrp.Position)
                            local footPos, _ = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                            local boxHeight = math.abs(headPos.Y - footPos.Y) * ESPBoxSize; local boxWidth = boxHeight * 0.6
                            esp.Box.Visible = true; esp.Box.Color = ESPColor; esp.Box.Thickness = 1.5; esp.Box.Size = Vector2.new(boxWidth, boxHeight); esp.Box.Position = Vector2.new(headPos.X - boxWidth/2, headPos.Y)
                        else esp.Box.Visible = false end

                        if ESPNome then
                            local sp, _ = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 2.5, 0))
                            esp.Name.Visible = true; esp.Name.Color = Color3.fromRGB(255,255,255); esp.Name.Size = 14; esp.Name.Center = true; esp.Name.Outline = true; esp.Name.Position = Vector2.new(sp.X, sp.Y); esp.Name.Text = player.Name
                        else esp.Name.Visible = false end

                        if ESPVida then
                            local sp, _ = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1.5, 0))
                            esp.Health.Visible = true; esp.Health.Color = Color3.fromRGB(0,255,0); esp.Health.Size = 14; esp.Health.Center = true; esp.Health.Outline = true; esp.Health.Position = Vector2.new(sp.X, sp.Y); esp.Health.Text = "HP: " .. math.floor(hum.Health)
                        else esp.Health.Visible = false end
                        
                        if ESPArma then
                            local tool = char:FindFirstChildOfClass("Tool"); local weaponName = tool and tool.Name or "Maos"
                            local sp, _ = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 3.8, 0))
                            esp.Weapon.Visible = true; esp.Weapon.Color = Color3.fromRGB(255, 200, 0); esp.Weapon.Size = 14; esp.Weapon.Center = true; esp.Weapon.Outline = true; esp.Weapon.Position = Vector2.new(sp.X, sp.Y); esp.Weapon.Text = "[" .. weaponName .. "]"
                        else esp.Weapon.Visible = false end
                        
                        if ESPEsqueleto then
                            local torso = GetTargetPart(char, "Torso")
                            local lArm = char:FindFirstChild("LeftHand") or char:FindFirstChild("Left Arm")
                            local rArm = char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm")
                            local lLeg = char:FindFirstChild("LeftFoot") or char:FindFirstChild("Left Leg")
                            local rLeg = char:FindFirstChild("RightFoot") or char:FindFirstChild("Right Leg")
                            
                            if torso and head then
                                local torsoPos, tOn = Camera:WorldToViewportPoint(torso.Position)
                                local lArmPos, laOn = Camera:WorldToViewportPoint(lArm and lArm.Position or torso.Position + Vector3.new(-1,0,0))
                                local rArmPos, raOn = Camera:WorldToViewportPoint(rArm and rArm.Position or torso.Position + Vector3.new(1,0,0))
                                local lLegPos, llOn = Camera:WorldToViewportPoint(lLeg and lLeg.Position or torso.Position + Vector3.new(-1,-1,0))
                                local rLegPos, rlOn = Camera:WorldToViewportPoint(rLeg and rLeg.Position or torso.Position + Vector3.new(1,-1,0))

                                local function SetSkel(line, p1, o1, p2, o2)
                                    if o1 and o2 and p1.Z > 0 and p2.Z > 0 then
                                        line.Visible = true; line.Color = ESPColor; line.Thickness = 1.5; line.From = Vector2.new(p1.X, p1.Y); line.To = Vector2.new(p2.X, p2.Y)
                                    else line.Visible = false end
                                end
                                SetSkel(esp.Skel[1], headPos, onScreen, torsoPos, tOn); SetSkel(esp.Skel[2], torsoPos, tOn, lArmPos, laOn); SetSkel(esp.Skel[3], torsoPos, tOn, rArmPos, raOn); SetSkel(esp.Skel[4], torsoPos, tOn, lLegPos, llOn); SetSkel(esp.Skel[5], torsoPos, tOn, rLegPos, rlOn)
                            else for _, l in ipairs(esp.Skel) do l.Visible = false end end
                        else
                            if ESP_Objects[player] then for _, l in ipairs(ESP_Objects[player].Skel) do l.Visible = false end end
                        end
                    else
                        esp.Line.Visible = false; esp.Box.Visible = false; esp.Name.Visible = false; esp.Health.Visible = false; esp.Weapon.Visible = false
                        for _, l in ipairs(esp.Skel) do l.Visible = false end
                    end
                else
                    if ESP_Objects[player] then
                        ESP_Objects[player].Line.Visible = false; ESP_Objects[player].Box.Visible = false; ESP_Objects[player].Name.Visible = false; ESP_Objects[player].Health.Visible = false; ESP_Objects[player].Weapon.Visible = false
                        for _, l in ipairs(ESP_Objects[player].Skel) do l.Visible = false end
                    end
                end
            end
        end
    end
end)

-- Limpar ESP quando o jogador sair
Players.PlayerRemoving:Connect(function(player)
    if ESP_Objects[player] then
        for _, obj in pairs(ESP_Objects[player]) do
            if typeof(obj) == "table" then for _, line in pairs(obj) do line:Remove() end
            else obj:Remove() end
        end
        ESP_Objects[player] = nil
    end
end)

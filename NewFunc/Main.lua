-- UILibrary.lua (Updated: Removed manual scaling, added section background blocks, and optimized scrolling canvas boundaries)

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local UILibrary = {}
UILibrary.__index = UILibrary
local TabMeta = {}
TabMeta.__index = TabMeta

function UILibrary:CreateWindow(config)
    config = config or {}
    local title = config.Title or "UI Library"
    local desc = config.Desc or ""
    local iconId = config.Icon or "rbxassetid://6031094678"
    local keybind = config.Keybind or Enum.KeyCode.RightShift

    local targetParent = Players.LocalPlayer:WaitForChild("PlayerGui")
    pcall(function()
        for _, child in ipairs(targetParent:GetChildren()) do
            if child.Name == "UILibrary_Main" or child.Name == "UILibrary_Notifications" or child.Name == "UILibrary_FloatingIcon" then
                child:Destroy()
            end
        end
    end)
    pcall(function()
        for _, child in ipairs(CoreGui:GetChildren()) do
            if child.Name == "UILibrary_Main" or child.Name == "UILibrary_Notifications" or child.Name == "UILibrary_FloatingIcon" then
                child:Destroy()
            end
        end
    end)

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UILibrary_Main"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    if typeof(protectgui) == "function" then
        pcall(protectgui, ScreenGui)
    elseif typeof(syn) == "table" and typeof((syn :: any).protect_gui) == "function" then
        pcall((syn :: any).protect_gui, ScreenGui)
    end
    ScreenGui.Parent = targetParent

    local NotifGui = Instance.new("ScreenGui")
    NotifGui.Name = "UILibrary_Notifications"
    NotifGui.ResetOnSpawn = false
    if typeof(protectgui) == "function" then
        pcall(protectgui, NotifGui)
    elseif typeof(syn) == "table" and typeof((syn :: any).protect_gui) == "function" then
        pcall((syn :: any).protect_gui, NotifGui)
    end
    NotifGui.Parent = targetParent

    local NotifHolder = Instance.new("Frame")
    NotifHolder.Name = "NotifHolder"
    NotifHolder.Size = UDim2.new(0, 310, 1, -40)
    NotifHolder.Position = UDim2.new(1, -325, 0, 20)
    NotifHolder.BackgroundTransparency = 1
    NotifHolder.Parent = NotifGui

    local NotifLayout = Instance.new("UIListLayout")
    NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    NotifLayout.Padding = UDim.new(0, 10)
    NotifLayout.Parent = NotifHolder

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 520, 0, 380)
    MainFrame.Position = UDim2.new(0.5, -260, 0.5, -190)
    MainFrame.BackgroundColor3 = Color3.fromRGB(11, 17, 32)
    MainFrame.BackgroundTransparency = 1 
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    MainFrame.Size = UDim2.new(0, 460, 0, 340)
    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 520, 0, 380),
        BackgroundTransparency = 0.1
    }):Play()

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(56, 189, 248)
    MainStroke.Transparency = 0.4
    MainStroke.Thickness = 1.5
    MainStroke.Parent = MainFrame

    local GlowFrame = Instance.new("Frame")
    GlowFrame.Name = "GlowFrame"
    GlowFrame.Size = UDim2.new(0, 532, 0, 392)
    GlowFrame.Position = UDim2.new(0.5, -266, 0.5, -196)
    GlowFrame.BackgroundColor3 = Color3.fromRGB(14, 165, 233)
    GlowFrame.BackgroundTransparency = 1
    GlowFrame.BorderSizePixel = 0
    GlowFrame.ZIndex = MainFrame.ZIndex - 1
    GlowFrame.Parent = ScreenGui

    TweenService:Create(GlowFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.75
    }):Play()

    local GlowCorner = Instance.new("UICorner")
    GlowCorner.CornerRadius = UDim.new(0, 14)
    GlowCorner.Parent = GlowFrame

    local GlowStroke = Instance.new("UIStroke")
    GlowStroke.Color = Color3.fromRGB(56, 189, 248)
    GlowStroke.Transparency = 0.3
    GlowStroke.Thickness = 4
    GlowStroke.Parent = GlowFrame

    local BottomGlowBar = Instance.new("Frame")
    BottomGlowBar.Name = "BottomGlowBar"
    BottomGlowBar.Size = UDim2.new(1, -24, 0, 3)
    BottomGlowBar.Position = UDim2.new(0, 12, 1, -5)
    BottomGlowBar.BackgroundColor3 = Color3.fromRGB(56, 189, 248)
    BottomGlowBar.BorderSizePixel = 0
    BottomGlowBar.Parent = GlowFrame

    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = BottomGlowBar

    local headerHeight = 54
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, headerHeight)
    Header.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
    Header.BackgroundTransparency = 0.2
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 10)
    HeaderCorner.Parent = Header

    local dragging, dragInput, dragStart, startPos, startGlowPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            startGlowPos = GlowFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            GlowFrame.Position = UDim2.new(startGlowPos.X.Scale, startGlowPos.X.Offset + delta.X, startGlowPos.Y.Scale, startGlowPos.Y.Offset + delta.Y)
        end
    end)

    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 26, 0, 26)
    CloseButton.Position = UDim2.new(1, -34, 0, 14)
    CloseButton.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
    CloseButton.BackgroundTransparency = 0.2
    CloseButton.BorderSizePixel = 0
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 11
    CloseButton.Parent = Header

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton

    local CollapseButton = Instance.new("TextButton")
    CollapseButton.Size = UDim2.new(0, 26, 0, 26)
    CollapseButton.Position = UDim2.new(1, -66, 0, 14)
    CollapseButton.BackgroundColor3 = Color3.fromRGB(14, 165, 233)
    CollapseButton.BackgroundTransparency = 0.2
    CollapseButton.BorderSizePixel = 0
    CollapseButton.Font = Enum.Font.GothamBold
    CollapseButton.Text = "🗜"
    CollapseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CollapseButton.TextSize = 11
    CollapseButton.Parent = Header

    local CollapseCorner = Instance.new("UICorner")
    CollapseCorner.CornerRadius = UDim.new(0, 6)
    CollapseCorner.Parent = CollapseButton

    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0, 26, 0, 26)
    MinimizeButton.Position = UDim2.new(1, -98, 0, 14)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(234, 179, 8)
    MinimizeButton.BackgroundTransparency = 0.2
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Text = "🗕"
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.TextSize = 11
    MinimizeButton.Parent = Header

    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 6)
    MinCorner.Parent = MinimizeButton

    local FloatGui = Instance.new("ScreenGui")
    FloatGui.Name = "UILibrary_FloatingIcon"
    FloatGui.ResetOnSpawn = false
    FloatGui.Enabled = false
    if typeof(protectgui) == "function" then
        pcall(protectgui, FloatGui)
    elseif typeof(syn) == "table" and typeof((syn :: any).protect_gui) == "function" then
        pcall((syn :: any).protect_gui, FloatGui)
    end
    FloatGui.Parent = targetParent

    local FloatButton = Instance.new("TextButton")
    FloatButton.Size = UDim2.new(0, 52, 0, 52)
    FloatButton.Position = UDim2.new(0, 30, 0.5, -26)
    FloatButton.BackgroundColor3 = Color3.fromRGB(11, 17, 32)
    FloatButton.BackgroundTransparency = 0.1
    FloatButton.BorderSizePixel = 0
    FloatButton.AutoButtonColor = true
    FloatButton.Text = ""
    FloatButton.Parent = FloatGui

    local FloatCorner = Instance.new("UICorner")
    FloatCorner.CornerRadius = UDim.new(1, 0)
    FloatCorner.Parent = FloatButton

    local FloatStroke = Instance.new("UIStroke")
    FloatStroke.Color = Color3.fromRGB(56, 189, 248)
    FloatStroke.Thickness = 2
    FloatStroke.Parent = FloatButton

    local FloatImage = Instance.new("ImageLabel")
    FloatImage.Size = UDim2.new(0, 30, 0, 30)
    FloatImage.Position = UDim2.new(0.5, -15, 0.5, -15)
    FloatImage.BackgroundTransparency = 1
    FloatImage.Image = iconId
    FloatImage.Parent = FloatButton

    local floatDragging, floatDragStart, floatStartPos
    FloatButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            floatDragging = true
            floatDragStart = input.Position
            floatStartPos = FloatButton.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    floatDragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if floatDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - floatDragStart
            FloatButton.Position = UDim2.new(floatStartPos.X.Scale, floatStartPos.X.Offset + delta.X, floatStartPos.Y.Scale, floatStartPos.Y.Offset + delta.Y)
        end
    end)

    local isCollapsed = false
    local fullHeight = 380

    local TabContainer, ContentContainer, UserFooter

    CollapseButton.MouseButton1Click:Connect(function()
        isCollapsed = not isCollapsed
        local targetH = isCollapsed and headerHeight or fullHeight
        local glowH = targetH + 12
        
        if TabContainer then TabContainer.Visible = not isCollapsed end
        if ContentContainer then ContentContainer.Visible = not isCollapsed end
        if UserFooter then UserFooter.Visible = not isCollapsed end

        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 520, 0, targetH)}):Play()
        TweenService:Create(GlowFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 532, 0, glowH)}):Play()
    end)

    MinimizeButton.MouseButton1Click:Connect(function()
        TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        TweenService:Create(GlowFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.delay(0.2, function()
            MainFrame.Visible = false
            GlowFrame.Visible = false
            FloatGui.Enabled = true
            FloatButton.Size = UDim2.new(0, 0, 0, 0)
            TweenService:Create(FloatButton, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 52, 0, 52)}):Play()
        end)
    end)

    FloatButton.MouseButton1Click:Connect(function()
        FloatGui.Enabled = false
        MainFrame.Visible = true
        GlowFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        GlowFrame.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 520, 0, isCollapsed and headerHeight or fullHeight)}):Play()
        TweenService:Create(GlowFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 532, 0, (isCollapsed and headerHeight or fullHeight) + 12)}):Play()
    end)

    CloseButton.MouseButton1Click:Connect(function()
        TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        TweenService:Create(GlowFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.delay(0.2, function()
            ScreenGui:Destroy()
            NotifGui:Destroy()
            FloatGui:Destroy()
        end)
    end)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -112, 0, 22)
    TitleLabel.Position = UDim2.new(0, 16, 0, 8)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(240, 249, 255)
    TitleLabel.TextSize = 15
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Header

    local DescLabel = Instance.new("TextLabel")
    DescLabel.Name = "WindowDesc"
    DescLabel.Size = UDim2.new(1, -112, 0, 16)
    DescLabel.Position = UDim2.new(0, 16, 0, 30)
    DescLabel.BackgroundTransparency = 1
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.Text = desc
    DescLabel.TextColor3 = Color3.fromRGB(148, 211, 249)
    DescLabel.TextSize = 11
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.Parent = Header

    local tabAreaOffset = headerHeight + 8
    local footerHeight = 52

    TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 134, 1, -(tabAreaOffset + footerHeight + 12))
    TabContainer.Position = UDim2.new(0, 8, 0, tabAreaOffset)
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.ScrollBarThickness = 2
    TabContainer.Active = true -- Fixed mobile scrolling support
    TabContainer.ScrollingEnabled = true
    TabContainer.Parent = MainFrame

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 6)
    TabLayout.Parent = TabContainer

    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 4)
    end)

    ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -150, 1, -(tabAreaOffset + footerHeight + 12))
    ContentContainer.Position = UDim2.new(0, 146, 0, tabAreaOffset)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.BorderSizePixel = 0
    ContentContainer.Parent = MainFrame

    UserFooter = Instance.new("Frame")
    UserFooter.Name = "UserFooter"
    UserFooter.Size = UDim2.new(0, 134, 0, 44)
    UserFooter.Position = UDim2.new(0, 8, 1, -50)
    UserFooter.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
    UserFooter.BackgroundTransparency = 0.4
    UserFooter.BorderSizePixel = 0
    UserFooter.Parent = MainFrame

    local FooterCorner = Instance.new("UICorner")
    FooterCorner.CornerRadius = UDim.new(0, 7)
    FooterCorner.Parent = UserFooter

    local AvatarImg = Instance.new("ImageLabel")
    AvatarImg.Size = UDim2.new(0, 32, 0, 32)
    AvatarImg.Position = UDim2.new(0, 6, 0.5, -16)
    AvatarImg.BackgroundTransparency = 1
    AvatarImg.Image = "rbxassetid://0"
    AvatarImg.Parent = UserFooter

    local AvatarCorner = Instance.new("UICorner")
    AvatarCorner.CornerRadius = UDim.new(1, 0)
    AvatarCorner.Parent = AvatarImg

    pcall(function()
        local content, isReady = Players:GetUserThumbnailAsync(Players.LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size42x42)
        if isReady then
            AvatarImg.Image = content
        end
    end)

    local UsernameLabel = Instance.new("TextLabel")
    UsernameLabel.Size = UDim2.new(1, -44, 0, 16)
    UsernameLabel.Position = UDim2.new(0, 44, 0, 5)
    UsernameLabel.BackgroundTransparency = 1
    UsernameLabel.Font = Enum.Font.GothamBold
    UsernameLabel.Text = Players.LocalPlayer and Players.LocalPlayer.Name or "User"
    UsernameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    UsernameLabel.TextSize = 11
    UsernameLabel.TextXAlignment = Enum.TextXAlignment.Left
    UsernameLabel.Parent = UserFooter

    local SubLabel1 = Instance.new("TextLabel")
    SubLabel1.Size = UDim2.new(1, -44, 0, 12)
    SubLabel1.Position = UDim2.new(0, 44, 0, 19)
    SubLabel1.BackgroundTransparency = 1
    SubLabel1.Font = Enum.Font.GothamSemibold
    SubLabel1.Text = "Premium"
    SubLabel1.TextColor3 = Color3.fromRGB(250, 204, 21)
    SubLabel1.TextSize = 10
    SubLabel1.TextXAlignment = Enum.TextXAlignment.Left
    SubLabel1.Parent = UserFooter

    local SubLabel2 = Instance.new("TextLabel")
    SubLabel2.Size = UDim2.new(1, -44, 0, 12)
    SubLabel2.Position = UDim2.new(0, 44, 0, 30)
    SubLabel2.BackgroundTransparency = 1
    SubLabel2.Font = Enum.Font.GothamSemibold
    SubLabel2.Text = "Permanent"
    SubLabel2.TextColor3 = Color3.fromRGB(74, 222, 128)
    SubLabel2.TextSize = 10
    SubLabel2.TextXAlignment = Enum.TextXAlignment.Left
    SubLabel2.Parent = UserFooter

    local isOpen = true
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == keybind then
            isOpen = not isOpen
            if isOpen then
                FloatGui.Enabled = false
                MainFrame.Visible = true
                GlowFrame.Visible = true
                MainFrame.Size = UDim2.new(0, 0, 0, 0)
                GlowFrame.Size = UDim2.new(0, 0, 0, 0)
                TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 520, 0, isCollapsed and headerHeight or fullHeight)}):Play()
                TweenService:Create(GlowFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 532, 0, (isCollapsed and headerHeight or fullHeight) + 12)}):Play()
            else
                TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
                TweenService:Create(GlowFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
                task.delay(0.2, function()
                    if not isOpen then
                        MainFrame.Visible = false
                        GlowFrame.Visible = false
                    end
                end)
            end
        end
    end)

    local windowObj = {}
    windowObj.ScreenGui = ScreenGui
    windowObj.MainFrame = MainFrame
    windowObj.TabContainer = TabContainer
    windowObj.ContentContainer = ContentContainer
    windowObj.NotifHolder = NotifHolder

    function windowObj:SetHead(newTitle)
        TitleLabel.Text = newTitle
    end

    function windowObj:SetHeadSub(newDesc)
        DescLabel.Text = newDesc
    end

    setmetatable(windowObj, UILibrary)
    return windowObj
end

local activeTabIndicator = nil

function UILibrary:CreateTab(config)
    config = config or {}
    local title = config.Title or "Tab"
    local iconId = config.Icon or ""

    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, 0, 0, 34)
    TabButton.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
    TabButton.BackgroundTransparency = 0.5
    TabButton.BorderSizePixel = 0
    TabButton.Font = Enum.Font.GothamSemibold
    TabButton.Text = "  " .. title
    TabButton.TextColor3 = Color3.fromRGB(148, 211, 249)
    TabButton.TextSize = 13
    TabButton.TextXAlignment = Enum.TextXAlignment.Left
    TabButton.Parent = self.TabContainer

    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 7)
    TabCorner.Parent = TabButton

    local Indicator = Instance.new("Frame")
    Indicator.Name = "Indicator"
    Indicator.Size = UDim2.new(0, 3, 0, 0)
    Indicator.Position = UDim2.new(0, 0, 0.5, 0)
    Indicator.BackgroundColor3 = Color3.fromRGB(56, 189, 248)
    Indicator.BorderSizePixel = 0
    Indicator.Parent = TabButton

    local IndCorner = Instance.new("UICorner")
    IndCorner.CornerRadius = UDim.new(1, 0)
    IndCorner.Parent = Indicator

    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContent.ScrollBarThickness = 3
    TabContent.Active = true -- Fixed mobile scrolling support
    TabContent.ScrollingEnabled = true
    TabContent.Visible = false
    TabContent.Parent = self.ContentContainer

    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 7)
    ContentLayout.Parent = TabContent

    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 8)
    end)

    local function selectTab()
        for _, child in ipairs(self.ContentContainer:GetChildren()) do
            if child:IsA("ScrollingFrame") then
                child.Visible = false
            end
        end
        for _, btn in ipairs(self.TabContainer:GetChildren()) do
            if btn:IsA("TextButton") then
                local ind = btn:FindFirstChild("Indicator")
                if ind then
                    TweenService:Create(ind, TweenInfo.new(0.2), {Size = UDim2.new(0, 3, 0, 0), Position = UDim2.new(0, 0, 0.5, 0)}):Play()
                end
                TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(148, 211, 249), BackgroundTransparency = 0.5}):Play()
            end
        end

        TabContent.Visible = true
        TabContent.Position = UDim2.new(0, 12, 0, 0)
        TabContent.BackgroundTransparency = 1
        TweenService:Create(TabContent, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        
        TweenService:Create(Indicator, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 3, 0, 20), Position = UDim2.new(0, 0, 0.5, -10)}):Play()
        TweenService:Create(TabButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(240, 249, 255), BackgroundTransparency = 0.3}):Play()
    end

    TabButton.MouseButton1Click:Connect(selectTab)

    if #self.TabContainer:GetChildren() == 2 then
        selectTab()
    end

    local tabObj = {
        Container = TabContent
    }
    setmetatable(tabObj, TabMeta)
    return tabObj
end

function UILibrary:Notify(config)
    config = config or {}
    local title = config.Title or "Notification"
    local desc = config.Desc or ""
    local duration = config.Time or 3
    local notifType = string.lower(config.Type or "info")

    local accentColor = Color3.fromRGB(56, 189, 248)
    if notifType == "error" then
        accentColor = Color3.fromRGB(239, 68, 68)
    elseif notifType == "success" then
        accentColor = Color3.fromRGB(34, 197, 94)
    elseif notifType == "warning" then
        accentColor = Color3.fromRGB(234, 179, 8)
    end

    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(1, 0, 0, 72)
    NotifFrame.Position = UDim2.new(1, 40, 0, 0)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(11, 17, 32)
    NotifFrame.BackgroundTransparency = 0.1
    NotifFrame.BorderSizePixel = 0
    NotifFrame.Parent = self.NotifHolder

    TweenService:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()

    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 8)
    NotifCorner.Parent = NotifFrame

    local NotifStroke = Instance.new("UIStroke")
    NotifStroke.Color = accentColor
    NotifStroke.Transparency = 0.5
    NotifStroke.Parent = NotifFrame

    local Strip = Instance.new("Frame")
    Strip.Size = UDim2.new(0, 4, 1, 0)
    Strip.BackgroundColor3 = accentColor
    Strip.BorderSizePixel = 0
    Strip.Parent = NotifFrame

    local StripCorner = Instance.new("UICorner")
    StripCorner.CornerRadius = UDim.new(0, 2)
    StripCorner.Parent = Strip

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -20, 0, 22)
    TitleLabel.Position = UDim2.new(0, 12, 0, 6)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(240, 249, 255)
    TitleLabel.TextSize = 13
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = NotifFrame

    local DescLabel = Instance.new("TextLabel")
    DescLabel.Size = UDim2.new(1, -20, 0, 28)
    DescLabel.Position = UDim2.new(0, 12, 0, 26)
    DescLabel.BackgroundTransparency = 1
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.Text = desc
    DescLabel.TextColor3 = Color3.fromRGB(148, 211, 249)
    DescLabel.TextSize = 11
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.TextWrapped = true
    DescLabel.Parent = NotifFrame

    local ProgressTrack = Instance.new("Frame")
    ProgressTrack.Size = UDim2.new(1, -12, 0, 4)
    ProgressTrack.Position = UDim2.new(0, 12, 1, -8)
    ProgressTrack.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
    ProgressTrack.BorderSizePixel = 0
    ProgressTrack.Parent = NotifFrame

    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(1, 0)
    TrackCorner.Parent = ProgressTrack

    local ProgressBar = Instance.new("Frame")
    ProgressBar.Size = UDim2.new(1, 0, 1, 0)
    ProgressBar.BackgroundColor3 = accentColor
    ProgressBar.BorderSizePixel = 0
    ProgressBar.Parent = ProgressTrack

    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = ProgressBar

    TweenService:Create(ProgressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)}):Play()

    task.spawn(function()
        task.wait(duration)
        local t1 = TweenService:Create(NotifFrame, TweenInfo.new(0.25), {BackgroundTransparency = 1, Position = UDim2.new(1, 40, 0, 0)})
        local t2 = TweenService:Create(TitleLabel, TweenInfo.new(0.25), {TextTransparency = 1})
        local t3 = TweenService:Create(DescLabel, TweenInfo.new(0.25), {TextTransparency = 1})
        local t4 = TweenService:Create(Strip, TweenInfo.new(0.25), {BackgroundTransparency = 1})
        local t5 = TweenService:Create(ProgressBar, TweenInfo.new(0.25), {BackgroundTransparency = 1})
        t1:Play(); t2:Play(); t3:Play(); t4:Play(); t5:Play()
        t1.Completed:Wait()
        NotifFrame:Destroy()
    end)
end

function TabMeta:CreateHeader(titleText)
    local HeaderLabel = Instance.new("TextLabel")
    HeaderLabel.Size = UDim2.new(1, 0, 0, 24)
    HeaderLabel.BackgroundTransparency = 1
    HeaderLabel.Font = Enum.Font.GothamBold
    HeaderLabel.Text = titleText or "Header"
    HeaderLabel.TextColor3 = Color3.fromRGB(224, 242, 254)
    HeaderLabel.TextSize = 13
    HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
    HeaderLabel.Parent = self.Container

    local headerObj = {}
    function headerObj:SetHeader(newTitle)
        HeaderLabel.Text = newTitle
    end
    return headerObj
end

function TabMeta:Label(config)
    local text = "Title Desc"
    local desc = ""
    
    if type(config) == "table" then
        text = config.Title or config.Text or "Title Desc"
        desc = config.Desc or ""
    elseif type(config) == "string" then
        text = config
    end

    local LabelComponent = Instance.new("Frame")
    LabelComponent.Size = UDim2.new(1, 0, 0, (desc ~= "") and 48 or 34)
    LabelComponent.BackgroundTransparency = 1
    LabelComponent.Parent = self.Container

    local TextHolder = Instance.new("TextLabel")
    TextHolder.Size = UDim2.new(1, -12, 0, 20)
    TextHolder.Position = UDim2.new(0, 6, 0, 4)
    TextHolder.BackgroundTransparency = 1
    TextHolder.Font = Enum.Font.GothamMedium
    TextHolder.Text = text
    TextHolder.TextColor3 = Color3.fromRGB(240, 249, 255)
    TextHolder.TextSize = 12
    TextHolder.TextXAlignment = Enum.TextXAlignment.Left
    TextHolder.Parent = LabelComponent

    local DescHolder = Instance.new("TextLabel")
    DescHolder.Size = UDim2.new(1, -12, 0, 18)
    DescHolder.Position = UDim2.new(0, 6, 0, 24)
    DescHolder.BackgroundTransparency = 1
    DescHolder.Font = Enum.Font.Gotham
    DescHolder.Text = desc
    DescHolder.TextColor3 = Color3.fromRGB(148, 211, 249)
    DescHolder.TextSize = 10
    DescHolder.TextXAlignment = Enum.TextXAlignment.Left
    DescHolder.TextWrapped = true
    DescHolder.Visible = (desc ~= "")
    DescHolder.Parent = LabelComponent

    local labelObj = {}
    function labelObj:SetTitle(newTitle)
        TextHolder.Text = tostring(newTitle)
    end
    function labelObj:SetDesc(newDesc)
        DescHolder.Text = tostring(newDesc)
        DescHolder.Visible = (newDesc ~= "")
        LabelComponent.Size = UDim2.new(1, 0, 0, (newDesc ~= "") and 48 or 34)
    end
    function labelObj:SetTextColor3(color)
        TextHolder.TextColor3 = color
    end
    function labelObj:SetDescColor3(color)
        DescHolder.TextColor3 = color
    end
    return labelObj
end

function TabMeta:Image(config)
    config = config or {}
    local imageId = config.Image or "rbxassetid://0"
    local title = config.Title or ""
    local desc = config.Desc or ""

    local hasText = (title ~= "" or desc ~= "")
    local frameHeight = hasText and 72 or 54

    local ImageFrame = Instance.new("Frame")
    ImageFrame.Size = UDim2.new(1, 0, 0, frameHeight)
    ImageFrame.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
    ImageFrame.BackgroundTransparency = 0.5
    ImageFrame.BorderSizePixel = 0
    ImageFrame.Parent = self.Container

    local ImgCorner = Instance.new("UICorner")
    ImgCorner.CornerRadius = UDim.new(0, 7)
    ImgCorner.Parent = ImageFrame

    local ImgLabel = Instance.new("ImageLabel")
    ImgLabel.Size = UDim2.new(0, 42, 0, 42)
    ImgLabel.Position = UDim2.new(0, 10, 0.5, -21)
    ImgLabel.BackgroundTransparency = 1
    ImgLabel.Image = imageId
    ImgLabel.Parent = ImageFrame

    local ImgSubCorner = Instance.new("UICorner")
    ImgSubCorner.CornerRadius = UDim.new(0, 6)
    ImgSubCorner.Parent = ImgLabel

    if hasText then
        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Size = UDim2.new(1, -66, 0, 20)
        TitleLabel.Position = UDim2.new(0, 60, 0, desc ~= "" and 12 or 16)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.Text = title
        TitleLabel.TextColor3 = Color3.fromRGB(240, 249, 255)
        TitleLabel.TextSize = 12
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.Parent = ImageFrame

        if desc ~= "" then
            local DescLabel = Instance.new("TextLabel")
            DescLabel.Size = UDim2.new(1, -66, 0, 16)
            DescLabel.Position = UDim2.new(0, 60, 0, 34)
            DescLabel.BackgroundTransparency = 1
            DescLabel.Font = Enum.Font.Gotham
            DescLabel.Text = desc
            DescLabel.TextColor3 = Color3.fromRGB(148, 211, 249)
            DescLabel.TextSize = 10
            DescLabel.TextXAlignment = Enum.TextXAlignment.Left
            DescLabel.Parent = ImageFrame
        end
    else
        ImgLabel.Position = UDim2.new(0.5, -21, 0.5, -21)
    end

    local imageObj = {}
    function imageObj:SetImage(newId)
        ImgLabel.Image = newId
    end
    function imageObj:SetTitle(newTitle)
        if TitleLabel then TitleLabel.Text = newTitle end
    end
    function imageObj:SetDesc(newDesc)
        if DescLabel then DescLabel.Text = newDesc end
    end
    return imageObj
end

function TabMeta:Section(config)
    config = config or {}
    local title = config.Title or "Section"

    local SectionFrame = Instance.new("Frame")
    SectionFrame.Size = UDim2.new(1, 0, 0, 34)
    SectionFrame.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
    SectionFrame.BackgroundTransparency = 0.5
    SectionFrame.BorderSizePixel = 0
    SectionFrame.ClipsDescendants = true
    SectionFrame.Parent = self.Container

    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 7)
    SectionCorner.Parent = SectionFrame

    local SectionButton = Instance.new("TextButton")
    SectionButton.Size = UDim2.new(1, 0, 0, 34)
    SectionButton.BackgroundTransparency = 1
    SectionButton.BorderSizePixel = 0
    SectionButton.Font = Enum.Font.GothamBold
    SectionButton.Text = "  ▼ " .. title
    SectionButton.TextColor3 = Color3.fromRGB(224, 242, 254)
    SectionButton.TextSize = 12
    SectionButton.TextXAlignment = Enum.TextXAlignment.Left
    SectionButton.Parent = SectionFrame

    local ItemsContainer = Instance.new("Frame")
    ItemsContainer.Size = UDim2.new(1, 0, 0, 0)
    ItemsContainer.Position = UDim2.new(0, 0, 0, 34)
    ItemsContainer.BackgroundTransparency = 1
    ItemsContainer.ClipsDescendants = true
    ItemsContainer.Parent = SectionFrame

    local ItemsLayout = Instance.new("UIListLayout")
    ItemsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ItemsLayout.Padding = UDim.new(0, 6)
    ItemsLayout.Parent = ItemsContainer

    local minimized = false

    local function updateSectionSize()
        if minimized then
            TweenService:Create(SectionFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 34)}):Play()
            TweenService:Create(ItemsContainer, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 0)}):Play()
        else
            local contentHeight = ItemsLayout.AbsoluteContentSize.Y
            local targetH = 34 + contentHeight + 8
            TweenService:Create(SectionFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, targetH)}):Play()
            TweenService:Create(ItemsContainer, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, contentHeight + 4)}):Play()
        end
    end

    SectionButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        SectionButton.Text = (minimized and "  ▶ " or "  ▼ ") .. title
        updateSectionSize()
    end)

    ItemsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if not minimized then
            updateSectionSize()
        end
    end)

    local sectionObj = {
        Container = ItemsContainer
    }
    setmetatable(sectionObj, TabMeta)
    return sectionObj
end

function TabMeta:Button(config)
    config = config or {}
    local title = config.Title or "Button"
    local desc = config.Desc or ""
    local callback = config.Callback or function() end

    local ButtonFrame = Instance.new("TextButton")
    ButtonFrame.Size = UDim2.new(1, 0, 0, desc ~= "" and 48 or 36)
    ButtonFrame.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
    ButtonFrame.BackgroundTransparency = 0.5
    ButtonFrame.BorderSizePixel = 0
    ButtonFrame.AutoButtonColor = true
    ButtonFrame.Text = ""
    ButtonFrame.Parent = self.Container

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 7)
    BtnCorner.Parent = ButtonFrame

    ButtonFrame.MouseButton1Down:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.2}):Play()
    end)
    ButtonFrame.MouseButton1Up:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.5}):Play()
    end)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -20, 0, 20)
    TitleLabel.Position = UDim2.new(0, 12, 0, desc ~= "" and 6 or 8)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamMedium
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(240, 249, 255)
    TitleLabel.TextSize = 12
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = ButtonFrame

    if desc ~= "" then
        local DescLabel = Instance.new("TextLabel")
        DescLabel.Size = UDim2.new(1, -20, 0, 14)
        DescLabel.Position = UDim2.new(0, 12, 0, 26)
        DescLabel.BackgroundTransparency = 1
        DescLabel.Font = Enum.Font.Gotham
        DescLabel.Text = desc
        DescLabel.TextColor3 = Color3.fromRGB(148, 211, 249)
        DescLabel.TextSize = 10
        DescLabel.TextXAlignment = Enum.TextXAlignment.Left
        DescLabel.Parent = ButtonFrame
    end

    ButtonFrame.MouseButton1Click:Connect(function()
        task.spawn(callback)
    end)
end

function TabMeta:Toggle(config)
    config = config or {}
    local title = config.Title or "Toggle"
    local desc = config.Desc or ""
    local imageId = config.Image or ""
    local value = config.Value or false
    local callback = config.Callback or function() end

    local hasImage = (imageId ~= "")
    local textLeftOffset = hasImage and 48 or 12
    local textRightOffset = 60

    local ToggleFrame = Instance.new("TextButton")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 42)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
    ToggleFrame.BackgroundTransparency = 0.5
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.AutoButtonColor = false
    ToggleFrame.Text = ""
    ToggleFrame.Parent = self.Container

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 7)
    ToggleCorner.Parent = ToggleFrame

    if hasImage then
        local IconLabel = Instance.new("ImageLabel")
        IconLabel.Size = UDim2.new(0, 26, 0, 26)
        IconLabel.Position = UDim2.new(0, 12, 0.5, -13)
        IconLabel.BackgroundTransparency = 1
        IconLabel.Image = imageId
        IconLabel.Parent = ToggleFrame
    end

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -(textLeftOffset + textRightOffset), 1, 0)
    TitleLabel.Position = UDim2.new(0, textLeftOffset, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamMedium
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(240, 249, 255)
    TitleLabel.TextSize = 12
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = ToggleFrame

    if desc ~= "" then
        TitleLabel.Size = UDim2.new(1, -(textLeftOffset + textRightOffset), 0, 20)
        TitleLabel.Position = UDim2.new(0, textLeftOffset, 0, 5)
        local DescLabel = Instance.new("TextLabel")
        DescLabel.Size = UDim2.new(1, -(textLeftOffset + textRightOffset), 0, 14)
        DescLabel.Position = UDim2.new(0, textLeftOffset, 0, 23)
        DescLabel.BackgroundTransparency = 1
        DescLabel.Font = Enum.Font.Gotham
        DescLabel.Text = desc
        DescLabel.TextColor3 = Color3.fromRGB(148, 211, 249)
        DescLabel.TextSize = 10
        DescLabel.TextXAlignment = Enum.TextXAlignment.Left
        DescLabel.Parent = ToggleFrame
    end

    local SwitchBg = Instance.new("Frame")
    SwitchBg.Size = UDim2.new(0, 38, 0, 20)
    SwitchBg.Position = UDim2.new(1, -48, 0.5, -10)
    SwitchBg.BackgroundColor3 = value and Color3.fromRGB(56, 189, 248) or Color3.fromRGB(30, 41, 59)
    SwitchBg.BorderSizePixel = 0
    SwitchBg.Parent = ToggleFrame

    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(1, 0)
    SwitchCorner.Parent = SwitchBg

    local SwitchCircle = Instance.new("Frame")
    SwitchCircle.Size = UDim2.new(0, 16, 0, 16)
    SwitchCircle.Position = value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    SwitchCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SwitchCircle.BorderSizePixel = 0
    SwitchCircle.Parent = SwitchBg

    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = SwitchCircle

    local function updateToggle(val, skipCallback)
        value = val
        local targetColor = value and Color3.fromRGB(56, 189, 248) or Color3.fromRGB(30, 41, 59)
        local targetPos = value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        
        TweenService:Create(SwitchBg, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = targetColor}):Play()
        TweenService:Create(SwitchCircle, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = targetPos}):Play()
        
        if not skipCallback then
            task.spawn(function()
                callback(value)
            end)
        end
    end

    ToggleFrame.MouseButton1Click:Connect(function()
        updateToggle(not value)
    end)

    local toggleObj = {}
    function toggleObj:SetValue(val, skipCallback)
        updateToggle(val, skipCallback)
    end
    function toggleObj:GetValue()
        return value
    end
    function toggleObj:SetTitle(newTitle)
        TitleLabel.Text = tostring(newTitle)
    end
    function toggleObj:SetDesc(newDesc)
        if DescLabel then DescLabel.Text = tostring(newDesc) end
    end
    return toggleObj
end

function TabMeta:Slider(config)
    config = config or {}
    local title = config.Title or "Slider"
    local min = config.Min or 0
    local max = config.Max or 100
    local rounding = config.Rounding or 0
    local value = config.Value or min
    local callback = config.Callback or function() end

    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 50)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
    SliderFrame.BackgroundTransparency = 0.5
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = self.Container

    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 7)
    SliderCorner.Parent = SliderFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -60, 0, 20)
    TitleLabel.Position = UDim2.new(0, 12, 0, 6)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamMedium
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(240, 249, 255)
    TitleLabel.TextSize = 12
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = SliderFrame

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 50, 0, 20)
    ValueLabel.Position = UDim2.new(1, -62, 0, 6)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.Text = tostring(value)
    ValueLabel.TextColor3 = Color3.fromRGB(148, 211, 249)
    ValueLabel.TextSize = 12
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = SliderFrame

    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(1, -24, 0, 6)
    Track.Position = UDim2.new(0, 12, 0, 33)
    Track.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
    Track.BorderSizePixel = 0
    Track.Parent = SliderFrame

    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(1, 0)
    TrackCorner.Parent = Track

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(math.clamp((value - min) / (max - min), 0, 1), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(56, 189, 248)
    Fill.BorderSizePixel = 0
    Fill.Parent = Track

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = Fill

    local dragging = false

    local function updateValue(inputX)
        local sizeX = math.clamp((inputX - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        local rawValue = min + ((max - min) * sizeX)
        local mult = 10 ^ rounding
        value = math.floor(rawValue * mult + 0.5) / mult

        TweenService:Create(Fill, TweenInfo.new(0.05), {Size = UDim2.new(sizeX, 0, 1, 0)}):Play()
        ValueLabel.Text = tostring(value)
        task.spawn(function() callback(value) end)
    end

    Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateValue(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateValue(input.Position.X)
        end
    end)
end

function TabMeta:Textbox(config)
    config = config or {}
    local title = config.Title or "Textbox"
    local desc = config.Desc or ""
    local placeholder = config.Placeholder or "Enter text..."
    local value = config.Value or ""
    local clearOnFocus = config.ClearTextOnFocus or false
    local callback = config.Callback or function() end

    local BoxFrame = Instance.new("Frame")
    BoxFrame.Size = UDim2.new(1, 0, 0, desc ~= "" and 56 or 42)
    BoxFrame.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
    BoxFrame.BackgroundTransparency = 0.5
    BoxFrame.BorderSizePixel = 0
    BoxFrame.Parent = self.Container

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 7)
    BoxCorner.Parent = BoxFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -145, 0, 20)
    TitleLabel.Position = UDim2.new(0, 12, 0, desc ~= "" and 6 or 11)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamMedium
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(240, 249, 255)
    TitleLabel.TextSize = 12
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = BoxFrame

    if desc ~= "" then
        local DescLabel = Instance.new("TextLabel")
        DescLabel.Size = UDim2.new(1, -145, 0, 14)
        DescLabel.Position = UDim2.new(0, 12, 0, 27)
        DescLabel.BackgroundTransparency = 1
        DescLabel.Font = Enum.Font.Gotham
        DescLabel.Text = desc
        DescLabel.TextColor3 = Color3.fromRGB(148, 211, 249)
        DescLabel.TextSize = 10
        DescLabel.TextXAlignment = Enum.TextXAlignment.Left
        DescLabel.Parent = BoxFrame
    end

    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(0, 125, 0, 28)
    TextBox.Position = UDim2.new(1, -133, 0, 7)
    TextBox.BackgroundColor3 = Color3.fromRGB(11, 17, 32)
    TextBox.BackgroundTransparency = 0.3
    TextBox.BorderSizePixel = 0
    TextBox.Font = Enum.Font.Gotham
    TextBox.PlaceholderText = placeholder
    TextBox.Text = value
    TextBox.TextColor3 = Color3.fromRGB(224, 242, 254)
    TextBox.PlaceholderColor3 = Color3.fromRGB(100, 116, 139)
    TextBox.TextSize = 11
    TextBox.ClipsDescendants = true
    TextBox.ClearTextOnFocus = clearOnFocus
    TextBox.Parent = BoxFrame

    local TextCorner = Instance.new("UICorner")
    TextCorner.CornerRadius = UDim.new(0, 6)
    TextCorner.Parent = TextBox

    local TextStroke = Instance.new("UIStroke")
    TextStroke.Color = Color3.fromRGB(56, 189, 248)
    TextStroke.Transparency = 0.6
    TextStroke.Parent = TextBox

    TextBox.Focused:Connect(function()
        TweenService:Create(TextStroke, TweenInfo.new(0.2), {Transparency = 0.1}):Play()
    end)

    TextBox.FocusLost:Connect(function(enterPressed)
        TweenService:Create(TextStroke, TweenInfo.new(0.2), {Transparency = 0.6}):Play()
        task.spawn(function()
            callback(TextBox.Text, enterPressed)
        end)
    end)

    local tbObj = {}
    function tbObj:SetText(newText)
        TextBox.Text = tostring(newText)
    end
    function tbObj:GetText()
        return TextBox.Text
    end
    return tbObj
end

function TabMeta:Dropdown(config)
    config = config or {}
    local title = config.Title or "Dropdown"
    local desc = config.Desc or ""
    local list = config.List or {}
    local selected = config.Value or (config.Multi and {} or "")
    local isMulti = config.Multi or false
    local callback = config.Callback or function() end

    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Size = UDim2.new(1, 0, 0, desc ~= "" and 56 or 42)
    DropdownFrame.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
    DropdownFrame.BackgroundTransparency = 0.5
    DropdownFrame.BorderSizePixel = 0
    DropdownFrame.ClipsDescendants = true
    DropdownFrame.Parent = self.Container

    local DropCorner = Instance.new("UICorner")
    DropCorner.CornerRadius = UDim.new(0, 7)
    DropCorner.Parent = DropdownFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -145, 0, 20)
    TitleLabel.Position = UDim2.new(0, 12, 0, desc ~= "" and 6 or 11)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamMedium
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(240, 249, 255)
    TitleLabel.TextSize = 12
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = DropdownFrame

    if desc ~= "" then
        local DescLabel = Instance.new("TextLabel")
        DescLabel.Size = UDim2.new(1, -145, 0, 14)
        DescLabel.Position = UDim2.new(0, 12, 0, 27)
        DescLabel.BackgroundTransparency = 1
        DescLabel.Font = Enum.Font.Gotham
        DescLabel.Text = desc
        DescLabel.TextColor3 = Color3.fromRGB(148, 211, 249)
        DescLabel.TextSize = 10
        DescLabel.TextXAlignment = Enum.TextXAlignment.Left
        DescLabel.Parent = DropdownFrame
    end

    local DropButton = Instance.new("TextButton")
    DropButton.Size = UDim2.new(0, 125, 0, 28)
    DropButton.Position = UDim2.new(1, -133, 0, 7)
    DropButton.BackgroundColor3 = Color3.fromRGB(11, 17, 32)
    DropButton.BackgroundTransparency = 0.3
    DropButton.BorderSizePixel = 0
    DropButton.Font = Enum.Font.Gotham
    DropButton.Text = "Select..."
    DropButton.TextColor3 = Color3.fromRGB(224, 242, 254)
    DropButton.TextSize = 11
    DropButton.Parent = DropdownFrame

    local DropBtnCorner = Instance.new("UICorner")
    DropBtnCorner.CornerRadius = UDim.new(0, 6)
    DropBtnCorner.Parent = DropButton

    local DropBtnStroke = Instance.new("UIStroke")
    DropBtnStroke.Color = Color3.fromRGB(56, 189, 248)
    DropBtnStroke.Transparency = 0.6
    DropBtnStroke.Parent = DropButton

    local OptionsContainer = Instance.new("ScrollingFrame")
    OptionsContainer.Size = UDim2.new(1, -24, 0, 0)
    OptionsContainer.Position = UDim2.new(0, 12, 0, desc ~= "" and 50 or 40)
    OptionsContainer.BackgroundTransparency = 0
    OptionsContainer.BackgroundColor3 = Color3.fromRGB(11, 17, 32)
    OptionsContainer.BorderSizePixel = 0
    OptionsContainer.ScrollBarThickness = 2
    OptionsContainer.Active = true -- Fixed mobile scrolling support
    OptionsContainer.ScrollingEnabled = true
    OptionsContainer.Visible = false
    OptionsContainer.ZIndex = 5
    OptionsContainer.Parent = DropdownFrame

    local OptLayout = Instance.new("UIListLayout")
    OptLayout.SortOrder = Enum.SortOrder.LayoutOrder
    OptLayout.Padding = UDim.new(0, 4)
    OptLayout.Parent = OptionsContainer

    local isOpen = false
    local baseHeight = desc ~= "" and 56 or 42

    local function updateDisplay()
        if isMulti then
            DropButton.Text = (#selected > 0) and (#selected .. " selected") or "Select..."
        else
            DropButton.Text = (selected ~= "" and selected) or "Select..."
        end
    end

    local function rebuildOptions()
        for _, child in ipairs(OptionsContainer:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end

        for _, item in ipairs(list) do
            local OptButton = Instance.new("TextButton")
            OptButton.Size = UDim2.new(1, 0, 0, 26)
            OptButton.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
            OptButton.BackgroundTransparency = 0.2
            OptButton.BorderSizePixel = 0
            OptButton.Font = Enum.Font.Gotham
            OptButton.Text = "  " .. tostring(item)
            OptButton.TextColor3 = Color3.fromRGB(203, 213, 225)
            OptButton.TextSize = 11
            OptButton.TextXAlignment = Enum.TextXAlignment.Left
            OptButton.ZIndex = 6
            OptButton.Parent = OptionsContainer

            local OptCorner = Instance.new("UICorner")
            OptCorner.CornerRadius = UDim.new(0, 5)
            OptCorner.Parent = OptButton

            OptButton.MouseButton1Click:Connect(function()
                if isMulti then
                    local index = table.find(selected, item)
                    if index then
                        table.remove(selected, index)
                    else
                        table.insert(selected, item)
                    end
                else
                    selected = item
                    isOpen = false
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, baseHeight)}):Play()
                    OptionsContainer.Visible = false
                end
                updateDisplay()
                task.spawn(function() callback(selected) end)
            end)
        end
        OptionsContainer.CanvasSize = UDim2.new(0, 0, 0, OptLayout.AbsoluteContentSize.Y + 6)
    end

    DropButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        rebuildOptions()
        local expandHeight = math.clamp(OptLayout.AbsoluteContentSize.Y + 12, 0, 130)
        local targetH = isOpen and (baseHeight + expandHeight + 10) or baseHeight
        
        OptionsContainer.Visible = true
        TweenService:Create(DropdownFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, targetH)}):Play()
        if not isOpen then
            task.delay(0.25, function()
                if not isOpen then OptionsContainer.Visible = false end
            end)
        end
    end)

    updateDisplay()

    local dropObj = {}
    function dropObj:SetSelected(newSelected)
        selected = newSelected
        updateDisplay()
    end
    function dropObj:SetList(newList)
        list = newList
        if isOpen then rebuildOptions() end
    end
    function dropObj:GetSelected()
        return selected
    end
    return dropObj
end

return UILibrary

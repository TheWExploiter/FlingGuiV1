local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

pcall(function()
    game.CoreGui.FlingUI:Destroy()
end)

local gui = Instance.new("ScreenGui")
gui.Name = "FlingUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = game.CoreGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 500, 0, 350)
main.Position = UDim2.new(0.3, 0, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.Active = true
main.Draggable = true
main.ClipsDescendants = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", main)
title.Text = "Fling Gui V1"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

local sidebar = Instance.new("ScrollingFrame", main)
sidebar.Size = UDim2.new(0, 160, 1, -80)
sidebar.Position = UDim2.new(0, 0, 0, 30)
sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
sidebar.ScrollBarThickness = 4
sidebar.CanvasSize = UDim2.new(0, 0, 10, 0)
sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 6)

local layout = Instance.new("UIListLayout", sidebar)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 2)

local box = Instance.new("TextBox", main)
box.PlaceholderText = "Selected Player"
box.Size = UDim2.new(0, 320, 0, 40)
box.Position = UDim2.new(0, 170, 0, 220)
box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
box.TextColor3 = Color3.fromRGB(255, 255, 255)
box.Font = Enum.Font.Gotham
box.TextScaled = true
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)

local flingBtn = Instance.new("TextButton", main)
flingBtn.Text = "FLING!"
flingBtn.Size = UDim2.new(0, 320, 0, 40)
flingBtn.Position = UDim2.new(0, 170, 0, 270)
flingBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
flingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flingBtn.Font = Enum.Font.GothamBold
flingBtn.TextScaled = true
Instance.new("UICorner", flingBtn).CornerRadius = UDim.new(0, 6)

local credits = Instance.new("TextLabel", main)
credits.Text = "Made By : TheEpicGamer16YT\nTested By : Dorinel2020t"
credits.Size = UDim2.new(1, -10, 0, 40)
credits.Position = UDim2.new(0, 5, 1, -45)
credits.BackgroundTransparency = 1
credits.TextColor3 = Color3.fromRGB(120, 120, 120)
credits.Font = Enum.Font.Gotham
credits.TextScaled = true
credits.TextWrapped = true

local function notify(msg)
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "Fling Gui V1",
            Text = msg,
            Duration = 3
        })
    end)
end

local function refreshPlayers()
    for _, child in ipairs(sidebar:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 40)
            container.BackgroundTransparency = 1
            container.Parent = sidebar

            local img = Instance.new("ImageLabel", container)
            img.Size = UDim2.new(0, 30, 0, 30)
            img.Position = UDim2.new(0, 5, 0.5, -15)
            img.BackgroundTransparency = 1
            img.Image = Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)

            local btn = Instance.new("TextButton", container)
            btn.Size = UDim2.new(1, -40, 1, 0)
            btn.Position = UDim2.new(0, 40, 0, 0)
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Text = plr.Name
            btn.Font = Enum.Font.Gotham
            btn.TextScaled = true
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

            btn.MouseButton1Click:Connect(function()
                box.Text = plr.Name
            end)
        end
    end
end


task.spawn(function()
    while gui.Parent do
        refreshPlayers()
        task.wait(2)
    end
end)

local function getTarget(name)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Name:lower():find(name:lower()) then
            return plr
        end
    end
end

local function flingTarget(target)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local tchar = target.Character
    if not tchar then return end

    local thrp = tchar:FindFirstChild("HumanoidRootPart")
    if not thrp then return end

    local connection
    local timer = 0
    local duration = 7  -- 7 second fling duration

    -- (Optional) Break joints to ensure physics override – adjust if needed.
    char:BreakJoints()

    connection = RunService.Heartbeat:Connect(function(dt)
        timer = timer + dt
        if timer >= duration then
            connection:Disconnect()
            task.wait(0.2)

            -- Reset the character after fling by setting health to 0.
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.Health = 0  -- Set health to 0 to reset the character (die)
                end
            end
        else
            -- Aim directly at the target's HRP position with an offset and full chaos spin
            local targetPos = thrp.Position + Vector3.new(0, 2, 0)
            hrp.CFrame = CFrame.new(targetPos) * CFrame.Angles(
                math.rad(math.random(0, 360)), 
                math.rad(math.random(0, 360)), 
                math.rad(math.random(0, 360))
            )
            hrp.AssemblyAngularVelocity = Vector3.new(
                math.random(-10000, 10000),
                math.random(-10000, 10000),
                math.random(-10000, 10000)
            )
            hrp.AssemblyLinearVelocity = Vector3.new(100, 100, 100)
        end
    end)
end

flingBtn.MouseButton1Click:Connect(function()
    local name = box.Text
    if name == "" then
        notify("Pick a player first!")
        return
    end

    local target = getTarget(name)
    if not target then
        notify("Player not found!")
        return
    end

    notify("FLINGING " .. target.Name .. "!!")
    flingTarget(target)
end)

-- Fling Gui V1 | Made By: TheEpicGamer16YT | Tested By: Dorinel2020t

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "FlingGui"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 500, 0, 300)
frame.Position = UDim2.new(0.5, -250, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Active = true
frame.Draggable = true
frame.BorderSizePixel = 0

Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Fling Gui V1.2"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 20

local sidebar = Instance.new("ScrollingFrame", frame)
sidebar.Size = UDim2.new(0, 150, 1, -30)
sidebar.Position = UDim2.new(0, 0, 0, 30)
sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
sidebar.ScrollBarThickness = 4
sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", sidebar)

local selectedBox = Instance.new("TextBox", frame)
selectedBox.Size = UDim2.new(0, 200, 0, 30)
selectedBox.Position = UDim2.new(0, 160, 0, 40)
selectedBox.PlaceholderText = "Selected player..."
selectedBox.Text = ""
selectedBox.TextColor3 = Color3.new(1,1,1)
selectedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", selectedBox)

local flingBtn = Instance.new("TextButton", frame)
flingBtn.Size = UDim2.new(0, 100, 0, 30)
flingBtn.Position = UDim2.new(0, 160, 0, 80)
flingBtn.Text = "Fling!"
flingBtn.TextColor3 = Color3.new(1,1,1)
flingBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
Instance.new("UICorner", flingBtn)

local credits = Instance.new("TextBox", frame)
credits.Size = UDim2.new(0, 200, 0, 50)
credits.Position = UDim2.new(0, 160, 1, -60)
credits.Text = "Made By : TheEpicGamer16YT\nTested By : Dorinel2020t"
credits.TextColor3 = Color3.new(1,1,1)
credits.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
credits.TextXAlignment = Enum.TextXAlignment.Left
credits.TextYAlignment = Enum.TextYAlignment.Top
credits.ClearTextOnFocus = false
credits.TextEditable = false
credits.Font = Enum.Font.Code
Instance.new("UICorner", credits)

local potatoBtn = Instance.new("TextButton", frame)
potatoBtn.Size = UDim2.new(0, 30, 0, 30)
potatoBtn.Position = UDim2.new(1, -35, 0, 5)
potatoBtn.Text = "🥔"
potatoBtn.BackgroundColor3 = Color3.fromRGB(100, 60, 30)
Instance.new("UICorner", potatoBtn)

potatoBtn.MouseButton1Click:Connect(function()
    LocalPlayer:Kick("🥔")
end)

-- Notification
function notify(text)
    game.StarterGui:SetCore("SendNotification", {
        Title = "Fling Gui V1.2",
        Text = text,
        Duration = 3
    })
end

-- Fling function
local function flingTarget(target)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local tchar = target.Character
    if not tchar then return end

    local thrp = tchar:FindFirstChild("HumanoidRootPart")
    if not thrp then return end

    -- Collision detection
    local function arePlayersCollidable()
        local tempPart = Instance.new("Part")
        tempPart.Size = Vector3.new(2, 2, 2)
        tempPart.Position = hrp.Position + Vector3.new(0, 5, 0)
        tempPart.Anchored = false
        tempPart.CanCollide = true
        tempPart.Parent = workspace

        local touching = tempPart:GetTouchingParts()
        local collides = false
        for _, part in ipairs(touching) do
            local pChar = part:FindFirstAncestorOfClass("Model")
            if pChar and Players:GetPlayerFromCharacter(pChar) then
                collides = true
                break
            end
        end
        tempPart:Destroy()
        return collides
    end

    if arePlayersCollidable() then
        notify("Collisions with players: ENABLED")
    else
        notify("Collisions with players: DISABLED")
    end

    local timer = 0
    local duration = 7
    local connection

    char:BreakJoints()

    connection = RunService.Heartbeat:Connect(function(dt)
        timer += dt
        if timer >= duration then
            connection:Disconnect()
            notify("Resetting...")
            task.wait(0.25)
            LocalPlayer.Character:BreakJoints()
        else
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

-- Update sidebar with all players
function updatePlayerList()
    sidebar:ClearAllChildren()
    for i, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local btn = Instance.new("TextButton", sidebar)
            btn.Size = UDim2.new(1, -10, 0, 40)
            btn.Position = UDim2.new(0, 5, 0, (i-1)*45)
            btn.Text = "  "..plr.Name
            btn.TextColor3 = Color3.new(1,1,1)
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            Instance.new("UICorner", btn)

            local thumb = Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
            local img = Instance.new("ImageLabel", btn)
            img.Image = thumb
            img.Size = UDim2.new(0, 30, 0, 30)
            img.Position = UDim2.new(0, 5, 0.5, -15)
            img.BackgroundTransparency = 1

            btn.MouseButton1Click:Connect(function()
                selectedBox.Text = plr.Name
            end)
        end
    end
end

updatePlayerList()
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)
while true do
    updatePlayerList()
    task.wait(3)
end

flingBtn.MouseButton1Click:Connect(function()
    local name = selectedBox.Text
    local target = Players:FindFirstChild(name)
    if target then
        flingTarget(target)
    else
        notify("Player not found!")
    end
end)

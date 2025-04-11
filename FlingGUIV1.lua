local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local hrp = player.Character:WaitForChild("HumanoidRootPart")
local frame = script.Parent
local mainFrame = frame:WaitForChild("MainFrame")

local collisionStatus = Instance.new("TextLabel")
collisionStatus.Name = "CollisionStatus"
collisionStatus.Size = UDim2.new(0, 180, 0, 25)
collisionStatus.Position = UDim2.new(1, -190, 0, 5)
collisionStatus.BackgroundTransparency = 1
collisionStatus.TextScaled = true
collisionStatus.Font = Enum.Font.GothamSemibold
collisionStatus.Text = "Checking collisions..."
collisionStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
collisionStatus.TextStrokeTransparency = 0.5
collisionStatus.Parent = frame

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

    if collides then
        collisionStatus.Text = "Collisions: ENABLED"
        collisionStatus.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        collisionStatus.Text = "Collisions: DISABLED"
        collisionStatus.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end

arePlayersCollidable()

local flingButton = Instance.new("TextButton")
flingButton.Size = UDim2.new(0, 200, 0, 50)
flingButton.Position = UDim2.new(0.5, -100, 0.8, 0)
flingButton.Text = "Fling!"
flingButton.TextScaled = true
flingButton.Font = Enum.Font.GothamSemibold
flingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flingButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
flingButton.Parent = mainFrame

flingButton.MouseButton1Click:Connect(function()
    local targetPlayer = -- get selected player
    if targetPlayer then
        local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if targetHRP then
            player.Character:MoveTo(targetHRP.Position)
            local startTime = tick()
            while tick() - startTime < 7 do
                player.Character:SetPrimaryPartCFrame(targetHRP.CFrame * CFrame.Angles(0, math.rad(10), 0))
                wait(0.1)
            end
            player.Character:SetPrimaryPartCFrame(hrp.CFrame)
        end
    end
end)

local potatoButton = Instance.new("TextButton")
potatoButton.Size = UDim2.new(0, 40, 0, 40)
potatoButton.Position = UDim2.new(1, -50, 0, 50)
potatoButton.Text = "🥔"
potatoButton.TextScaled = true
potatoButton.Font = Enum.Font.GothamSemibold
potatoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
potatoButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
potatoButton.Parent = mainFrame

potatoButton.MouseButton1Click:Connect(function()
    player:Kick("🥔")
end)

local playerListFrame = Instance.new("ScrollingFrame")
playerListFrame.Size = UDim2.new(0, 200, 0, 200)
playerListFrame.Position = UDim2.new(0, 10, 0, 50)
playerListFrame.ScrollBarThickness = 10
playerListFrame.BackgroundTransparency = 1
playerListFrame.Parent = mainFrame

local function updatePlayerList()
    playerListFrame:ClearAllChildren()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            local playerButton = Instance.new("TextButton")
            playerButton.Size = UDim2.new(0, 180, 0, 40)
            playerButton.Text = p.Name
            playerButton.TextScaled = true
            playerButton.Font = Enum.Font.GothamSemibold
            playerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            playerButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            playerButton.Parent = playerListFrame

            local avatarImage = Instance.new("ImageLabel")
            avatarImage.Size = UDim2.new(0, 30, 0, 30)
            avatarImage.Position = UDim2.new(0, 5, 0, 5)
            avatarImage.Image = "https://www.roblox.com/bust-thumbnail/image?userId=" .. p.UserId .. "&width=100&height=100&format=png"
            avatarImage.Parent = playerButton
        end
    end
end

while true do
    updatePlayerList()
    wait(3)
end

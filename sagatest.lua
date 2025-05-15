-- ...existing code...

local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera

local autoTpEnemy = false
local tpEnemyConnection

local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

LocalPlayer.CharacterAdded:Connect(function(char)
    character = char
    humanoidRootPart = nil
    repeat wait() until char:FindFirstChild("HumanoidRootPart")
    humanoidRootPart = char.HumanoidRootPart
    humanoid = char:WaitForChild("Humanoid")
    camera.CameraSubject = humanoid
    camera.CameraType = Enum.CameraType.Custom
end)

local function findNearestEnemy()
    local mobsFolder = workspace:FindFirstChild("Enemy")
    if not mobsFolder then return nil end
    local mobs = mobsFolder:FindFirstChild("Mob")
    if not mobs then return nil end

    if not humanoidRootPart then return nil end

    local nearestMob = nil
    local nearestDistance = math.huge
    for _, mob in pairs(mobs:GetChildren()) do
        if mob:IsA("Model") and mob:FindFirstChild("HumanoidRootPart") then
            local mobHRP = mob.HumanoidRootPart
            local dist = (mobHRP.Position - humanoidRootPart.Position).Magnitude
            if dist < nearestDistance then
                nearestDistance = dist
                nearestMob = mob
            end
        end
    end
    return nearestMob
end

AutoPlaySection:AddToggle("AutoTPEnemy", {
    Title = "Auto TP Enemy",
    Default = false,
    Callback = function(Value)
        autoTpEnemy = Value
        if autoTpEnemy then
            tpEnemyConnection = RunService.Heartbeat:Connect(function()
                if character and humanoidRootPart and humanoid then
                    local nearestEnemy = findNearestEnemy()
                    if nearestEnemy and nearestEnemy:FindFirstChild("HumanoidRootPart") then
                        local enemyHRP = nearestEnemy.HumanoidRootPart
                        local targetPos = enemyHRP.Position - Vector3.new(0, 7, 0)
                        -- Hướng mặt lên trời
                        local lookDir = Vector3.new(0, 1, 0)
                        character:PivotTo(CFrame.new(targetPos, targetPos + lookDir))
                        camera.CameraSubject = humanoid
                        camera.CameraType = Enum.CameraType.Custom
                    end
                end
            end)
        else
            if tpEnemyConnection then
                tpEnemyConnection:Disconnect()
                tpEnemyConnection = nil
            end
        end
    end
})

-- ...existing code...

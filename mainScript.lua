--4692517897
--4692605521
local serverStorage = game:GetService("ServerStorage")
local replicatedStorage = game:GetService("ReplicatedStorage")
local KOValue = "Kills"
local WOValue = "Wipeouts"
local damage = 30
local ah = game.Workspace.DeathSound

function tagHumanoid(humanoid, player)
				local Creator_Tag = Instance.new("ObjectValue")
				Creator_Tag.Name = "creator"
				Creator_Tag.Value = player
				Creator_Tag.Parent = humanoid
end

function UntagHumanoid(humanoid)
	for i, v in pairs(humanoid:GetChildren()) do
		if v:IsA("ObjectValue") and v.Name == "creator" then
			v:Destroy()
		end
	end
end


replicatedStorage.ShootEvent.OnServerEvent:Connect(function(player,tool,position,part)
	
	if game.Workspace[player.Name].Humanoid.Health <= 0 then
	else
			local distance = (tool.Handle.CFrame.p - position).magnitude
			if game.Workspace:FindFirstChild(player.Name.."‘s Trajectory") then
				game.Workspace:FindFirstChild(player.Name.."‘s Trajectory"):Destroy()
			end
		local trajectory = Instance.new("Part")
		local smoke = serverStorage.SmokeParticle:Clone()
		smoke.Parent = tool.Handle
		trajectory.BrickColor = BrickColor.new("Really red")
		trajectory.Material = "SmoothPlastic"
		trajectory.Name = player.Name.."'s Trajectory"
		trajectory.Transparency = 0.5
		trajectory.Anchored = true
		trajectory.Locked = true
		trajectory.CanCollide = false
		trajectory.Parent = game.Workspace
		trajectory.Size = Vector3.new(0.3,0.3,distance)
			for i = 0,distance,6 do
				trajectory.CFrame = CFrame.new(tool.Handle.CFrame.p,position) * CFrame.new(0,0,-distance / 2)
				wait(0.0001)
			end
			
		smoke:Destroy()
			if part then
				if part.Name == "Head" or part:IsA("Hat") or part:IsA("Accessory") and part.Parent:FindFirstChild("Humanoid").Health > 0 then
					if part.Parent:FindFirstChild("creator") then
						part.Parent.creator:Destroy()	
						tagHumanoid(part.Parent.Humanoid,player)			
					end
					replicatedStorage.Headshot:FireClient(player)
					damage = 50
					trajectory:Destroy()
			end
				local humanoid = part.Parent:FindFirstChild("Humanoid")
					if  humanoid then
						humanoid:TakeDamage(damage)
							if humanoid.Health <= 0 then
								player.leaderstats[KOValue].Value = player.leaderstats[KOValue].Value + 1
								ah:Play()
								game.Players[humanoid.Parent.Name].leaderstats[WOValue].Value = game.Players[humanoid.Parent.Name].leaderstats[WOValue].Value
							end
					end	
					wait(.5)
						if trajectory then
							trajectory:Destroy()		
						end
			end
		end
end)

replicatedStorage.EquipAnimation.OnServerEvent:Connect(function(player,animation)
	local newAnim = game.Workspace[player.Name].Humanoid:LoadAnimation(animation)
	newAnim:Play()
	replicatedStorage.UnequipAnimation.OnServerEvent:Connect(function(player,animation)
		newAnim:Stop()
		for i,v in pairs(game.Workspace:GetChildren()) do
			if v.Name == player.Name.."'s Trajectory" then
				v:Destroy()
			end
		end
	end)
	
	replicatedStorage.Reload.OnServerEvent:Connect(function(player,animation)
		newAnim:Stop()
			local reloadAnim = game.Workspace[player.Name].Humanoid:LoadAnimation(animation)
			reloadAnim:Play()
	end)
end)
function checkBodyType(player,tool)
if game.Workspace[player.Name]:FindFirstChild("LowerTorso") then 
tool.shoot.AnimationId = "rbxassetid://4692517897"
tool.reload.AnimationId = "rbxassetid://4692605521"
return "R15"
end
end
replicatedStorage.CheckBodyType.OnServerInvoke = checkBodyType 


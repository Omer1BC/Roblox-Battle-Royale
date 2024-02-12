game.Players.PlayerAdded:Connect(function(player)
local leaderstats = Instance.new("IntValue",player)
leaderstats.Name = "leaderstats"

local kills = Instance.new("IntValue",leaderstats)
kills.Name = "Kills"
kills.Value = 0

local wipeouts = Instance.new("IntValue",leaderstats)
wipeouts.Name = "Wipeouts"
wipeouts.Value = 0

player.CharacterAdded:Connect(function(character)
	character.Humanoid.WalkSpeed = 16	
	character.Humanoid.Died:Connect(function()
	if character.Humanoid and character.Humanoid:FindFirstChild("creator") then
		game.ReplicatedStorage.Status.Value = tostring(character.Humanoid.creator.Value).. " Killed "..player.Name 
    end
		if character:FindFirstChild("GameTag") then
			character.GameTag:Destroy()
		end
		player:LoadCharacter()
	end)	
	end)


end)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local MapsFolder = ServerStorage:WaitForChild("Maps")
local Status = game.ReplicatedStorage.Status
local GameLength = 50
local minPlayers = 2
local reward =25
local gameInProgress = game.ReplicatedStorage.GameInProgress
while true do
	Status.Value = "Waiting for enough players"
	repeat wait(1) until game.Players.NumPlayers >= minPlayers
	Status.Value = "Intermission"
	wait(10)
	local plrs = {}
	for i, player in pairs(game.Players:GetPlayers()) do
		if player then
			table.insert(plrs,player)
		end
	end
	wait(2)
	local AvailableMaps = MapsFolder:GetChildren()
	local ChosenMap = AvailableMaps[math.random(1,#AvailableMaps)]
	Status.Value = ChosenMap.Name .. " Chosen"
	local ClonedMap = ChosenMap:Clone()
	ClonedMap.Parent = workspace
	
	local SpawnPoints = ClonedMap:FindFirstChild("SpawnPoints")
	if not SpawnPoints then
		print("No spawnpoints")
	end
	local AvailableSpawnPoints = SpawnPoints:GetChildren()
	for i, player in pairs(plrs) do
		if player then
			character = player.Character
			if character then
				
				character:FindFirstChild("HumanoidRootPart").CFrame = AvailableSpawnPoints[1].CFrame + Vector3.new(0,10,0)
				player.CameraMode = Enum.CameraMode.LockFirstPerson
				gameInProgress.Value = true
				table.remove(AvailableSpawnPoints,1)
				
				local Sword = ServerStorage.Gun:Clone()
				Sword.Parent = player.Backpack
				
				local GameTag = Instance.new("BoolValue")
				 GameTag.Name = "GameTag"
				 GameTag.Parent = player.Character
			else
				if not player then
					table.remove(plrs,i)
				end	
			end
		end

	end
	Status.Value = "Get ready to play!"
	for i = GameLength,0,-1 do
		for x, player in pairs(plrs) do
			if player then
				character = player.Character
				if not character then
					table.remove(plrs,x)
				else
					if character:FindFirstChild("GameTag") then
						print(player.Name.." is still in the game!")
					else
						table.remove(plrs,x)
					end
				end
			else
				table.remove(plrs,x)
				print(player.Name.." hasbeen removed!")
			end
		end
		Status.Value = "There are "..i.." seconds remaining, and "..#plrs.." players left"
		if #plrs == 1 then
			Status.Value = "The winner is "..plrs[1].Name
--			plrs[1].leaderstats.Bucks.Value = plrs[1].leaderstats.Bucks.Value + reward
			break
		elseif #plrs == 0 then
			Status.Value = "Nobody Won"	
		elseif i == 0 then
			Status.Value = "Times Up!"
			break
		end
		wait(1)
	end
	print("End")
	wait(2)
	for i,player in pairs(game.Players:GetPlayers()) do
		character = player.Character
		if character then
			if character:FindFirstChild("GameTag") then
				character.GameTag:Destroy()
				player.CameraMode = Enum.CameraMode.Classic
				
			
				
				
				
				
			end
			if player.Backpack:FindFirstChild("Sword") then
				player.Backpack.Sword:Destroy()
			end
			if character:FindFirstChild("Sword") then
				character.Sword:Destroy()
			end
			
		end
		gameInProgress.Value = false
		player:LoadCharacter()
	end
	ClonedMap:Destroy()
	Status.Value = "Game Ended"
	wait(2)
	
	
end --whileLoop

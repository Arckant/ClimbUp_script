anims = {
  {'climb1', 'climb1c'},
  {'climb2', 'climb2clip'},
  {'climb3', 'climb3clip'},
  {'boost1', 'boost1c'},
  {'boost2', 'boost2c'}
}

RegisterNetEvent("PickUp", function()
	local player = PlayerPedId()
  local range = 0.0
  local edgecoord = GetOffsetFromEntityInWorldCoords(player, 0.0, range, -1.0)

	for i = 1, 20, 1 do
    local playeroffset = GetOffsetFromEntityInWorldCoords(player, 0.0, range, 0.0)
    local playeroffset1 = GetOffsetFromEntityInWorldCoords(player, 0.0, range, -5.0)
    endpoint = Raycast(playeroffset, playeroffset1)
    range = range + 0.1
		line(endpoint)

    if math.abs(edgecoord.z - endpoint.z) < 0.1 or edgecoord.z < endpoint.z then edgecoord = endpoint end
    if #(playeroffset - endpoint) > 2.5 and  #(playeroffset - endpoint) < 5 then interpoint = endpoint end
	end

	local endpoint = interpoint
	if interpoint == nil then return end

	SetEntityCoords(player, edgecoord, false, false, false, false) 
	
	Citizen.Wait(11)
	
	local animoffset1 = GetOffsetFromEntityInWorldCoords(player, 0.0, -0.4, -1.0)
	local animoffset = GetOffsetFromEntityInWorldCoords(player, 0.0, 1.25, -5.0)
	local heading = GetEntityHeading(player) + 180
	
	SetEntityCoords(player, animoffset1, false, false, false, false)
	
	local i = 0
	RequestAnimDict(anims[1][1])
	while not HasAnimDictLoaded(anims[1][1]) and i < 30 do
		i = i + 1
		Citizen.Wait(1)
	end
	if not HasAnimDictLoaded(anims[1][1]) then return end
	
	TaskPlayAnim(player, anims[1][1], anims[1][2], 4.0, 4.0, -1, 1026, 0)

	local i = 0
	RequestAnimDict(anims[3][1])
	while not HasAnimDictLoaded(anims[3][1]) and i < 30 do
		i = i + 1
		Citizen.Wait(1)
	end

	TriggerServerEvent("SetClimbUpMarker", animoffset, heading, endpoint)

	Citizen.CreateThread(function()
		while IsEntityPlayingAnim(player, anims[1][1], anims[1][2], 3) do
			Wait(100)
		end
		TriggerServerEvent("DeleteClimbUpMarker")
	end)

end)

RegisterNetEvent("ClimbUpMarker", function(animoffset, heading, endpoint, initiator)
	Citizen.CreateThread(function()
		while not closethread1 do
			
			local sleep = 2000
			local player = PlayerPedId()
			local pos = GetEntityCoords(player)
			local coord = endpoint
			local dist = GetDistanceBetweenCoords(pos, coord, true)

			if dist < 30.0 then
				sleep = 0
				DrawMarker(20, coord.x, coord.y, coord.z+1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 100, 0, 1)
				
				if dist < 1.5 then
					
					BeginTextCommandDisplayHelp("STRING")
					AddTextComponentString('E')
					EndTextCommandDisplayHelp(0,0,1, 500)
					
					if IsControlJustPressed(0, 38) then 
						local i = 0
						RequestAnimDict(anims[2][1])
						while not HasAnimDictLoaded(anims[2][1]) and i < 30 do
							i = i + 1
							Citizen.Wait(10)

						end
						if not HasAnimDictLoaded(anims[2][1]) then return end
						
						TriggerServerEvent('TriggerClimbUpMarker', animoffset, heading, initiator)
						TriggerServerEvent("DeleteClimbUpMarker")
					end
				end
			end
			Citizen.Wait(sleep)
		end
		return
	end)
end)

RegisterNetEvent('DeleteClimbUpMarker', function() closethread1 = true end)

RegisterNetEvent("ClimbUp1", function()
	local player = PlayerPedId()
	--local coord = GetEntityCoords(player)
  TaskPlayAnim(player, anims[3][1], anims[3][2], 4.0, 4.0, -1, 1024, 0)
	--SetEntityCoords(player, coord)

  RemoveAnimDict(anims[3][1])

end)

RegisterNetEvent("ClimbUp2", function(animoffset, heading)
	local player = PlayerPedId()

  SetEntityCoords(player, animoffset, false, false, false, false) 
	SetEntityHeading(player, heading)
	
  TaskPlayAnim(player, anims[2][1], anims[2][2], 4.0, 4.0, -1, 1024, 0)

  RemoveAnimDict(anims[2][1])
end)

RegisterCommand("Boost", function()
	local player = PlayerPedId()
  local offset = GetOffsetFromEntityInWorldCoords(player, 0.0, 0.15, -1.0)
  local animoffset = GetOffsetFromEntityInWorldCoords(player, 0.0, 0.7, 0.0)
	local heading = GetEntityHeading(player)
	FreezeEntityPosition(player, 1)
	
	local i = 0
	RequestAnimDict(anims[4][1])
	while not HasAnimDictLoaded(anims[4][1]) and i < 30 do
		i = i + 1
		Citizen.Wait(10)
	end
	if not HasAnimDictLoaded(anims[4][1]) then return end

  TaskPlayAnim(player, anims[4][1], anims[4][2], 4.0, 4.0, -1, 2, 0)

	Wait(0)

	TriggerServerEvent("SetBoostMarker", offset, animoffset, heading)
end)

RegisterNetEvent("BoostEntityRemove", function(entity)
	local player = PlayerPedId()
	Citizen.CreateThread(function()
		while IsEntityPlayingAnim(player, anims[4][1], anims[4][2], 3) do
			Wait(100)
		end
		TriggerServerEvent('DeleteBoostMarker', entity)
		return
	end)
end)

RegisterNetEvent("BoostMarker", function(offset, animoffset, heading, entity, initiator)
	Citizen.CreateThread(function()
		Wait(0)
		local entity = NetToObj(entity)
		SetEntityAlpha(entity, 0, 1)

		while not closethread2 and initiator ~= GetPlayerServerId(PlayerId()) do
			local sleep = 2000
			local player = PlayerPedId()
			local pos = GetEntityCoords(player)
			local dist = GetDistanceBetweenCoords(pos, offset, true)
			if dist < 30.0 then
				sleep = 0
				DrawMarker(0, offset.x, offset.y, offset.z+1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 0, 0, 1)
				
				if dist < 1.3 then
					
					BeginTextCommandDisplayHelp("STRING")
					AddTextComponentString('E')
					EndTextCommandDisplayHelp(0,0,1, 500)
					
					if IsControlJustPressed(0, 38) then 
						local entity = ObjToNet(entity)
						TriggerServerEvent('TriggerBoostMarker', animoffset, heading, entity, initiator)
						
					end
				end
			end
			Citizen.Wait(sleep)
		end
	end)
end)

RegisterNetEvent('DeleteBoostMarker', function(entity) closethread2 = true DeleteEntity(NetToObj(entity)) end)

RegisterNetEvent("Boost1", function()
	local player = PlayerPedId()

end)

RegisterNetEvent("Boost2", function(animoffset, heading, entity)
	local player = PlayerPedId()

	SetEntityCollision(NetToObj(entity), 1, 0)
	
	local i = 0
	RequestAnimDict(anims[5][1])
	while not HasAnimDictLoaded(anims[5][1]) and i < 30 do
		i = i + 1
		Citizen.Wait(10)
	end
	if not HasAnimDictLoaded(anims[5][1]) then return end

	SetEntityHeading(player, heading + 180)
  SetEntityCoords(player, animoffset.x, animoffset.y, animoffset.z -1) 
  TaskPlayAnim(player, anims[5][1], anims[5][2], 8.0, 8.0, -1, 1024, 0.0)
end)

function Raycast(coordFrom, coordTo)
	local ped = PlayerPedId()
	local shapeTest = StartShapeTestLosProbe(coordFrom, coordTo, 4294967295, GetPlayerPed(-1), 0)
	local retval, hit, endCoords, surfaceNormal, entityHit
	local i
	
	while i ~= 2 do
		retval, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(shapeTest)
		i = retval
		Wait(0)
	end
	
	if IsEntityAPed(entityHit) then 
		shapeTest = StartShapeTestLosProbe(coordFrom, coordTo, 4294967295, entityHit, 0)
		retval, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(shapeTest)
	end
	
	if hit then return endCoords end
	return nil
end

function line(c)
	local coords = c
	Citizen.CreateThread(function()
		while true do
			DrawLine(coords.x, coords.y, coords.z, coords.x, coords.y, coords.z + 2, 255, 0, 255, 100)
			Citizen.Wait(0)
		end
	end)
end

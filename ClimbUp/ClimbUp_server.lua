AddEventHandler("SetMarker", function(caller)
  Target = nil
  TriggerEvent('gridsystem:registerMarker', {
		name = 'climb_up_marker',
		pos = cooord,
		scale = vector3(1.5, 1.5, 1.5),
		msg = 'Нажмите Е что-бы забраться',
		control = 'E',
		type = 20,
		color = { r = 130, g = 120, b = 110 },
		action = function()
      Target = GetPlayerPed(source)
			TriggerEvent("PickUp2", Caller, Target)
		end
  end
})
end)

AddEventHandler("PickUp1", function(source)
  Caller = GetPlayerPed(source)
  local x1, y1, z1 = table.unpack(GetEntityCoords(caller))
  local playerpedcoords = vector3(x1, y1, z1 - 1)
  local edgecoord = GetEntityCoords(GetPlayerPed(caller))
  local range = 0.0
  for i = 1, 20, 1 do
    range = range + 0.1
    local playeroffset = GetOffsetFromEntityInWorldCoords(caller, 0.0, range, -0.9)
    local playeroffset1 = GetOffsetFromEntityInWorldCoords(caller, 0.0, range, -10.0)
    local endpoint = raycast(playeroffset, playeroffset1)
    if #(playerpedcoords - endpoint) < 0.5 then edgecoord = endpoint end
    if #(playeroffset - endpoint) > 2.5 and  #(playeroffset - endpoint) < 4 then 
      TriggerEvent("SetMarker", caller)
      SetEntityCoords(caller, edgecoord, false, false, false, false) 
      Citizen.Wait(11)
      animoffset = GetOffsetFromEntityInWorldCoords(caller, 0.0, -1.0, -1.0)
      animoffset2 = GetOffsetFromEntityInWorldCoords(caller, 0.0, -0.065, -1.0)
      SetEntityCoords(caller, animoffset, false, false, false, false)

      RequestAnimDict('wallclimb3@anim')
      while not HasAnimDictLoaded('wallclimb3@anim') do
        Wait(1)
      end
      TaskPlayAnim(caller, 'wallclimb3@anim', 'wallclimb3_clip', 8.0, 8.0, -1, 1026, 0.1)
    end
  end
end)

AddEventHandler("PickUp2", function(caller, target)
  TriggerEvent('gridsystem:unregisterMarker', 'climb_up_marker')

  animoffset2 = GetOffsetFromEntityInWorldCoords(caller, 0.0, -0.065, -1.0)
  SetEntityCoords(target, animoffset2, false, false, false, false) 

  RequestAnimDict('wallclimb1@anim')
  RequestAnimDict('wallclimb2@anim')
  while not HasAnimDictLoaded('wallclimb1@anim') do
    Wait(1)
  end
  
  while not HasAnimDictLoaded('wallclimb2@anim') do
    Wait(1)
  end
  TaskPlayAnim(target, 'wallclimb1@anim', 'wallclimb1_clip', 8.0, 8.0, -1, 1024, 0.1)
  TaskPlayAnim(caller, 'wallclimb2@anim', 'wallclimb2_clip', 8.0, 8.0, -1, 1024, 0.1)
  RemoveAnimDict('wallclimb1@anim')
  RemoveAnimDict('wallclimb2@anim')
end)

AddEventHandler("Boost", function(source)
  local x, y, z = table.unpack(GetPlayerLookingVector(GetPlayerPed(-1), 0.15))
  TaskPlayAnim(GetPlayerPed(source), 'missfbi_s4mop', 'guard_idle_b', 8.0, 8.0, -1, 1, 0.0)
  CreateObject(-1186769817, x, y, z - 0.75, 1, 0, 0)
  local entity = GetEntityInDirection(GetEntityCoords(GetPlayerPed(-1)), GetPlayerLookingVector(GetPlayerPed(-1), 0.15))
  Citizen.Wait(101)
  SetEntityAlpha(entity, 115, 0)
  
end)

function raycast(coordFrom, coordTo)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped, false)
	local shapeTest = StartShapeTestRay(coordFrom, coordTo, 4294967295, GetPlayerPed(-1), 0)
	local retval, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(shapeTest)
	if hit then return endCoords end
	return nil
end

function GetPlayerLookingVector(playerped, radius)
	local yaw = GetEntityHeading(playerped)
	local pitch = 90

	if yaw > 180 then
		yaw = yaw - 360
	elseif yaw < -180 then
		yaw = yaw + 360
	end

	local pitch = pitch * math.pi / 180
	local yaw = yaw * math.pi / 180
	local x = radius * math.sin(pitch) * math.sin(yaw)
	local y = radius * math.sin(pitch) * math.cos(yaw)
	local z = radius * math.cos(pitch)

	local playerpedcoords = GetEntityCoords(playerped)
	local xcorr = -x+ playerpedcoords.x 
	local ycorr = y+ playerpedcoords.y
	local zcorr = z+ playerpedcoords.z -0.5
	local Vector = vector3(tonumber(xcorr), tonumber(ycorr), tonumber(zcorr))
	return Vector
end

function GetEntityInDirection(coordFrom, coordTo)
  local rayHandle = StartShapeTestRay(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 8, GetPlayerPed(-1), 0)
  local _,flag_PedHit,PedCoords,_,PedHit = GetShapeTestResult(rayHandle)
  return PedHit
end
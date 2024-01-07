
RegisterCommand("PickUp", function(source)
	TriggerServerEvent("PickUp1", source)
end)


--Citizen.CreateThread(function()
--	while true do
--		if IsControlJustReleased(1, 288) then -- F1
--			PickUp1()
--    end
--
--		if IsControlJustReleased(1, 289) then -- F2
--			ClearPedTasks(GetPlayerPed(-1))
--			DetachEntity(source, 1, 1)
--		end
--		
--		if IsControlJustReleased(1, 29) then -- F2
--			PickUp2()
--		end
--		Citizen.Wait(1)
--	end
--end)


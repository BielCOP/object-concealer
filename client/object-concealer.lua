RegisterNetEvent('client:createObject')
RegisterNetEvent('client:deleteObject')
RegisterNetEvent('client:loadObject')

-- [[ Eventos ]]

AddEventHandler('client:createObject', function(model, coords) -- vector4 coords
	local object = CreateObject(GetHashKey(model), coords.x, coords.y, coords.z, false, true, true)

	PlaceObjectOnGroundProperly(object)

	SetEntityHeading(object, coords.w)
end)

AddEventHandler('client:deleteObject', function(model, coords, radius) -- only vector3 coords
	local object = GetClosestObjectOfType(coords.x, coords.y, coords.z, radius, GetHashKey(model), true)

	if object then
		DeleteObject(object)
	end
end)

AddEventHandler('client:loadObject', function(model, coords) -- vector4 coords
	local object = CreateObject(GetHashKey(model), coords.x, coords.y, coords.z, false, true, true)

	PlaceObjectOnGroundProperly(object)

	SetEntityHeading(object, coords.w)
end)

-- [[ Threads ]]

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)

		if NetworkIsSessionStarted() then
			TriggerServerEvent('server:loadObjectsToPlayer')
			break
		end
	end
end)

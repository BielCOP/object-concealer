RegisterServerEvent('server:createObject')
RegisterServerEvent('server:loadObjects')
RegisterServerEvent('server:loadObjectsForPlayer')

-- [[ Variáveis ]]

Project = 'Object Concealer - v0.1'
Archive = 'objetos.ini'

local objectData = {}

-- [[ Eventos ]]

AddEventHandler('server:createObject', function(model, coords, time) -- vector4 coords
	table.insert(objectData, {
		model = model,
		coords = coords,
		time = (os.time() + time)
	})
	TriggerClientEvent('client:createObject', -1, model, coords) -- Chamado para todos os players
end)

AddEventHandler('server:loadObjects', function()
	local f = io.open(Archive, 'r')

	if f then
		for x in f:lines() do
			local obj = json.decode(x)

			table.insert(objectData, {
				model = obj.model,
				coords = vector4(obj.coords.x, obj.coords.y, obj.coords.z, obj.coords.w),
				time = obj.time
			})
			print('[' .. Project .. ']' .. #objectData .. ' carregado com sucesso!')
		end
	end
end)

AddEventHandler('server:loadObjectsForPlayer', function()
	local src = source

	for k, v in pairs(objectData) do
		TriggerClientEvent('client:loadObject', src, v.model, v.coords)
	end
end)

-- [[ Threads ]]

Citizen.CreateThread(function()
	TriggerEvent('server:loadObjects')

	while true do
		Citizen.Wait(1000)

		for k, v in pairs(objectData) do
			if v.time < os.time() then
				TriggerClientEvent('client:deleteObject', -1, v.model, v.coords, 1.0) -- Chamado para todos os players

				objectData[k] = nil
			end
		end

		_saveObjects()
	end
end)

-- [[ Funções ]]

function _saveObjects() -- dini times
	local f = io.open(Archive, 'w+')

	for k, v in pairs(objectData) do
		f:write(json.encode(v) .. '\n')
	end

	f:close()
end

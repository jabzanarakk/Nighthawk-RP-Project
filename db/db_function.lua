-- Loading MySQL Class
require "resources/sarp/lib/MySQL"

local dbIP = SARP_SETTINGS.dbIP
local dbName = SARP_SETTINGS.dbName
local dbUser = SARP_SETTINGS.dbUser
local dbPass = SARP_SETTINGS.dbPass

-- MySQL:open("IP", "databasname", "user", "password")
MySQL:open(dbIP, dbName, dbUser, dbPass)

function LoadUser(identifier, source, new)
	local executed_query = MySQL:executeQuery("SELECT * FROM users WHERE identifier = '@name'", {['@name'] = identifier})
	local result = MySQL:getResults(executed_query, {'permission_level', 'money', 'identifier', 'group', 'pos'}, "identifier")

	local group = groups[result[1].group]
	Users[source] = Player(source, result[1].permission_level, result[1].money, result[1].identifier, group)

	TriggerClientEvent('sarp:setPlayerDecorator', source, 'rank', Users[source]:getPermissions())
    
    if new then
        newbie[source] = true
    end
end

function isIdentifierBanned(id)
	local executed_query = MySQL:executeQuery("SELECT * FROM bans WHERE banned = '@name'", {['@name'] = id})
	local result = MySQL:getResults(executed_query, {'expires', 'reason', 'timestamp'}, "identifier")

	if(result)then
		for k,v in ipairs(result)do
			if v.expires > v.timestamp then
				return true
			end
		end
	end

	return false
end

AddEventHandler('sarp:getPlayers', function(cb)
	cb(Users)
end)

function hasAccount(identifier)
	local executed_query = MySQL:executeQuery("SELECT * FROM users WHERE identifier = '@name'", {['@name'] = identifier})
	local result = MySQL:getResults(executed_query, {'permission_level', 'money'}, "identifier")

	if(result[1] ~= nil) then
		return true
	end
	return false
end


function isLoggedIn(source)
	if(Users[GetPlayerName(source)] ~= nil)then
	if(Users[GetPlayerName(source)]['isLoggedIn'] == 1) then
		return true
	else
		return false
	end
	else
		return false
	end
end

function registerUser(identifier, name, source)
	-- Inserting Default User Account Stats
	MySQL:executeQuery("INSERT INTO users (`identifier`, `name`, `permission_level`, `money`, `group`) VALUES ('@username', '@name', '0', '@money', 'user')",
	{['@username'] = identifier, ['@name'] = name, ['@money'] = SARP_SETTINGS.startMoney})
	LoadUser(identifier, source, true)
end

function renameCheck(identifier, name)
    local executed_query = MySQL:executeQuery("SELECT * FROM users WHERE identifier = '@id'", {['@id'] = identifier})
    local result = MySQL:getResults(executed_query, {'permission_level', 'name'}, "identifier")
    
    if(result[1].name == name)then
        return false
    end
    return true
end

AddEventHandler("sarp:setPlayerData", function(user, k, v, cb)
	if(Users[user])then
		if(Users[user][k])then

			if(k ~= "money") then
				Users[user][k] = v

				MySQL:executeQuery("UPDATE users SET `@key`='@value' WHERE identifier = '@identifier'",
			    {['@key'] = k, ['@value'] = v, ['@identifier'] = Users[user]['identifier']})
			end

			if(k == "group")then
				Users[user].group = groups[v]
			end

			cb("Player data edited.", true)
		else
			cb("Column does not exist!", false)
		end
	else
		cb("User could not be found!", false)
	end
end)

AddEventHandler("sarp:setPlayerDataId", function(user, k, v, cb)
	MySQL:executeQuery("UPDATE users SET @key='@value' WHERE identifier = '@identifier'",
	{['@key'] = k, ['@value'] = v, ['@identifier'] = user})

	cb("Player data edited.", true)
end)

AddEventHandler("sarp:getPlayerFromId", function(user, cb)
	if(Users)then
		if(Users[user])then
			cb(Users[user])
		else
			cb(nil)
		end
	else
		cb(nil)
	end
end)

AddEventHandler("sarp:getPlayerFromIdentifier", function(identifier, cb)
	local executed_query = MySQL:executeQuery("SELECT * FROM users WHERE identifier = '@name'", {['@name'] = identifier})
	local result = MySQL:getResults(executed_query, {'permission_level', 'money', 'identifier', 'group'}, "identifier")

	if(result[1])then
		cb(result[1])
	else
		cb(nil)
	end
end)

AddEventHandler("sarp:getAllPlayers", function(cb)
	local executed_query = MySQL:executeQuery("SELECT * FROM users", {})
	local result = MySQL:getResults(executed_query, {'permission_level', 'money', 'identifier', 'group'}, "identifier")

	if(result)then
		cb(result)
	else
		cb(nil)
	end
end)

AddEventHandler("sarp:getLastPos", function(cb)
    local executed_query = MySQL:executeQuery("SELECT * FROM users WHERE identifier = '@id'", {['@id'] = identifier})
    local result = MySQL:getResults(executed_query, {'permission_level', 'pos'}, "identifier")
    
    if(result)then
        cb(result[1].pos)
    else
        cb(nil)
    end
end)

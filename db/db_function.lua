local port = 5984 -- Change to whatever port you have CouchDB running on
local ip = "127.0.0.1" -- Change to wherever your DB is hosted.
local auth = "RWFnbGVvbmU6MTI5NjU3" -- base64 encoded string like this: "user:password", so, "root:1202" is what is here, (without quotes)
local dbName = LSRP_SETTINGS.dbName -- define local database name for server

db = {}
exposedDB = {}

function db.firstRunCheck()
	PerformHttpRequest("http://" .. ip .. ":" .. port .. "/" .. dbName, function(err, rText, headers)
		if err == 0 then
			print("First run detected, setting up.")
		else
			print("^ Ignore that, Setup already ran, continueing.")
		end
	end, "PUT", "", {Authorization = "Basic " .. auth})
end

function db.performCheckRunning()
	PerformHttpRequest("http://" .. ip .. ":" .. port .. "", function(err, rText, headers)
	end, "GET", "", {Authorization = "Basic " .. auth})
end

-- First run check
db.firstRunCheck()

function exposedDB.createDatabase(db, cb)
	PerformHttpRequest("http://" .. ip .. ":" .. port .. "/" .. db, function(err, rText, headers)
		if err == 0 then
			cb(true, 0)
		else
			cb(false, rText)
		end
	end, "PUT", "", {Authorization = "Basic " .. auth})
end

-- query function

function exposedDB.createDocument(db, rows, cb)
	PerformHttpRequest("http://" .. ip .. ":" .. port .. "/_uuids", function(err, rText, headers)
		PerformHttpRequest("http://" .. ip .. ":" .. port .. "/" .. db .. "/" .. json.decode(rText).uuids[1], function(err, rText, headers)
			if err == 0 then
				cb(true, 0)
			else
				cb(false, rText)
			end
		end, "PUT", json.encode(rows), {["Content-Type"] = 'application/json', Authorization = "Basic " .. auth})
	end, "GET", "", {Authorization = "Basic " .. auth})
end

function exposedDB.getDocumentByRow(db, row, value, callback)
	local qu = {selector = {[row] = value}}
	PerformHttpRequest("http://" .. ip .. ":" .. port .. "/" .. db .. "/_find", function(err, rText, headers)
		local t = json.decode(rText)

		if(err == 0)then
			if(t.docs[1])then
				callback(t.docs[1])
			else
				callback(false)
			end
		else
			callback(false, rText)
		end
	end, "POST", json.encode(qu), {["Content-Type"] = 'application/json', Authorization = "Basic " .. auth})		
end

function exposedDB.updateDocument(db, documentID, updates, callback)
	PerformHttpRequest("http://" .. ip .. ":" .. port .. "/" .. db .. "/" .. documentID, function(err, rText, headers)
		local doc = json.decode(rText)

		if(doc)then
			for i in pairs(updates)do
				doc[i] = updates[i]
			end

			PerformHttpRequest("http://" .. ip .. ":" .. port .. "/" .. db .. "/" .. doc._id, function(err, rText, headers)
				callback((err or true))
			end, "PUT", json.encode(doc), {["Content-Type"] = 'application/json', Authorization = "Basic " .. auth})
		end
	end, "GET", "", {["Content-Type"] = 'application/json', Authorization = "Basic " .. auth})	
end

-- Why the fuck is this required?
local theTestObject, jsonPos, jsonErr = json.decode('{"test":"tested"}')

-- normal function

function dbRegisterUser(identifier, source)
    print ('dbRegisterUser - start')
    local startMoney = LSRP_SETTINGS.startMoney
    exposedDB.createDocument(dbName, {identifier = identifier, playerName = GetPlayerName(source), money = startMoney, group = "user", permission = 0}, function(cb)
        if cb then
            print ('insert pass')
        else
            print ('insert bad' .. cb)
        end
    end)
end

function dbLoadUser(identifier, source)
    print ('dbLoadUser - start')
    exposedDB.getDocumentByRow(dbName, "identifier", identifier, function(data)
        local group = groups[data.group]

        playerData[source] = Player(source, data.playerName, data.permission, data.money, data.identifier, group)
    end)
end

function dbGetUser(identifier, source)
    print ('dbLoadUser')
	exposedDB.getDocumentByRow(dbName, "identifier", identifier, function(data)
		print ('exposedDB.getDocumentByRow')
        local data = data
        if not data then
            print ('exposedDB.getDocumentByRow - true')
            dbRegisterUser(identifier, source)
        else
            print ('exposedDB.getDocumentByRow - else')
            dbLoadUser(identifier, source)
        end
	end)
end

function renameCheck (identifier, name)
    exposedDB.getDocumentByRow(dbName, "identifier", identifier, function(data)
        local data = data
        if not data then
            print ('New Player Join ' .. name)
            return true
        else
            print ('Anti Rename Check - else')
            local dataName = data.playerName
            print ('Old ' .. dataName)
            if dataName == name then
                print ('Anti Rename Check - true')
                return true
            end
            print ('Anti Rename Check - false')
            return false
        end
    end)
end
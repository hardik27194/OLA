------ database class------------------------------------------------
--local db=require "lua/db.lua"

database = {}
function database.conn ()   
	Log:d('database','conn execute...')
	--api.dbConnection()
end   
function database.open(db_name)
	Log:d('database','open execute...')
	connection:open(db_name,false)
end

function database.exec(sql)
	Log:d('database','createTable execute...')
	connection:execSQL(sql)
end

function database.query(sql,...)
	Log:d('database','execute sql...')
	local data=connection:query(sql,'')
	Log:d('database','returned data='..data)
	return loadstring('return {'..data..'}')()
end
function database.close()	
	connection:close()
	Log:d('database','db  was closed ...')
end
------ end database class------------------------------------------------
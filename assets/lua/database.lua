------ Database class------------------------------------------------
--local db=require "lua/db.lua"

Database = {}
 Database.__index=Database
 Database.instance=nil
 function Database:new() 
     local temp = {e={}} 
     setmetatable(temp, Database) 
     return temp 
 end 

function Database:conn()   
	Log:d('Database','conn execute...')
	--api.dbConnection()
	self.instance=DBConn:create()
end   
function Database:open(db_name)
	Log:d('Database','open execute...')
	self.instance:open(db_name)
end

function Database:exec(sql)
	Log:d('Database','createTable execute...')
	self.instance:execSQL(sql)
end

function Database:query(sql,...)
	Log:d('Database','execute sql...')
	local data=self.instance:query(sql,'')
	--Log:d('Database','returned data='..data)
	if data~="" and string.len(data)>0 then
		data= string.gsub(data, "^%s*(.-)%s*$", "%1")  --trim()
		data= string.gsub(data, "\n", "\\n")
		data= string.gsub(data, "\r", "\\n")
		Log:d('Database','returned data='..data)
		return loadstring('return {'..data..'}')()
	else
		--Log:d('Database','returned nil')
		return nil
	end
end
function Database:close()	
	self.instance:close()
	Log:d('Database','db  was closed ...')
end
------ end Database class------------------------------------------------
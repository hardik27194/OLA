--Check versions of the portal and apps, then auto download and install

require "JSON4Lua"

function initiate()
	--check OLA platform's version
	Log:d('HTTP','update is started')
	Log:d('HTTP',type(lbl_msg))
	Log:d('HTTP OLA.esb=',type(OLA.esb))
	--if not has named a ESB server, start the application directely
	if OLA.esb==nil then
		LMProperties:startApp("olaportal")
	else
		local uimsg=AsyncTask:create()
		uimsg:sendMessage('lbl_loading:setText("Checking new versions...")')
		local http=HTTP:create(OLA.esb..'checkVersion.json')
		Log:d('HTTP',OLA.esb..'checkVersion.json')
		http:setComplitedCallback("checkVersion")
		http:sendRequest()
		--http:receive()
	end
end
function checkVersion (http)
	local state=http:getState()
	local content=http:getContent()
	Log:d('HTTP','state='..state)
	Log:d('HTTP','content='..content)
	local uimsg=AsyncTask:create()
	if state==-2 or state==-3 then
		uimsg:sendMessage('lbl_loading:setText("Connecting to server is failed.")')
		LMProperties:startApp("olaportal")
	else
		uimsg:sendMessage('lbl_loading:setText("Downloading new version files.")')

		--if OLA.lua was updated, it will be abailable in the next time after the aplication is restarted

		
		Log:d("Update",'JSON4Lua was loaded')
		local apps=json.decode(content)

		Log:d("Update",'apps type='..type(apps))



		local olaApp={}
		local updateApps={}
		local j=1
		--system apps
		local sysApps=apps.sys
		for i=1, #sysApps do
			olaApp=sysApps[i]
			local version=findSysAppVersion(olaApp.app)
			Log:d("Update",olaApp.app..': new version='..olaApp.version..'; current='..version)
			if version<olaApp.version then
				--update(olaApp.app,olaApp.version)
				--download:addUrl_forKey(OLA.esb.."/version/"..olaApp.app.."/"..olaApp.version..".zip",olaApp.app)
				Log:d("download","addUrl_forKey:"..OLA.esb.."/version/"..olaApp.app.."/"..olaApp.version..".zip")
				updateApps[j]=olaApp
				j=j+1
			end
			if olaApp.app=="olaos" then
				lbl_version:setText("V "..olaApp.version)
			end
			
		end
		
		--merge server side App version info
		for i=1, #apps.user_apps do
		   apps.user_apps[i].state=0;
		end
		--merge server's user app to OLA.user_apps
		mergeTable(OLA.apps.user_apps,apps.user_apps)
		Log:d("OLA.apps.user_apps",'Merged')
		--TODO, need to write to the mobile phone's storage
		local tmpApp=OLA.apps.user_apps
		for i=1, #tmpApp do
		   Log:d("OLA.apps.user_apps",tmpApp[i].title)
		end
		
		--write apps.lua to local storage
		writeAppsConfig(sysApps,tmpApp)


		
		if #updateApps >= 1 then
			local download=AsyncDownload:create();
			download:setDestination(OLA.storage.."/download/")

			for i=1, #updateApps do
					updateApp=updateApps[i]
					download:addUrl_forKey(OLA.esb.."/version/"..updateApp.app.."/"..updateApp.version..".zip",updateApp.app)
					Log:d("download","addUrl_forKey:"..OLA.esb.."/version/"..updateApp.app.."/"..updateApp.version..".zip")
			end

			download:setProcessingCallback("downloadMonitor")
			Log:d("download","setProcessingCallback")
			download:setComplitedCallback("finishDownload")
			download:start()
		else
			lbl_loading:setText("Update Successfull.")
			LMProperties:startApp("olaportal")

		end

		


		--[[
		--user apps
		for i=1, #apps.user_apps do
			olaApp=apps.user_apps[i]
			local version=findUserAppVersion(olaApp.app)
			Log:d("Update",olaApp.app..': new version='..olaApp.version..'; current='..version)
			if version<olaApp.version then
				update(olaApp.app,olaApp.version)
			end
		end
		]]
	end
end

--Merge the elements of table "t2" to table "t1", and the the duplicated elelments will be removed
function mergeTable(t1,t2)
	for i=1, #t2 do
		isInsert=true
			for j=1, #t1 do
				if t1[j].app==t2[i].app then isInsert=false; break; end
			end
		if isInsert then table.insert(t1,t2[i]) end
	end
	return t1
end
function  update(appName,version)
	local remoteFile=OLA.esb.."/version/"..appName.."/"..version..".zip"
	Log:d("Update",'remoteFile='..remoteFile)
	--local localFile=OLA.storage.."/download/"..appName.."_v"..version..".zip"
	local localFile=OLA.storage.."/download/"..version..".zip"
	Log:d("Update",'localFile='..localFile)
	local download =AsyncDownload:create(remoteFile)
	download:setDestination(OLA.storage.."/download/")
	download:start()
	download:receive()
	Log:d("Update",localFile..' was downloaded')
	local zip=Zip:open(localFile)
	zip:unzipTo(OLA.storage.."/download/"..version.."/")

end
function findUserAppVersion (appName)
	local version=0
	local userApps=OLA.apps.user_apps
	Log:d("Update",'userApps:'..type(userApps))
	for i=1, #userApps do
		local currentApp=userApps[i]
		if currentApp.app == appName then
			version=currentApp.version
		end
	end
	return version
end

function findSysAppVersion (appName)
	local version=0
	local apps=OLA.apps.sys
	Log:d("Update",'apps:'..type(apps))
	for i=1, #apps do
		local currentApp=apps[i]
		if currentApp.app == appName then
			version=currentApp.version
		end
	end
	return version
end



function downloadMonitor(state,totalSize, downloadedSize,url,localFileName,key)
	local percent=(1.0*downloadedSize/totalSize)*100
	ProgressBar:setValue(percent)
	lbl_msg:setText(key..':'..math.floor(percent)..'%')
end
function finishDownload(totalNumber,currentNumber,currentUrl,localFileName,key)
	Log:d("Update","finishDownload")
	local percent=(1.0*currentNumber/totalNumber)*100
	ProgressBar2:setValue(percent)
	lbl_loading:setText('Installing...')
	lbl_msg:setText(key..' :'..math.floor(percent)..'%')
	Log:d("Update","unzip to Dir="..OLA.storage.."/download/"..key.."/")
	Log:d("Update","localFileName="..localFileName)

	local zip=Zip:open(localFileName)
	zip:unzipTo(OLA.storage.."/download/"..key.."/")
	Log:d("Update","currentNumber="..currentNumber)
	Log:d("Update","totalNumber="..totalNumber)

	if currentNumber>=totalNumber then
		lbl_loading:setText("Update Successfull.")
		LMProperties:startApp("olaportal")
	end
end

-- write OLA.lua to the local app storage
function writeAppsConfig(sys,user) 
		local user_json=json.encode(user)
		local sys_json=json.encode(sys)
		local all='{"sys":'..sys_json..',"user_apps":'..user_json..'}'
		local olaPath=OLA.app_path.."/"..OLA.base.."/apps.json";
		local fc = fos:open(olaPath,'false')
        fc:writeString(all)
		fc:close();

end


Log:d("Update",'load successfully')

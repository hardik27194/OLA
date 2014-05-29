function initiate()
	Log:d('initiate','initiate execute...')
	Log:d('initiate',type(OLA.apps))
	local apps=OLA.apps.user_apps
	Log:d('initiate','len='..#apps )
	Log:d('initiate','ui type='..type(ui) )
	local barStr='<div layout="LinearLayout"  style="orientation:horizontal;align:left;width:auto;"></div>'
	local bar=""
	local i=1
	local installedApps={}
	local otherApps={}
	local m=1
	local n=1
	for i=1, #apps do
		if apps[i].state==1 then
			Log:d('apps','installed='..apps[i].app )
			installedApps[m]=apps[i]
			m=m+1
		elseif apps[i].state==0 then
			otherApps[n]=apps[i]
			n=n+1
		end
	end
	for i=1, #installedApps do
		if i % 4 == 1 then
			bar=ui:createView(barStr)
			Log:d('initiate','bar='..bar )
			Apps_Panel:addView(bar)
		end 
		--for key, value in pairs(installedApps[i]) do  
		--	Log:d('OLA.apps','key='..key..'; value='..value)  
		--end

			viewStr='<div layout="LinearLayout"  style="orientation:vertical;weight:1px;margin:3px;padding:5px;align:center;"></div>'
			local appPanel=ui:createView(viewStr)
			_G[bar]:addView(appPanel)
			viewStr='<button style="width:48px;height:48px;background-image:url('..apps[i].ico..');valign:middle;" onclick=\'startApplication("'..installedApps[i].app..'")\'></button>'
			local btn=ui:createView(viewStr)
			_G[appPanel]:addView(btn)
			viewStr='<label style="width:auto;align:center;">'..installedApps[i].title..'</label>'
			local appTitle=ui:createView(viewStr)
			_G[appPanel]:addView(appTitle)

	end
	local barCount=#installedApps%4
	Log:d('json',"barCount="..barCount)
	if barCount==0 then barCount=4 end
	barCount=4-barCount
	for j=1,barCount do
			viewStr='<div layout="LinearLayout"  style="orientation:vertical;weight:1px;margin:3px;padding:5px;align:center;"></div>'
			local appPanel=ui:createView(viewStr)
			_G[bar]:addView(appPanel)
			viewStr='<div layout="LinearLayout"  style="width:48px;height:48px;valign:middle;"></div>'
			local btn=ui:createView(viewStr)
			_G[appPanel]:addView(btn)
	end

	for i=1, #otherApps do
		if i % 4 == 1 then
			bar=ui:createView(barStr)
			Log:d('initiate','bar='..bar )
			Apps_Other_Panel:addView(bar)
		end 

			viewStr='<div layout="LinearLayout"  style="orientation:vertical;weight:1px;margin:3px;padding:5px;align:center;"></div>'
			local appPanel=ui:createView(viewStr)
			_G[bar]:addView(appPanel)
			viewStr='<button style="width:48px;height:48px;background-image:url('..apps[i].ico..');valign:middle;" onclick=\'displayInstallMenu("'..otherApps[i].app..'")\'></button>'
			local btn=ui:createView(viewStr)
			_G[appPanel]:addView(btn)
			viewStr='<label style="width:auto;align:center;">'..otherApps[i].title..'</label>'
			local appTitle=ui:createView(viewStr)
			_G[appPanel]:addView(appTitle)

	end
	local barCount=#otherApps%4
	Log:d('json',"barCount="..barCount)
	if barCount==0 then barCount=4 end
	barCount=4-barCount
	for j=1,barCount do
			viewStr='<div layout="LinearLayout"  style="orientation:vertical;weight:1px;margin:3px;padding:5px;align:center;"></div>'
			local appPanel=ui:createView(viewStr)
			_G[bar]:addView(appPanel)
			viewStr='<div layout="LinearLayout"  style="width:48px;height:48px;valign:middle;"></div>'
			local btn=ui:createView(viewStr)
			_G[appPanel]:addView(btn)
	end
	Log:d('json',"..................")


end

function startApplication(appName)
	LMProperties:startApp(appName)
end
function displayInstallMenu(appName)
		local menuStr="<div id='otherAppsMenu' layout='LinearLayout'  style='orientation:vertical;width:auto;height:auto;valign:middle;align:center;alpha:0.8;background-color:#cccccc'><label style='background-color:#ffffff'>The new app will provides new Enterprise services for employees.\nDownload and install the app, you will enjoy it.</label><button style='width:auto;align:center;'>Download</button><button  style='width:auto;align:center;' onclick='closeMenu()'>Cancel</button></div>"
	local view=ui:createView(menuStr)
	body:addView(view)
end
function closeMenu ()
	otherAppsMenu:setVisibility('block');
end

function reload()
	 Log:d("reload","MainMenu Lua reload is executed..")
	 sys.reload()
end

function layerOnPress(id)
	_G[id]:setBackgroundColor("#336699")
end
function layerOnRelease(id)
	_G[id]:setBackgroundColor("#99CCFF")
end
require "JSON4Lua"



--http://php.weather.sina.com.cn/xml.php?city=武汉&password=DJOYnieT8234jlsK&day=0
local baiduWeatherApi='http://api.map.baidu.com/telematics/v3/weather?location=武汉&output=json&ak=vXkp3IQseGUbm7KXOdm6sSOmfbV3aF4R'

function initiate()

		local http=HTTP:create(baiduWeatherApi)
		http:setComplitedCallback("parseBaidu")
		http:sendRequest()
		http:receive()
end

function parseBaidu(http)
	local state=http:getState()
	local content=http:getContent()
	--Log:d('weather',content)
	local weathers=json.decode(content)

	if weathers.error~=0 then 
		temp_lbl:setText('天气变幻莫测，气象局失联。')
	else
		local r=weathers.results[1]
		local city=r.currentCity
		local pm25=r.pm25
		local todayIndex=r.index
		local today=r.weather_data[1]

		pm25_lbl:setText("PM2.5: "..pm25)
		--周六 06月11日 (实时：23℃)
		local current=string.split(today.date," ");
		local cur=string.sub(current[3],11,12)

		current_temp_lbl:setText(cur)
		temp_lbl:setText(today.temperature)
		wind_lbl:setText(today.wind)
		weather_lbl:setText(today.weather)
	end


end



function switch()
	ui:switchView("testLua1.xml","callback('file opener returned param')","file opener params")
end
function reload()
	 sys.reload()
end

function show(pageName)
	ui:switchView(pageName..".xml","callback('file opener returned param')","file opener params")
end

function back2Portal()
	LMProperties:printtype()
	LMProperties:exit()
end

function layerOnPress(id)
	_G[id]:setBackgroundColor("#336699")
end
function layerOnRelease(id)
	_G[id]:setBackgroundColor("#99CCFF")
end

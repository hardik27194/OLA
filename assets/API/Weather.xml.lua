require "JSON4Lua"



--http://php.weather.sina.com.cn/xml.php?city=武汉&password=DJOYnieT8234jlsK&day=0
local baiduWeatherApi='http://api.map.baidu.com/telematics/v3/weather?location=武汉&output=json&ak=vXkp3IQseGUbm7KXOdm6sSOmfbV3aF4R'
--[[
{
    "error": 0,
    "status": "success",
    "date": "2016-06-11",
    "results": [
        {
            "currentCity": "武汉",
            "pm25": "55",
            "index": [
                {
                    "title": "穿衣",
                    "zs": "舒适",
                    "tipt": "穿衣指数",
                    "des": "建议着长袖T恤、衬衫加单裤等服装。年老体弱者宜着针织长袖衬衫、马甲和长裤。"
                },
                {
                    "title": "洗车",
                    "zs": "不宜",
                    "tipt": "洗车指数",
                    "des": "不宜洗车，未来24小时内有雨，如果在此期间洗车，雨水和路上的泥水可能会再次弄脏您的爱车。"
                },
                {
                    "title": "旅游",
                    "zs": "适宜",
                    "tipt": "旅游指数",
                    "des": "温度适宜，又有较弱降水和微风作伴，会给您的旅行带来意想不到的景象，适宜旅游，可不要错过机会呦！"
                },
                {
                    "title": "感冒",
                    "zs": "少发",
                    "tipt": "感冒指数",
                    "des": "各项气象条件适宜，无明显降温过程，发生感冒机率较低。"
                },
                {
                    "title": "运动",
                    "zs": "较不宜",
                    "tipt": "运动指数",
                    "des": "有降水，推荐您在室内进行健身休闲运动；若坚持户外运动，须注意携带雨具并注意避雨防滑。"
                },
                {
                    "title": "紫外线强度",
                    "zs": "最弱",
                    "tipt": "紫外线强度指数",
                    "des": "属弱紫外线辐射天气，无需特别防护。若长期在户外，建议涂擦SPF在8-12之间的防晒护肤品。"
                }
            ],
            "weather_data": [
                {
                    "date": "周六 06月11日 (实时：23℃)",
                    "dayPictureUrl": "http://api.map.baidu.com/images/weather/day/zhongyu.png",
                    "nightPictureUrl": "http://api.map.baidu.com/images/weather/night/zhongyu.png",
                    "weather": "中雨",
                    "wind": "微风",
                    "temperature": "30 ~ 21℃"
                },
                {
                    "date": "周日",
                    "dayPictureUrl": "http://api.map.baidu.com/images/weather/day/xiaoyu.png",
                    "nightPictureUrl": "http://api.map.baidu.com/images/weather/night/duoyun.png",
                    "weather": "小雨转多云",
                    "wind": "微风",
                    "temperature": "27 ~ 21℃"
                },
                {
                    "date": "周一",
                    "dayPictureUrl": "http://api.map.baidu.com/images/weather/day/duoyun.png",
                    "nightPictureUrl": "http://api.map.baidu.com/images/weather/night/duoyun.png",
                    "weather": "多云",
                    "wind": "微风",
                    "temperature": "31 ~ 23℃"
                },
                {
                    "date": "周二",
                    "dayPictureUrl": "http://api.map.baidu.com/images/weather/day/duoyun.png",
                    "nightPictureUrl": "http://api.map.baidu.com/images/weather/night/duoyun.png",
                    "weather": "多云",
                    "wind": "微风",
                    "temperature": "33 ~ 23℃"
                }
            ]
        }
    ]
}
]]--

function initiate()

		local http=HTTP:create(baiduWeatherApi)
		http:setComplitedCallback("parseBaidu")
		http:sendRequest()
		http:receive()
		showGPS()
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

	    local high=""
	    local low=""

		--day1_lbl:setText(today.date)
		wind1_lbl:setText(today.wind)
		weather1_lbl:setText(today.weather)
		local temp=string.split(today.temperature," ");
		high=high..temp[1]
		local i,j=string.find(temp[3],"%d*")
		low=low..string.sub(temp[3],i,j)


		local day2=r.weather_data[2] --tomorrow
		day2_lbl:setText(day2.date)
		wind2_lbl:setText(day2.wind)
		weather2_lbl:setText(day2.weather)
		temp=string.split(day2.temperature," ");
		high=high..","..temp[1]
		i,j=string.find(temp[3],"%d*")
		low=low..","..string.sub(temp[3],i,j)

		local day3=r.weather_data[3]
		day3_lbl:setText(day3.date)
		wind3_lbl:setText(day3.wind)
		weather3_lbl:setText(day3.weather)
		temp=string.split(day3.temperature," ");
		high=high..","..temp[1]
		i,j=string.find(temp[3],"%d*")
		low=low..","..string.sub(temp[3],i,j)

		local day4=r.weather_data[4]
		day4_lbl:setText(day4.date)
		wind4_lbl:setText(day4.wind)
		weather4_lbl:setText(day4.weather)
		temp=string.split(day4.temperature," ");
		high=high..","..temp[1]
		i,j=string.find(temp[3],"%d*")
		low=low..","..string.sub(temp[3],i,j)
	Log:d("Hight",high)
	Log:d("Low",low)
		showLineChart(high,low)
	end


end


function showLineChart(high,low)

	line_chart:clear()
	line_chart:setXValue(' , , , ')
	line_chart:addYValue("高温",high)
	line_chart:addYValue("低温",low)
	line_chart:show()
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

function showGPS()
Log:d("GPS","----------------")
local loc=Location:create()
Log:d("GPS","1----------------")
loc:bdLocate()
Log:f("x",loc:getLatitude())
Log:f("Y",loc:getLongitude())
Log:f("Z",loc:getAltitude())
end
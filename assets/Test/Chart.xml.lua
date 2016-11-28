function initiate()
Log:d("chart","initiate...")
    lineChart()
end


function reload()
	 sys.reload()
end

function layerOnPress(id)
	_G[id]:setBackgroundColor("#336699")
end
function layerOnRelease(id)
	_G[id]:setBackgroundColor("#99CCFF")
end

function back2Portal()
	LMProperties:printtype()
	LMProperties:exit()
end

function lineChart()
Log:d("chart","lineChart...")
    line_chart:clear()
    Log:d("chart","1...")
	line_chart:setXValue("A,B,C,D,E")
    Log:d("chart","2...")
	--line_chart:addYValue(name,ya)
	line_chart:addYValue_withLabel("1.5,2,3.5,4.5,15.5","Test1")
    line_chart:addYValue_withLabel("1,2.5,4,5,0","Test2")
    line_chart:addYValue_withLabel("-2,6,3,4.5,8","Test3")
	line_chart:show()

end
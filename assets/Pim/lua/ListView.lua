Log:d("ListView","loading....")
--TODO add a data list to store item values
ListView={
	 sequence=0,
	 size=0,
	 selected="0",
	 OK=nil,
	 CANCEL=nil
}

 ListView.__index=ListView
 function ListView:new() 
 print(type(self))
     local temp = {
	 e={}

	 } 
     setmetatable(temp, ListView) 
     return temp 
 end 


function ListView:create()
		--self.OK=nil
		--self.CANCEL=nil
		math.randomseed(tostring(os.time()):reverse():sub(1, 6))
		self.dialogId=string.format("Dialog_ListView_%d",math.floor(math.random()*1000000))
		local dialogId=self.dialogId
		local viewStr="<div id='"..dialogId.."' layout='LinearLayout'  style='orientation:vertical;width:auto;height:auto;valign:middle;align:center;alpha:0.8;background-color:#cccccc'><label id='"..dialogId.."_title' layout='LinearLayout'  style='margin:2px;padding:10px;orientation:vertical;width:auto;align:left;alpha:1;background-color:#FFFFFF'>Dialog</label><div id='"..dialogId.."_item' layout='LinearLayout'  style='margin:2px;padding:10px;orientation:vertical;width:auto;align:center;alpha:1;background-color:#FFFFFF'></div><div id='"..dialogId.."_btn' layout='LinearLayout'  style='margin:2px;padding:10px;orientation:horizontal;width:auto;align:center;alpha:1;background-color:#FFFFFF'></div></div>"
		self.view=ui:createView(viewStr)
end

function ListView:setTitle(text)
	_G[self.dialogId.."_title"]:setText(text);
end
function ListView:addItem(value,text)
	self.sequence=self.sequence+1
	local id=self.dialogId .."_item_"..value
	Log:d("ListView",id)
	_G[self.dialogId.."_item"]:addView(ui:createView("<label id='"..id .."' style='width:auto;align:center;margin:2px;background-color:#99FFFF;' onclick='ListView:onItemClick(\""..id.."\")'>"..text.."</label>"))
end
function ListView:OK(text,callback)
	self.OK="<button onclick='"..callback.."()' style='width:auto;weight:1px;align:center;background-color:#FFFFCC;margin:2px;'>"..text.."</button>"
	_G[self.dialogId.."_btn"]:addView(ui:createView(self.OK))
end
function ListView:CANCEL(text,callback)
	local callStr;
	if callback~=nil 
	then
		callStr=callback.."()"
	else
		callStr=self.dialogId..':setVisibility("block")'
	end
	self.CANCEL="<button onclick='"..callStr.."' style='width:auto;weight:1px;align:center;background-color:#FFFFCC;margin:2px;'>"..text.."</button>"
	_G[self.dialogId.."_btn"]:addView(ui:createView(self.CANCEL))
end
function ListView:showOn(bodyId)
	--if self.OK~=nil then self:addView(self.OK) end
	--if self.CANCEL~=nil then self:addView(self.CANCEL) end
	_G[bodyId]:addView(self.view)
end

function ListView:onItemPressed(itemId)
	_G[itemId]:setBackgroundColor("#FF9900")
end	

function ListView:onItemClick(itemId)
	local lastItem=_G[self.selected]
	if lastItem~=nil then lastItem:setBackgroundColor("#99FFFF") end
	_G[itemId]:setBackgroundColor("#006699")
	self.selected=itemId;
	Log:d("ListView",self.selected)
end	

function ListView:getSelectedItem()
	return _G[self.selected]
end
function ListView:getSelectedItemId()
	return self.selected
end
function ListView:getSelectedItemText()
	return _G[self.selected]:getText()
end
function ListView:getSelectedItemValue()
	Log:d("ListView",self.selected)
	local value=string.split(self.selected,"_")[5]
	return value
end
function ListView:close()
	_G[self.view]:setVisibility('block')
end	


Log:d("ListView","loaded....")

Log:d("RightListView","loading....")
--TODO add a data list to store item values
RightListView={
	 sequence=0,
	 size=0,
	 selected="0",
	 OK=nil,
	 CANCEL=nil
}

 RightListView.__index=RightListView
 function RightListView:new() 
 print(type(self))
     local temp = {
	 e={}

	 } 
     setmetatable(temp, RightListView) 
     return temp 
 end 


function RightListView:create()
		--self.OK=nil
		--self.CANCEL=nil
		math.randomseed(tostring(os.time()):reverse():sub(1, 6))
		self.dialogId=string.format("Dialog_RightListView_%d",math.floor(math.random()*1000000))
		local dialogId=self.dialogId
		local viewStr="<div id='"..dialogId.."' layout='LinearLayout'  style='orientation:vertical;width:auto;height:auto;valign:middle;align:right;' onclick='_G[\""..dialogId.."\"]:setVisibility(\"block\")'><div layout='LinearLayout'  style='orientation:vertical;width:150px;height:auto;valign:top;align:right;' onclick='_G[\""..dialogId.."\"]:setVisibility(\"block\")'><div id='"..dialogId.."_item' layout='LinearLayout'  style='margin:2px;padding:10px;orientation:vertical;width:auto;align:center;alpha:1;background-color:#FFFFFF'></div></div></div>"
		self.view=ui:createView(viewStr)
end

function RightListView:setTitle(text)
	_G[self.dialogId.."_title"]:setText(text)
end

function RightListView:setTop(top)
	_G[self.view]:setTop(top)
end
function RightListView:addItem(ico,text,callback)
	self.sequence=self.sequence+1
	local id=self.dialogId .."_item_"..self.sequence
	local icoId=self.dialogId .."_item_ico_"..self.sequence
	local txtId=self.dialogId .."_item_txt_"..self.sequence
	local imgIco=""
	if ico~=nil then imgIco="background-image:url("..ico..")" end

	Log:d("RightListView",imgIco)
	_G[self.dialogId.."_item"]:addView(ui:createView("<div id='"..id .."' layout='LinearLayout' style='width:auto;align:center;margin:2px;valign:middle;background-color:#ccccff'><label id='"..icoId .."' style='width:30px;height:30px;margin:2px;"..imgIco.."' onpress='RightListView:onItemPressed(\""..id.."\")' onrelease='RightListView:onItemReleased(\""..id.."\")'  onclick='"..callback.."()'></label><label id='"..txtId .."' style='width:auto;align:left;valign:middle;margin:2px;'  onpress='RightListView:onItemPressed(\""..id.."\")' onrelease='RightListView:onItemReleased(\""..id.."\")' onclick='"..callback.."()'>"..text.."</label></div>"))
end
function RightListView:OK(text,callback)
	self.OK="<button onclick='"..callback.."()' style='width:auto;weight:1px;align:center;background-color:#FFFFCC;margin:2px;'>"..text.."</button>"
	_G[self.dialogId.."_btn"]:addView(ui:createView(self.OK))
end
function RightListView:CANCEL(text,callback)
	self.CANCEL="<button onclick='"..callback.."()' style='width:auto;weight:1px;align:center;background-color:#FFFFCC;margin:2px;'>"..text.."</button>"
	_G[self.dialogId.."_btn"]:addView(ui:createView(self.CANCEL))
end
function RightListView:showOn(bodyId)
	--if self.OK~=nil then self:addView(self.OK) end
	--if self.CANCEL~=nil then self:addView(self.CANCEL) end
	_G[bodyId]:addView(self.view)
end


function RightListView:onItemPressed(itemId)
	_G[itemId]:setBackgroundColor("#FF9900")
end	
function RightListView:onItemReleased(itemId)
	_G[itemId]:setBackgroundColor("#ccccff")
end
function RightListView:onItemClick(itemId)
	local lastItem=_G[self.selected]
	if lastItem~=nil then lastItem:setBackgroundColor("#99FFFF") end
	_G[itemId]:setBackgroundColor("#006699")
	self.selected=itemId;
	Log:d("RightListView",self.selected)
end	

function RightListView:getSelectedItem()
	return _G[self.selected]
end
function RightListView:getSelectedItemId()
	return self.selected
end
function RightListView:getSelectedItemText()
	return _G[self.selected]:getText()
end
function RightListView:getSelectedItemValue()
	Log:d("RightListView",self.selected)
	local value=string.split(self.selected,"_")[5]
	return value
end
function RightListView:close()
	_G[self.view]:setVisibility('block')
end	


Log:d("RightListView","loaded....")

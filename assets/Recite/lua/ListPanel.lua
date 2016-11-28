Log:d("ListPanel","loading....")
require "string_ext"
--TODO add a data list to store item values
ListPanel={
	 sequence=0,
	 size=0,
	 selected="0",
	 OK=nil,
	 CANCEL=nil
}

 ListPanel.__index=ListPanel
 function ListPanel:new() 
 print(type(self))
     local temp = {
	 e={}

	 } 
     setmetatable(temp, ListPanel) 
     return temp 
 end 


function ListPanel:create()
		--self.OK=nil
		--self.CANCEL=nil
		math.randomseed(tostring(os.time()):reverse():sub(1, 6))
		self.dialogId=string.format("Dialog_ListPanel_%d",math.floor(math.random()*1000000))
		local dialogId=self.dialogId
		local viewStr="<div id='"..dialogId.."' layout='LinearLayout'  style='orientation:vertical;width:auto;height:auto;valign:middle;align:center;'><div id='"..dialogId.."_item' layout='LinearLayout'  style='margin:2px;padding:10px;orientation:vertical;width:auto;align:center;'></div></div>"
		self.view=ui:createView(viewStr)
end

function ListPanel:addItem(value,...)
	self.sequence=self.sequence+1
	local id=self.dialogId .."_item_"..value
	local texts = {...}
	local itemXml="<div id='"..id .."' layout='LinearLayout' style='width:auto;align:center;margin:2px;' onclick='ListPanel:onItemClick(\""..id.."\")'>"

	for n,text in ipairs(texts) do
			itemXml=itemXml.."<label style='weight:1px;align:center;' onclick='ListPanel:onItemClick(\""..id.."\")'>"..text.."</label>"
	end
	itemXml=itemXml.."</div>"

	_G[self.dialogId.."_item"]:addView(ui:createView(itemXml))

	local hr="<label style='width:auto;weight:1px;align:center;height:1px;background-color:#cccccc;' />"
	_G[self.dialogId.."_item"]:addView(ui:createView(hr))
end


function ListPanel:showOn(bodyId)
	--if self.OK~=nil then self:addView(self.OK) end
	--if self.CANCEL~=nil then self:addView(self.CANCEL) end
	_G[bodyId]:addView(self.view)
end

function ListPanel:onItemPressed(itemId)
	_G[itemId]:setBackgroundColor("#FF9900")
end	

function ListPanel:onItemClick(itemId)
	local lastItem=_G[self.selected]
	if lastItem~=nil then 
		lastItem:setBackgroundColor("#ffFFFF") 
		--lastItem:setColor("#000000") 
	end
	_G[itemId]:setBackgroundColor("#C8EDFF")
	--_G[itemId]:setColor("#ffffff")
	self.selected=itemId;
end	

function ListPanel:getSelectedItem()
	return _G[self.selected]
end
function ListPanel:getSelectedItemId()
	return self.selected
end

--return value and text
function ListPanel:getSelected()
	local v=string.split(self.selected,"_")[5]
	return v
end

require "JSON4Lua"

function initiate()
	allMyBookOrder()
end
function back()
		ui:switchView("MyInfo.xml","callback('file opener returned param')","file opener params")
		return 1;
end

function exit()

end



function allMyBookOrder()

	local url=Global.server.."PocketRecite/MyBookOrder.action"
	local http=HTTP:create(url)
	if Global.cookies~=nil then http:setCookies(Global.cookies) end
	http:sendRequest()
	http:receive()
	
	local content=http:getContent()
			Log:d("orders",content)
	local results=json.decode(content)
	local orders=results.data

		book_order:removeAllViews()


	for i=1, #orders do
			Log:d("orders",orders[i].book_name)
			local book=orders[i]
			local viewXml='<div layout="LinearLayout" style="orientation:horizontal;margin:10px;width:auto;valign:middle;" >'

			local payState=""
			if book.pay_state=='TRADE_SUCCESS' then 
				payState='Paid' 
				viewXml=viewXml..'<label  style="width:36px;height:36px;background-image:url($/images/ico2/(42).png);"></label>'
			else 
				payState="Unpaid" 
				viewXml=viewXml..'<label  style="width:36px;height:36px;background-image:url($/images/ico2/(40).png);"></label>'
			end

			viewXml=viewXml..'<label  style="width:auto;weight:1px;">'..book.book_name..'</label>'
			viewXml=viewXml..'<label  style="width:50px;">'..book.price..'</label>'
			viewXml=viewXml..'<label  style="width:60px;">'..payState..'</label>'

			viewXml=viewXml..'</div>'
			local bookItem=ui:createView(viewXml)
			book_order:addView(bookItem)
	end

	
		
		
		
	


end
Log:d("MainMenu","loaded successfullly")

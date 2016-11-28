require "JSON4Lua"
	require "url_encode"
	require "string_ext"
	require "string_ext2"


function initiate()
	--Global.cookies
	if Global.user==nil or Global.user_account=='' then
		showLocalBooks()
	else
		getBookList()
	end
end
function back()
		ui:switchView("StudyView.xml","callback('file opener returned param')","file opener params")
		return 1;
end

function exit()

end


function showLocalBooks()
	sys_send_books:removeAllViews()

		local books=getLocalBooks()
		for i=1, #books do
			book=books[i]

			local bookView="<div layout='LinearLayout' style='orientation:vertical;width:auto;'>"
			bookView=bookView.."<div layout='LinearLayout' style='orientation:horizontal;width:auto;'>"
			bookView=bookView.."<label style='height:24px;width:auto;weight:1px;' >"..book.book_name.."</label>"

				if Global.currentBookName==book.book_name then
					bookView=bookView.."<button  style='width:36px;height:36px;background-image:url($/images/nav/(342).png)' ></button>"
				else
					bookView=bookView.."<button  style='width:36px;height:36px;background-image:url($/images/nav/(341).png)' onclick='setToCurrentBook(\""..book.book_name.."\",\""..book.file_name.."\")'></button>"
				end
			bookView=bookView.."</div>"
			bookView=bookView.."<label style='height:1px;width:auto;background-color:#cccccc;' ></label>"
			bookView=bookView.."</div>"

			Log:d("myBooks",book.book_name.."==="..book.file_name)

			local bookBar=ui:createView(bookView)
			sys_send_books:addView(bookBar)
			sys_send_books_lbl:setText("Local Books")
			message_lbl:setText("Logon for more books!")
			my_books_panle:setVisibility("hidden")
			new_books_panle:setVisibility("hidden")
		end


end


function getBookList()

			sys_send_books_lbl:setText("Free Books")
			message_lbl:setText("Logon for more books!")
			my_books_panle:setVisibility("none")
			new_books_panle:setVisibility("none")


	local url=Global.server.."PocketRecite/VocabularyBookList.action"
	local http=HTTP:create(url)
	if Global.cookies~=nil then http:setCookies(Global.cookies) end
	http:sendRequest()
	http:receive()
	
	local content=http:getContent()
	local result=json.decode(content)

	url=Global.server.."PocketRecite/MyBookList.action"
	http=HTTP:create(url)
	if Global.cookies~=nil then http:setCookies(Global.cookies) end
	http:sendRequest()
	http:receive()
	local myBookContent=http:getContent()
			Log:d("myBooks",myBookContent)

	--if the returned data can be decoded into JSON, or think it is not logon and ignore the return messages
	local isNoErr,myBookData=pcall(json.decode,myBookContent)
	local myBooks=nil
	if isNoErr==true and myBookData.data~=nil then
		myBooks=myBookData.data
		for i=1, #myBooks do
			Log:d("myBooks",myBooks[i].book_name)
		end
	end

	sys_send_books:removeAllViews()
	buyed_books:removeAllViews()
	not_buyed_books:removeAllViews()

	local localBooks=getLocalBooks()

	for i=1, #localBooks do
			Log:d("localBooks",localBooks[i].book_name)
	end

	for i=1, #myBooks do
			Log:d("myBooks",myBooks[i].book_name)
	end

	if result.data==nil then
		showLogonMessage(content)
	else
		local books=result.data
		for i=1, #books do
			book=books[i]

			local bookView="<div layout='LinearLayout' style='orientation:vertical;width:auto;'>"
			bookView=bookView.."<div layout='LinearLayout' style='orientation:horizontal;width:auto;'>"
			bookView=bookView.."<label style='height:24px;width:auto;weight:1px;' >"..book.book_name.."</label>"

			--the book is in the mobile local book list
			local isDownload=false
			local downloadingBook=Global.bookOnDownloading["book_"..book.id]

			if isInMyBook(book,localBooks) then
				if Global.currentBookName==book.book_name then
					bookView=bookView.."<button  style='width:36px;height:36px;background-image:url($/images/nav/(342).png)' ></button>"
				else
					bookView=bookView.."<button  style='width:36px;height:36px;background-image:url($/images/nav/(341).png)' onclick='setToCurrentBook(\""..book.book_name.."\",\""..book.file_name.."\")'></button>"
				end
			elseif isInMyBook(book,myBooks) or book.price==0 then
				if downloadingBook==nil then
					bookView=bookView.."<button id='my_book_"..book.id.."' style='width:36px;height:36px;background-image:url($/images/nav/(18).png)' onclick='downloadBook(\""..book.file_name.."\",\""..book.id.."\")' />"
					isDownload=true
				else
					bookView=bookView.."<button id='my_book_"..book.id.."' style='width:36px;height:36px;background-image:url($/images/nav/(217).png)' onclick='downloadBook(\""..book.file_name.."\",\""..book.id.."\")' />"
				end
			else
				bookView=bookView.."<button id='my_book_"..book.id.."' style='width:36px;height:36px;background-image:url($/images/nav/(132).png)' onclick='alipay(\""..book.book_name.."\",\""..book.id.."\")' />"
			end
			bookView=bookView.."</div>"
			if isDownload then
				bookView=bookView..'<ProgressBar id="my_book_bar_'..book.id..'"  style="style:bar;width:auto;height:2px;visibility:hidden;"></ProgressBar>'
			elseif  downloadingBook~=nil then
				bookView=bookView..'<ProgressBar id="my_book_bar_'..book.id..'"  style="style:bar;width:auto;height:2px;"></ProgressBar>'

			end

			bookView=bookView.."<label style='height:1px;width:auto;background-color:#cccccc;' ></label>"
			bookView=bookView.."</div>"


			local bookBar=ui:createView(bookView)
			if book.price==0 then
				sys_send_books:addView(bookBar)
			elseif isInMyBook(book,myBooks) then
				buyed_books:addView(bookBar)
			else
				not_buyed_books:addView(bookBar)
			end
		end
	end

	--[[
	for i=1, #localBooks do
			book=localBooks[i]
			local bookBar=ui:createView("<label style='height:36px;' >"..book.book_name.."</label>")
				not_buyed_books:addView(bookBar)
	end
	]]--
	Log:d("Global.currentBookName",Global.currentBookName)
end

function isInMyBook(book, myBooks)
	if myBooks==nil or book==nil then return false end
	local rs=false
	for i=1, #myBooks do
		if myBooks[i].book_name==book.book_name then rs=true end
	end
	return rs
end

function showLogonMessage(msg)
	local fv=FlashView:new()
	fv:create()
	fv:addItem(1,msg)
	fv:CANCEL("CANCEL")
	fv:showOn("Main_body")

end

function getLocalBooks()
	local books={}

	local path=Global.storage
	local i=1
    for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then
            local f = file

           if string.endswith(f,".dbx") then	
				local fin = fis:open(Global.storage..f)
				if fin:exists() then
					  local book={}
					  book.book_name=fin:readStringWithLength()
					  book.file_name=string.sub(f,0,string.len(f)-4)
					  book.version=fin:readDouble()
					  book.encyptType=fin:readByte()
					  book.wordsCount=fin:readInt()
					  book.bookGroupAmount = (book.wordsCount % Global.groupSize > 0  and book.wordsCount / Global.groupSize + 1) or book.wordsCount / Global.groupSize;
					  --local bytes=fin:readIntArray(Global.wordsCount * 6)
					  --WordIndex.pos = loadstring('return '..bytes)()
					  books[i]=book
					  i=i+1
				  end
				fin:close()
			end
            --if attr.mode == "directory" then	Log:d("lfs dir",f)	end
		end
	end

--[[
	local fileStr=FileConnector:listFiles(Global.storage,".dbx")
	--Log:d("file",fileStr)
	local files=loadstring('return {'..fileStr.."}")()
	for i=1, #files do
		--Log:d("file",Global.storage..files[i].name)
		local fin = fis:open(Global.storage..files[i].name)
		if fin:exists() then
			  local book={}
			  book.book_name=fin:readStringWithLength()
			  book.file_name=string.gsub(files[i].name,0,string.len(files[i].name)-3)
			  book.version=fin:readDouble()
			  book.encyptType=fin:readByte()
			  book.wordsCount=fin:readInt()
			  book.bookGroupAmount = (book.wordsCount % Global.groupSize > 0  and book.wordsCount / Global.groupSize + 1) or book.wordsCount / Global.groupSize;
			  --local bytes=fin:readIntArray(Global.wordsCount * 6)
			  --WordIndex.pos = loadstring('return '..bytes)()
			  books[i]=book
			  Log:d("book name",book.file_name)
		  end
		fin:close()
	end
	]]--
	return books

end
function setToCurrentBook(bookName,fileName)
	Log:d("book name",bookName)
	Log:d("file Name",fileName)

    Global.currentBookName = bookName;
    Global.currentBookFileName = fileName;
	WordIndex.load()
	Global.saveProperties() 
	reload()

end

function alipay(bookName,bookId)
	local pay=AliPay:create()
		local orderGenUrl=Global.server.."/pay/alipay.action?cmd=genord&vocBookId="..bookId;
		local http=HTTP:create(orderGenUrl);
		if Global.cookies~=nil then http:setCookies(Global.cookies) end
		http:sendRequest();
		http:receive();
		local payInfo =http:getContent()
		pay:pay(bookName,payInfo,"refreshBookStatus('"..bookId.."')")
end

function refreshBookStatus(bookId)
	_G["my_book_"..bookId]:setBackgroundImageUrl("$/images/nav/(18).png")
	_G["my_book_"..bookId]:setOnclick("downloadBook('"..bookId.."')")
end

function downloadBook(fileName,bookId)

	_G["my_book_"..bookId]:setBackgroundImageUrl("$/images/nav/(217).png")
	_G["my_book_bar_"..bookId]:setVisibility("none")

	--startThreadMethod(bookId)

	--fileName=string.gsub(fileName," ","+")
	fileName=url_encode:encode(fileName)

	Log:d("file name",fileName)

	Global.bookOnDownloading["book_"..bookId]={id=bookId,value=0,file_name=fileName}

	local remoteFile=Global.server.."FileDownload.action?fileName="..fileName
	local localFile=OLA.storage.."/download/"..fileName..".zip"
	local download =AsyncDownload:create(remoteFile)

	--if assigned a progress bar to the Download thread, it will be auto updated
	download:setProgressBar("my_book_bar_"..bookId)

	download:setDestination(OLA.storage.."/download/")
	--download:setProcessingCallback("downloadMonitor('"..bookId.."')")
	download:setComplitedCallback("finishDownload('"..bookId.."')")
	download:start()
	--download:receive()
	--local zip=Zip:open(localFile)
	--zip:unzipTo(OLA.storage.."/download/"..fileName.."/")


end

function downloadMonitor(bookId,state,totalSize, downloadedSize,url,localFileName,key)
	Log:d("downloadMonitor",localFileName)
	Log:d("downloadMonitor ","state"..(state))
	Log:d("downloadMonitor ","totalSize"..(totalSize))
	Log:d("downloadMonitor ","downloadedSize"..(downloadedSize))
	Log:d("downloadMonitor url",url)
	--Log:d("downloadMonitor key",key)
	local percent=(1.0*downloadedSize/totalSize)*100
	Global.bookOnDownloading["book_"..bookId].value=percent
	Log:d("downloadMonitor","percent="..percent)
	--_G["my_book_bar_"..bookId]:setValue(percent)
	--lbl_msg:setText(key..':'..math.floor(percent)..'%')
end
function finishDownload(bookId,totalNumber,currentNumber,currentUrl,localFileName,key)
	Log:d("Update","finishDownload")
	Log:d("finishDownload",localFileName)
	local percent=(1.0*currentNumber/totalNumber)*100

	_G["my_book_bar_"..bookId]:setValue(percent)

	Global.bookOnDownloading["book_"..bookId]=nil

	local zip=Zip:open(localFileName)
	zip:unzipTo(OLA.storage.."/download/"..key.."/")
	
		_G["my_book_"..bookId]:setBackgroundImageUrl("$/images/nav/(341).png")
		--local onclick="onclick='setToCurrentBook(\""..book.book_name.."\",\""..book.file_name.."\")'"
		--_G["my_book_"..bookId]:setOnclock(onclick)
		_G["my_book_bar_"..bookId]:setVisibility("hidden")

	if currentNumber>=totalNumber then
		--all files were downloaded completely
	end
end



function startThreadMethod(bookId)
	local thread=Thread:create(1000)
	local s = os.date("%s", os.time())   
	thread:start("updateProgressBar('"..bookId.."',"..s..")");
end

function updateProgressBar(bookId,s0)
	local s = os.date("%s", os.time())    
	Log:d("Timer","my_book_bar_"..bookId..":this is the "..(s-s0).." seceod")
			_G["my_book_bar_"..bookId]:setValue(s-s0)
		if s -s0  >= 10 then
			Log:d("Timer","end...")    
			return true
    end

end

Log:d("MainMenu","loaded successfullly")

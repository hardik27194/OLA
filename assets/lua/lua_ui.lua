------ LUI class------------------------------------------------

module ("lui", package.seeall)


function reload()
	 sys.reload()
end

function back2Portal()
	LMProperties:printtype()
	LMProperties:exit()
end


function createView(viewXml)
	 local viewId=ui:createView(viewXml)
	 return viewId
end

function switch(xmlFileName, invokedFun,paramString)
	local rootViewId=ui:getRootViewId()
	local view=createLoadingView()
	_G[rootViewId]:addView(view)
	ui:switchView(xmlFileName, invokedFun,paramString)
	--_G[rootViewId]:removeView(view)
	
end


function createLoadingView()
		local viewXml=''
		viewXml=viewXml..'<div id="lui_loading_view" layout="LinearLayout" style="orientation:vertical;height:auto;width:auto;background-color:#6699CC;alpha:0.8;">'
		viewXml=viewXml..'	 <div layout="LinearLayout" style="orientation:vertical;width:auto;height:auto;align:center;valign:middle;">'
		viewXml=viewXml..'			<ProgressBar style="style:rotate;progress-image:url($/images/loading.png);width:60px;height:60px;"></ProgressBar>'
		viewXml=viewXml..'			<label style="margin:10px;align:center;"  onclick="reload()">   Loading...</label>'
		viewXml=viewXml..'    </div>'
		viewXml=viewXml..'</div>'
		local v= ui:createView(viewXml)
		return v
end

function showLoadingView()
	local rootViewId=ui:getRootViewId()
	local view=createLoadingView()
	_G[rootViewId]:addView(view)

end
function cleanViewCache()
	ui:cleanViewCache()
end
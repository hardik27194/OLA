------ LUI class------------------------------------------------

module ("lui", package.seeall)
lui={}

lui.loadingView=nil

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
		viewXml=viewXml..'<div layout="LinearLayout" style="orientation:vertical;width:auto;height:auto;align:center;valign:middle;">'
		viewXml=viewXml..'<ProgressBar id="loading_progress" type="rotate" style="type:rotate;progress-image:url($/images/loading.png);width:160px;height:160px;"/>'
		viewXml=viewXml..'<label style="margin:10px;align:center;"  onclick="loading_progress:start()">   Loading...</label>'
		viewXml=viewXml..'</div>'
		viewXml=viewXml..'</div>'
		local v= ui:createView(viewXml)
		return v
end

function showLoadingView()
    --loading_progress:start()
    Log:d("Loading view","start...")
	local rootViewId=ui:getRootViewId()
	local view=createLoadingView()
    Log:d("Loading view","end create...")

    Log:d("Loading view","root view ID="..rootViewId)
    Log:d("Loading view","loading bar ID="..view)
	_G[rootViewId]:addView(view)
    loading_progress:start()
    lui.loadingView=view

end
function closeLoadingView()

    loading_progress:stop()
	local rootViewId=ui:getRootViewId()
	_G[rootViewId]:removeView(lui.loadingView)

end


function cleanViewCache()
	ui:cleanViewCache()
end
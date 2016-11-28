
function initiate()
	name_lbl:setText(Global.user.name)
end
function back()
		ui:switchView("StudyView.xml","callback('file opener returned param')","file opener params")
		return 1;
end

function exit()

end

function allMyBookOrder()
		ui:switchView("order/AllBookOrder.xml","callback('file opener returned param')","file opener params")
end

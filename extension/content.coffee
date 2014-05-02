port = chrome.runtime.connect()
overflow = undefined
tabsView = undefined

port.onMessage.addListener (tabs) ->
	unless overflow
		overflow = document.createElement 'div'
		overflow.className = 'tabster-overflow'

		tabsView = document.createElement 'div'
		tabsView.id = 'tabster-tabs-view'

		overflow.appendChild tabsView
		document.body.appendChild overflow

	tabsView.innerHTML = ''

	for tab in tabs
		tabView = document.createElement 'div'
		tabView.className = 'tabster-tab'
		tabView.innerHTML = "<div class='tabster-tab-title'>#{tab.title}</div>
		<div class='tabster-tab-url'>#{tab.url.replace(/^http(s)?:\/\//, "")}</div>"
		tabsView.appendChild(tabView)
		tabView.addEventListener('click', tabsterSwitchTab.bind(this, tab.id), false)

	overflow.className += " visible"

tabsterSwitchTab = (id) ->
	tabsterClose()
	port.postMessage(
		method: "switchTab"
		id: id
	)

tabsterClose = () ->
	overflow.className = 'tabster-overflow'

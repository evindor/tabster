port = chrome.runtime.connect()
overflow = undefined
tabsView = undefined

baseKeys = ['a', 's', 'd', 'f', 'h', 'j', 'k', 'l']
keys = []

for key in baseKeys
	for key2 in baseKeys
		keys.push(key + key2)

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
		console.log(tab);
		tabView = document.createElement 'div'
		tabView.className = 'tabster-tab'
		tabView.innerHTML = "
		<div class='tabster-tab-title'><img src='#{tab.favIconUrl}' class='tabster-favicon'/>#{tab.title}</div>
		<div class='tabster-tab-url'>#{tab.url.replace(/^http(s)?:\/\//, "")}</div>
		<div class='tabster-tab-key'>#{keys[tab.index]}</div>"
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

port = chrome.runtime.connect()
overflow = undefined
tabsView = undefined
controlInput = undefined
tabsterActive = false
buffer = null

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

		addEvents(document)

	tabsView.innerHTML = ''

	for tab in tabs
		tabView = document.createElement 'div'
		firstKey = keys[tab.index].substring(0, 1)
		lastKey = keys[tab.index].substring(1, 2)
		tabView.className = "tabster-tab tabster-first-key-#{firstKey} tabster-last-key-#{lastKey}"
		tabView.innerHTML = "
		<div class='tabster-tab-title'><img src='#{tab.favIconUrl}' class='tabster-favicon'/>#{tab.title}</div>
		<div class='tabster-tab-url'>#{tab.url.replace(/^http(s)?:\/\//, "")}</div>
		<div class='tabster-tab-key'><span class='tabster-tab-first-key'>#{firstKey}</span>#{lastKey}</div>"
		tabsView.appendChild(tabView)
		tabView.addEventListener('click', tabsterSwitchTab.bind(this, tab.id), false)

	overflow.classList.add("visible")
	tabsterActive = true

tabsterSwitchTab = (id) ->
	tabsterClose()
	port.postMessage(
		method: "switchTab"
		id: id
	)

tabsterClose = () ->
	overflow.classList.remove("visible")
	tabsterActive = false

tabsterUndo = () ->
	buffer = null
	tabs = document.querySelectorAll(".tabster-tab.tabster-hit")
	for tab in tabs
		tab.classList.remove('tabster-hit')

handleKeyEvents = (e) ->
	return e unless (tabsterActive)
	e.preventDefault()
	if 27 == e.keyCode
		if buffer
			tabsterUndo()
		else
			tabsterClose()
	key = String.fromCharCode(e.keyCode).toLowerCase()
	if key in baseKeys
		updateTabs(key)


addEvents = () ->
	document.addEventListener 'keyup', handleKeyEvents, false

updateTabs = (key) ->
	tabs = document.querySelectorAll(".tabster-tab")
	if buffer
		for tab in buffer
			if tab.className.search(".tabster-last-key-#{key}") > -1
				buffer = null
				return tab.click()
	
	possibleHits = document.querySelectorAll ".tabster-first-key-#{key}"
	buffer = possibleHits
	for tab in possibleHits
		tab.classList.add 'tabster-hit'

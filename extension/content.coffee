port = chrome.runtime.connect()
overflow = undefined
tabsView = undefined
controlInput = undefined
tabsterActive = false
buffer = null
closeMode = false

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

		closeWarning = document.createElement 'div'
		closeWarning.className = 'tabster-close-mode-warning'
		closeWarning.innerHTML = 'Close mode'

		overflow.appendChild tabsView
		overflow.appendChild closeWarning
		document.body.appendChild overflow

		addEvents(document)

	tabsView.innerHTML = ''

	for tab in tabs
		tabView = document.createElement 'div'
		firstKey = keys[tab.index].substring(0, 1)
		lastKey = keys[tab.index].substring(1, 2)
		tabView.className = "tabster-tab tabster-first-key-#{firstKey} tabster-last-key-#{lastKey}"
		tabView.tabId = tab.id
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

tabsterDecativate = () ->
	overflow.classList.remove 'tabster-typing'
	overflow.classList.remove "tabster-close-mode-true"
	overflow.classList.add "tabster-close-mode-false"
	buffer = null
	closeMode = false

tabsterClose = () ->
	overflow.classList.remove 'visible'
	tabsterActive = false
	tabsterDecativate()

tabsterUndo = () ->
	tabs = document.querySelectorAll '.tabster-tab.tabster-hit'
	for tab in tabs
		tab.classList.remove 'tabster-hit'
	overflow.classList.remove 'tabster-typing'
	buffer = null

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
	if "x" == key
		toggleCloseMode()


addEvents = () ->
	document.addEventListener 'keyup', handleKeyEvents, false

updateTabs = (key) ->
	tabs = document.querySelectorAll '.tabster-tab'
	if buffer
		for tab in buffer
			if tab.className.search(".tabster-last-key-#{key}") > -1
				buffer = null
				if closeMode
					tabsterUndo()
					return port.postMessage(
						method: 'closeTab'
						id: tab.tabId
					) && tab.remove()
				return tab.click()
	
	possibleHits = document.querySelectorAll ".tabster-first-key-#{key}"
	buffer = possibleHits
	for tab in possibleHits
		tab.classList.add 'tabster-hit'
	overflow.classList.add 'tabster-typing'

toggleCloseMode = () ->
	closeMode = !closeMode
	overflow.classList.remove "tabster-close-mode-#{!closeMode}"
	overflow.classList.add "tabster-close-mode-#{closeMode}"

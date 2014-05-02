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
		tabView.innerHTML = "<div class='tabster-tab-title'>#{tab.title.substring(0, 40)}</div>
		<div class='tabster-tab-url'>#{tab.url.replace(/^http(s)?:\/\//, "").substring(0, 40);}</div>"
		tabsView.appendChild(tabView)

	overflow.className += " visible"

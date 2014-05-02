port = chrome.runtime.connect()

overflow = document.createElement('div');
overflow.className = "tabster-overflow";
document.body.appendChild(overflow);

port.onMessage.addListener (tabs) ->
	overflow.innerHTML = ""
	for tab in tabs
		tabView = document.createElement('div');
		tabView.className = "tabster-tab";
		tabView.innerHTML = tab.url
		overflow.appendChild(tabView)
	overflow.className += " visible"

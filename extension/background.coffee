chrome.runtime.onConnect.addListener((port)->
	chrome.commands.onCommand.addListener( () ->
		chrome.tabs.query({}, (tabs) ->
			port.postMessage(tabs)
		)
	)

	port.onMessage.addListener((msg) ->
		if "switchTab" == msg.method
			return chrome.tabs.update(msg.id, {active: true})
		if "closeTab" == msg.method
			chrome.tabs.remove(msg.id)
	)
)

chrome.runtime.onConnect.addListener((port)->
	chrome.commands.onCommand.addListener( () ->
		chrome.tabs.query({}, (tabs) ->
			port.postMessage(tabs)
		)
	)

	port.onMessage.addListener((msg) ->
		chrome.tabs.update(msg.id, {active: true})
	)
)

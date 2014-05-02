chrome.runtime.onConnect.addListener((port)->
	chrome.commands.onCommand.addListener( () ->
		chrome.tabs.query({}, (tabs) ->
			port.postMessage(tabs)
		)
	)
)

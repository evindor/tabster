chrome.commands.onCommand.addListener( () ->
	chrome.tabs.query({active: true}, (tab) ->
		chrome.tabs.query({}, (tabs) ->
			chrome.tabs.sendMessage(tab[0].id, {method: 'showTabs', tabs: tabs})
		)
	)
)

chrome.runtime.onMessage.addListener((msg) ->
	if "switchTab" == msg.method
		return chrome.tabs.update(msg.id, {active: true})
	if "closeTab" == msg.method
		chrome.tabs.remove(msg.id)
)

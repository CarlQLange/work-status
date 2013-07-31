
status_hash = {}

module.exports = (robot) ->
	robot.respond /i'm\s+working\s+on\s+(.*)/i, (msg) ->
		status_hash[msg.message.user.name] = msg.match[1]
		after 86400000, => delete status_hash[msg.message.user.name]

	robot.respond /what\s+is\s+(.*)\s+working on/, (msg) ->
		if msg.match[1] is 'everyone'
			message = ""
			for user of status_hash
				message += "#{user_match_to_short_name(user)}: #{status_hash[user]}\n"
			msg.send message
		else
			shortname = msg.match[1]
			longname = user_match_to_full_name(shortname)
			status = "#{user_match_to_short_name(longname)} isn't working on anything, as far as I know."

			if status_hash[longname]?
				status = "#{user_match_to_short_name(longname)} is working on #{status_hash[longname]}"

			msg.send status

user_match_to_full_name = (shortname) ->
	match = ""
	for user of status_hash
		if user.match(/(\w*)\s/)[1].trim().toLowerCase() is shortname.trim().toLowerCase()
			match = user
	match

user_match_to_short_name = (longname) ->
	longname.match(/(\w*)\s/)[1].trim()

after = (ms, func) -> setTimeout(func, ms)

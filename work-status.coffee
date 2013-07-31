
status_hash = {}

module.exports = (robot) ->
	robot.respond /i'm\s+working\s+on\s+(.*)/i, (msg) ->
		status_hash[msg.message.user.name] = msg.match[1]
		after 86400000, => delete status_hash[msg.message.user.name]

	robot.respond /what\s+is\s+(.*)\s+working on/, (msg) ->
		if msg.match[1] is 'everyone'
			message = ""
			for user of status_hash
				message += "#{user_match_to_short_name(user)": #{status_hash[user]}"
			msg.send message
		else
			shortname = msg.match[1]
			longname = user_match_to_full_name[shortname]
			status = "#{user} isn't working on anything, as far as I know."

			if status_hash[longname]?
				status = status_hash[longname]

			msg.send "#{user} is working on #{status}"

user_match_to_full_name = (shortname) ->
	for user in status_hash
		if user.match(/(\w*)\s/)[1].trim().toLowerCase() is shortname.trim().toLowerCase()
			user

user_match_to_short_name = (longname) ->
	longname.match(/(\w*)\s/)[1].trim()

after = (ms, func) -> setTimeout(func, ms)

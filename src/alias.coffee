# Description:
#   Action alias for hubot
#
# Commands:
#   hubot alias xxx=yyy - Make alias xxx for yyy
#   hubot alias xxx= - Remove alias xxx for yyy
#   hubot alias clear - Clear the alias table
#
# Author:
#   dtaniwaki

ALIAS_TABLE_KEY = 'hubot-alias-table'

module.exports = (robot) ->
  receiveOrg = robot.receive
  robot.receive = (msg)->
    table = robot.brain.get(ALIAS_TABLE_KEY) || {}
    orgText = msg.text?.trim()
    if /^hubot\salias/.test orgText
      # Skip the check
    else if /^hubot(\s)(.*)$/.test orgText
      sp = RegExp.$1
      text = RegExp.$2
      for regexp, value of table
        replaced = text.replace(new RegExp("^" + regexp + "\\b"), value)
        if text != replaced
          msg.text = "hubot#{sp}#{replaced}"
          break
    console.log "Change \"#{orgText}\" as \"#{msg.text}\"" if orgText != msg.text

    receiveOrg.bind(robot)(msg)

  robot.respond /alias(.*)$/i, (msg)->
    text = msg.match[1].trim()
    table = robot.brain.get(ALIAS_TABLE_KEY) || {}
    if text.toLowerCase() == 'clear'
      robot.brain.set ALIAS_TABLE_KEY, {}
      msg.send "I cleared the alias table"
    else if !text
      msg.send JSON.stringify(table)
    else
      match = text.match /([^\s=]*)=(.*)?$/
      alias = match[1]
      action = match[2]
      if action?
        msg.send "I made alias #{alias} for #{action}"
        table[alias] = action
        robot.brain.set ALIAS_TABLE_KEY, table
      else
        msg.send "I removed alias #{alias}"
        delete table[alias]
        robot.brain.set ALIAS_TABLE_KEY, table

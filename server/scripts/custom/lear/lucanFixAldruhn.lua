local lucanFixAldruhnConfig = {}

lucanFixAldruhnConfig.respawnTimer = 900 -- This is how long in seconds before Lucan should be allowed to spawn again for the
						-- same player. This is if, say, the server crashes or the player wanders off
						-- from the cell. 900 = 15 mins which is the default.

--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
This script will prevent Lucan from continuosly spawning in Ald-ruhn during his quest line (mv_thieftrader).
If left uncheck, he can cause massive lag and spawn spamming in Ald-ruhn.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DO NOT EDIT BEYOND THIS, UNLESS YOU KNOW WHAT YOU'RE DOING.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
]]

local Methods = {}


Methods.StopLucanOstoriusScript = function(pid)
	logicHandler.DeleteObjectForPlayer(pid, "-2, 6", "482620-0")
	if Players[pid].data.customVariables.lear == nil then
		Players[pid].data.customVariables.lear = {}
	end
	if Players[pid].data.customVariables.lear.questFixes == nil then
		Players[pid].data.customVariables.lear.questFixes = {}
	end
	logicHandler.RunConsoleCommandOnPlayer(pid, "stopscript lucan_ostorius")
end

customEventHooks.registerHandler("OnPlayerAuthentified", function(eventStatus, pid)
	tes3mp.LogMessage(enumerations.log.INFO, "Stopping lucan_ostorius script for " .. Players[pid].name)
	Methods.StopLucanOstoriusScript(pid)
end)

local hasQuest = function(pid, qId, qIndex)
	if tableHelper.containsKeyValuePairs(Players[pid].data.journal, { quest = qId, index = qIndex }, true) then
		return true
	end
	return false
end

customEventHooks.registerHandler("OnPlayerCellChange", function(eventStatus, pid, previousCellDescription, currentCellDescription)
-- Delete Lucan respawn
	if currentCellDescription == "-2, 6" then
		if (hasQuest(pid, "mv_thieftrader", 20) or hasQuest(pid, "mv_thieftrader", 25)) and not hasQuest(pid, "mv_thieftrader", 90) then
			if (Players[pid].data.customVariables.lear.questFixes.mv_thieftrader_spawn_timer == nil or os.time() >= Players[pid].data.customVariables.lear.questFixes.mv_thieftrader_spawn_timer) then
				logicHandler.RunConsoleCommandOnPlayer(pid, "startscript lucan_ostorius")
				local respawnTimer = lucanFixAldruhnConfig.respawnTimer
				respawnTimer = respawnTimer + os.time()
				Players[pid].data.customVariables.lear.questFixes.mv_thieftrader_spawn_timer = respawnTimer
			end
		end
	end
end)


return Methods

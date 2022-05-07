local config = dofile(DspcGlobal.Path .. "/Lua/config.lua")

if SERVER then
	print("DeathSkillPenaltyCustomizer starting...")

	local function applyLoss(oldSkillLevel, minSkillLevel)
		local newSkillLevel = oldSkillLevel
		if config.deathSkillLossFlat > 0 then
			newSkillLevel = newSkillLevel - config.deathSkillLossFlat
		end
		if config.deathSkillLossPercentage > 0 then
			newSkillLevel = newSkillLevel - (config.deathSkillLossPercentage / 100.0) * oldSkillLevel
		end

		local delta = oldSkillLevel - newSkillLevel

		if delta < config.deathSkillLossMin then
			newSkillLevel = oldSkillLevel - config.deathSkillLossMin
		end
		if delta > config.deathSkillLossMax then
			newSkillLevel = oldSkillLevel - config.deathSkillLossMax
		end

		return math.max(newSkillLevel, minSkillLevel)
	end

	local function reduceSkills(characterInfo)
		-- This whole function does look very wonky indeed but it was the best way i found
		if not characterInfo then
			return
		end
		if not characterInfo.Job then
			return
		end

		local jobPrefab = characterInfo.Job.Prefab
		local jobPrefabSkills = jobPrefab.Skills

		local skillIdentifiers = {}
		local skillMinima = {}
		for i, val in pairs(jobPrefabSkills) do
			skillIdentifiers[i] = val.Identifier
			skillMinima[i] = val.LevelRange.Start
		end

		for i, id in pairs(skillIdentifiers) do
			local min = 0
			if config.respectSkillMin then
				min = math.max(skillMinima[i], 0)
			end
			local skill = characterInfo.Job.GetSkill(id)
			local skillLevel = skill.Level
			local newSkillLevel = applyLoss(skillLevel, min)
			characterInfo.SetSkillLevel(id, newSkillLevel)
			print("Reduced Skill ", id, " from ", skillLevel, " to ", newSkillLevel, ".")
		end
	end
	
	Hook.HookMethod("Barotrauma.Networking.RespawnManager", "ReduceCharacterSkills", function (instance, ptable)
		reduceSkills(ptable.characterInfo)
		-- return anything to prevent vanilla ReduceCharacterSkills from running
		return false 
	end, Hook.HookMethodType.Before)

	print("DeathSkillPenaltyCustomizer started.")
end

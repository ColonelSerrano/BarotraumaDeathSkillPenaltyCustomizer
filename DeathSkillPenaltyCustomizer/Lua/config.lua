local config = {}

-- Number of permanent skill points to lose on death, 0 to disable
config.deathSkillLossFlat = 0
-- Percentage of skills to lose on death, 0 means none, 100 means all
-- Can be combined with flat loss
config.deathSkillLossPercentage = 10.0
-- Can be used to create conditions like "loose 10% of your skill but at least 3 and at most 5"
config.deathSkillLossMin = 0
config.deathSkillLossMax = 100
-- Whether to respect starting skill minimum. Deactivation allows skills to drop to 0.
config.respectSkillMin = true

return config

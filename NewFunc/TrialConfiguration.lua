--!strict
-- AutoTrialsRequirements.lua
-- Static trial/fallback requirements and strategy script URLs.

return {
    trialScripts = {
        ["Speedy Enemies"]    = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/StratsFunc/Speedy.lua",
        ["Glass"]             = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/StratsFunc/Glass.lua",
        ["Quarantine"]        = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/StratsFunc/Quarantine.lua",
        ["Fog"]               = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/StratsFunc/Fog.lua",
        ["Limitation"]        = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/StratsFunc/Limitation.lua", -- done
        ["Flying"]            = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/StratsFunc/Flying%20Enemies.lua", -- done
        ["Jailed"]            = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/StratsFunc/Jailed.lua", -- done
        ["Exploding Enemies"] = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/StratsFunc/Exploading%20Enemies.lua", -- done
        ["Inflation"]         = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/StratsFunc/Inflation.lua", -- done 
        ["Committed"]         = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/StratsFunc/Committed.lua", -- done
        ["Hidden"]            = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/StratsFunc/Hidden%20Enemies.lua", -- done
        ["Broke"]             = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/StratsFunc/Broke.lua", -- done 
        ["Healthy Enemies"]   = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/StratsFunc/Healthy%20Enemies.lua", -- done
    },

    fallbackScripts = {
        ["Easy"]         = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/Strats/Mode.lua",
        ["Casual"]       = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/Strats/Mode.lua",
        ["Intermediate"] = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/Strats/Mode.lua",
        ["Molten"]       = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/Strats/Mode.lua",
        ["Fallen"]       = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/Strats/Mode.lua",
        ["Frost"]        = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/Strats/Mode.lua",
    },

    trialConfigs = {
        ["Speedy Enemies"] = {
            Level = 175,
            Towers = {"Hacker", "Gatling Gun", "Militant", "Mercenary Base", "Trapper"},
            Golden = {},
            SkillTree = {},
        },
        ["Glass"] = {
            Level = 175,
            Towers = {"Hacker", "Gatling Gun", "Militant", "Mercenary Base", "Trapper"},
            Golden = {},
            SkillTree = {},
        },
        ["Quarantine"] = {
            Level = 175,
            Towers = {"Hacker", "Gatling Gun", "Militant", "Mercenary Base", "DJ Booth"},
            Golden = {},
            SkillTree = {},
        },
        ["Fog"] = {
            Level = 175,
            Towers = {"Trapper", "Hacker", "Gatling Gun", "Mercenary Base", "DJ Booth"},
            Golden = {},
            SkillTree = {},
        },
        ["Limitation"] = {
            Level = 175,
            Towers = {"Trapper", "Medic", "Gatling Gun", "Mercenary Base", "DJ Booth"}, -- no gold, no skill tree, no hardcore
            Golden = {},
            SkillTree = {},
        },
        ["Flying"] = {
            Level = 175,
            Towers = {"Militant", "Gatling Gun", "Medic", "Mercenary Base", "DJ Booth"}, -- no gold, no skill tree, no hardcore
            Golden = {},
            SkillTree = {},
        },
        ["Jailed"] = {
            Level = 175,
            Towers = {"Scout", "Gatling Gun", "Militant", "Mercenary Base", "Paintballer", "Assasin", "DJ Booth", "Crook Boss"}, -- no gold, no skill tree, no hardcore, - higher winrate chance
            Golden = {},
            SkillTree = {},
        },
        ["Exploding Enemies"] = {
            Level = 175,
            Towers = {"Militant", "Gatling Gun", "Medic", "Mercenary Base", "DJ Booth"}, -- no gold, no skill tree, no hardcore
            Golden = {},
            SkillTree = {},
        },
        ["Inflation"] = {
            Level = 175,
            Towers = {"Ace Pilot", "Trapper", "Gatling Gun", "DJ Booth", "Medic"}, -- no gold, no skill tree, no hardcore
            Golden = {},
            SkillTree = {},
        },
        ["Committed"] = {
            Level = 175,
            Towers = {"Hacker", "Gatling Gun", "Medic", "Scout", "Demoman"}, -- super exepsive 50% winrate
            Golden = {"Scout", "Demoman"},
            SkillTree = {
                ["Bigger Budget"] = 25,
                ["Fortify"] = 40,
                ["Stonks"] = 20,
                ["Over-Heal"] = 25,
                ["Bandages"] = 25,
                ["Accelerator"] = 25,
                ["Enhanced Optics"] = 20,
                ["Scavenger"] = 250,
				["Improved Gunpowder"] = 25,
				["Fight Dirty"] = 25,
				["Precision"] = 15,
				["Re-enforcements"] = 10,
				["Extreme Conditioning"] = 25,
            },
        },
        ["Hidden"] = {
            Level = 175,
            Towers = {"Gatling Gun", "Medic", "Mercenary Base", "Militant", "DJ Booth"}, -- no gold, no skill tree, no hardcore
            Golden = {},
            SkillTree = {},
        },
        ["Broke"] = {
            Level = 175,
            Towers = {"Gatling Gun", "Trapper", "Militant", "Trapper", "DJ Booth"}, -- no gold, no skill tree, no hardcore
            Golden = {},
            SkillTree = {},
        },
        ["Healthy Enemies"] = {
            Level = 175,
            Towers = {"Ace Pilot", "Mercenary Base", "DJ Booth", "Gatling Gun", "Medic"}, -- No Gold, No Hardcore
            Golden = {},
            SkillTree = {
                ["Bigger Budget"] = 10,
                ["Fortify"] = 10,
                ["Stonks"] = 10,
                ["Over-Heal"] = 10,
                ["Bandages"] = 10,
                ["Accelerator"] = 10,
                ["Enhanced Optics"] = 10,
                ["Resourcefulness"] = 10,
            },
        },
    },

    -- Standard modes do not have a trial title, so fallback requirements stay separate.
    FallbackConfigs = {
        ["Easy"] = {
            Level = 175,
            Towers = {"Gatling Gun", "Trapper", "Medic", "DJ Booth", "Mercenary Base"},
            Golden = {},
            SkillTree = {},
            Maps = {},
        },
        ["Casual"] = {
            Level = 175,
            Towers = {"Gatling Gun", "Trapper", "Medic", "DJ Booth", "Mercenary Base"},
            Golden = {},
            SkillTree = {},
            Maps = {},
        },
        ["Intermediate"] = {
            Level = 175,
            Towers = {"Gatling Gun", "Trapper", "Medic", "DJ Booth", "Mercenary Base"},
            Golden = {},
            SkillTree = {},
            Maps = {"Simplicity"},
        },
        ["Molten"] = {
            Level = 175,
            Towers = {"Gatling Gun", "Trapper", "Medic", "DJ Booth", "Mercenary Base"},
            Golden = {},
            SkillTree = {},
            Maps = {},
        },
        ["Fallen"] = {
            Level = 175,
            Towers = {"Gatling Gun", "Trapper", "Medic", "DJ Booth", "Mercenary Base"},
            Golden = {},
            SkillTree = {},
            Maps = {},
        },
        ["Frost"] = {
            Level = 175,
            Towers = {"Gatling Gun", "Trapper", "Medic", "DJ Booth", "Mercenary Base"},
            Golden = {},
            SkillTree = {},
            Maps = {},
        },
    },

    allTrialOptions = {
        "Exploding Enemies",
        "Fog",
        "Quarantine",
        "Speedy Enemies",
        "Glass",
        "Limitation",
        "Flying",
        "Jailed",
        "Inflation",
        "Committed",
        "Hidden Enemies",
        "Hidden",
        "Broke",
        "Healthy Enemies",
    },

    fallbackModesList = {
        "Easy",
        "Casual",
        "Intermediate",
        "Molten",
        "Fallen",
        "Frost",
    },
}

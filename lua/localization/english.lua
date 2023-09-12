Language = {
    id = "English",
    match_start = "New match start",
    round_prepare = "Prepare for new round",
    round_start = "Round starts in %s second(s)",
    round_end = "Starting a new round in %s second(s)",
    round_switch = "Switching to a random map & gametype in %s second(s)",
    round_win = "%s has won round!",
    spectating = "Spectating %s",
    binds = {
        Medkit = {
            SwitchMate = "%s - equip medkit to heal PLAYER",
            SwitchYourself = "%s - switch to medkit",
        },
        TeamBind = "%s - team selection menu",
        LoadoutBind =  "%s - loadout menu",
        VoiceBind = "%s - voice selection menu",
        SpectateBind = "%s - change spectate target",
        MainMenuBind = "%s - gamemode's main menu"
    },
    loadoutmenu = {
        Bandages = "Bandages",
        SpareAmmo = "Spare ammo",
    },
    settings = {
        VisualCollap = "Visual",
        OtherCollap = "Other",
        GameplayCollap = "Gameplay",
        Headshot = "HEADSHOT",
        Language = "Current language: ",
        Crosshair = "Enable crosshair rendering for CW 2.0 Default",
        HudFlipped = "Mirror HUD?",
        Legs = "Enable legs rendering in 1st person?",
        Toytown = "Enable toytown effect?",
        BloomBool = "Enable bloom effect?",
        BloomStyle = "Bloom style: ",
        FilterBool = "Enable filter?",
        FilterRed = "The add color's red value",
        FilterGreen = "The add color's green value",
        FilterBlue = "The add color's blue value",
        FilterColour = "The saturation value",
        Impact = "Enable new impact effects?",
        Dynlight = "Enable muzzleflash dynlight?[Only TFA]",
        SmokeShock = "Replace standard TFA smoke particles?[Only TFA]",
        EjectSmoke = "Replace standard TFA eject smoke particles?[Only TFA]",
        XAxis = "X Offset for CW 2.0 weapons",
        YAxis = "Y Offset for CW 2.0 weapons",
        ZAxis = "Z Offset for CW 2.0 weapons",
        XAxisTFA = "X Offset for TFA weapons",
        YAxisTFA = "Y Offset for TFA weapons",
        ZAxisTFA = "Z Offset for TFA weapons",
        AbilityKey = "Ability activation button:",
        RadioKey = "Toggle radio menu button:",
        NVGActivation = "NVG activation/deactivation button:",
        NVGCycle = "NVG cycle button:",
        LeanLeft = "Lean left button:",
        LeanRight = "Lean right button:",
    },
    specRoundCount = "Special round in %s round(s).",
    curSpecRound = "Current special round: %s.",
    expbar = "%s/%s EXP",
    unlock = {
        [true] = "Unlock more slots by playing cooperatively.",
        [false] = "All locked slots unlocked.",
    },
    cash = "Cash $ %s",
    stats = {
        Integrity = "Integrity %s points",
        Weight = "Weight %s KG",
        MaxPen = "Max penetration value: %s",
        TraumReduc = "Penetration damage reduction: %s",
        DamReduc = "Penetration damage reduction: %s",
        StunReduc = "Stun reduction: %s",
        Bleeding = "Bleeding will occur from any shot.",
        NoArmor = "No armor selected.",
        Actual = {
            ["steel_helmet"] = {
                Name = "Steel Helmet",
                Desc = "Provides type II protection against projectiles.",
            },
            ["kevlar_helmet"] = {
                Name = "ACH Helmet",
                Desc = "Provides type IIIA protection against projectiles.",
            },
            ["dyneema_vest"] = {
                Name = "Dyneema Vest",
                Desc = "Provides type II protection against projectiles.",
            },
            ["kevlar_vest"] = {
                Name = "Kevlar Vest",
                Desc = "Provides type IIIA protection against projectiles.",
            },
            ["spectra_vest"] = {
                Name = "SPECTRA Vest",
                Desc = "Provides type III protection against projectiles.",
            },
        }
    },
    slots = {
        SlotId = "Slot %s", -- example: "Slot 3"
        UsedSlots = "Used slots %s/%s",
    },
    trait = {
        Inactive = "Inactive",
        ActivateTip = "This trait is not active, left-click to activate it.",
        RightClick = "Right-click to increase level for $%s",
        LeftClick = "Left-click to unlock specialization for $%s",
        Level = "Level: %s/%s",
        CashHave = "(You have $%s)",
        Actual = {
            ["war_hardened"] = {
              Name = "War hardened",
              Desc = {
                {
                    t = "You've undergone extensive training to operate efficiently in high stress situations.", 
                },
                {
                    t = "Decreases adrenaline duration and increase speed by %s per each level.", 
                },
                {
                    t = "Current adrenaline duration and increase speed reduction: -CURRENT%",
                }
              }

            },
            ["conditioned"] = {
                Name = "Conditioned",
                Desc = {
                  {
                      t = "You've undergone extensive physical preparation to become more endurant.", 
                  },
                  {
                      t = "Decreases stamina drain from sprinting and jumping by %s per each level.", 
                  },
                  {
                      t = "Current sprint stamina drain reduction: -CURRENT%",
                  }
                }
  
            },
            ["medic"] = {
                Name = "Medic",
                Desc = {
                  {
                      t = "You've undergone extensive medical training to treat wounds efficiently.", 
                  },
                  {
                      t = "Each level increases healing proficiency with the Medkit.", 
                  },
                  {
                      t = "Can uncripple team mates.",
                  }
                }
  
            },
            ["will_to_live"] = {
                Name = "Will to Live",
                Desc = {
                  {
                      t = "Your will to live is unmatched - you overcome pain and shock that would have had killed others.", 
                  },
                  {
                      t = "Allows to restore a small amount of health passively every %s seconds.", 
                  },
                  {
                      t = "Each level increases health restored by %s points.",
                  },
                  {
                    t = "Current maximum health restored: +CURRENT%", 
                  }
                }
  
            },
            ["covert_ops"] = {
                Name = "Covert Ops",
                Desc = {
                  {
                      t = "You've undergone extensive stealth training to sneak quicker while maintaining combat readiness.", 
                  },
                  {
                      t = "Increases crouched movement speed by %s%% per level.", 
                  },
                  {
                      t = "Current crouch-move speed increase: +CURRENT%",
                  }
                }
  
            },
        }
    },
    gadgets = {
     ["spareammo"] = {
      Display = "RESUPPLY",
     },
    },
    weapon = {
     NoSelect = "None selected",
     Damage = "Damage",
     Recoil = "Recoil",
     Accuracy = "Accuracy",
     Firerate = "Firerate",
     Hip = "Hip accuracy",
     Mobility = "Mobility",
     SPS = "Spread per shot",
     MaxSpread = "Max spread",
     Weight = "Weapon weight",
     MagWeight = "Mag weight",
     Pen = "Penetration",
    },
    weight = {
     StamDrain = "Stamina drain: +%s",
     NoiseFact = "Noise factor: +%s",
     Weight = "Weight: %s/%s KG",
     CurWeight = "The weight of your current loadout.",
     HighWeight = "A high weight will increase movement noise and stamina drain from sprinting and jumping.",
     Deselect = "You can always deselect primary/secondary/tertiary weapons by right-clicking on them.",
    },
    attaches = {
     Enough = "You have enough money to buy the following attachments:",
     Begin = "Click to begin purchase.",
     Custom = "%s - customization",
     Purchase = "Click to purchase for %s$",
     Fail = "Can't attach, requires: ",
     Conflict = "Can't attach, conflicts with: %s",
     LeftClick = "Left-click to assign attachment.",
     RightClick = "Right-click to un-assign attachment.",
     Title = "Assign attachment",
     None = "None",
     Slot = "Slot %s",
     UnlockFail = "Slot not unlocked, can not assign to it.",
     AssignFail = "Can't assign to this slot - desired category already in use.",
     ReAssign = "Left-click to re-assign slot.",
     UnAssign = "Right-click to un-assign slot.",
     SlotAssign = "Left-click to assign slot.",
    },
    tips = {
     BEGIN_BLEEDING = "Being shot in an unprotected area will cause bleeding. Press Q_MENU_KEY to bandage yourself.",
     STOPPED_BLEEDING = "Applying a bandage will not restore health, be careful around gunfire.",
     PICKUP_WEAPON = "Picking up weapons will not transmit the owner's ammo, and you can not carry more than 2 weapons at a time.",
     DROPPED_WEAPON = "Taking too much damage to the arms will make you drop your primary and be unable to use them.",
     RADIO_USED = "Radios can be used for quick communication and marking enemy positions. Press C_MENU_KEY to open the radio menu.",
     KILLED_ENEMY = "Make sure to report enemy deaths using the radio, it marks the death area and gives you a cash and experience bonus.",
     MARK_ENEMIES = "Make sure to spot enemies using the radio, it'll give you a spot bonus for enemies killed within the marked area.",
     HEAL_TEAMMATES = "You can bandage your team-mates the same way you can bandage yourself.",
     RESUPPLY_TEAMMATES = "If you have any spare ammo, give it to team-mates that need some.",
     HELP_TEAMMATES = "Make sure to help your team-mates, alone you're rarely a threat to the enemy.",
     HIGH_WEIGHT = "Carrying a lot of equipment will cause your stamina to drain faster from sprinting.",
     SPEND_CASH = "Spend your earned Cash on weapon attachments and Traits.",
     UNLOCK_ATTACHMENT_SLOTS = "Earning Experience will unlock more attachment slots for your guns.",
     HIGH_ADRENALINE = "Being suppressed increases your run speed and hip-fire accuracy, but makes aimed fire difficult.",
     FASTER_MOVEMENT = "Switching to a lighter weapon allows for faster movement.",
     HEALTH_REGEN = "Damage negated by an armor vest without penetration is equal to the amount of health you can regenerate idly.",
     BACKUP_SIGHTS = "The sight you have attached has back-up sights. Double-tap USE_KEY while aiming to switch to them and back.",
     THROW_FRAGS_NEW = "Hold USE_KEY and press PRIMARY_ATTACK_KEY, or press QUICKNADEKEY to throw frag grenades.",
     LOUD_LANDING = "The higher your loadout weight, the lesser the distance required to make a noisy landing.",
     WEAPON_CUSTOMIZATION = "Press C_MENU_KEY to open the weapon interaction menu at the start of a round.",
     ACHIV_EARNED = "You can earn money and experience by earning achievements.",
    },
    MVPs = {
        Title = "Most Valuable Players",
        ["kills"] = {name = "Bounty hunter",desc = "Most kills",formatText = function(self,amount)
            if amount == 1 then
                return "1 kill"
            end
            
            return amount .. " kills" 
        end},
        ["headshots"] = {name = "Head Hunter",desc = "Most headshots",formatText = function(self,amount)
            if amount == 1 then
                return "1 headshot"
            end
            
            return amount .. " headshots"
        end},
        ["damage"] = {name = "Hit and Run",desc = "Most damage",formatText = function(self,amount)
            return amount .. " damage"
        end},
        ["spotting"] = {name = "Spot-a-Boat",desc = "Most spot assists",formatText = function(self,amount)
            return amount .. " spot-assists"
        end},
        ["bandaging"] = {name = "Walking Bandage",desc = "Most team bandaging",formatText = function(self,amount)
            return amount .. " bandages applied"
        end},
        ["resupply"] = {name = "Walking Ammobox",desc = "Most team resupplies",formatText = function(self,amount)
            return amount .. " rounds given"
        end},
        ["medkitfan"] = {name = "Medkit Fan",desc = "Most healing",formatText = function(self,amount)
            return amount .. " heals"
        end},
        ["cqcenjoyer"] = {name = "CQC Enjoyer",desc = "Most disarms",formatText = function(self,amount)
            return amount .. " disarms"
        end},
        ["crippler"] = {name = "Bone Breaker",desc = "Most crippling",formatText = function(self,amount)
            return amount .. " players crippled"
        end},
        ["coomer"] = {name = "Coomer",desc = "Most nuts busted",formatText = function(self,amount)
            return amount .. " nuts busted"
        end},
        ["cumsniper"] = {name = "Cum Sniper",desc = "Most enemy cums",formatText = function(self,amount)
            return amount .. " enemies jizzed"
        end},
    },
    death = {
        Unknown = "Unknown death cause",
        Suicide = "Suicide!",
        Random = {"A headbutt, maybe?"},
        KilledBy = "Killed by ",
    },
    lastManStatus = "Last man standing",
    lastManPhrases = {"Good Luck"},
    gametypes = {
        Drugbust = {
            ["Retrieve&Protect"] = "Retrieve & protect",
            ["Protect"] = "Protect",
            ["Attack&Capture"] = "Attack & capture",
            ["Capture"] = "Capture",
            ["Drugs"] = "Drugs",
            ["DrugPoint"] = "Drug drop point",
            ["Deliver"] = "Capture drugs",
            ["PreventCapture"] = "Prevent capture",
            ["Return"] = "Return drugs",
        },
        Rush = {
         ["Capture"] = "Capture ",
         ["Protect"] = "Protect ",
         ["Capture&Protect"] = {
            [true] = "Capture ",
            [false] = "Protect ",
         },
         ["Speed"] = "SPEED: x",
          ["Status"] = {
           [true] = "Capturing ",
           [false] = "Defending ",
          },
        },
        Assault = {
          ["Warning"] = {
            [true] = "You're too far away! You have TIME second(s) to get back to the playing area!",
            [false] = "Where are you going? You have TIME second(s) to get back to the playing area!",
          },
        },
        Urban = {
         ["CaptureStatus"] = "Capturing ",
         ["Cooldown"] = "Capture cooldown TIME",
         ["Sides"] = {
          ["US"] = "US: ",
          ["Enemy"] = "ENEMY: ",
         },
        },
    },
    classes = {
        ["soldier"] = {
            Name = "Soldier",
            Desc = "You are soldier. Stay close to the squad and follow the orders of the commander.",
        },
        ["cmd"] = {
            Name = "Commander",
            Desc = "You are commander of your squad. Lead your squad.",
        },
        ["spec"] = {
            Name = "Specialist",
            Desc = "You are specialist. Use your gear to complete the task.",
        },
        ["demo"] = {
            Name = "Demoman",
            Desc = "You are demoman. Use your weapon to wipe enemies off the face of the earth",
        },
        ["rookie"] = {
            Name = "Rookie",
            Desc = "You are rookie. You have been demoted and have been stripped of your equipment",
        },
    },
    achivs = {
     ["headshot"] = {
        Name = "Headshot",
        Desc = "Get your first headshot",
     },
     ["dlan"] = {
        Name = "It's a bird! It's a plane! It's RPG-7!",
        Desc = "What are you waiting for? Just kill enemy by RPG-7",
     },
     ["spec"] = {
        Name = "Specialist",
        Desc = "Use your ability 25 times",
     },
    },
}
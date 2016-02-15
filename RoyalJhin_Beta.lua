if GetObjectName(GetMyHero()) ~= "Jhin" then return end

require('Inspired')

local JhinMenu = MenuConfig("Jhin", "Jhin")

JhinMenu:Menu("Combo")

JhinMenu.Combo:Menu("QSettings", "Q - Settings")
JhinMenu.Combo.QSettings:Boolean("Q", "Use Q", true)
JhinMenu.Combo.QSettings:Slider("QMana", "Use Q if %Mana >", 60, 1, 100, 1)

JhinMenu.Combo:Menu("WSettings", "W - Settings")
JhinMenu.Combo.WSettings:Boolean("W", "Use W", true)
JhinMenu.Combo.WSettings:Slider("WMana", "Use W if %Mana >", 60, 1, 100, 1)

JhinMenu.Combo:Menu("ESettings", "E - Settings")
JhinMenu.Combo.ESettings:Boolean("E", "Use E", false)
JhinMenu.Combo.ESettings:Slider("EMana", "Use E if %Mana >", 60, 1, 100, 1)

JhinMenu:Menu("Killsteal", "Killsteal")

JhinMenu.Killsteal:Boolean("Steal", "Enable Killsteal", true)
JhinMenu.Killsteal:Boolean("StealQ", "Use Q", true)
JhinMenu.Killsteal:Boolean("StealW", "Use W", true)
JhinMenu.Killsteal:Boolean("StealIgnite", "Use Ignite", true)

JhinMenu:Menu("Misc", "Misc")

JhinMenu.Misc:Boolean("FarmQ", "Use Farming Q", true)
JhinMenu.Misc:Boolean("UseBotrk", "Use BoTRK", true)
JhinMenu.Misc:Boolean("UseYoumuu", "Use Youmuu's Ghostblade", true)


JhinMenu.Misc:Boolean("FarmQ", "Use Farming Q", true)
JhinMenu.Misc:Boolean("UseBotrk", "Use BoTRK", true)
JhinMenu.Misc:Boolean("UseYoumuu", "Use Youmuu's Ghostblade", true)

JhinMenu:Menu("Drawings", "Drawings")

JhinMenu.Drawings:Boolean("DrawQ", "Draw Q's Range", true)
JhinMenu.Drawings:Boolean("DrawW", "Draw W's Range", true)
JhinMenu.Drawings:Boolean("DrawE", "Draw E's Range", true)

local RTarget = TargetSelector(3000,TARGET_LOW_HP_PRIORITY,DAMAGE_PHYSICAL,true,false)
local isMarked = false
local RCasting = false
local RCast = 0
local Ignite = (GetCastName(GetMyHero(),SUMMONER_1):lower():find("summonerdot") and SUMMONER_1 or (GetCastName(GetMyHero(),SUMMONER_2):lower():find("summonerdot") and SUMMONER_2 or nil))

OnUpdateBuff(function(Object,buff) 
	if buff.Name == "jhinespotteddebuff" then
		IsMarked = true
	end
end)

OnRemoveBuff(function(Object,buff)
	if buff.Name == "jhinespotteddebuff" then
		IsMarked = false
	end
end)

OnProcessSpell(function(unit,spell)
  if unit == myHero then

    if spell.name == "JhinR" then
    IOW.movementEnabled = false
    IOW.attacksEnabled = false
    IsChanneled = true
    RCasting = true
	end
	if spell.name == "JhinRShotMis" then
	RCast = RCast + 1
	end
	if spell.name == "JhinRShotMis4" then
    IOW.movementEnabled = true
    IOW.attacksEnabled = true
    IsChanneled = false
    RCasting = false
	RCast = 0
	end
  end
end)

OnProcessSpellComplete(function(Object, spell)
  if Object == GetMyHero() and spell and spell.name then
    if spell.name == "JhinQ" then
    CastEmote(EMOTE_DANCE) 
    MoveToXYZ(GetMousePos())
    elseif spell.name == "JhinW" then
    CastEmote(EMOTE_DANCE) 
    MoveToXYZ(GetMousePos())
    elseif spell.name == "JhinE" then
    CastEmote(EMOTE_DANCE) 
    MoveToXYZ(GetMousePos())
    end
  end
end)



OnDraw (function (myHero)
	local pos = GetOrigin(myHero)
	if JhinMenu.Drawings.DrawQ:Value() then DrawCircle(pos,550,1,60,GoS.Red) end
	if JhinMenu.Drawings.DrawW:Value() then DrawCircle(pos,2500,1,60,GoS.Yellow) end
	if JhinMenu.Drawings.DrawE:Value() then DrawCircle(pos,750,1,60,GoS.Green) end
end)

OnTick(function(myHero)	

	local target = GetCurrentTarget()
	local ULTTarget = RTarget:GetTarget()
	local Blade = GetItemSlot(myHero,3144)
	local Ruined = GetItemSlot(myHero,3153)
	local Yomuu = GetItemSlot(myHero,3142)

	if RCasting and ValidTarget(ULTTarget, 3000) then
	    if RCast == 0 then
			local R1Pred = GetPredictionForPlayer(GetOrigin(myHero),ULTTarget,GetMoveSpeed(ULTTarget),1700,250,3000,75,false,true)
			if R1Pred.HitChance == 1 then
				CastSkillShot(_R, R1Pred.PredPos)
			end
		elseif RCast == 1 then
			local R2Pred = GetPredictionForPlayer(GetOrigin(myHero),ULTTarget,GetMoveSpeed(ULTTarget),1700,250,3000,75,false,true)
			if R2Pred.HitChance == 1 then
				CastSkillShot(_R, R2Pred.PredPos)
			end
		elseif RCast == 2 then
			local R3Pred = GetPredictionForPlayer(GetOrigin(myHero),ULTTarget,GetMoveSpeed(ULTTarget),1700,250,3000,75,false,true)
			if R3Pred.HitChance == 1 then
				CastSkillShot(_R, R3Pred.PredPos)
			end
		elseif RCast == 3 then
			local R4Pred = GetPredictionForPlayer(GetOrigin(myHero),ULTTarget,GetMoveSpeed(ULTTarget),1700,250,3000,75,false,true)
			if R4Pred.HitChance == 1 then
				CastSkillShot(_R, R4Pred.PredPos)
			end
		end
	end

	if IOW:Mode() == "Combo" then

		if Blade >= 1 and ValidTarget(target,550) and JhinMenu.Misc.UseBotrk:Value() then
			if CanUseSpell(myHero,GetItemSlot(myHero,3144)) == READY then
				CastTargetSpell(target, GetItemSlot(myHero,3144))
			end	
		elseif Ruined >= 1 and ValidTarget(target,550) and JhinMenu.Misc.UseBotrk:Value() then 
			if CanUseSpell(myHero,GetItemSlot(myHero,3153)) == READY then
				CastTargetSpell(target,GetItemSlot(myHero,3153))
			end
		end
		if Yomuu >= 1 and ValidTarget(target,550) and JhinMenu.Misc.UseYoumuu:Value() then
			if CanUseSpell(myHero,GetItemSlot(myHero,3142)) == READY then
				CastSpell(GetItemSlot(myHero,3142))
			end
		end

	    if IsReady(_E) and ValidTarget(target, 750) and JhinMenu.Combo.ESettings.E:Value() and (GetPercentMP(myHero) >= JhinMenu.Combo.ESettings.EMana:Value()) then
			CastTargetSpell(target, _E)
			PrintChat("E TARGET: " ..GetObjectName(target))
        IsReady(_W) and JhinMenu.Combo.WSettings.W:Value() and (GetPercentMP(myHero) >= JhinMenu.Combo.WSettings.WMana:Value()) then
			if IsMarked == true and IsReady(_W) and ValidTarget(target, 2500) then
				local WPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),1400,250,2500,100,false,true)
				if WPred.HitChance == 1 then
					CastSkillShot(_W, WPred.PredPos)
				end
			end
		end

		if IsReady(_Q) and JhinMenu.Combo.QSettings.Q:Value() and (GetPercentMP(myHero) >= JhinMenu.Combo.QSettings.QMana:Value()) then
			for i,minion in pairs(minionManager.objects) do
				if IsObjectAlive(minion) and GetTeam(minion) == MINION_ENEMY and IsReady(_Q) and ValidTarget(minion, 550) and GetCurrentHP(minion) < CalcDamage(myHero, minion, 35 + 25*GetCastLevel(myHero, _Q) + (0.25 + 0.05*GetCastLevel(myHero, _Q))*GetBonusDmg(myHero), 0) and MinionsAround(GetOrigin(minion), 500) <= 3 then
					CastTargetSpell(minion, _Q)
				elseif ValidTarget(target, 550) then
					CastTargetSpell(target, _Q)
				end
			end
		end
    end -- End combo mode

	if IOW:Mode() == "LastHit" or "LaneClear" and not RCasting then
		if JhinMenu.Misc.FarmQ:Value() then
			for i,minion in pairs(minionManager.objects) do
				if IsObjectAlive(minion) and GetTeam(minion) == MINION_ENEMY and IsReady(_Q) and ValidTarget(minion, 550) and GetCurrentHP(minion) < CalcDamage(myHero, minion, 35 + 25*GetCastLevel(myHero, _Q) + (0.25 + 0.05*GetCastLevel(myHero, _Q))*GetBonusDmg(myHero), 0) then
					CastTargetSpell(minion, _Q)
				end
			end
		end
	end -- End Clear Mode

	if JhinMenu.Killsteal.Steal:Value() and not RCasting then
	for i, enemy in pairs(GetEnemyHeroes()) do
		
        if JhinMenu.Killsteal.StealQ:Value() then
			if Ready(_Q) and GetCurrentHP(enemy) + GetMagicShield(enemy) + GetDmgShield(enemy) < CalcDamage(myHero, enemy, 35 + 25*GetCastLevel(myHero, _Q) + (0.25 + 0.05*GetCastLevel(myHero, _Q))*GetBonusDmg(myHero), 0) and ValidTarget(enemy, 550) then
			    CastTargetSpell(enemy, _Q) 
		    end
	    end

		if JhinMenu.Killsteal.StealW:Value() then
			if Ready(_W) and GetCurrentHP(enemy) + GetMagicShield(enemy) + GetDmgShield(enemy) < CalcDamage(myHero, enemy, 15 + 35*GetCastLevel(myHero, _Q) + 0.7*GetBonusDmg(myHero), 0) and ValidTarget(enemy, 2500) then
			    local WPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(enemy),1400,250,2500,220,false,true)
				if WPred.HitChance == 1 then
					CastSkillShot(_W, WPred.PredPos)
				end
		    end
	    end

    end
	end

end)

print("[Royal] Jhin prototype loaded!")

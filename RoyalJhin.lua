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

JhinMenu.Combo:Menu("RSettings", "R - Settings")
JhinMenu.Combo.RSettings:Boolean("R", "Use R (Shooting)", false)

JhinMenu:Menu("Killsteal", "Killsteal")

JhinMenu.Killsteal:Boolean("Steal", "Enable Killsteal", true)
JhinMenu.Killsteal:Boolean("StealQ", "Use Q", true)
JhinMenu.Killsteal:Boolean("StealW", "Use W", true)
JhinMenu.Killsteal:Boolean("StealIgnite", "Use Ignite", true)

JhinMenu:Menu("Farming", "Farming")

JhinMenu.Farming:Boolean("FarmQ", "Use Q", true)
JhinMenu.Farming:Boolean("FarmE", "Use E (LaneClear only)", true)
JhinMenu.Farming:Slider("FarmingMana", "Farm if %Mana >", 30, 1, 100, 1)

JhinMenu:Menu("Misc", "Misc")

JhinMenu.Misc:Boolean("UseBotrk", "Use BoTRK", true)
JhinMenu.Misc:Boolean("UseYoumuu", "Use Youmuu's Ghostblade", true)
JhinMenu.Misc:Boolean("Farsight", "Buy Farsight Alteration", true)

JhinMenu:Menu("Drawings", "Drawings")

JhinMenu.Drawings:Boolean("DrawQ", "Draw Q's Range", true)
JhinMenu.Drawings:Boolean("DrawW", "Draw W's Range", true)
JhinMenu.Drawings:Boolean("DrawE", "Draw E's Range", true)
JhinMenu.Drawings:Boolean("DrawR", "Draw R's Range", true)

local isMarked = false
local RCasting = false
local RCast = 0
local ShouldCast = false
local Ignite = (GetCastName(GetMyHero(),SUMMONER_1):lower():find("summonerdot") and SUMMONER_1 or (GetCastName(GetMyHero(),SUMMONER_2):lower():find("summonerdot") and SUMMONER_2 or nil))
local EPred = nil
local WPred = nil
local FindRadius = 0
local RPred = nil
local target = GetCurrentTarget()
local OldTarget = target


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
  if unit == myHero and JhinMenu.Combo.RSettings.R:Value() then

	if spell.name == "JhinR" then
		IOW.movementEnabled = false
		IOW.attacksEnabled = false
		IsChanneled = true
		RCasting = true
		OldTarget = GetCurrentTarget()

		DelayAction(function() 
			ResetUlt()
		end, 10)
	end

	if spell.name == "JhinRShotMis" then
		RCast = RCast + 1
		ShouldCast = true
		DelayAction(function() 
			ResetUlt()
		end, 10 - 3*RCast)
	end

	if spell.name == "JhinRShotMis4" then
	ResetUlt() 
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
	local posTarget = GetOrigin(GetCurrentTarget())
	if JhinMenu.Drawings.DrawQ:Value() then DrawCircle(pos,600,1,60,GoS.Red) end
	if JhinMenu.Drawings.DrawW:Value() then DrawCircle(pos,2500,1,60,GoS.Yellow) end
	if JhinMenu.Drawings.DrawE:Value() then DrawCircle(pos,750,1,60,GoS.Green) end
	if JhinMenu.Drawings.DrawR:Value() then DrawCircle(pos,3500,1,60,GoS.Cyan) end
end)

OnTick(function(myHero)	

	target = GetCurrentTarget()
	local Blade = GetItemSlot(myHero,3144)
	local Ruined = GetItemSlot(myHero,3153)
	local Yomuu = GetItemSlot(myHero,3142)
	local TotalDamage = GetBaseDamage(myHero) + GetBonusDmg(myHero)
	FindRadius = 2 * math.ceil(GetDistance(OldTarget) / 4.6)

	if RCasting and ValidTarget(target, 3500) and IsVisible(target) and ShouldCast and RCast > 0 and not IsDead(OldTarget) then ShotUlt(target) end
	if RCasting and IsDead(OldTarget) and (EnemiesAround(OldTarget, FindRadius) <= 1 or not ValidTarget(target, 1700)) then ResetUlt() end

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
		if Yomuu >= 1 and ValidTarget(target,750) and JhinMenu.Misc.UseYoumuu:Value() then
			if CanUseSpell(myHero,GetItemSlot(myHero,3142)) == READY then
				CastSpell(GetItemSlot(myHero,3142))
			end
		end

	    if IsReady(_E) and ValidTarget(target, 750) and JhinMenu.Combo.ESettings.E:Value() and (GetPercentMP(myHero) >= JhinMenu.Combo.ESettings.EMana:Value()) then

			EPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target), 750, 250, 750, 260, false, true)
				if EPred.HitChance == 1 then
					CastSkillShot(_E, EPred.PredPos)
				end
		end
        if IsReady(_W) and JhinMenu.Combo.WSettings.W:Value() and (GetPercentMP(myHero) >= JhinMenu.Combo.WSettings.WMana:Value()) then
			if IsMarked and ValidTarget(target, 2500) then
				WPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),math.huge,750,2500,50,false,true)
				if WPred.HitChance == 1 then
					CastSkillShot(_W, WPred.PredPos)
				end
			end
		end

		if IsReady(_Q) and JhinMenu.Combo.QSettings.Q:Value() and (GetPercentMP(myHero) >= JhinMenu.Combo.QSettings.QMana:Value()) then
			for i,minion in pairs(minionManager.objects) do
				if IsObjectAlive(minion) and GetTeam(minion) == MINION_ENEMY and IsReady(_Q) and ValidTarget(minion, 600) and GetCurrentHP(minion) < CalcDamage(myHero, minion, 35 + 25*GetCastLevel(myHero, _Q) + (0.25 + 0.05*GetCastLevel(myHero, _Q))*GetBonusDmg(myHero), 0) and EnemiesAround(GetOrigin(minion), 500) > 0 and MinionsAround(GetOrigin(minion), 500) <= 3 then
					CastTargetSpell(minion, _Q)
				elseif ValidTarget(target, 600) then
					CastTargetSpell(target, _Q)
				end
			end
		end
    end -- End combo mode

	if IOW:Mode() == "LastHit" and not RCasting then
		if JhinMenu.Farming.FarmQ:Value() and (GetPercentMP(myHero) >= JhinMenu.Farming.FarmingMana:Value()) then
			for i,minion in pairs(minionManager.objects) do
				if IsObjectAlive(minion) and GetTeam(minion) == MINION_ENEMY and IsReady(_Q) and ValidTarget(minion, 600) and GetCurrentHP(minion) < CalcDamage(myHero, minion, 35 + 25*GetCastLevel(myHero, _Q) + (0.25 + 0.05*GetCastLevel(myHero, _Q))*GetBonusDmg(myHero), 0) then
					CastTargetSpell(minion, _Q)
				end
			end
		end
	end -- End Clear Mode

	if IOW:Mode() == "LaneClear" and not RCasting then
		if JhinMenu.Farming.FarmQ:Value() and (GetPercentMP(myHero) >= JhinMenu.Farming.FarmingMana:Value()) then
			for i,minion in pairs(minionManager.objects) do
				if IsObjectAlive(minion) and GetTeam(minion) == MINION_ENEMY and IsReady(_Q) and ValidTarget(minion, 600) and GetCurrentHP(minion) < CalcDamage(myHero, minion, 35 + 25*GetCastLevel(myHero, _Q) + (0.25 + 0.05*GetCastLevel(myHero, _Q))*GetBonusDmg(myHero), 0) then
					CastTargetSpell(minion, _Q)
				end
			end
		end
		if IsReady(_E) and JhinMenu.Farming.FarmE:Value() and (GetPercentMP(myHero) >= JhinMenu.Farming.FarmingMana:Value()) then
           local BestPos, BestHit = GetFarmPosition(750, 260, MINION_ENEMY)
           if BestPos and BestHit > 0 then 
           CastSkillShot(_E, BestPos)
           end
	    end

	end

	if JhinMenu.Killsteal.Steal:Value() and not RCasting then
		for i, enemy in pairs(GetEnemyHeroes()) do
			if JhinMenu.Killsteal.StealQ:Value() then
				if Ready(_Q) and GetCurrentHP(enemy) + GetDmgShield(enemy) < CalcDamage(myHero, enemy, 35 + 25*GetCastLevel(myHero, _Q) + (0.25 + 0.05*GetCastLevel(myHero, _Q))*TotalDamage, 0) and ValidTarget(enemy, 600) then
				    CastTargetSpell(enemy, _Q) 
			    end
			end	
			if JhinMenu.Killsteal.StealW:Value() then
				if Ready(_W) and GetCurrentHP(enemy) + GetDmgShield(enemy) < CalcDamage(myHero, enemy, 15 + 35*GetCastLevel(myHero, _Q) + 0.7*TotalDamage, 0) and ValidTarget(enemy, 2500) then
				    WPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(enemy),math.huge,750,2500,50,false,true)
					if WPred.HitChance == 1 then
						CastSkillShot(_W, WPred.PredPos)
					end
			    end
			 end
			if Ignite and JhinMenu.Killsteal.StealIgnite:Value() then
				if IsReady(Ignite) and 20*GetLevel(myHero)+50 > GetCurrentHP(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*3 and ValidTarget(enemy, 600) then
					CastTargetSpell(enemy, Ignite)
				end
			end
		end
	end

	if JhinMenu.Misc.Farsight:Value() and GetLevel(myHero) > 8 then 
		if GetItemID(myHero,ITEM_7) ~= 3363 then
			BuyItem(3363)
		end -- Noddy pls
	end

end)

function ShotUlt(target)
	RPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),2500,250,3000,50,false,true)
		if RPred.HitChance == 1 and ShouldCast then
			CastSkillShot(_R, RPred.PredPos)
		end
end

function ResetUlt()
	IOW.movementEnabled = true
	IOW.attacksEnabled = true
	IsChanneled = false
	RCasting = false
	RCast = 0
	ShouldCast = false
end

OnLoseVision(function(Object)
	if Object == GetCurrentTarget() and RCasting then
	ShouldCast = false
	end
end)

OnGainVision(function(Object)
	if Object == GetCurrentTarget() and RCasting then
	ShouldCast = true
	end
end)

PrintChat("[Royal] Jhin prototype loaded!")

if GetObjectName(GetMyHero()) ~= "Kayle" then return end

require('Inspired')

local KayleMenu = MenuConfig("Kayle","Kayle")

KayleMenu:Menu("Combo")

KayleMenu.Combo:Menu("QSettings", "Q - Settings")
KayleMenu.Combo.QSettings:Boolean("Q", "Use Q", true)
KayleMenu.Combo.QSettings:Slider("QMana", "Use Q if %Mana >", 60, 1, 100, 1)
KayleMenu.Combo.QSettings:DropDown("QMode", "Q Mode", 1, {"Always", "Enemy out of range"})

KayleMenu.Combo:Menu("WSettings", "W - Settings")
KayleMenu.Combo.WSettings:Boolean("W", "Use W", true)
KayleMenu.Combo.WSettings:Slider("WHP", "Use W if %HP <", 90, 1, 100, 1)
KayleMenu.Combo.WSettings:Slider("WMana", "Use W if %Mana >", 60, 1, 100, 1)
KayleMenu.Combo.WSettings:DropDown("WMode", "W Mode", 1, {"Healing", "Enemy out of range"})

KayleMenu.Combo:Boolean("E", "Use E", true)

KayleMenu.Combo:Menu("RSettings", "R - Settings")
KayleMenu.Combo.RSettings:Boolean("R", "Use R", false)
KayleMenu.Combo.RSettings:Slider("UltHP", "Use R if %HP <", 25, 1, 100, 1)
KayleMenu.Combo.RSettings:Slider("Enemies", "Use R if Enemies >=", 1, 1, 5)
KayleMenu.Combo.RSettings:DropDown("RMode", "R Mode", 1, {"Egoistic Bitch", "Help your team"})

KayleMenu:Menu("Killsteal", "Killsteal")
KayleMenu.Killsteal:Boolean("KillQ", "Use Q", true)
KayleMenu.Killsteal:Boolean("KillIgnite", "Use Ignite", false)

KayleMenu:Menu("Drawings", "Drawings")
KayleMenu.Drawings:Boolean("DrawQ", "Draw Q Range", true)
KayleMenu.Drawings:Boolean("DrawW", "Draw W&R Range", true)
KayleMenu.Drawings:Slider("Quality", "Quality", 125, 1, 255)


OnDraw(function(myHero)

	if KayleMenu.Drawings.DrawQ:Value() and IsReady(_Q) then
		DrawCircle(GetOrigin(myHero), 650, 1, KayleMenu.Drawings.Quality:Value(), GoS.Green)
		--DrawCircle(Vector3D, radius, width, quality, color)
	end
	if KayleMenu.Drawings.DrawW:Value() and IsReady(_W) or IsReady(_R) then
		DrawCircle(GetOrigin(myHero), 900, 1, KayleMenu.Drawings.Quality:Value(), GoS.Yellow)
	end
end)


OnTick(function(myHero)

	local target = GetCurrentTarget()

	if IOW:Mode() == "Combo" then 

		if IsReady(_Q) and KayleMenu.Combo.QSettings.Q:Value() and ValidTarget(target,650) and (GetPercentMP(myHero) >= KayleMenu.Combo.QSettings.QMana:Value()) then
			if KayleMenu.Combo.QSettings.QMode:Value() == 1 then
				CastTargetSpell(target, _Q)
			elseif KayleMenu.Combo.QSettings.QMode:Value() == 2 and GetDistance(target, myHero) >= 625 then
				CastTargetSpell(target, _Q)
			end
        end

		if IsReady(_W) and KayleMenu.Combo.WSettings.W:Value() and ValidTarget(target,900) and (GetPercentMP(myHero) >= KayleMenu.Combo.WSettings.WMana:Value()) then
			if KayleMenu.Combo.WSettings.WMode:Value() == 1 and (GetCurrentHP(myHero) <= KayleMenu.Combo.WSettings.WHP:Value()) then
				CastTargetSpell(myHero, _W)
			elseif KayleMenu.Combo.WSettings.WMode:Value() == 2 and GetDistance(target, myHero) >= 625 then
				CastTargetSpell(myHero, _W)
			end
        end

		if IsReady(_E) and KayleMenu.Combo.E:Value() and ValidTarget(target,625) then
			CastSpell(_E)
        end

	end

	if IsReady(_R) and KayleMenu.Combo.RSettings.R:Value() then 

		if KayleMenu.Combo.RSettings.RMode:Value() == 1 and (GetPercentHP(myHero) <= KayleMenu.Combo.RSettings.UltHP:Value()) and EnemiesAround(GetOrigin(ally), 900) >= KayleMenu.Combo.RSettings.Enemies:Value() then
			CastTargetSpell(myHero, _R)
		elseif KayleMenu.Combo.RSettings.RMode:Value() == 2 then
			
			for _, ally in pairs(GetAllyHeroes()) do
				if not IsDead(ally) and GetPercentHP(ally) <= KayleMenu.Combo.RSettings.UltHP:Value() and EnemiesAround(GetOrigin(ally), 900) >= KayleMenu.Combo.RSettings.Enemies:Value() and not IsDead(ally) then
					if GetDistance(ally) <= 900 then
						CastTargetSpell(ally, _R)	
					end	
				end	
			end
		end
	end

	if IOW:Mode() == "LaneClear" or IOW:Mode() == "LastHit" or IOW:Mode() == "Harass" then 
		if IsReady(_E) then
			CastSpell(_E)
        end
	end

	for i, enemy in pairs(GetEnemyHeroes()) do

        if KayleMenu.Killsteal.KillQ:Value() and Ready(_Q) and ValidTarget(target, 650) then
			if GetCurrentHP(enemy) + GetMagicShield(enemy) + GetDmgShield(enemy) < CalcDamage(myHero, enemy, 0, 10 + 50*GetCastLevel(myHero, _Q) + 0.6*GetBonusAP(myHero) + GetBonusDmg(myHero)) then
			    CastTargetSpell(enemy, _Q) 
		    end
	    end

		if Ignite and KayleMenu.Killsteal.KillIgnite:Value() then
        if IsReady(Ignite) and 20*GetLevel(myHero)+50 > GetCurrentHP(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*3 and ValidTarget(enemy, 600) then
        CastTargetSpell(enemy, Ignite)
        end
      end

   end

end)

print("[Royal] Kayle prototype loaded!")

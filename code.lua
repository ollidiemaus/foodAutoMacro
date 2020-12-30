-- This file is loaded from "FoodAutoMacro.toc"
do

  local conjuredId = 113509; -- Conjured Mana Bun
  local ambroriaDewId = 177040; -- Ambroria Dew
  local etheralPomegranateId = 173859; -- Ethereal Pomegranate
  
  
  function getFoodNames()
    conjuredName = GetItemInfo(conjuredId);
    ambroriaDewName = GetItemInfo(ambroriaDewId);
    etheralPomegranateName = GetItemInfo(etheralPomegranateId);
  
    -- fall back on connect sometimes GetItem fail
    if conjuredName==nil then
      conjuredName = "Conjured Mana Bun"
    end
    if ambroriaDewName==nil then
      ambroriaDewName = "Ambroria Dew"
    end
    if etheralPomegranateName==nil then
      etheralPomegranateName = "Ethereal Pomegranate"
    end
    return conjuredName, ambroriaDewName, etheralPomegranateName
  end
  
  function getFood()
    conjuredName, ambroriaDewName, etheralPomegranateName = getFoodNames()
    return {
      {conjuredName, GetItemCount(conjuredId, false, false)},
      {ambroriaDewName, GetItemCount(ambroriaDewId, false, false)},
      {etheralPomegranateName, GetItemCount(etheralPomegranateId, false, false)}
  
    }
  end
  
  local onCombat = true;
  local FoodMacroIcon = CreateFrame("Frame");
  FoodMacroIcon:RegisterEvent("BAG_UPDATE");
  FoodMacroIcon:RegisterEvent("PLAYER_LOGIN");
  FoodMacroIcon:RegisterEvent("PLAYER_REGEN_ENABLED");
  FoodMacroIcon:RegisterEvent("PLAYER_REGEN_DISABLED");
  FoodMacroIcon:SetScript("OnEvent",function(self,event,...)
    if event=="PLAYER_LOGIN" then
      onCombat = false;
    end
    if event=="PLAYER_REGEN_DISABLED" then
      onCombat = true;
      return ;
    end
    if event=="PLAYER_REGEN_ENABLED" then
      onCombat = false;
    end
  
    if onCombat==false then
      local food = getFood()
      local macroStr, foodName, foodList, foodListCounter, foodsString;
  
      foodList = {}
      foodListCounter = 0;
      foodsString = ""
  
      for i,v in ipairs(food) do
        if v[2] > 0 then
          foodName = v[1]
          table.insert(foodList,foodName)
          foodListCounter=foodListCounter+1;
        end
      end
  
      if foodListCounter==0 then
        macroStr = "#showtooltip"
      else
        for i, v in ipairs(foodList) do
          if i==1 then
            foodsString = foodsString .. v;
          else
            foodsString = foodsString .. ", " .. v;
          end
        end
      end
      macroStr = "#showtooltip \n/castsequence reset=combat " .. foodsString;
      EditMacro("FAMFood", "FAMFood", nil, macroStr, 1, nil)
    end
  end)
  
  end
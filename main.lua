-- Lua SwitchBox for Beier SFR-1 widget V0.1
--
--
-- A Radiomaster TX16S widget for the EdgeTX OS to simulate a SWTBOX
--
-- Author: Dieter Bruse http://bruse-it.com/
--
-- This file is part of a free Widgetlibrary.
--
-- Smart Switch is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY, without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, see <http://www.gnu.org/licenses>.
local name = "SwitchView"


-- Create a table with default options
-- Options can be changed by the user from the Widget Settings menu
-- Notice that each line is a table inside { }
local options = {
    --{ "Source", SOURCE, 1 },
    -- BOOL is actually not a boolean, but toggles between 0 and 1
    --{ "Boolean", BOOL, 1 },
    --{ "Value", VALUE, 1, 0, 10},
    { "Color", COLOR, BLACK },
    --{ "Text", STRING, "Max8chrs" }
  }

local inputs = {}
local SwitchInfo = {}
local BackgroundImage = Bitmap.open("/WIDGETS/SWITCHVW/PNG/RMTX16II.png")

local function loadConfig(options)

    local lines = 99
    local input = 0
    local index = 0
    local theInput = {}
    local fieldInfo = {}
    
    while lines > 0 do
        lines = model.getInputsCount(input)
        for line=0, lines do
            theInput = model.getInput(input, line)
            if theInput ~= nil
            then
                fieldInfo = getFieldInfo(theInput.source)
                inputs[index] = {InputID=input, InputLine=theInput, fieldInfo=fieldInfo}
--                SwitchInfo[theInput.inputName] = "My Test"
--                SwitchInfo[fieldInfo.name]= SwitchInfo[fieldInfo.name] .. theInput.inputName
--                if(SwitchInfo[fieldInfo.id] == nil)
--                then
--                    SwitchInfo[fieldInfo.id].Name = theInput.name
--                end
                index = index + 1
            end
        end
        input = input + 1
    end


end

local function create(zone, options)
    -- Runs one time when the widget instance is registered
    -- Store zone and options in the widget table for later use
    local widget = {
      zone = zone,
      options = options
    }
    -- Add local variables to the widget table,
    -- unless you want to share with other instances!
    widget.someVariable = 3
    loadConfig(options)
    -- Return widget table to EdgeTX
    return widget
  end

  local function update(widget, options)
    -- Runs if options are changed from the Widget Settings menu
    widget.options = options
  end
 
  local function background(widget)
    -- Runs periodically only when widget instance is not visible
    -- lcd.clear()
    -- lcd.drawText(60,60,"Background Size " .. widget.zone.w .. "/" .. widget.zone.h)
  end

  local function refresh(widget, event, touchState)
    -- Runs periodically only when widget instance is visible
    -- If full screen, then event is 0 or event value, otherwise nil
    -- lcd.clear()
   --lcd.drawText(0,1,"Refresh Size " .. widget.zone.w .. "/" .. widget.zone.h)
    --lcd.drawText(0,30,"Count of Inputs " .. #inputs)
    --for idx=0, #inputs do
    --  lcd.drawText(0,idx * 15, "Index:" .. idx .. " has ID:" .. inputs[idx].InputID .. " Name:" .. inputs[idx].InputLine.name .. " FieldName:" .. inputs[idx].fieldInfo.name .. "(" .. inputs[idx].fieldInfo.id .. ")" )
    --end
    lcd.drawBitmap(BackgroundImage, 0, 0)
    local idx = 0
    --lcd.drawText(0,0, "Count:" .. #SwitchInfo)
    for index,value in ipairs({{name="sa",col=0, row=110}, {name="sb",col=0, row=80}, {name="sc",col=300, row=80}, {name="sd",col=300, row=110}, {name="se",col=0, row=45}, {name="sf",col=0, row=5}, {name="sg",col=300, row=45},{name= "sh",col=300, row=5}})
    do
      local resultValue = ""
      local delimiter = string.upper(value.name) .. ": "
      for input_index = 0, #inputs do
        if inputs[input_index].fieldInfo.name == value.name
        then
          resultValue = resultValue .. delimiter .. inputs[input_index].InputLine.name
          delimiter = "/"
        end
      end
      if(resultValue ~= "")
      then
        lcd.drawText(value.col,value.row, resultValue, widget.options.Color)
        idx = idx + 1
      end
    end

end

  return {
    name = name,
    options = options,
    create = create,
    update = update,
    refresh = refresh,
    background = background
  }
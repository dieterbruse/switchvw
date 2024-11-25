-- Lua SwitchBox for Beier SFR-1 widget V0.1
--
--
-- A Radiomaster TX16S widget for the EdgeTX OS
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
local BackgroundImage = Bitmap.open("/WIDGETS/SWITCHVW/PNG/RMTX16II.png")
local log_filename = "/LOGS/SWITCHVWlog.txt"


local function write_log(message, create)
      local write_mode = "a"
        if create ~= true then
          write_mode = "a"
        else
          write_mode = "w"
        end
  			local file = io.open(log_filename, write_mode)
  			io.write(file, message, "\r\n")
  			io.close(file)
end

local function loadConfig(options)

    local lines = 99
    local input = 0
    local index = 0
    local theInput = {}
    local fieldInfo = {}
    inputs = {}
    while lines > 0 do
        lines = model.getInputsCount(input)
        for line=0, lines do
--            write_log("Loading Line Nr. " .. line, true)
            theInput = model.getInput(input, line)
            if theInput ~= nil
            then
--                write_log("Loading Input for Line " .. line .. " Input Name: " .. theInput.name .. " InputName: " .. theInput.inputName,false)
                fieldInfo = getFieldInfo(theInput.source)
--                write_log("Loading FieldInfo for Line " .. line .. " InputName: " .. fieldInfo.name,false)
                inputs[index] = {InputID=input, InputLine=theInput, fieldInfo=fieldInfo}
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
    loadConfig(options)
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
 
    lcd.drawBitmap(BackgroundImage, 0, 0)
    local idx = 0
    local rightStart = 285
    for index,value in ipairs({{name="sa",col=0, row=110}, {name="sb",col=0, row=75}, {name="sc",col=rightStart, row=75}, {name="sd",col=rightStart, row=110}, {name="se",col=0, row=40}, {name="sf",col=0, row=5}, {name="sg",col=rightStart, row=40},{name= "sh",col=rightStart, row=5}})
    do
      local firstLine = ""
      local secondLine = ""
      local delimiter = string.upper(value.name) .. ": "
      local inputsPrinted = 0
      lcd.drawRectangle(value.col, value.row, 105, 33, RED)      
      for input_index = 0, #inputs do
--        write_log("View: Compare Input Nr. " .. input_index .. " Name: " .. string.upper(inputs[input_index].fieldInfo.name) .. " with valueName: " .. string.upper(value.name), false)
        if string.upper(inputs[input_index].fieldInfo.name) == string.upper(value.name)
        then
          if inputsPrinted < 2
          then
            firstLine = firstLine .. delimiter .. inputs[input_index].InputLine.name
  --          write_log("View: Input Nr. " .. input_index .. "ResultValue: " .. resultValue, false )
            delimiter = "/"
          else
            if inputsPrinted == 2
            then
              delimiter = ""
            end
            secondLine = secondLine .. delimiter .. inputs[input_index].InputLine.name
            delimiter = "/"
          end
          inputsPrinted = inputsPrinted + 1
        end
      end
      if firstLine ~= ""
      then
        lcd.drawText(value.col+1,value.row, firstLine, widget.options.Color)
        idx = idx + 1
      end
      if secondLine ~= ""
      then
        lcd.drawText(value.col + 29,value.row + 15, secondLine, widget.options.Color)
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
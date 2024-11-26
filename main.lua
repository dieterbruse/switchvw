-- Lua SwitchBox for Beier SFR-1 widget V1.2
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
    { "SwitchName", BOOL, 1 },
    { "DrawBox", BOOL, 1 },
    --{ "Value", VALUE, 1, 0, 10},
    { "Color", COLOR, BLACK },
    --{ "Text", STRING, "Max8chrs" }
  }

local inputs = {}
local BackgroundImage = Bitmap.open("/WIDGETS/SWITCHVW/PNG/RMTX16II.png")
local log_filename = "/LOGS/SWITCHVWlog.txt"
local firstColumnPx=0
local secondColumnPx=285
local firstRowPx=5
local secondRowPx=40
local thirdRowPx=75
local lastRowPx=110
local SwitchValues = {}
local PositionForName = 0

local function write_log(message, create)
--      local write_mode = "a"
--        if create ~= true then
--          write_mode = "a"
--        else
--          write_mode = "w"
--        end
--  			local file = io.open(log_filename, write_mode)
--  			io.write(file, message, "\r\n")
--  			io.close(file)
end

local function loadConfig(options)

    local lines = 99
    local input = 0
    local index = 0
    local theInput = {}
    local theMix = {}
    local fieldInfo = {}
    inputs = {}
    local delimiter = ""

    SwitchValues = {
      {
        name="SA",
        textEntries=0,
        firstValue="",
        secondValue="",
        col=firstColumnPx,
        row=lastRowPx
      },
      {
        name="SB",
        textEntries=0,
        firstValue="",
        secondValue="",
        col=firstColumnPx,
        row=thirdRowPx
      },
      {
        name="SC",
        textEntries=0,
        firstValue="",
        secondValue="",
        col=secondColumnPx,
        row=thirdRowPx
      },
      {
        name="SD",
        textEntries=0,
        firstValue="",
        secondValue="",
        col=secondColumnPx,
        row=lastRowPx
      },
      {
        name="SE",
        textEntries=0,
        firstValue="",
        secondValue="",
        col=firstColumnPx,
        row=secondRowPx
      },
      {
        name="SF",
        textEntries=0,
        firstValue="",
        secondValue="",
        col=firstColumnPx,
        row=firstRowPx
      },
      {
        name="SG",
        textEntries=0,
        firstValue="",
        secondValue="",
        col=secondColumnPx,
        row=secondRowPx
      },
      {
        name="SH",
        textEntries=0,
        firstValue="",
        secondValue="",
        col=secondColumnPx,
        row=firstRowPx
      }
    }

    write_log("Start the Logging for SwitchView Widget V 1.2", true)
    if options.SwitchName == 1
    then
      PositionForName = 29
    else
      PositionForName = 0
    end

    for index, value in ipairs(SwitchValues)
    do
      write_log("Start the search with Line Nr. " .. index .. " Switch: " .. value.name .. " at Positon ROW/COL: " .. value.row .. "/" .. value.col, false)
      input = 0
      lines=99
      while lines > 0 do
        lines = model.getInputsCount(input)
        for line=0, lines do
--          write_log("Loaded InputLines " .. input .. " Line: " .. line , false)
          theInput = model.getInput(input, line)
          if theInput ~= nil
          then
--            write_log("Loaded Input Name: " .. theInput.name, false)
            fieldInfo = getFieldInfo(theInput.source)
            if string.upper(fieldInfo.name) == string.upper(value.name)
            then
--              write_log("Loaded FieldInfo " .. fieldInfo.name, false)
              if SwitchValues[index].textEntries < 2
              then

                if options.SwitchName == 1 and SwitchValues[index].textEntries == 0
                then
                  SwitchValues[index].firstValue = SwitchValues[index].name .. ":"
                end

                SwitchValues[index].firstValue = SwitchValues[index].firstValue .. delimiter .. theInput.name
                delimiter = "/"
              else
                if SwitchValues[index].textEntries == 2
                then
                  delimiter = ""
                end
                SwitchValues[index].secondValue = SwitchValues[index].secondValue .. delimiter .. theInput.name
                delimiter = "/"
              end
              SwitchValues[index].textEntries = SwitchValues[index].textEntries + 1
            end
          end
        end
        input = input + 1
        delimiter = ""
      end
      input = 0
      for channel=0, 15 do
        lines = model.getMixesCount(channel)
        for line=0, lines do
          write_log("Loaded MixLines " .. channel .. " Line: " .. line , false)
          theMix = model.getMix(channel, line)
          if theMix ~= nil
          then
            fieldInfo = getFieldInfo(theMix.source)
            write_log("Mix CH" .. channel + 1 .. " Name:" .. theMix.name .. " FieldName:" .. fieldInfo.name, false)
            if string.upper(fieldInfo.name) == string.upper(value.name)
            then
              write_log("Loaded FieldInfo " .. fieldInfo.name, false)
              if SwitchValues[index].textEntries < 2
              then

                if options.SwitchName == 1 and SwitchValues[index].textEntries == 0
                then
                  SwitchValues[index].firstValue = SwitchValues[index].name .. ":"
                end

                SwitchValues[index].firstValue = SwitchValues[index].firstValue .. delimiter .. theMix.name
                delimiter = "/"
              else
                if SwitchValues[index].textEntries == 2
                then
                  delimiter = ""
                end
                SwitchValues[index].secondValue = SwitchValues[index].secondValue .. delimiter .. theMix.name
                delimiter = "/"
              end
              SwitchValues[index].textEntries = SwitchValues[index].textEntries + 1
            end
          end
          delimiter = ""
        end
      end
    end

    -- ONLY FOR DEBUG
    for index, value in ipairs(SwitchValues)
    do
      write_log("Finished the search with Line Nr. " .. index .. " 1st Value: " .. value.firstValue .. " 2nd Value: " .. value.secondValue, false)
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
 
    for index, value in ipairs(SwitchValues)
    do
      write_log("Draw Switch " .. value.name .. " 1st Value: " .. value.firstValue .. " 2nd Value: " .. value.secondValue .. " to Col/Raw " .. value.col .. "/" .. value.row, false)
      if widget.options.DrawBox == 1
      then
        lcd.drawRectangle(value.col, value.row, 105, 33, RED)      
      end
      if value.firstValue ~= ""
      then
        lcd.drawText(value.col+1,value.row, value.firstValue, widget.options.Color)
       end
      if value.secondValue ~= ""
      then
        lcd.drawText(value.col + PositionForName,value.row + 15, value.secondValue, widget.options.Color)
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
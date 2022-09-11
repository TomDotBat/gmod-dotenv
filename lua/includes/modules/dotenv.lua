--[[
	COPYRIGHT NOTICE:
	© 2022 Thomas O'Sullivan - All rights reserved.

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.

	FILE INFORMATION:
	Name: dotenv.lua
	Project: gmod-dotenv
	Author: Tom
	Created: 2nd September 2022
--]]

--- A dotenv implementation in Lua.
-- @module env
-- @author Tom.
-- @license MIT
-- @copyright Thomas O'Sullivan
env = {}

local keys = {}

--- Get the value of an environment variable as a string.
-- @tparam string key the name of the variable.
-- @tparam ?string|nil fallback a string to return if the variable is not set.
-- @treturn ?string|nil the value of the variable if set, else the fallback is used, nil if no fallback is provided.
function env.getString(key, fallback)
	assert(isstring(key), "Key must be a string.")
	assert(fallback == nil or isstring(fallback), "Fallback must be a string or left empty.")

	return keys[key] or fallback
end

--- Get the value of an environment variable as a number.
-- @tparam string key the name of the variable.
-- @tparam ?number|nil fallback a number to return if the variable is not set.
-- @treturn ?number|nil the value of the variable if set, else the fallback is used, nil if no fallback is provided.
function env.getNumber(key, fallback)
	assert(fallback == nil or isnumber(fallback), "Fallback must be a number or left empty.")

	return tonumber(env.getString(key)) or fallback
end

--- Get the value of an environment variable as an integer.
-- @tparam string key the name of the variable.
-- @tparam ?number|nil fallback an integer to return if the variable is not set.
-- @treturn ?number|nil the value of the variable if set, else the fallback is used, nil if no fallback is provided.
function env.getInteger(key, fallback)
	local value = env.getNumber(key, fallback)
	if isnumber(value) then
		return math.floor(value)
	end
end

--- Get the value of an environment variable as a boolean.
-- @tparam string key the name of the variable.
-- @tparam ?boolean|nil fallback a boolean to return if the variable is not set.
-- @treturn ?boolean|nil the value of the variable if set, else the fallback is used, nil if no fallback is provided.
function env.getBoolean(key, fallback)
	assert(fallback == nil or isbool(fallback), "Fallback must be a boolean or left empty.")

	local value = env.getString(key)

	if isstring(value) then
		local lower = value:lower()

		if lower == "true" then
			return true
		elseif lower == "false" then
			return false
		end
	end

	return fallback
end

--- Get every variable name set in the environment.
-- @treturn {string,...} a sequential table of variable names.
function env.getKeys()
	return table.GetKeys(keys)
end

local function splitLineBySeparator(line)
	local separatorPos = line:find("=")
	if separatorPos then
		return line:sub(1, separatorPos - 1),
			line:sub(separatorPos + 1)
	end
end

local function stripComment(text)
	local commentStart = text:find("#")

	return commentStart
		and text:sub(1, commentStart - 1)
		or text
end

local function getTextBetweenPair(text, char)
	local length = text:len()
	if text:sub(1, 1) == char and text:sub(length, length) == char then
		return text:sub(2, length - 1)
	end
end

local STRING_LITERAL_DECLARATORS = {"\"", "'"}

local function extractValue(text)
	text = text:Trim()

	for _, declarator in ipairs(STRING_LITERAL_DECLARATORS) do
		local value = getTextBetweenPair(text, declarator)
		if value then
			return value
		end
	end

	return text
end

local function isEmpty(text)
	return text == nil
		or text == ""
		or text == " "
end

--- Parses the body of a dotenv file.
-- @tparam string the dotenv file body.
-- @treturn {[string]=string,...} the variable keys associated with their values.
function env.parse(body)
	assert(isstring(body), "Body must be a string.")

	local output = {}

	for _, line in ipairs(body:Split("\n")) do
		local pre, post = splitLineBySeparator(stripComment(line))

		if pre and post then
			local key = pre:Trim():upper()
			local value = extractValue(post)

			if not (isEmpty(key) or isEmpty(value)) then
				output[key] = value
			end
		end
	end

	return output
end

local BASE_PATH = "GAME"

--- Loads the dotenv file at the given location.
-- @tparam string the path to the dotenv file.
function env.load(filePath)
	assert(isstring(filePath), "File path must be a string.")

	if not file.Exists(filePath, BASE_PATH) then
		print("Attempted to load non-existent dotenv file at:", filePath)
		return
	end

	keys = env.parse(file.Read(filePath, BASE_PATH))
end

setmetatable(env, {
	__call = function(_, key, fallback)
		return env.getString(key, fallback)
	end
})
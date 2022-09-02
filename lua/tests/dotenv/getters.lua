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
	Name: getters.lua
	Project: gmod-dotenv
	Author: Tom
	Created: 2nd September 2022
--]]

local TEST_KEY = "HELLO_WORLD_TEST"
local TEST_FALLBACK_STRING = "hello world!"
local TEST_FALLBACK_NUMBER = 123

return {
	groupName = "Getters",
	beforeAll = function()
		require("dotenv")
	end,
	cases = {
		{ --getString
			name = "getString should error when no key is provided",
			func = function()
				expect(env.getString)
					.to.errWith("Key must be a string.")
			end
		},
		{
			name = "getString should error when the fallback is not a string",
			func = function()
				expect(env.getString, TEST_KEY, TEST_FALLBACK_NUMBER)
					.to.errWith("Fallback must be a string or left empty.")
			end
		},

		{ --getNumber
			name = "getNumber should error when no key is provided",
			func = function()
				expect(env.getNumber)
					.to.errWith("Key must be a string.")
			end
		},
		{
			name = "getNumber should error when the fallback is not a number",
			func = function()
				expect(env.getNumber, TEST_KEY, TEST_FALLBACK_STRING)
					.to.errWith("Fallback must be a number or left empty.")
			end
		},

		{ --getInteger
			name = "getInteger should error when no key is provided",
			func = function()
				expect(env.getInteger).to.errWith("Key must be a string.")
			end
		},
		{
			name = "getInteger should error when the fallback is not a number",
			func = function()
				expect(env.getInteger, TEST_KEY, TEST_FALLBACK_STRING)
					.to.errWith("Fallback must be a number or left empty.")
			end
		},

		{ --getBoolean
			name = "getBoolean should error when no key is provided",
			func = function()
				expect(env.getBoolean)
					.to.errWith("Key must be a string.")
			end
		},
		{
			name = "getBoolean should error when the fallback is not a boolean",
			func = function()
				expect(env.getBoolean, TEST_KEY, TEST_FALLBACK_STRING)
					.to.errWith("Fallback must be a boolean or left empty.")
			end
		},

		{--env
			name = "The env table should be callable",
			func = function()
				expect(env)
					.to.succeed()
			end
		},
	}
}
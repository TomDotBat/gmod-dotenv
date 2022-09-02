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
local TEST_FALLBACK_STRING = "Hello!"
local TEST_FALLBACK_NUMBER = 123

local TEST_BODY = [[TEST_STRING="Hello World!"
TEST_NUMBER=1.23
TEST_NEGATIVE_NUMBER=-1.23
TEST_INTEGER=1
TEST_NEGATIVE_INTEGER=-1
TEST_BOOLEAN=true
TEST_UPPER_BOOLEAN=false
TEST_MIXED_BOOLEAN=FaLsE]]

return {
	groupName = "Getters",
	beforeEach  = function() --TODO: use beforeAll once gLuaTest has updated
		require("dotenv")

		local fileExists = stub(file, "Exists")
			.returns(true)

		local readFile = stub(file, "Read")
			.returns(TEST_BODY)

		env.load(".env")

		fileExists:Restore()
		readFile:Restore()
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
		{
			name = "getString returns a string when the provided key is present",
			func = function()
				expect(env.getString("TEST_STRING"))
					.to.equal("Hello World!")
			end
		},
		{
			name = "getString returns nil when the provided key isn't present",
			func = function()
				expect(env.getString("NOT_PRESENT"))
					.to.beNil()
			end
		},
		{
			name = "getString returns the fallback when the provided key isn't present",
			func = function()
				expect(env.getString("NOT_PRESENT", "Goodbye World"))
					.to.equal("Goodbye World")
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
		{
			name = "getNumber returns a number when the provided key is present",
			func = function()
				expect(env.getNumber("TEST_NUMBER"))
					.to.equal(1.23)
			end
		},
		{
			name = "getNumber should support negative values",
			func = function()
				expect(env.getNumber("TEST_NEGATIVE_NUMBER"))
					.to.equal(-1.23)
			end
		},
		{
			name = "getNumber returns nil when the provided key isn't present",
			func = function()
				expect(env.getNumber("NOT_PRESENT"))
					.to.beNil()
			end
		},
		{
			name = "getNumber returns the fallback when the provided key isn't present",
			func = function()
				expect(env.getNumber("NOT_PRESENT", 100))
					.to.equal(100)
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
		{
			name = "getInteger returns an integer when the provided key is present",
			func = function()
				expect(env.getInteger("TEST_INTEGER"))
					.to.equal(1)
			end
		},
		{
			name = "getInteger should support negative values",
			func = function()
				expect(env.getInteger("TEST_NEGATIVE_INTEGER"))
					.to.equal(-1)
			end
		},
		{
			name = "getInteger returns nil when the provided key isn't present",
			func = function()
				expect(env.getInteger("NOT_PRESENT"))
					.to.beNil()
			end
		},
		{
			name = "getInteger returns the fallback when the provided key isn't present",
			func = function()
				expect(env.getInteger("NOT_PRESENT", 100))
					.to.equal(100)
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
		{
			name = "getBoolean returns a boolean when the provided key is present",
			func = function()
				expect(env.getBoolean("TEST_BOOLEAN"))
					.to.beTrue()
			end
		},
		{
			name = "getBoolean should support mixed casing",
			func = function()
				expect(env.getBoolean("TEST_UPPER_BOOLEAN"))
					.to.beFalse()

				expect(env.getBoolean("TEST_MIXED_BOOLEAN"))
					.to.beFalse()
			end
		},
		{
			name = "getBoolean returns nil when the provided key isn't present",
			func = function()
				expect(env.getBoolean("NOT_PRESENT"))
					.to.beNil()
			end
		},
		{
			name = "getBoolean returns the fallback when the provided key isn't present",
			func = function()
				expect(env.getBoolean("NOT_PRESENT", true))
					.to.beTrue()
			end
		},

		{--env
			name = "The env table should be callable",
			func = function()
				expect(env, TEST_KEY)
					.to.succeed()
			end
		},
		{
			name = "The env table returns a string when the provided key is present",
			func = function()
				expect(env("TEST_STRING"))
					.to.equal("Hello World!")
			end
		},
	}
}
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
	Name: parser.lua
	Project: gmod-dotenv
	Author: Tom
	Created: 2nd September 2022
--]]

local TEST_BODY = [[#No value on this line, just a comment, the next line doesn't have a value either!

TEST_SINGLE_QUOTES='Single Quotes!'
TEST_DOUBLE_QUOTES="Double Quotes!"
TEST_STRING=Hello World
TEST_STRING_2=Hello World #I hope this comment doesn't cause any problems!
TEST_STRING_3="Hello World #Not a comment!"
TEST_NUMBER=1.23
TEST_INTEGER=1
TEST_UPPER_BOOLEAN=TRUE
TEST_LOWER_BOOLEAN=FALSE
TEST_MIXED_BOOLEAN=FaLsE #This still works, because why not?
   TEST_VALUE  =    What happens if we space things weirdly for no reason?                               #HELLO
 TEST_VALUE_QUOTED  =    "What happens if we space things weirdly for no reason?"                               #HELLO
TEST_EMPTY= #This should be treated as nil
=-100
 =Broken
    =.19

#End of .env...]]

local EXPECTED_KEYS = {
	TEST_SINGLE_QUOTES = true,
	TEST_DOUBLE_QUOTES = true,
	TEST_STRING = true,
	TEST_STRING_2 = true,
	TEST_STRING_3 = true,
	TEST_NUMBER = true,
	TEST_INTEGER = true,
	TEST_UPPER_BOOLEAN = true,
	TEST_LOWER_BOOLEAN = true,
	TEST_MIXED_BOOLEAN = true,
	TEST_VALUE = true,
	TEST_VALUE_QUOTED = true,
}

local output

return {
	groupName = "Parser",
	beforeAll = function()
		require("dotenv")
	end,
	cases = {
		{
			name = "Parse should error when no body is provided",
			func = function()
				expect(env.parse)
					.to.errWith("Body must be a string.")
			end
		},
		{
			name = "Parse should return a table when a body is provided",
			func = function()
				local success = pcall(function()
					output = env.parse(TEST_BODY)
				end)

				expect(success)
					.to.beTrue()

				expect(output)
					.to.beA("table")
			end
		},
		{
			name = "Quotes should be stripped from values if a matching pair is found",
			func = function()
				expect(output["TEST_SINGLE_QUOTES"])
					.to.equal("Single Quotes!")

				expect(output["TEST_DOUBLE_QUOTES"])
					.to.equal("Double Quotes!")
			end
		},
		{
			name = "Empty values should be treated as nil values",
			func = function()
				expect(output["TEST_EMPTY"])
					.to.beNil()
			end
		},
		{
			name = "Whitespace should be trimmed from keys and values",
			func = function()
				expect(output["TEST_VALUE"])
					.to.equal("What happens if we space things weirdly for no reason?")

				expect(output["TEST_VALUE_QUOTED"])
					.to.equal("What happens if we space things weirdly for no reason?")
			end
		},
		{
			name = "Comments should stripped from values",
			func = function()
				expect(output["TEST_STRING_2"])
					.to.equal("Hello World")
			end
		},
		{
			name = "Comments cannot be made within quoted string values",
			func = function()
				expect(output["TEST_STRING_3"])
					.to.equal("Hello World #Not a comment!")
			end
		},
		{
			name = "Only expected keys should be present",
			func = function()
				expect(table.Count(output))
					.to.equal(table.Count(EXPECTED_KEYS))

				for key, _ in pairs(output) do
					expect(EXPECTED_KEYS[key])
						.to.beTrue()
				end
			end
		}
	}
}
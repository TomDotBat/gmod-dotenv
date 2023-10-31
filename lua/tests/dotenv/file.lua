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
	Name: file.lua
	Project: gmod-dotenv
	Author: Tom
	Created: 2nd September 2022
--]]

local TEST_FILE_PATH = ".env.test"
local TEST_FILE_BODY = "TEST_VALUE=Hello!"

return {
	groupName = "File Loader",
	beforeAll = function()
		require("dotenv")
	end,
	cases = {
		{
			name = "Load should error when no file path is provided",
			func = function()
				expect(env.load)
					.to.errWith("File path must be a string.")
			end
		},
		{
			name = "Load should check the provided file exists before reading it",
			func = function()
				local fileExists = stub(file, "Exists")
					.returns(false)

				env.load(TEST_FILE_PATH)

				expect(fileExists)
					.was.called()
			end
		},
		{
			name = "Load should read from the provided file if it exists",
			func = function()
				stub(file, "Exists")
					.returns(true)

				local readFile = stub(file, "Read")
					.returns(TEST_FILE_BODY)

				env.load(TEST_FILE_PATH)

				expect(readFile)
					.was.called()
			end
		},
		{
			name = "Load should parse the file once read",
			func = function()
				stub(file, "Exists")
					.returns(true)

				stub(file, "Read")
					.returns(TEST_FILE_BODY)

				local envParse = stub(env, "parse")
					.returns({})

				env.load(TEST_FILE_PATH)

				expect(envParse)
					.was.called()
			end
		}
	}
}
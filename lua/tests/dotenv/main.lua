return {
	groupName = ".env",
	cases = {
		{
			name = "Should create env global",
			func = function()
				require("dotenv")
				expect(env).to.exist()
			end
		}
	}
}
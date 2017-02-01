#! /usr/bin/env lua
-- Compare the current file contents to any open file
-- (including the saved version of the current file).
--
-- 0.2 - Changed to use io.popen to retrieve command output,
-- instead of piping to temporary file.
-- 0.3 - changed to show full path of current file,
-- to assist in comparing files with the same name.
-- (c) 2013 by Carl Antuar.
-- Distribution is permitted under the terms of the GPLv2
-- or any later version.

-- Define functions --
debugEnabled = false

function debugMessage(message)
	if debugEnabled then geany.message("DEBUG", message) end
end

function getDiffCommand(file1, file2)
	if os.execute("meld --version") == 0 then return "meld"
	elseif os.execute("kompare --version") == 0 then return "kompare"
	elseif os.execute("kdiff3 --version") == 0 then return "kdiff3"
	elseif os.execute("diffuse --version") == 0 then return "diffuse"
	elseif os.execute("tkdiff --version") == 0 then return "tkdiff"
	elseif os.execute("opendiff --version") == 0 then return "opendiff"
	else
		return "diff"
	end
end

---- Start execution ----

local file1 = geany.filename()

if geany.fileinfo().changed then
	if file1 == nil then
		file1 = "untitled"
	end
	file1 = os.tmpname().."_"..geany.basename(file1) --Generate a name that can be used for a temporary file. This only generates a name, it does not open a file.
	-- copy current contents to temporary file
	local file1Handle = io.open(file1, "w")

	file1Handle:write(geany.text())
	file1Handle:flush()


	io.close(file1Handle)
	--flieHandle:close()


end

local msg = "Which document do you want to compare "..geany.filename().." to?\n"
local file2Index = 1
local files = {}
for filename in geany.documents()
do
	files[file2Index] = filename
	file2Index = file2Index + 1
end
file2 = geany.choose(msg, files)
if not (file2 == nil) then
	local diffCommand = getDiffCommand()
	if diffCommand == "diff" then
		-- no external program found; use diff
		geany.newfile()
		local f = io.popen(diffCommand.." "..file1.." "..file2, 'r')
		if f == nil then
			geany.message("Failed to perform diff")
			return
		end
		local s = f:read('*a')
		debugMessage("Command output was: "..s)
		geany.selection(s)
	else
		local ok,msg = geany.launch(diffCommand, file1, file2)
		if not ok then geany.message(msg) end
	end
else
	geany.message("Cancelling")
end

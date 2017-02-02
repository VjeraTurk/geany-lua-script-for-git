function scandir(directory)

    local i, t, popen = 0, {}, io.popen
    local pfile = popen('ls "'..directory..'"')
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename
    end
    pfile:close()
    return t
end
--nema jebeni index 0 u lui -.-
function listvalues(s)
    local t = { }
    for k,v in ipairs(s) do
        t[#t+1] = tostring(v)
    end
    return table.concat(t,"\n")
end

function addFiles(path)

	local files = scandir(path)
	local yes_no = {"Add","Cancel"}
	local dialog= dialog.new ("banner", yes_no)
	dialog.label(dialog, "Pick files to add")
		
	for i,file in ipairs(files) do
			dialog:checkbox(files[i], false,files[i])	
		end

	local button, results = dialog:run()
	local cat={}
	local i = 1
	if results then

		for key,value in pairs(results)
			do
--			msg="\n"..key..":\t"..value
			if value == "1" then				
				cat[i]=key
				geany.message("Ovo je cat["..i.."] "..cat[i])
				i=i+1
				--geany.message(msg)
				--[[
				
				cmd ="cd "..path.."  2>&1\ngit add "..key.."  2>&1"
				geany.message(cmd)
				handle = io.popen(cmd)
				result = handle:read("*a")
				handle:close()
				geany.message(result)
				]]
			end
		
		end
		
		i=i-1
		for j=1,i do
		geany.message(cat[j])
		end
		geany.message(listvalues(cat))
	
	end	
	
end

	local FILE_DIR_PATH = geany.dirname(geany.filename())
	local files = scandir(FILE_DIR_PATH)
	local conc=listvalues(files)


	local yes_no = {"OK","Cancel"}
	local dialogUser= dialog.new ("				Push							", yes_no)
	local dialogPass= dialog.new ("				Push							", yes_no)
	--dialog.label(dialog, "Pick files to add")
	dialog.label(dialogUser, "				Push							")
	dialog.text(dialogUser, "Drugi argument", "", "Username" )
	dialog.label(dialogPass, "				Push							")
	dialog.password (dialog, "Drugi argument", "", "Password" )
	
	local name = dialog.run(dialogUser)
	local psw = dialog.run(dialogPass)
	
	cmd= ""..name--.."\n"..psw
	handle = io.popen(cmd)
	result = handle:read("*a")
	handle:close()
	geany.message(" "..cmd.." :\n"..result.."")

	--[[
	if message ~= nil then
		cmd="cd "..FILE_DIR_PATH.."  2>&1\n git commit -m \""..message.."\""
	else
		cmd="cd "..FILE_DIR_PATH.."  2>&1\n git commit -m \"no comment\""
	end

	handle = io.popen(cmd)
	result = handle:read("*a")
	handle:close()

	geany.message(" "..cmd.." :\n"..result.."")
	]]

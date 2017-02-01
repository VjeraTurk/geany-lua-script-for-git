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
	local FILE_DIR_PATH = geany.dirname(geany.filename())

	local files = scandir(FILE_DIR_PATH)
	local yes_no = {"Add","Cancel"}
	local dialog= dialog.new ("banner", yes_no)
	
	dialog.label(dialog, "Pick files to add")

		
			for i,file in ipairs(files) do
					dialog:checkbox(files[i], false,files[i])	
				end

	local button, results = dialog:run()
	local cmd

	if results then

		for key,value in pairs(results)
			do
			msg="\n"..key..":\t"..value
			
			if value == "1" then
				geany.message(msg)
				
				cmd ="cd "..FILE_DIR_PATH.."  2>&1\ngit add "..key.."  2>&1"
				geany.message(cmd)
				
				handle = io.popen(cmd)
				result = handle:read("*a")
				handle:close()
				geany.message(result)
				
			end
		
		end
	end	
	

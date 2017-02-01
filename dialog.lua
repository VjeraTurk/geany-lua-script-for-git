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

	local yes_no = {"Add","Cancel"}
	local dialog= dialog.new ("banner", yes_no)

	dialog.label(dialog, "Pick files to add")
	local choosen = {}
	local files = scandir(FILE_DIR_PATH)
		
			for i,file in ipairs(files) do
			--		dialog.checkbox ( dialog,"files", false, files[i])
					dialog:checkbox(files[i], false,files[i])	
				end
			

	dialog.hr(dialog)

local button, results = dialog:run()

if results then
	
	for key,value in pairs(results)
		do
		msg="\n"..key..":\t"..value
		geany.message(msg)
	
	end
end	
	

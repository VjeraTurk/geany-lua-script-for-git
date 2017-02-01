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
	local i = -1
	if results then

		for key,value in pairs(results)
			do
--			msg="\n"..key..":\t"..value
			if value == "1" then				
				i=i+1
				cat[i]=key
				geany.message("Ovo je cat["..i.."] "..cat[i])
				
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
		
		for j=0,i do
		geany.message(cat[j])
		end
		geany.message(listvalues(cat))
	
	end	
	
end

	local FILE_DIR_PATH = geany.dirname(geany.filename())
	local files = scandir(FILE_DIR_PATH)
	local conc=listvalues(files)
	geany.message(conc)
	addFiles(FILE_DIR_PATH)

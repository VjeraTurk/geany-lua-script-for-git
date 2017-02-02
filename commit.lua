--[[
	Opis

	--Velicinu prozora mijenjam s tabovima unutar imena
	--ne radi provjera koko --version, nastavlja s komitom
	--	geany.banner = "Commit your changes"
		message=geany.input("Commit message", "no comment")
		--git clone
		
		prozor ima Ok i Cancel (i x) ali izvrši commit bez obzira, nema provjere sta je odabrano -> napraviti dialog ili geany confirm
	-- dva dialoga za redom ne rade! Greška na new u drugom
	]]

	local FILE_PATH = geany.filename() --!! geany.filename() cijeli path, ne samo ime
    local FILE_DIR_PATH = geany.dirname(geany.filename())
	local FILE_NAME = geany.basename(geany.filename())

-- Lua implementation of PHP scandir function
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


--spoji vrijednosti u tablici u  dugacak string
function listvalues(s)
    local t = { }
    for k,v in ipairs(s) do
        t[#t+1] = tostring(v)
    end
    return table.concat(t,'\t')
end
--ispisuje checkboxove svih fileova u folderu čiji path primi, radi git add na odabranima 
function addFiles(path)

	local files = scandir(path)
	local yes_no = {"Add","Cancel"}
	local dialog= dialog.new ("Add files", yes_no)
	dialog.label(dialog, "Pick files to add")
		
	for i,file in ipairs(files) do
			dialog:checkbox(files[i], false,files[i])	
		end

	local button, results = dialog:run()
	local checked={}
	local i = 1
--izmjena
	if results then

		for key,value in pairs(results)
			do
		--	msg="\n"..key..":\t"..value
			if value == "1" then
				checked[i]=key
				i=i+1
				--geany.message(msg)
				
				cmd ="cd "..path.."  2>&1\ngit add "..key.."  2>&1"
				
				handle = io.popen(cmd)
				result = handle:read("*a")
				handle:close()
				geany.message(" "..cmd.." :\n"..result.."")
				
			end
		
		end
	--[[		
		i=i-1
		for j=1,i do
		geany.message(checked[j])
		end
	]]
		return checked
	end	
	
end

function isInstaled(program)

	local cmd = ""..program.." --version 2>&1"	--!! pokazuje ili output ili error
	handle = io.popen(cmd)
	result = handle:read("*a")
	--handle:close()
	
	geany.message(" "..cmd.." :\n"..result)

		if string.match(result,"not found") then
			install_msg="Before you start using "..program..", you have to make it available on your computer. You can either install it as a package or via another installer, or download the source code and compile it yourself. \nDebian/Ubuntu:\n$ apt-get install "..program.." \nFedora:\n $ yum install "..program..""
			geany.message(install_msg)
			return nil
		
		else return 1
		
		end
		
end

function runCommand(cmd)
	
	handle = io.popen(cmd)
	result = handle:read("*a")
	handle:close()
	
	return result
end
	--geany.message(""..FILE_PATH.."\n"..FILE_DIR_PATH.."\n"..FILE_NAME.."")

function logIn()
	--maknuti gumbe, oni us bzvez (samo ok?)
	local yes_no = {"OK","Cancel"}
	local dialogUser = dialog.new ("		Log In				", yes_no)
	local dialogEmail = dialog.new("		Log In				", yes_no)
	dialog.text(dialogUser, "username", "", "Username" )
	dialog.text(dialogEmail, "email", "", "Email   " )

	local btU, resU = dialog.run(dialogUser)

		for key,value in pairs(resU)
			do
			msg = "\n"..key..":\t"..value
			--geany.message(msg)			
			name=value
		end
	

	local btnE, resE = dialog.run(dialogEmail)
	
	if resE then
		for key,value in pairs(resE)
			do
			msg = "\n"..key..":\t"..value
			--geany.message(msg)			
			email=value
		end
	end

	cmd="cd "..FILE_DIR_PATH.."\ngit config user.name "..name.."\ngit config user.email "..email
	
	result=runCommand(cmd)
	--geany.message(" "..cmd.." :\n"..result.."")
	

end

function pushToOrigin()
	
	local yes_no = {"OK","Cancel"}
	local dialogUser= dialog.new ("		Username		", yes_no)
	local dialogPass= dialog.new ("		Password		", yes_no)
	dialog.text(dialogUser, "username", "", "Username" )
	dialog.password (dialogPass, "password", "", "Password" )
	
	local btU, resU = dialog.run(dialogUser)
	local btnP, resP = dialog.run(dialogPass)
	
	if resU then
		for key,value in pairs(resU)
			do
			msg = "\n"..key..":\t"..value
			geany.message(msg)			
			name=value
		end
	end
	
	if resP then
		for key,value in pairs(resP)
			do
			msg="\n"..key..":\t"..value
			geany.message(msg)			
			psw=value
		end
	end

--	cmd = "git config --get remote.origin.url"--makni 8 slova i dodaj @
--	result = runCommand(cmd)

	cmd="cd "..FILE_DIR_PATH.."\n git push -u --repo https://"..name..":"..psw.."@github.com/VjeraTurk/test 2>&1"
	result = runCommand(cmd)
	geany.message(" "..cmd.." :\n"..result.."")


end
cmds={
	--["force_local_users"]="git config --global user.useConfigOnly true",
	["add_remote_origin"]="git add remote origin ",
--  ["clone"]="git clone", --gitlab Public The project can be cloned without any authentication.
	["commit"]="git commit -m ",
--  ["config_name"]="git config user.name ",--"Your Name Here"
	["config_email"]="git config user.email ",--"your@email.com"
--	["install"]="apt-get install git"
	}
--izmjena
	geany.banner = "Geany Git assistant"
	
	instaled=isInstaled("git")
	if instaled == nil then return end

	cmd = "cd "..FILE_DIR_PATH.."  2>&1\ngit add "..FILE_PATH.."  2>&1"
	--!! 2>&1 pokazuje ili output ili error
	--!! ako ulancavamo 2 komande, između stavljamo \n
	
	handle = io.popen(cmd)
	result = handle:read("*a")
	handle:close()
	geany.message(""..cmd.." :\n"..result.."")
	
	
	if result=="fatal: Not a git repository (or any of the parent directories): .git\n" then --!! obavezno \n, u suprotnom ne radi
		geany.banner = "Not a git repository"
		
		local choice = geany.confirm ( "Your file could not be commited", "This directory is not a git repository (or any of the parent directories. Init new repository?", true )

		if choice == true then
			--git init
			geany.banner = "Init new repository"
			cmd = "git init "..FILE_DIR_PATH.."  2>&1"	--!! pokazuje ili output ili error
			handle = io.popen(cmd)
			result = handle:read("*a")
			handle:close()
			geany.message(result)
			
			--git config user.name git config user.email
			logIn()
			--git add
			cmd = "cd "..FILE_DIR_PATH.."  2>&1\ngit add "..FILE_PATH.."  2>&1"

			handle = io.popen(cmd)
			result = handle:read("*a")
			handle:close()


			result=''

			geany.banner = "Add remote origin"
			choice = geany.confirm ( "Add remote origin", "This directory is only local. Link to web repository? (add origin)", true )
				
				if choice == true then
					origin = geany.input("Please use public repository.", "https://")
					cmd="cd "..FILE_DIR_PATH.."  2>&1\ngit remote add origin "..origin.." "
					handle = io.popen(cmd)
					result = handle:read("*a")
					handle:close()

					if result=='' then
						--geany.message(" "..cmd.." :\n"..result.."")
						geany.message("Hurray!", "Repositories are now linked. Each time you push your code it will be saved on your remote origin. ")
						os.execute(string.format('xdg-open "%s"', origin))
						--handle:close()
					end
				end
		end

	end

if result==''  then
	
	geany.banner = "Commit your changes"
	message = geany.input("Commit message", "no comment")
	
		
		if message ~= nil then
			cmd="cd "..FILE_DIR_PATH.."  2>&1\n git commit -m \""..message.."\""
		else
			cmd="cd "..FILE_DIR_PATH.."  2>&1\n git commit -m \"no comment\""
		end

		handle = io.popen(cmd)
		result = handle:read("*a")
		handle:close()

		geany.message(" "..cmd.." :\n"..result.."")
		
	--Changes not staged for commit or untracked files present
	
	--if string.match(result,"nothing added to commit but untracked files present") then
	
	if string.match(result,"Changes not staged for commit") or string.match(result,"untracked files present") then
	--izmjena
	--izmjena
	geany.banner = "Untracked files present or changes not staged for commit"
	choice = geany.confirm("		Add untracked or modified files to repository		"  ,"	Add untracked files to your repository?",true)

		if choice == true then
			
			local list = listvalues( addFiles(FILE_DIR_PATH) )
			
				if(list ~='') then
					geany.banner = "Commit your changes"
					message=geany.input("Commit message", "Added files: "..list)

					if message ~= nil then
						cmd="cd "..FILE_DIR_PATH.."  2>&1\n git commit -m \""..message.."\""
					else
						cmd="cd "..FILE_DIR_PATH.."  2>&1\n git commit -m \"no comment\""
					end

					handle = io.popen(cmd)
					result = handle:read("*a")
					handle:close()

					geany.message(" "..cmd.." :\n"..result.."")
				end
		end

	end
	
	pushToOrigin()
end

--prije git comande, cd komanda u direktorij filea
--!! local cmd="echo "..geany.filename().." > SomeFile2.txt" : ne radi, mora biti cijeli filepath od SomeFile2.txt
--local test_cmd="echo Neki tekst u novi file >/usr/share/geany-plugins/geanylua/edit/someFile2.txt"
--local test_cmd="echo "..geany.filename().." >/usr/share/geany-plugins/geanylua/edit/someFile2.txt"
--!! local cmd="Neki tekst >/usr/share/geany-plugins/geanylua/edit/someFile2.txt": samo stvori novi file, ignorira prvi dio

--[[
function os.capture(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end

function execute(command)
	 -- returns success, error code, output.
	 local f = io.popen(command..' 2>&1 && echo " $?"')
	 local output = f:read"*a"
	 local begin, finish, code = output:find" (%d+)\n$"
	 output, code = output:sub(1, begin -1), tonumber(code)
	 return code == 0 and true or false, code, output
  end


function dirLookup(dir)
   local p = io.popen('find "'..dir..'" -type f')  --Open directory look for files, save data in p. By giving '-type f' as parameter, it returns all files.
   for file in p:lines() do                         --Loop through all files
       i = i + 1
       t[i] = filename
   end
   return t
end


function getBrowserCommand()

	if os.execute("firefox --version") == 0 then return "firefox"
	elseif os.execute("google-chrome --version") == 0 then return "google-chrome"
	else
		return "diff"
	end
end


]]
--neka izmjena
	-- Require setting user.name and email per-repo:
	--$ git config --global user.useConfigOnly true
	-- Remove email address from global config:

	--$ git config --global --unset-all user.email
	--$ git config --global --unset-all user.name

--komentar
--komentar novi

local yes_no = {"OK","Cancel"}
local dialogUser= dialog.new ("Unesi Username", yes_no)
local dialogPass= dialog.new ("Unesi Password", yes_no)
--dialog.label(dialog, "Pick files to add")
	dialog.text(dialogUser, "Drugi argument", "xxxxxx", "Ime" )
	dialog.password (dialogPass, "Drugi argument", "xxxxxx", "Lozinka" )
	local name = dialog.run(dialogUser)
	local psw = dialog.run(dialogPass)
	
	cmd= ""..name--.."\n"..psw
	handle = io.popen(cmd)
	result = handle:read("*a")
	handle:close()
	geany.message(" "..cmd.." :\n"..result.."")

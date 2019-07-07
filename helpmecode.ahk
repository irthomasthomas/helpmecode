#Include Socket.ahk

;SET IP ADDRESS OF PYTHON SERVER HERE...
addr := "" ; ENTER YOUR IP FROM THE PYTHON SCREEN
if addr = ""
	addr = %A_IPAddress1%
myTcp := new SocketTCP()
try
{
    myTcp.Connect([addr, 8337])
}
catch e 
{
	MsgBox, 64, Error, Either the python server is inaccessible or you did not edit this script to include it's lan IP
    Exit
}

msgbox , , ,helpmecode AugmentedIntelligence, Connected. `r`n Type helpme and your query in your editor. `r`n Reload app with Ctrl+Alt+R `r`n to quit app Ctrl+Alt+Q 

:*B0:helpme:: ; typing helpme triggers the function to read your input...
	WinGetTitle, title, A
	if title not contains Visual Studio Code, Notepad++, SciTE4AutoHotkey, Sublime, Atom
		return 
	Input, query, V, {Enter}{Esc}{Tab}	;... and {enter} submits the query
	SendInput, {Enter} {Up}
	SendRaw % howdoiquery(query,myTcp)	
return

howdoiquery(query, myTcp)
{
	WinGetTitle, title, A
	{ ;...looks for common code extensions in window title to restrict search
		if title contains .ahk, .AHK
			query .= " autohotkey"
		Else if title contains .py, .PY
			query .= " python"
		Else if title contains .sql, .SQL
			query .= " sql"
		Else if title contains .groovy
			query .= " groovy"
		Else if title contains .go, .GO
			query .= " go"
		Else if title contains .cs, .CS
			query .= " c#"
		Else if title contains .sh, .SH		
			query .= " bash"
		Else if title contains .js, .JS
			query .= " javascript"
		Else if title contains .jsx
			query .= " javascript react"
	}
	command := "howdoi"
	command .= ";" . query
	myTcp.SendText(command)
	SetKeyDelay, 80
	Send, let me see ... {Enter}
	SetKeyDelay, 5
	return myTcp.recvText(2048)
}

^!r::Reload
^!q::ExitApp

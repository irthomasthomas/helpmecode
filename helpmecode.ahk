#Include Socket.ahk
SetKeyDelay, 0, 10, InputThenPlay  

;SET IP ADDRESS OF PYTHON SERVER HERE...
addr := "192.168.0.2" ; ENTER YOUR IP FROM THE PYTHON SCREEN
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

msgbox , , ,helpmecode AI, Connected. `r`n type howdoi in your editor. `r`n Reload app with Ctrl+Alt+R `r`n to quit app Ctrl+Alt+Q 

:*B0:helpme:: ; typing helpme triggers the function to read...
	WinGetTitle, title, A
	if title !contains "Visual Studio Code", "Notepad++"
		return
	
	Input, query, V, {Enter}	;... and {enter} submits the query
	BlockInput, On
	backspaces := strlen(query) + 7
	SendInput, {Backspace %backspaces%}

	answer := howdoiquery(query,myTcp)
	
	answerlen := strlen(answer)
	string1 := SubStr(answer,1,(answerlen/2)) ;splitting the answer in half...
	string2 := SubStr(answer,(answerlen/2),answerlen) ;...  to overcome SendRaw limitation. 
	SetKeyDelay, 0, 10, InputThenPlay  
	SendRaw, %string1%
	SendRaw, %string2%
	BlockInput, Off
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
			query .= "groovy"
		Else if title contains .go, .GO
			query .= "go"
		Else if title contains .cs, .CS
			query .= "c sharp"
		Else if title contains .sh, .SH		
			query .= "bash"
		Else if title contains .js, .JS
			query .= "javascript"
		Else if title contains .jsx
			query .= "javascript react"
	}
	
	command := "howdoi"
	command .= ";" . query
	myTcp.SendText(command)
	SetKeyDelay, 100, 0, InputThenPlay
	Send, let me see ...
	Loop 4
		send ^{backspace}
	response := myTcp.recvText(2048)
	
	return %response%
}

^!r::Reload
^!q::ExitApp
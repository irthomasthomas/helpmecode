#Include Socket.ahk
SetKeyDelay, 0, 10, InputThenPlay  

myTcp := new SocketTCP()
addr := "192.168.0.2"
myTcp.Connect([addr, 8337])

:*B0:helpme:: ; typing helpme triggers the function

	Input, query, V, {Enter}	
	backspaces := strlen(query) + 7
	SendInput, {Backspace %backspaces%}
	answer := howdoiquery(query,myTcp)
	answerlen := strlen(answer)
	string1 := SubStr(answer,1,(answerlen/2)) ;splitting the answer in two. 
	string2 := SubStr(answer,(answerlen/2),answerlen)
	SetKeyDelay, 0, 10, InputThenPlay  
	SendRaw, %string1%
	SendRaw, %string2%

return

howdoiquery(query, myTcp)
{
	WinGetTitle, title, A
	if title contains .ahk
		query .= " autohotkey"
	Else if title contains .py
		query .= " python"
	Else if title contains .sql
		query .= " sql"
	command := "howdoi"
	command .= ";" . query
	myTcp.SendText(command)
	;SetKeyDelay, 100, 0, InputThenPlay
	;Send, let me see ...
	;Loop 4
	;	send ^{backspace}
	response := myTcp.recvText(2048)
	
	return %response%
}

^!r::Reload


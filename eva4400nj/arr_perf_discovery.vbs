
' ====== CONFIGURATION ====== 
zabSend = "C:\Program Files\zabbix_agent\bin\win32\zabbix_sender.exe"
zabServer = "zabbix_server_IP"
zabPort = "10051"
sssuPath = "C:\Program Files\Hewlett-Packard\Sanworks\Element Manager for StorageWorks HSV\sssu.exe"
evaPerf = "C:\Program Files\Hewlett-Packard\EVA Performance Monitor\evaperf.exe"
manager = "localhost"
username = "username"
password = "SSSU_Password"
storages = "EVA4400_nj"
'============================


Set xmlDoc = CreateObject("Msxml2.DOMDocument") 
Set objShell=CreateObject("Wscript.Shell")
Const WshRunning = 0

selectSys = """select system " & storages & """ "
	
discovery_arr_perf = "{""data"":["
Set objExecObject = objShell.Exec("""" & evaPerf & """ as -nh -csv -nots -sz " & storages)
WScript.Sleep 1000
Do Until objExecObject.StdOut.AtEndOfStream
	csv = objExecObject.StdOut.ReadLine() 
	if csv<>"" then 
		str = split(csv,",")
		discovery_arr_perf = discovery_arr_perf & "{""{#ARRAYNAME}"": """ & str(2) & """}"	
	end if 		
Loop
discovery_arr_perf = discovery_arr_perf & "]}"

wscript.echo discovery_arr_perf

Function getXML(cmd, parse)
	varCmd = """"&sssuPath& """ ""select manager " & manager & " username=" & username & " password=" & password & """ " & cmd	
	Set objExec=objShell.Exec(varCmd)
	res = objExec.StdOut.ReadAll
	res = Mid(res,InStr(res,parse))
	res = Replace(res, Chr("&H01"),"")
	res = "<?xml version='1.0'?><root>" & res & "</root>"
	getXML = res 
End Function 

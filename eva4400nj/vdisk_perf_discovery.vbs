
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
	
discovery_vdisk_perf = "{""data"":["
Set objExecObject2 = objShell.Exec("""" & evaPerf & """ vd -nh -csv -nots -sz " & storages)
WScript.Sleep 2000
Do Until objExecObject2.StdOut.AtEndOfStream
	csv = objExecObject2.StdOut.ReadLine() 
	if csv<>"" then
		str = split(csv,",")
		k = InStrRev(str(22),"\")
		if k<>0 then
			vdisk = Mid(str(22), k+1)
		else 
			vdisk = str(22)
		end if
			
		discovery_vdisk_perf = discovery_vdisk_perf & "{""{#VDISK}"": """ & vdisk & """},"		
	end if
Loop
discovery_vdisk_perf = Left(discovery_vdisk_perf, (Len(discovery_vdisk_perf)-1))
discovery_vdisk_perf = discovery_vdisk_perf & "]}"

wscript.echo discovery_vdisk_perf


Function getXML(cmd, parse)
	varCmd = """"&sssuPath& """ ""select manager " & manager & " username=" & username & " password=" & password & """ " & cmd	
	Set objExec=objShell.Exec(varCmd)
	res = objExec.StdOut.ReadAll
	res = Mid(res,InStr(res,parse))
	res = Replace(res, Chr("&H01"),"")
	res = "<?xml version='1.0'?><root>" & res & "</root>"
	getXML = res 
End Function 

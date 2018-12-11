
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
	
discovery_vdisk = "{""data"":["
str = xmlDoc.loadXML(getXML(selectSys & """ls vdisk FULL XML""", "<object>"))
Set cNodeList = xmlDoc.selectNodes("//root/object/objectid")
For Each cNode in cNodeList
	discovery_vdisk = discovery_vdisk & "{""{#VDISKID}"": """ & cNode.text & ""","
	set cNode2   = xmlDoc.SelectSingleNode("//root/object[objectid=""" & cNode.text & """]/familyname")
	discovery_vdisk = discovery_vdisk & """{#VDISKNAME}"": """ & cNode2.text & """},"
Next
discovery_vdisk = Left(discovery_vdisk, (Len(discovery_vdisk)-1))
discovery_vdisk = discovery_vdisk & "]}"
	
wscript.echo discovery_vdisk


Function getXML(cmd, parse)
	varCmd = """"&sssuPath& """ ""select manager " & manager & " username=" & username & " password=" & password & """ " & cmd	
	Set objExec=objShell.Exec(varCmd)
	res = objExec.StdOut.ReadAll
	res = Mid(res,InStr(res,parse))
	res = Replace(res, Chr("&H01"),"")
	res = "<?xml version='1.0'?><root>" & res & "</root>"
	getXML = res 
End Function 

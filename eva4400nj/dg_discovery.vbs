
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
	
discovery_dg = "{""data"":["
str = xmlDoc.loadXML(getXML(selectSys & """ls disk_group FULL XML""", "<object>"))
Set cNodeList = xmlDoc.selectNodes("//root/object/objectid")
For Each cNode in cNodeList			
	discovery_dg = discovery_dg & "{""{#DISKGROUPID}"": """ & cNode.text & ""","
	set cNode2   = xmlDoc.SelectSingleNode("//root/object[objectid=""" & cNode.text & """]/diskgroupname")
	discovery_dg = discovery_dg & """{#DISKGROUPNAME}"": """ & cNode2.text & """},"
Next
discovery_dg = Left(discovery_dg, (Len(discovery_dg)-1))
discovery_dg = discovery_dg & "]}"
	
wscript.echo discovery_dg


Function getXML(cmd, parse)
	varCmd = """"&sssuPath& """ ""select manager " & manager & " username=" & username & " password=" & password & """ " & cmd	
	Set objExec=objShell.Exec(varCmd)
	res = objExec.StdOut.ReadAll
	res = Mid(res,InStr(res,parse))
	res = Replace(res, Chr("&H01"),"")
	res = "<?xml version='1.0'?><root>" & res & "</root>"
	getXML = res 
End Function 

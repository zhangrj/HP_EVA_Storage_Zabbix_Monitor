
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
	
discovery_ctrl = "{""data"":["
str = xmlDoc.loadXML(getXML(selectSys & """ls controller FULL XML""", "<object>"))
Set cNodeList = xmlDoc.selectNodes("//root/object/objectid")
For Each cNode in cNodeList
	discovery_ctrl = discovery_ctrl & "{""{#CTRLID}"": """ & cNode.text & ""","
	Set cNode2 = xmlDoc.SelectSingleNode("//root/object[objectid=""" & cNode.text & """]/controllername")
	discovery_ctrl = discovery_ctrl & """{#CTRLNAME}"": """ & cNode2.text & """},"
Next
discovery_ctrl = Left(discovery_ctrl, (Len(discovery_ctrl)-1))
discovery_ctrl = discovery_ctrl & "]}"

wscript.echo discovery_ctrl


Function getXML(cmd, parse)
	varCmd = """"&sssuPath& """ ""select manager " & manager & " username=" & username & " password=" & password & """ " & cmd	
	Set objExec=objShell.Exec(varCmd)
	res = objExec.StdOut.ReadAll
	res = Mid(res,InStr(res,parse))
	res = Replace(res, Chr("&H01"),"")
	res = "<?xml version='1.0'?><root>" & res & "</root>"
	getXML = res 
End Function 

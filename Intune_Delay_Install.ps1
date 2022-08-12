<# 
This software (or sample code) is not supported under any Microsoft standard support program or service.
The software is provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties
including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. 
The entire risk arising out of the use or performance of the software and documentation remains with you. In no 
event shall Microsoft, its authors, or anyone else involved in the creation, production, or delivery of the 
software be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, 
business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability 
to use the software or documentation, even if Microsoft has been advised of the possibility of such damages.

**********This code will delay app install after Autopilot enrollment + $appinstalldelay time span **************
#>


Function GetRegDate ($path, $key){
    function GVl ($ar){
        return [uint32]('0x'+(($ar|ForEach-Object ToString X2) -join ''))
    }
    $ar=Get-ItemPropertyValue $path $key
    [array]::reverse($ar)
    $time = New-Object DateTime (GVl $ar[14..15]),(GVl $ar[12..13]),(GVl $ar[8..9]),(GVl $ar[6..7]),(GVl $ar[4..5]),(GVl $ar[2..3]),(GVl $ar[0..1])
    return $time
}
$AppInstallDelay = New-TimeSpan -Days 0 -Hours 0 -Minutes 30
$RegKey = (@(Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Enrollments" -recurse | Where-Object {$_.PSChildName -like 'DeviceEnroller'}))
$RegPath = $($RegKey.name).TrimStart("HKEY_LOCAL_MACHINE")
$RegDate = GetRegDate HKLM:\$RegPath "FirstScheduleTimestamp"
$DeviceEnrolmentDate = Get-Date $RegDate
If ((Get-Date) -ge ($DeviceEnrolmentDate + $AppInstallDelay)) {
    $InstallApp = 0
}
Else {
    $InstallApp = -1
}
$InstallApp
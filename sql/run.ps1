[CmdletBinding()]
Param([switch]$RemoveWhenFinished, [string]$Password="P@ssw0rd", [string]$DBPath=$null)

$args = @();
$args += "run"
$args += "-d"
$args += "-p 1433:1433"
$args += "-e sa_password=$Password"
$args += "-e ACCEPT_EULA=Y"

if ($RemoveWhenFinished.IsPresent) {
    $args+="--rm"
}


$dbs=@();

if (Test-Path -Path $DBPath) {
    Get-ChildItem $DBPath -Filter "*.mdf" | % {
        $_db = New-DB

        $_db.dbName = $_.BaseName
        $_db.dbFiles += Get-ChildItem $DBPath -Filter "$($_.BaseName)*.*df" | Select -ExpandProperty Name
            
        $dbs += $_db
    }
    $args += "-v $($DBPath.Replace("\","/")):C:/Databases"
}


$args += "-e attach_dbs=`'$($dbs | ConvertTo-Json -Compress)'"
$args += "microsoft/mssql-server-windows"

"$args"
Start-Process "docker" -ArgumentList "$args" -NoNewWindow -Wait

Function New-DB {
   $db = New-Object -TypeName PSObject
   $db | Add-Member -Type NoteProperty -Name dbName -Value ""
   $db | Add-Member -Type NoteProperty -Name dbFiles -Value @()
    
    return $db
}
[CmdletBinding()]
Param([switch]$RemoveWhenFinished, [int]$Port=80, [string]$Path, [string]$Name)

$args=@();

$args += "run"
if ($RemoveWhenFinished.IsPresent) {
    $args+="--rm"
}
if ($Name) {
    $args += "--name $Name"
}

$args += "-p ${port}:$port"
$args += "-e `"PORT=$port`""
$args += "-v $($Path.Replace("\","/")):C:/Site "
$args += "cdonke/iis:nanoserver"

Start-Process "docker" -ArgumentList "$args" -NoNewWindow -Wait
<#
.SYNOPSIS
    Monitor the route (from the PRTG Probe server) to a specified target

.DESCRIPTION
    Simple PRTG sensor to compare the route from the probe server to a specified target with a given expected route.
    Useful to detect changes in a dynamicly routed network.

.PARAMETER target
    IP/Hostname of the target device

.PARAMETER index_start
    The route is stored in a array, where each hop is represented by an element. if you only want to monitor a part of
    the route, set your index_start to skip a number of hops. Reminder: Arrays start at 0.

.PARAMETER index_end
    The route is stored in a array, where each hop is represented by an element. if you only want to monitor a part of
    the route, set your index_end to ignore any hops after that. Reminder: Arrays start at 0.

.PARAMETER max_hops
    Terminate the traceroute after this amount of hops.

.PARAMETER expected
    Array of your expected route. If this differs from the actual route, the sensor will throw an error.

.EXAMPLE
    .\Compare-Route.ps1 -target "172.16.1.254" -index_start 0 -index_end 4 -max_hops 10 -expected "192.168.1.254","10.1.1.1","172.16.254.1","172.16.1.254"

.NOTES
    Author: Felix Schwärzler
    Date: 29.07.2024
    Version: 1.0
    GitHub: https://github.com/stayfesch/Compare-Route

.LINK
    https://github.com/stayfesch/Compare-Route
#>

param (
  [Parameter(Mandatory=$true)]
  [string]$target,
  [int]$index_start = 0,
  [int]$index_end = 10,
  [int]$max_hops = 10,
  [Parameter(Mandatory=$true)]
  [string[]]$expected = @()
)

function Compare-Route($target, $index_start, $index_end, $max_hops, $expected) {
  $traceroute = (Test-NetConnection -ComputerName $target -TraceRoute -Hop $max_hops -WarningAction SilentlyContinue)
  if ($traceroute.PingSucceeded -ne "True") {
    Exit-Error 2 "Target could not be reached." 2
  }

  $hops = $traceroute.TraceRoute
  $result = @()

  $end = $max_hops
  if ($hops.count -lt $max_hops) {
    $end = $hops.count
  }

  if ($index_start -gt $end) {
    Exit-Error 2 "Index bounds are wrong!" 2
  }

  for ($i = $index_start; $i -lt $end; $i++) {
    $result += $hops[$i]
  }

  if ((Compare-Object -ReferenceObject $result -DifferenceObject $expected) -ne $null) {
    Exit-Error 4 "$($result)" 4
  }

  Exit-Success $result
}

function Exit-Success($result) {
  $resultString = ""
  $result | ForEach-Object {
    $resultString += "$($_) "
  }

  $resultString = $resultString -replace ".{1}$"

  Write-Host "0:$($resultString)"
}

function Exit-Error($value, $message, $exitcode) {
  Write-Host "${value}:${message}"
    exit $exitcode
}

Compare-Route $target $index_start $index_end $max_hops $expected

# PRTG Sensor for Route Monitoring

## Usage
```
NAME
    Compare-Route.ps1

SYNOPSIS
    Monitor the route (from the PRTG Probe server) to a specified target


SYNTAX
    Compare-Route.ps1 [[-target] <String>] [[-index_start] <Int32>] [[-index_end] <Int32>] [[-max_hops] <Int32>] [[-expected] <String[]>] [<CommonParameters>]


DESCRIPTION
    Simple PRTG sensor to compare the route from the probe server to a specified target with a given expected route.
    Useful to detect changes in a dynamicly routed network.


PARAMETERS
    -target <String>
        IP/Hostname of the target device

        Required?                    true
        Position?                    1
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -index_start <Int32>
        The route is stored in a array, where each hop is represented by an element. if you only want to monitor a part of
        the route, set your index_start to skip a number of hops. Reminder: Arrays start at 0.

        Required?                    false
        Position?                    2
        Default value                0
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -index_end <Int32>
        The route is stored in a array, where each hop is represented by an element. if you only want to monitor a part of
        the route, set your index_end to ignore any hops after that. Reminder: Arrays start at 0.

        Required?                    false
        Position?                    3
        Default value                10
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -max_hops <Int32>
        Terminate the traceroute after this amount of hops.

        Required?                    false
        Position?                    4
        Default value                10
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -expected <String[]>
        Array of your expected route. If this differs from the actual route, the sensor will throw an error.

        Required?                    true
        Position?                    5
        Default value                @()
        Accept pipeline input?       false
        Accept wildcard characters?  false

    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216).


NOTES

        Author: Felix Schwärzler
        Date: 29.07.2024
        Version: 1.0
        GitHub: https://github.com/stayfesch/Compare-Route

    -------------------------- EXAMPLE 1 --------------------------

    PS > .\Compare-Route.ps1 -target "172.16.1.254" -index_start 0 -index_end 4 -max_hops 10 -expected "192.168.1.254","10.1.1.1","172.16.254.1","172.16.1.254"
```
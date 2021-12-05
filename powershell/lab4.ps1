function hardwareInformation {
    Write-Output "========== HARDWARE DESCRIPTION =========="
    Get-WmiObject win32_computersystem | Format-List Domain, Manufacturer, Model, Name, TotalPhysicalMemory
}
function OSInformation {
    Write-Output "========== OPERATING SYSTEM INFORMATION =========="
    Get-WmiObject win32_operatingsystem | Select-Object Caption, Version, OSArchitecture | Format-List
}
function processorInformation {
    Write-Output "========== PROCESSOR INFORMATION =========="
    Get-WmiObject win32_processor | 
    Select-Object Name, NumberOfCores, CurrentClockSpeed, MaxClockSpeed,
    @{  n = "L1CacheSize"; 
        e = { switch ($_.L1CacheSize) {
                $null { $output = "Info Not Found" }
                Default { $output = $_.L1CacheSize }
            };
            $output }
    },
    @{  n = "L2CacheSize"; 
        e = { switch ($_.L2CacheSize) {
                $null { $output = "Info Not Found" }
                Default { $output = $_.L2CacheSize }
            };
            $output }
    },
    @{  n = "L3CacheSize"; 
        e = { switch ($_.L3CacheSize) {
                $null { $output = "Info Not Found" }
                0 { $output = 0 }
                Default { $output = $_.L3CacheSize }
            };
            $output }
    } | Format-List
}
function ramInformation {
    Write-Output "========== RAM INFORMATION =========="
    $totalRamCapacity = 0
    Get-WmiObject win32_physicalmemory |
    ForEach-Object {
        $currentRam = $_ ;
        New-Object -TypeName psObject -Property @{
            Manufacturer = $currentRam.Manufacturer
            Description  = $currentRam.Description
            "Size(GB)"   = $currentRam.Capacity / 1gb
            Bank         = $currentRam.banklabel
            Slot         = $currentRam.devicelocator
        }
        $totalRamCapacity += $currentRam.Capacity
    } |
    Format-Table Manufacturer, Description, "Size(GB)", Bank, Slot -AutoSize
    Write-Output "Total RAM Capacity = $($totalRamCapacity/1gb) GB"
}
function diskDriveInformation {
    Write-Output "========== DISK DRIVE INFORMATION =========="
    $allDiskDrives = Get-CIMInstance CIM_diskdrive | Where-Object DeviceID -ne $null
    foreach ($currentDisk in $allDiskDrives) {
        $allPartitions = $currentDisk | get-cimassociatedinstance -resultclassname CIM_diskpartition
        foreach ($currentPartition in $allPartitions) {
            $allLogicalDisks = $currentPartition | get-cimassociatedinstance -resultclassname CIM_logicaldisk
            foreach ($currentLogicalDisk in $allLogicalDisks) {
                new-object -typename psobject -property @{
                    Model          = $currentDisk.Model
                    Manufacturer   = $currentDisk.Manufacturer
                    Location       = $currentPartition.deviceid
                    Drive          = $currentLogicalDisk.deviceid
                    "Size(GB)"     = [string]($currentLogicalDisk.size / 1gb -as [int]) + 'GB'
                    FreeSpace      = [string]($currentLogicalDisk.FreeSpace / 1gb -as [int]) + 'GB'
                    "FreeSpace(%)" = ([string]((($currentLogicalDisk.FreeSpace / $currentLogicalDisk.Size) * 100) -as [int]) + '%')
                } | Format-Table -AutoSize
            } 
        }
    }   
}
function networkInformation {
    Write-Output "========== NETWORK INFORMATION =========="
    get-ciminstance win32_networkadapterconfiguration | Where-Object { $_.ipenabled -eq 'True' } | 
    Select-Object Index, IPAddress, Description, 
    @{
        n = 'Subnet';
        e = {
            switch ($_.Subnet) {
                $null { $output = 'Info Unavailable' }
                Default { $output = $_.Subnet }
            };
            $output
        }
    }, 
    @{
        n = 'DNSdomain';
        e = {
            switch ($_.DNSdomain) {
                $null { $output = 'Info Unavailable' }
                Default { $output = $_.DNSdomain }
            };
            $output
        }
    }, 
    DNSServerSearchOrder |
    Format-Table Index, IPaddress, Description, Subnet, DNSdomain, DNSserversearchorder
}
function graphicsInformation {
    Write-Output "========== GRAPHICS INFORMATION =========="
    $controllerObject = Get-WmiObject win32_videocontroller
    $controllerObject = New-Object -TypeName psObject -Property @{
        Name             = $controllerObject.Name
        Description      = $controllerObject.Description
        ScreenResolution = [string]($controllerObject.CurrentHorizontalResolution) + 'px X ' + [string]($controllerObject.CurrentVerticalResolution) + 'px'
    } | Format-List Name, Description, ScreenResolution
    $controllerObject
}

# Calling Functions one by one
hardwareInformation
OSInformation
processorInformation
ramInformation
diskDriveInformation
networkInformation
graphicsInformation

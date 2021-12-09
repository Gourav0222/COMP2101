param (
    [switch]$System,
    [switch]$Disks,
    [switch]$Network
)
if ( !($System) -and !($Disks) -and !($Network)) {
    hardwareInformation
    processorInformation
    OSInformation
    ramInformation
    graphicsInformation
    diskDriveInformation
    networkInformation
}
if ($System) {
    hardwareInformation
    processorInformation
    OSInformation
    ramInformation
    graphicsInformation
}
if ($Disks) {
    diskDriveInformation
}
if ($Network) {
    networkInformation
}

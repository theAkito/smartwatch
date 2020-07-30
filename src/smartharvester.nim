import
  os,
  osproc
from strutils import
  splitLines,
  contains
from sequtils import
  keepIf,
  delete

const
  smart = "/usr/sbin/smartctl"
  smart_opts = " -a"
  lsblk = "/bin/lsblk"
  lsblk_opts = " -pilo KNAME"

var
  blockdevices: seq[string]

proc getAllDevices*(): seq =
  let (devices, _) = execCmdEx(lsblk & lsblk_opts)
  blockdevices = devices.splitLines
  blockdevices.delete(0)
  blockdevices.keepIf(
    proc (s: string): bool =
      if s != "" and not s.contains "loop": return true
  )
  return blockdevices

proc getSmartData*(devices: seq[string]): bool =
  for dev in devices:
    writeLine(stdout, dev)
    let (smart_data, err_code) = execCmdEx(smart & smart_opts & " " & dev)
    writeLine(stdout, smart_data)

discard getSmartData(getAllDevices())
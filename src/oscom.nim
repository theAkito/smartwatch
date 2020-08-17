from distros import 
  detectOS,
  foreignDep
from osproc import 
  execCmdEx

type
  OS_PROCESS_ERROR* = object of OSError
  OS_PERMISSION_ERROR* = object of OSError

proc isLsblkInstalled(): bool =
  let
    (_, errc) = execCmdEx("lsblk")
  if errc != 0:
    return false
  else:
    return true

proc getDeps*() =
  if detectOs(Debian) or 
     detectOs(Parrot) or
     detectOs(Deepin) or
     detectOs(SparkyLinux) or
     detectOs(LXLE) or
     detectOs(Kali) or
     detectOs(Ubuntu) or 
     detectOs(Peppermint) or
     detectOs(RancherOS) or
     detectOs(Fedora) or
     detectOs(KaOS) or
     detectOs(Mageia) or
     detectOs(OpenSUSE) or
     detectOs(PCLinuxOS) or 
     detectOs(Solus) or
     detectOs(CentOS):
      foreignDep "coreutils"
      foreignDep "util-linux"
      foreignDep "smartmontools"

  if detectOs(FreeBSD) or
     detectOs(Alpine):
      foreignDep "coreutils"
      foreignDep "lsblk"
      foreignDep "smartmontools"

  if detectOs(GhostBSD) or
     detectOs(OpenBSD) or
     detectOs(DragonFlyBSD):
      if not isLsblkInstalled():
        raise OS_PROCESS_ERROR.newException(
          "Running on BSD that is not FreeBSD requires you to manually install lsblk."
        )
      foreignDep "coreutils"
      foreignDep "smartmontools"
  if detectOs(Windows):
    raise OSError.newException("Nope. Not on Windows.")
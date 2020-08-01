# import distros
from distros import 
  detectOS,
  foreignDep

if detectOs(Debian) or 
  detectOs(Parrot) or
  detectOs(Deepin) or
  detectOs(SparkyLinux) or
  detectOs(LXLE) or
  detectOs(Kali) or
  detectOs(Ubuntu) or 
  detectOs(Peppermint) or
  detectOs(RancherOS):
    foreignDep "coreutils"
    foreignDep "util-linux"
    foreignDep "smartmontools"
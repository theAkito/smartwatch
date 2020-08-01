import
  os,
  json,
  tables,
  depman
from osproc import
  execCmdEx
from strutils import
  splitLines,
  contains
from sequtils import
  keepIf,
  delete
# from tables import
  # getOrDefault
# from json import
#   parseJson,
#   getFields,
#   getElems,
#   JsonNode,
#   JObject,
#   JArray

const
  debug_build {.booldefine.}: bool = false
  smart_opts = " -a --json=c "
  lsblk = "/bin/lsblk "
  lsblk_opts = " -pilo KNAME "

when debug_build == true:
  const
    smart = "/bin/bash -c /usr/bin/fakesmartctl "
else:
  const
    smart = "/usr/sbin/smartctl "

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
    let
      (raw_smart_data, err_code) = execCmdEx(smart & smart_opts & dev)
      smart_data = raw_smart_data.parseJson
      device_map = smart_data["device"].getFields
      device_type = device_map.getOrDefault("type")
      ata_smart_attributes = smart_data["ata_smart_attributes"].getFields
      asa_table = ata_smart_attributes["table"].getElems
      asa_t_id1 = asa_table[0].getFields
      asa_t_id3 = asa_table[1].getFields
      asa_t_id4 = asa_table[2].getFields
      asa_t_id5 = asa_table[3].getFields
      asa_t_id7 = asa_table[4].getFields
      asa_t_id9 = asa_table[5].getFields
      asa_t_id10 = asa_table[6].getFields
      asa_t_id12 = asa_table[7].getFields
      asa_t_id184 = asa_table[8].getFields
      asa_t_id187 = asa_table[9].getFields
      asa_t_id188 = asa_table[10].getFields
      asa_t_id189 = asa_table[11].getFields
      asa_t_id190 = asa_table[12].getFields
      asa_t_id191 = asa_table[13].getFields
      asa_t_id193 = asa_table[14].getFields
      asa_t_id194 = asa_table[15].getFields
      asa_t_id195 = asa_table[16].getFields
      asa_t_id197 = asa_table[17].getFields
      asa_t_id198 = asa_table[18].getFields
      asa_t_id199 = asa_table[19].getFields
      # Possible fields per SMART ID:
      # id
      # name
      # value
      # worst
      # thresh
      # when_failed
      # flags (another JsonNode in itself)
      # raw (another JsonNode in itself)
    writeLine(stdout, device_type)
    writeLine(stdout, asa_t_id1["name"])

discard getSmartData(getAllDevices())
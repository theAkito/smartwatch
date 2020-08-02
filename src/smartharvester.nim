import
  os,
  json,
  tables
from osproc import
  execCmdEx
from strutils import
  splitLines,
  contains
from sequtils import
  keepIf,
  delete
include smarttypes


const
  debug_build {.booldefine.}: bool = false
  smart_opts = " --all --json=c --device=sat,auto "
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

proc getSmartData*(devices: seq[string], property: SmartProperty): seq[string] =
  for dev in devices:
    let
      (raw_smart_data, err_code) = execCmdEx(smart & smart_opts & dev)
      smart_data  = raw_smart_data.parseJson
      device_map  = smart_data["device"].getFields
      device_type = device_map.getOrDefault("type")
      ata_smart_attributes = smart_data["ata_smart_attributes"].getFields
      asa_table   = ata_smart_attributes["table"].getElems
      st_id1   = asa_table[0].getFields
      st_id3   = asa_table[1].getFields
      st_id4   = asa_table[2].getFields
      st_id5   = asa_table[3].getFields
      st_id7   = asa_table[4].getFields
      st_id9   = asa_table[5].getFields
      st_id10  = asa_table[6].getFields
      st_id12  = asa_table[7].getFields
      st_id184 = asa_table[8].getFields
      st_id187 = asa_table[9].getFields
      st_id188 = asa_table[10].getFields
      st_id189 = asa_table[11].getFields
      st_id190 = asa_table[12].getFields
      st_id191 = asa_table[13].getFields
      st_id193 = asa_table[14].getFields
      st_id194 = asa_table[15].getFields
      st_id195 = asa_table[16].getFields
      st_id197 = asa_table[17].getFields
      st_id198 = asa_table[18].getFields
      st_id199 = asa_table[19].getFields
      # Possible fields per SMART ID:
      # id
      # name
      # value
      # worst
      # thresh
      # when_failed
      # flags (another JsonNode in itself)
      # raw (another JsonNode in itself)
    case property:
      of RAW_READ_ERROR_RATE:
        let smart_line = @[st_id1["name"].getStr,
                           $st_id1["value"],
                           $st_id1["worst"],
                           $st_id1["thresh"]]
        # echo $smart_line
        return smart_line
      of SPIN_UP_TIME:
        return @["empty_string"]
      of START_STOP_COUNT:
        return @["empty_string"]
      of REALLOCATED_SECTOR_CT:
        return @["empty_string"]
      of SEEK_ERROR_RATE:
        return @["empty_string"]
      of POWER_ON_HOURS:
        return @["empty_string"]
      of SPIN_RETRY_COUNT:
        return @["empty_string"]
      of POWER_CYCLE_COUNT:
        return @["empty_string"]
      of ENDTOEND_ERROR:
        return @["empty_string"]
      of REPORTED_UNCORRECT:
        return @["empty_string"]
      of COMMAND_TIMEOUT:
        return @["empty_string"]
      of HIGH_FLY_WRITES:
        return @["empty_string"]
      of AIRFLOW_TEMPERATURE_CEL:
        return @["empty_string"]
      of GSENSE_ERROR_RATE:
        return @["empty_string"]
      of POWEROFF_RETRACT_COUNT:
        return @["empty_string"]
      of LOAD_CYCLE_COUNT:
        return @["empty_string"]
      of TEMPERATURE_CELSIUS:
        return @["empty_string"]
      of HARDWARE_ECC_RECOVERED:
        return @["empty_string"]
      of CURRENT_PENDING_SECTOR:
        return @["empty_string"]
      of OFFLINE_UNCORRECTABLE:
        return @["empty_string"]
      of UDMA_CRC_ERROR_COUNT:
        return @["empty_string"]
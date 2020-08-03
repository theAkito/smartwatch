import
  os,
  json,
  tables,
  hashes
from osproc import
  execCmdEx
from strutils import
  splitLines,
  contains
from sequtils import
  keepIf,
  delete
include
  smarttypes

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

proc getAllDevices*(): seq[string] =
  let (devices, _) = execCmdEx(lsblk & lsblk_opts)
  blockdevices = devices.splitLines
  blockdevices.delete(0)
  blockdevices.keepIf(
    proc (s: string): bool =
      if s != "" and not s.contains "loop": return true
  )
  return blockdevices

proc hash*[A](x: seq[A]): Hash =
  for it in x.items: result = result !& hash(it)
  result = !$result

proc getSmartDataField(devices: seq[string], property: SmartProperty): OrderedTable[seq[string], seq[string]] =
  # Possible fields per SMART ID:
  # id
  # name
  # value
  # worst
  # thresh
  # when_failed
  # flags (another JsonNode in itself)
  # raw (another JsonNode in itself)
  for dev in devices:
    let
      (raw_smart_data, err_code) = execCmdEx(smart & smart_opts & dev)
      smart_data  = raw_smart_data.parseJson
      device_map  = smart_data["device"].getFields
      device_type = device_map.getOrDefault("type")
      model_family  = smart_data["model_family"].getStr
      model_name  = smart_data["model_name"].getStr
      serial_number  = smart_data["serial_number"].getStr
      ata_smart_attributes = smart_data["ata_smart_attributes"].getFields
      asa_table   = ata_smart_attributes["table"].getElems
      # st_id1   = asa_table[0].getFields
      # st_id3   = asa_table[1].getFields
      # st_id4   = asa_table[2].getFields
      # st_id5   = asa_table[3].getFields
      # st_id7   = asa_table[4].getFields
      # st_id9   = asa_table[5].getFields
      # st_id10  = asa_table[6].getFields
      # st_id12  = asa_table[7].getFields
      # st_id184 = asa_table[8].getFields
      # st_id187 = asa_table[9].getFields
      # st_id188 = asa_table[10].getFields
      # st_id189 = asa_table[11].getFields
      # st_id190 = asa_table[12].getFields
      # st_id191 = asa_table[13].getFields
      # st_id192 = asa_table[14].getFields
      # st_id193 = asa_table[15].getFields
      # st_id194 = asa_table[16].getFields
      # st_id195 = asa_table[17].getFields
      # st_id197 = asa_table[18].getFields
      # st_id198 = asa_table[19].getFields
      # st_id199 = asa_table[20].getFields
      device_info = @[
                        model_family,
                        model_name,
                        serial_number
                     ]
    var
      current_smart_elem: OrderedTable[string, JsonNode]
      avail_smart_elems: seq[int]
    for elem in asa_table:
      current_smart_elem = elem.getFields
      avail_smart_elems.add(current_smart_elem["id"].getInt)
    for elem in avail_smart_elems:
      case elem:
        of 01:
          discard
        of 02:
          discard
        of 03:
          discard
        of 04:
          discard
        of 05:
          discard
        of 06:
          discard
        of 07:
          discard
        of 08:
          discard
        of 09:
          discard
        of 10:
          discard
        of 11:
          discard
        of 12:
          discard
        of 13:
          discard
        of 22:
          discard
        of 170:
          discard
        of 171:
          discard
        of 172:
          discard
        of 173:
          discard
        of 174:
          discard
        of 175:
          discard
        of 176:
          discard
        of 177:
          discard
        of 179:
          discard
        of 180:
          discard
        of 181:
          discard
        of 182:
          discard
        of 183:
          discard
        of 184:
          discard
        of 185:
          discard
        of 187:
          discard
        of 188:
          discard
        of 189:
          discard
        of 190:
          discard
        of 191:
          discard
        of 192:
          discard
        of 193:
          discard
        of 194:
          discard
        of 195:
          discard
        of 196:
          discard
        of 197:
          discard
        of 198:
          discard
        of 199:
          discard
        of 200:
          discard
        of 201:
          discard
        of 202:
          discard
        of 203:
          discard
        of 204:
          discard
        of 205:
          discard
        of 206:
          discard
        of 207:
          discard
        of 208:
          discard
        of 209:
          discard
        of 210:
          discard
        of 211:
          discard
        of 212:
          discard
        of 220:
          discard
        of 221:
          discard
        of 222:
          discard
        of 223:
          discard
        of 224:
          discard
        of 225:
          discard
        of 226:
          discard
        of 227:
          discard
        of 228:
          discard
        of 230:
          discard
        of 231:
          discard
        of 232:
          discard
        of 234:
          discard
        of 235:
          discard
        of 240:
          discard
        of 241:
          discard
        of 242:
          discard
        of 243:
          discard
        of 244:
          discard
        of 249:
          discard
        of 250:
          discard
        of 251:
          discard
        of 252:
          discard
        of 254:
          discard
    case property:
      of RAW_READ_ERROR_RATE:
        let
          smart_line  = @[
                            st_id1["name"].getStr,
                            $st_id1["value"],
                            $st_id1["worst"],
                            $st_id1["thresh"]
                         ]
        var seqtable = initOrderedTable[seq[string], seq[string]]()
        seqtable[device_info] = smart_line
        return seqtable
      of SPIN_UP_TIME:
        let smart_line = @[st_id3["name"].getStr,
                           $st_id3["value"],
                           $st_id3["worst"],
                           $st_id3["thresh"]]
        var seqtable = initOrderedTable[seq[string], seq[string]]()
        seqtable[device_info] = smart_line
        return seqtable
      of START_STOP_COUNT:
        let smart_line = @[st_id4["name"].getStr,
                           $st_id4["value"],
                           $st_id4["worst"],
                           $st_id4["thresh"]]
        var seqtable = initOrderedTable[seq[string], seq[string]]()
        seqtable[device_info] = smart_line
        return seqtable
      of REALLOCATED_SECTOR_CT:
        let smart_line = @[st_id5["name"].getStr,
                           $st_id5["value"],
                           $st_id5["worst"],
                           $st_id5["thresh"]]
        var seqtable = initOrderedTable[seq[string], seq[string]]()
        seqtable[device_info] = smart_line
        return seqtable
      of SEEK_ERROR_RATE:
        let smart_line = @[st_id7["name"].getStr,
                           $st_id7["value"],
                           $st_id7["worst"],
                           $st_id7["thresh"]]
        var seqtable = initOrderedTable[seq[string], seq[string]]()
        seqtable[device_info] = smart_line
        return seqtable
      of POWER_ON_HOURS:
        let smart_line = @[st_id9["name"].getStr,
                           $st_id9["value"],
                           $st_id9["worst"],
                           $st_id9["thresh"]]
        var seqtable = initOrderedTable[seq[string], seq[string]]()
        seqtable[device_info] = smart_line
        return seqtable
      of SPIN_RETRY_COUNT:
        let smart_line = @[st_id10["name"].getStr,
                           $st_id10["value"],
                           $st_id10["worst"],
                           $st_id10["thresh"]]
        var seqtable = initOrderedTable[seq[string], seq[string]]()
        seqtable[device_info] = smart_line
        return seqtable
      of POWER_CYCLE_COUNT:
        let smart_line = @[st_id12["name"].getStr,
                           $st_id12["value"],
                           $st_id12["worst"],
                           $st_id12["thresh"]]
        var seqtable = initOrderedTable[seq[string], seq[string]]()
        seqtable[device_info] = smart_line
        return seqtable
      of ENDTOEND_ERROR:
        let smart_line = @[st_id184["name"].getStr,
                           $st_id184["value"],
                           $st_id184["worst"],
                           $st_id184["thresh"]]
        var seqtable = initOrderedTable[seq[string], seq[string]]()
        seqtable[device_info] = smart_line
        return seqtable
      of REPORTED_UNCORRECT:
        let smart_line = @[st_id187["name"].getStr,
                           $st_id187["value"],
                           $st_id187["worst"],
                           $st_id187["thresh"]]
        var seqtable = initOrderedTable[seq[string], seq[string]]()
        seqtable[device_info] = smart_line
        return seqtable
      of COMMAND_TIMEOUT:
        let smart_line = @[st_id188["name"].getStr,
                           $st_id188["value"],
                           $st_id188["worst"],
                           $st_id188["thresh"]]
        var seqtable = initOrderedTable[seq[string], seq[string]]()
        seqtable[device_info] = smart_line
        return seqtable
      of HIGH_FLY_WRITES:
        let smart_line = @[st_id189["name"].getStr,
                           $st_id189["value"],
                           $st_id189["worst"],
                           $st_id189["thresh"]]
        var seqtable = initOrderedTable[seq[string], seq[string]]()
        seqtable[device_info] = smart_line
        return seqtable
      of AIRFLOW_TEMPERATURE_CEL:
        let smart_line = @[st_id190["name"].getStr,
                           $st_id190["value"],
                           $st_id190["worst"],
                           $st_id190["thresh"]]
        var seqtable = initOrderedTable[seq[string], seq[string]]()
        seqtable[device_info] = smart_line
        return seqtable
      of GSENSE_ERROR_RATE:
        let smart_line = @[st_id191["name"].getStr,
                           $st_id191["value"],
                           $st_id191["worst"],
                           $st_id191["thresh"]]
        var seqtable = initOrderedTable[seq[string], seq[string]]()
        seqtable[device_info] = smart_line
        return seqtable
      of POWEROFF_RETRACT_COUNT:
        let smart_line = @[st_id192["name"].getStr,
                           $st_id192["value"],
                           $st_id192["worst"],
                           $st_id192["thresh"]]
        var seqtable = initOrderedTable[seq[string], seq[string]]()
        seqtable[device_info] = smart_line
        return seqtable
      of LOAD_CYCLE_COUNT:
        let smart_line = @[st_id193["name"].getStr,
                           $st_id193["value"],
                           $st_id193["worst"],
                           $st_id193["thresh"]]
        var seqtable = initOrderedTable[seq[string], seq[string]]()
        seqtable[device_info] = smart_line
        return seqtable
      of TEMPERATURE_CELSIUS:
        let smart_line = @[st_id194["name"].getStr,
                           $st_id194["value"],
                           $st_id194["worst"],
                           $st_id194["thresh"]]
        var seqtable = initOrderedTable[seq[string], seq[string]]()
        seqtable[device_info] = smart_line
        return seqtable
      of HARDWARE_ECC_RECOVERED:
        let smart_line = @[st_id195["name"].getStr,
                           $st_id195["value"],
                           $st_id195["worst"],
                           $st_id195["thresh"]]
        var seqtable = initOrderedTable[seq[string], seq[string]]()
        seqtable[device_info] = smart_line
        return seqtable
      of CURRENT_PENDING_SECTOR:
        let smart_line = @[st_id197["name"].getStr,
                           $st_id197["value"],
                           $st_id197["worst"],
                           $st_id197["thresh"]]
        var seqtable = initOrderedTable[seq[string], seq[string]]()
        seqtable[device_info] = smart_line
        return seqtable
      of OFFLINE_UNCORRECTABLE:
        let smart_line = @[st_id198["name"].getStr,
                           $st_id198["value"],
                           $st_id198["worst"],
                           $st_id198["thresh"]]
        var seqtable = initOrderedTable[seq[string], seq[string]]()
        seqtable[device_info] = smart_line
        return seqtable
      of UDMA_CRC_ERROR_COUNT:
        let smart_line = @[st_id199["name"].getStr,
                           $st_id199["value"],
                           $st_id199["worst"],
                           $st_id199["thresh"]]
        var seqtable = initOrderedTable[seq[string], seq[string]]()
        seqtable[device_info] = smart_line
        return seqtable

proc getSmartDataAll*(devices: seq[string]): OrderedTable[seq[string], seq[seq[string]]] =
  var
    smart_all_perDevice: OrderedTable[seq[string], seq[seq[string]]] = initOrderedTable[seq[string], seq[seq[string]]]()
    smart_line_perDevice: OrderedTable[seq[string], seq[string]] = initOrderedTable[seq[string], seq[string]]()
    current_device: seq[string]
    smart_all: seq[seq[string]]
    device_info: seq[string]
  for dev in devices:
    current_device = @[dev]
    smart_all = @[]
    for smartType in SmartProperty.typeof:
      smart_line_perDevice = getSmartDataField(current_device, smartType)
      #TODO DEBUG
      # echo "smart_line_perDevice output: " & $smart_line_perDevice
      for key, value in smart_line_perDevice.pairs:
        smart_all.add(value)
        device_info = key
    smart_all_perDevice[device_info] = smart_all
  return smart_all_perDevice
#TODO DEBUG
# echo getSmartDataAll(getAllDevices())
# echo getSmartDataAll(@["/dev/sda", "/dev/sdb"])

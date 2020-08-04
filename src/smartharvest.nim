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
  filter,
  delete
include
  smarttypes

const
  debug_build {.booldefine.}: bool = false
  lsblk = "/bin/lsblk "
  lsblk_opts = " -pilo KNAME "

when debug_build == true:
  const
    smart = "bash -c /usr/bin/fakesmartctl "
    smart_opts = " "
else:
  const
    smart = "/usr/sbin/smartctl "
    smart_opts = " --all --json=c --device=sat,auto "

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
    # var (raw_smart_data, err_code) = execCmdEx("bash -c \"/usr/bin/fakesmartctl " & dev &  " \" ")
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
    proc smart_attr_node(id: int): OrderedTable[string, JsonNode] =
      var
        node_table: OrderedTable[string, JsonNode]
      if avail_smart_elems.contains(id):
        for node in asa_table:
          node_table = node.getFields
          if node_table["id"].getInt == id:
            return node_table
          else:
            continue
        if node_table["id"].getInt != id:
          node_table["id"] = 9999.newJInt
    proc get_final_smart_attr(node_table: OrderedTable[string, JsonNode]): seq[string] =
      let
        smart_line  = @[
                          node_table["name"].getStr,
                          $node_table["value"],
                          $node_table["worst"],
                          $node_table["thresh"]
                      ]
      return smart_line
    case property:
      of RAW_READ_ERROR_RATE:
        block this_attr:
          let
            current_id = 1
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of THROUGHPUT_PERFORMANCE:
        block this_attr:
          let
            current_id = 2
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of SPIN_UP_TIME:
        block this_attr:
          let
            current_id = 3
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of START_STOP_COUNT:
        block this_attr:
          let
            current_id = 4
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of REALLOCATED_SECTORS_COUNT:
        block this_attr:
          let
            current_id = 5
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of READ_CHANNEL_MARGIN:
        block this_attr:
          let
            current_id = 6
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of SEEK_ERROR_RATE:
        block this_attr:
          let
            current_id = 7
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of SEEK_TIME_PERFORMANCE:
        block this_attr:
          let
            current_id = 8
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of POWER_ON_HOURS:
        block this_attr:
          let
            current_id = 9
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of SPIN_RETRY_COUNT:
        block this_attr:
          let
            current_id = 10
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of CALIBRATION_RETRY_COUNT:
        block this_attr:
          let
            current_id = 11
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of POWER_CYCLE_COUNT:
        block this_attr:
          let
            current_id = 12
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of SOFT_READ_ERROR_RATE:
        block this_attr:
          let
            current_id = 13
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of CURRENT_HELIUM_LEVEL:
        block this_attr:
          let
            current_id = 22
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of AVAILABLE_RESERVED_SPACE:
        block this_attr:
          let
            current_id = 170
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of SSD_PROGRAM_FAIL_COUNT:
        block this_attr:
          let
            current_id = 171
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of SSD_ERASE_FAIL_COUNT:
        block this_attr:
          let
            current_id = 172
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of SSD_WEAR_LEVELING_COUNT:
        block this_attr:
          let
            current_id = 173
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of UNEXPECTED_POWER_LOSS_COUNT:
        block this_attr:
          let
            current_id = 174
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of POWER_LOSS_PROTECTION_FAILURE:
        block this_attr:
          let
            current_id = 175
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of ERASE_FAIL_COUNT:
        block this_attr:
          let
            current_id = 176
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of WEAR_RANGE_DELTA:
        block this_attr:
          let
            current_id = 177
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of USED_RESERVED_BLOCK_COUNT_TOTAL:
        block this_attr:
          let
            current_id = 179
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of UNUSED_RESERVED_BLOCK_COUNT_TOTAL:
        block this_attr:
          let
            current_id = 180
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of PROGRAM_FAIL_COUNT_TOTAL:
        block this_attr:
          let
            current_id = 181
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of ERASE_FAIL_COUNT_SAMSUNG:
        block this_attr:
          let
            current_id = 182
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of SATA_DOWNSHIFT_ERROR_COUNT:
        block this_attr:
          let
            current_id = 183
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of ENDTOEND_ERROR_IOEDC:
        block this_attr:
          let
            current_id = 184
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of HEAD_STABILITY:
        block this_attr:
          let
            current_id = 185
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of INDUCED_OPVIBRATION_DETECTION:
        block this_attr:
          let
            current_id = 6
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of REPORTED_UNCORRECTABLE_ERRORS:
        block this_attr:
          let
            current_id = 187
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of COMMAND_TIMEOUT:
        block this_attr:
          let
            current_id = 188
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of HIGH_FLY_WRITES:
        block this_attr:
          let
            current_id = 189
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of AIRFLOW_TEMPERATURE:
        block this_attr:
          let
            current_id = 190
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of GSENSE_ERROR_RATE:
        block this_attr:
          let
            current_id = 191
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of UNSAFE_SHUTDOWN_COUNT:
        block this_attr:
          let
            current_id = 192
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of LOAD_CYCLE_COUNT:
        block this_attr:
          let
            current_id = 193
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of TEMPERATURE_CELSIUS:
        block this_attr:
          let
            current_id = 194
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of HARDWARE_ECC_RECOVERED:
        block this_attr:
          let
            current_id = 195
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of REALLOCATION_EVENT_COUNT:
        block this_attr:
          let
            current_id = 196
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of CURRENT_PENDING_SECTOR_COUNT:
        block this_attr:
          let
            current_id = 197
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of OFFLINE_UNCORRECTABLE_SECTOR_COUNT:
        block this_attr:
          let
            current_id = 198
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of ULTRADMA_CRC_ERROR_COUNT:
        block this_attr:
          let
            current_id = 199
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of MULTIZONE_ERROR_RATE:
        block this_attr:
          let
            current_id = 200
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of SOFT_READ_ERROR_RATE_2:
        block this_attr:
          let
            current_id = 201
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of DATA_ADDRESS_MARK_ERRORS:
        block this_attr:
          let
            current_id = 202
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of RUN_OUT_CANCEL:
        block this_attr:
          let
            current_id = 203
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of SOFT_ECC_CORRECTION:
        block this_attr:
          let
            current_id = 204
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of THERMAL_ASPERITY_RATE:
        block this_attr:
          let
            current_id = 205
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of FLYING_HEIGHT:
        block this_attr:
          let
            current_id = 206
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of SPIN_HIGH_CURRENT:
        block this_attr:
          let
            current_id = 207
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of SPIN_BUZZ:
        block this_attr:
          let
            current_id = 208
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of OFFLINE_SEEK_PERFORMANCE:
        block this_attr:
          let
            current_id = 209
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of VIBRATION_DURING_WRITE_MAXTOR:
        block this_attr:
          let
            current_id = 210
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of VIBRATION_DURING_WRITE:
        block this_attr:
          let
            current_id = 211
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of SHOCK_DURING_WRITE:
        block this_attr:
          let
            current_id = 212
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of DISK_SHIFT:
        block this_attr:
          let
            current_id = 220
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of GSENSE_ERROR_RATE_2:
        block this_attr:
          let
            current_id = 221
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of LOADED_HOURS:
        block this_attr:
          let
            current_id = 222
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of LOAD_UNLOAD_RETRY_COUNT:
        block this_attr:
          let
            current_id = 223
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of LOAD_FRICTION:
        block this_attr:
          let
            current_id = 224
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of LOAD_UNLOAD_CYCLE_COUNT:
        block this_attr:
          let
            current_id = 225
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of LOAD_IN_TIME:
        block this_attr:
          let
            current_id = 226
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of TORQUE_AMPLIFICATION_COUNT:
        block this_attr:
          let
            current_id = 227
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of POWEROFF_RETRACT_CYCLE:
        block this_attr:
          let
            current_id = 228
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of GMR_OR_DRIVE_LIFE:
        block this_attr:
          let
            current_id = 230
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of LIFE_LEFT:
        block this_attr:
          let
            current_id = 231
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of ENDURANCE_REMAINING:
        block this_attr:
          let
            current_id = 232
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of MEDIA_WEAROUT_INDICATOR:
        block this_attr:
          let
            current_id = 233
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of MAXIMUM_ERASE_COUNT:
        block this_attr:
          let
            current_id = 234
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of GOOD_BLOCK_COUNT:
        block this_attr:
          let
            current_id = 235
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of HEAD_FLYING_HOURS:
        block this_attr:
          let
            current_id = 240
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of TOTAL_LBAS_WRITTEN:
        block this_attr:
          let
            current_id = 241
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of TOTAL_LBAS_READ:
        block this_attr:
          let
            current_id = 242
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of TOTAL_LBAS_WRITTEN_EXPANDED:
        block this_attr:
          let
            current_id = 243
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of TOTAL_LBAS_READ_EXPANDED:
        block this_attr:
          let
            current_id = 244
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of NAND_WRITES_1GIB:
        block this_attr:
          let
            current_id = 249
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of READ_ERROR_RETRY_RATE:
        block this_attr:
          let
            current_id = 250
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of MINIMUM_SPARES_REMAINING:
        block this_attr:
          let
            current_id = 251
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of NEWLY_ADDED_BAD_FLASH_BLOCK:
        block this_attr:
          let
            current_id = 252
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
          return seqtable
      of FREE_FALL_PROTECTION:
        block this_attr:
          let
            current_id = 254
            node_table = smart_attr_node(current_id)
          if not node_table.hasKey("id") or
                 node_table["id"].getInt != current_id:
            break this_attr
          var seqtable = initOrderedTable[seq[string], seq[string]]()
          seqtable[device_info] = get_final_smart_attr(node_table)
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
        #TODO DEBUG
        # echo device_info
    smart_all_perDevice[device_info] = smart_all
  return smart_all_perDevice
#TODO DEBUG
# echo getSmartDataAll(getAllDevices())
# echo getSmartDataAll(@["/dev/sda", "/dev/sdb"])
# echo getSmartDataAll(@["/dev/sdb"])

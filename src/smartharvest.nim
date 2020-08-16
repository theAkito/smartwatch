import
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
  smarttypes,
  smartprocessor,
  oscom,
  debug

const
  smart = "/usr/sbin/smartctl "
  smart_opts = " --all --json=c "
  lsblk = "/bin/lsblk "
  lsblk_opts = " -pilo KNAME "

func isProcessExitCodeZero(errc: int): bool =
  case errc:
    of 0:
      return true
    else:
      return false

proc getAllDevices*(): seq[string] =
  var
    blockdevices: seq[string]
  let (devices, err_code) = execCmdEx(lsblk & lsblk_opts)
  if not isProcessExitCodeZero(err_code):
    raise OS_PROCESS_ERROR.newException("lsblk failed to execute!")
  blockdevices = devices.splitLines
  blockdevices.delete(0)
  blockdevices.keepIf(
    proc (s: string): bool =
      if s != "" and not s.contains "loop": return true
  )
  return blockdevices

func hash*[A](x: seq[A]): Hash =
  for it in x.items: result = result !& hash(it)
  result = !$result

func getSmartDataField(smart_data: JsonNode, device_info: seq[string],
                       asa_table: seq[JsonNode], property: SmartProperty):
                         OrderedTable[seq[string], seq[string]]
                      {.raises: [
                        ValueError,
                        ].} =
  func smart_attr_node(id: int): OrderedTable[string, JsonNode] =
    var
      current_smart_elem: OrderedTable[string, JsonNode]
      avail_smart_elems: seq[int]
      node_table: OrderedTable[string, JsonNode]
    for elem in asa_table:
      current_smart_elem = elem.getFields
      ## `avail_smart_elems` = Collection of all harvested SMART IDs.
      avail_smart_elems.add(current_smart_elem["id"].getInt)
    if avail_smart_elems.contains(id):
      for node in asa_table:
        node_table = node.getFields
        if node_table["id"].getInt == id:
          return node_table
        else:
          continue
  func get_final_smart_attr(node_table: OrderedTable[string, JsonNode]): seq[string] =
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
      1.getOrDismissAttr
    of THROUGHPUT_PERFORMANCE:
      2.getOrDismissAttr
    of SPIN_UP_TIME:
      3.getOrDismissAttr
    of START_STOP_COUNT:
      4.getOrDismissAttr
    of REALLOCATED_SECTORS_COUNT:
      5.getOrDismissAttr
    of READ_CHANNEL_MARGIN:
      6.getOrDismissAttr
    of SEEK_ERROR_RATE:
      7.getOrDismissAttr
    of SEEK_TIME_PERFORMANCE:
      8.getOrDismissAttr
    of POWER_ON_HOURS:
      9.getOrDismissAttr
    of SPIN_RETRY_COUNT:
      10.getOrDismissAttr
    of CALIBRATION_RETRY_COUNT:
      11.getOrDismissAttr
    of POWER_CYCLE_COUNT:
      12.getOrDismissAttr
    of SOFT_READ_ERROR_RATE:
      13.getOrDismissAttr
    of CURRENT_HELIUM_LEVEL:
      22.getOrDismissAttr
    of AVAILABLE_RESERVED_SPACE:
      170.getOrDismissAttr
    of SSD_PROGRAM_FAIL_COUNT:
      171.getOrDismissAttr
    of SSD_ERASE_FAIL_COUNT:
      172.getOrDismissAttr
    of SSD_WEAR_LEVELING_COUNT:
      173.getOrDismissAttr
    of UNEXPECTED_POWER_LOSS_COUNT:
      174.getOrDismissAttr
    of POWER_LOSS_PROTECTION_FAILURE:
      175.getOrDismissAttr
    of ERASE_FAIL_COUNT:
      176.getOrDismissAttr
    of WEAR_RANGE_DELTA:
      177.getOrDismissAttr
    of USED_RESERVED_BLOCK_COUNT_TOTAL:
      179.getOrDismissAttr
    of UNUSED_RESERVED_BLOCK_COUNT_TOTAL:
      180.getOrDismissAttr
    of PROGRAM_FAIL_COUNT_TOTAL:
      181.getOrDismissAttr
    of ERASE_FAIL_COUNT_SAMSUNG:
      182.getOrDismissAttr
    of SATA_DOWNSHIFT_ERROR_COUNT:
      183.getOrDismissAttr
    of ENDTOEND_ERROR_IOEDC:
      184.getOrDismissAttr
    of HEAD_STABILITY:
      185.getOrDismissAttr
    of INDUCED_OPVIBRATION_DETECTION:
      186.getOrDismissAttr
    of REPORTED_UNCORRECTABLE_ERRORS:
      187.getOrDismissAttr
    of COMMAND_TIMEOUT:
      188.getOrDismissAttr
    of HIGH_FLY_WRITES:
      189.getOrDismissAttr
    of AIRFLOW_TEMPERATURE:
      190.getOrDismissAttr
    of GSENSE_ERROR_RATE:
      191.getOrDismissAttr
    of UNSAFE_SHUTDOWN_COUNT:
      192.getOrDismissAttr
    of LOAD_CYCLE_COUNT:
      193.getOrDismissAttr
    of TEMPERATURE_CELSIUS:
      194.getOrDismissAttr
    of HARDWARE_ECC_RECOVERED:
      195.getOrDismissAttr
    of REALLOCATION_EVENT_COUNT:
      196.getOrDismissAttr
    of CURRENT_PENDING_SECTOR_COUNT:
      197.getOrDismissAttr
    of OFFLINE_UNCORRECTABLE_SECTOR_COUNT:
      198.getOrDismissAttr
    of ULTRADMA_CRC_ERROR_COUNT:
      199.getOrDismissAttr
    of MULTIZONE_ERROR_RATE:
      200.getOrDismissAttr
    of SOFT_READ_ERROR_RATE_2:
      201.getOrDismissAttr
    of DATA_ADDRESS_MARK_ERRORS:
      202.getOrDismissAttr
    of RUN_OUT_CANCEL:
      203.getOrDismissAttr
    of SOFT_ECC_CORRECTION:
      204.getOrDismissAttr
    of THERMAL_ASPERITY_RATE:
      205.getOrDismissAttr
    of FLYING_HEIGHT:
      206.getOrDismissAttr
    of SPIN_HIGH_CURRENT:
      207.getOrDismissAttr
    of SPIN_BUZZ:
      208.getOrDismissAttr
    of OFFLINE_SEEK_PERFORMANCE:
      209.getOrDismissAttr
    of VIBRATION_DURING_WRITE_MAXTOR:
      210.getOrDismissAttr
    of VIBRATION_DURING_WRITE:
      211.getOrDismissAttr
    of SHOCK_DURING_WRITE:
      212.getOrDismissAttr
    of DISK_SHIFT:
      220.getOrDismissAttr
    of GSENSE_ERROR_RATE_2:
      221.getOrDismissAttr
    of LOADED_HOURS:
      222.getOrDismissAttr
    of LOAD_UNLOAD_RETRY_COUNT:
      223.getOrDismissAttr
    of LOAD_FRICTION:
      224.getOrDismissAttr
    of LOAD_UNLOAD_CYCLE_COUNT:
      225.getOrDismissAttr
    of LOAD_IN_TIME:
      226.getOrDismissAttr
    of TORQUE_AMPLIFICATION_COUNT:
      227.getOrDismissAttr
    of POWEROFF_RETRACT_CYCLE:
      228.getOrDismissAttr
    of GMR_OR_DRIVE_LIFE:
      230.getOrDismissAttr
    of LIFE_LEFT:
      231.getOrDismissAttr
    of ENDURANCE_REMAINING:
      232.getOrDismissAttr
    of MEDIA_WEAROUT_INDICATOR:
      233.getOrDismissAttr
    of MAXIMUM_ERASE_COUNT:
      234.getOrDismissAttr
    of GOOD_BLOCK_COUNT:
      235.getOrDismissAttr
    of HEAD_FLYING_HOURS:
      240.getOrDismissAttr
    of TOTAL_LBAS_WRITTEN:
      241.getOrDismissAttr
    of TOTAL_LBAS_READ:
      242.getOrDismissAttr
    of TOTAL_LBAS_WRITTEN_EXPANDED:
      243.getOrDismissAttr
    of TOTAL_LBAS_READ_EXPANDED:
      244.getOrDismissAttr
    of NAND_WRITES_1GIB:
      249.getOrDismissAttr
    of READ_ERROR_RETRY_RATE:
      250.getOrDismissAttr
    of MINIMUM_SPARES_REMAINING:
      251.getOrDismissAttr
    of NEWLY_ADDED_BAD_FLASH_BLOCK:
      252.getOrDismissAttr
    of FREE_FALL_PROTECTION:
      254.getOrDismissAttr

proc getSmartDataAll*(devices: seq[string]): OrderedTable[seq[string], seq[seq[string]]] =
  var
    smart_all_perDevice  = initOrderedTable[seq[string], seq[seq[string]]]()
    smart_line_perDevice = initOrderedTable[seq[string], seq[string]]()
    current_device: seq[string]
    smart_all: seq[seq[string]]
    raw_smart_data: TaintedString
    err_code: int
    smart_data: JsonNode
    model_family: string
    model_name: string
    serial_number: string
    ata_smart_attributes: OrderedTable[string, JsonNode]
    asa_table: seq[JsonNode]
    device_info: seq[string]
  for dev in devices:
    current_device = @[dev]
    smart_all = @[]
    func getDeviceTypeOrDefault(dev_type: string = ""): string =
      if dev_type != "":
        result = """ of type """ & """"""" & dev_type & """""""
    proc harvestRawData(dev: string, debug: bool = false, dev_type: string) =
      if not debug:
        (raw_smart_data, err_code) = execCmdEx(smart & smart_opts & "--device=" & dev_type & " " & dev)
    proc harvestRawData(dev: string, debug: bool = false) =
      if debug:
        (raw_smart_data, err_code) = execCmdEx("./fakesmartctl " & dev )
      else:
        (raw_smart_data, err_code) = execCmdEx(smart & smart_opts & dev)
    proc harvestSmartData(dev: string, dev_type: string = "", explicit: bool = false)
                        {.raises: [
                                    OS_PROCESS_ERROR,
                                    Defect,
                                    IOError,
                                    OSError,
                                    ValueError,
                                    Exception
                                  ].} =
      if explicit and not isProcessExitCodeZero(err_code):
        raise OS_PROCESS_ERROR.newException(
                                            "ERROR: Cannot get SMART information from " &
                                            """"""" & model_name & """"""" &
                                            getDeviceTypeOrDefault(dev_type) &
                                            "."
                                          )
      smart_data  = raw_smart_data.parseJson
      if smart_data.hasKey("model_family"):
        model_family = smart_data["model_family"].getStr
      else:
        model_family = ""
      if smart_data.hasKey("serial_number"):
        serial_number = smart_data["serial_number"].getStr
      else:
        serial_number = ""
      if smart_data.hasKey("ata_smart_attributes"):
        ata_smart_attributes = smart_data["ata_smart_attributes"].getFields
        asa_table = ata_smart_attributes["table"].getElems
      model_name = smart_data["model_name"].getStr
      device_info = @[
                        model_family,
                        model_name,
                        serial_number
                    ]
    harvestRawData(dev, debug_build)
    harvestSmartData(dev)
    let
      device_type  = smart_data["device"].getFields.getOrDefault("type").getStr
    if not isProcessExitCodeZero(err_code):
      harvestRawData(dev, debug_build, device_type)
      try:
        harvestSmartData(dev, device_type, true)
      except OS_PROCESS_ERROR:
        echo getCurrentExceptionMsg()
        break
    for smart_attr in SmartProperty.typeof:
      #TODO Instead of iterating over every possible SmartProperty
      # we should first gather every available id, then iterate over all
      # actually provided ids by the particular device.
      # This should increase performance by a lot.
      smart_line_perDevice = getSmartDataField(smart_data, device_info, asa_table, smart_attr);
      for _, value in smart_line_perDevice.pairs:
        smart_all.add(value)
    smart_all_perDevice[device_info] = smart_all
  return smart_all_perDevice
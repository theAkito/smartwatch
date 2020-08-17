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
from oscom import 
  OS_PROCESS_ERROR
include
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

func getSmartAttrNode(id: int, ata_smart_attributes_table: seq[JsonNode]): OrderedTable[string, JsonNode] =
  var
    current_smart_elem: OrderedTable[string, JsonNode]
    avail_smart_elems: seq[int]
    ata_smart_attributes_table_node: OrderedTable[string, JsonNode]
  for elem in ata_smart_attributes_table:
    current_smart_elem = elem.getFields
    ## `avail_smart_elems` = Collection of all harvested SMART IDs.
    avail_smart_elems.add(current_smart_elem["id"].getInt)
  if avail_smart_elems.contains(id):
    for node in ata_smart_attributes_table:
      ata_smart_attributes_table_node = node.getFields
      if ata_smart_attributes_table_node["id"].getInt == id:
        return ata_smart_attributes_table_node
      else:
        continue

func getSmartAttrFinal(ata_smart_attributes_table_node: OrderedTable[string, JsonNode]): seq[string] =
  let
    smart_line  = @[
                      ata_smart_attributes_table_node["name"].getStr,
                      $ata_smart_attributes_table_node["value"],
                      $ata_smart_attributes_table_node["worst"],
                      $ata_smart_attributes_table_node["thresh"]
                    ]
  return smart_line

func getSmartAllAttrId(ata_smart_attributes_table: seq[JsonNode]): seq[int] =
    var
      avail_id_list: seq[int]
    for key, value in ata_smart_attributes_table:
      avail_id_list.add(value["id"].getInt)
    return avail_id_list

func getAttr(id: int, device_info: seq[string], ata_smart_attributes_table: seq[JsonNode]):
                OrderedTable[seq[string], seq[string]] =
  let
    ata_smart_attributes_table_node = getSmartAttrNode(id, ata_smart_attributes_table)
  var seqtable = initOrderedTable[seq[string], seq[string]]()
  seqtable[device_info] = getSmartAttrFinal(ata_smart_attributes_table_node)
  return seqtable

func getDeviceTypeOrDefault(dev_type: string = ""): string =
  if dev_type != "":
    result = """ of type """ & """"""" & dev_type & """""""

proc getSmartDataAll*(devices: seq[string]): OrderedTable[seq[string], seq[seq[string]]] =
  var
    smart_all_perDevice  = initOrderedTable[seq[string], seq[seq[string]]]()
    smart_line_perDevice = initOrderedTable[seq[string], seq[string]]()
    smart_all: seq[seq[string]]
    raw_smart_data: TaintedString
    err_code: int
    smart_data: JsonNode
    model_family: string
    model_name: string
    serial_number: string
    ata_smart_attributes: OrderedTable[string, JsonNode]
    ata_smart_attributes_table: seq[JsonNode]
    device_info: seq[string]
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
      ata_smart_attributes_table = ata_smart_attributes["table"].getElems
    model_name = smart_data["model_name"].getStr
    device_info = @[
                      model_family,
                      model_name,
                      serial_number
                  ]
  for dev in devices:
    smart_all = @[]
    harvestRawData(dev, debug_build)
    harvestSmartData(dev)
    let
      device_type  = smart_data["device"].getFields
                                         .getOrDefault("type")
                                         .getStr
    if not isProcessExitCodeZero(err_code):
      harvestRawData(dev, debug_build, device_type)
      try:
        harvestSmartData(dev, device_type, true)
      except OS_PROCESS_ERROR:
        echo getCurrentExceptionMsg()
        continue
      except:
        raise getCurrentException()
    let avail_id_list = getSmartAllAttrId(ata_smart_attributes_table)
    for id in avail_id_list:
      smart_line_perDevice = id.getAttr(device_info, ata_smart_attributes_table)
      for _, value in smart_line_perDevice.pairs:
        smart_all.add(value)
    smart_all_perDevice[device_info] = smart_all
  return smart_all_perDevice
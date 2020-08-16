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

func get_final_smart_attr(node_table: OrderedTable[string, JsonNode]): seq[string] =
  let
    smart_line  = @[
                      node_table["name"].getStr,
                      $node_table["value"],
                      $node_table["worst"],
                      $node_table["thresh"]
                    ]
  return smart_line

func smart_attr_node(id: int, asa_table: seq[JsonNode]): OrderedTable[string, JsonNode] =
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

func getSmartAllAttrId(asa_table: seq[JsonNode]): seq[int] =
    var
      avail_id_list: seq[int]
    for key, value in asa_table:
      avail_id_list.add(value["id"].getInt)
    return avail_id_list


proc getSmartDataField( 
                        smart_data: JsonNode,
                        device_info: seq[string],
                        asa_table: seq[JsonNode],
                        property_id: int
                      ): OrderedTable[seq[string], seq[string]]
                      {.raises: [
                        ValueError,
                        ].} =
  case property_id:
    of 1:
      1.getOrDismissAttr(asa_table)
    of 2:
      2.getOrDismissAttr(asa_table)
    of 3:
      3.getOrDismissAttr(asa_table)
    of 4:
      4.getOrDismissAttr(asa_table)
    of 5:
      5.getOrDismissAttr(asa_table)
    of 6:
      6.getOrDismissAttr(asa_table)
    of 7:
      7.getOrDismissAttr(asa_table)
    of 8:
      8.getOrDismissAttr(asa_table)
    of 9:
      9.getOrDismissAttr(asa_table)
    of 10:
      10.getOrDismissAttr(asa_table)
    of 11:
      11.getOrDismissAttr(asa_table)
    of 12:
      12.getOrDismissAttr(asa_table)
    of 13:
      13.getOrDismissAttr(asa_table)
    of 22:
      22.getOrDismissAttr(asa_table)
    of 170:
      170.getOrDismissAttr(asa_table)
    of 171:
      171.getOrDismissAttr(asa_table)
    of 172:
      172.getOrDismissAttr(asa_table)
    of 173:
      173.getOrDismissAttr(asa_table)
    of 174:
      174.getOrDismissAttr(asa_table)
    of 175:
      175.getOrDismissAttr(asa_table)
    of 176:
      176.getOrDismissAttr(asa_table)
    of 177:
      177.getOrDismissAttr(asa_table)
    of 179:
      179.getOrDismissAttr(asa_table)
    of 180:
      180.getOrDismissAttr(asa_table)
    of 181:
      181.getOrDismissAttr(asa_table)
    of 182:
      182.getOrDismissAttr(asa_table)
    of 183:
      183.getOrDismissAttr(asa_table)
    of 184:
      184.getOrDismissAttr(asa_table)
    of 185:
      185.getOrDismissAttr(asa_table)
    of 186:
      186.getOrDismissAttr(asa_table)
    of 187:
      187.getOrDismissAttr(asa_table)
    of 188:
      188.getOrDismissAttr(asa_table)
    of 189:
      189.getOrDismissAttr(asa_table)
    of 190:
      190.getOrDismissAttr(asa_table)
    of 191:
      191.getOrDismissAttr(asa_table)
    of 192:
      192.getOrDismissAttr(asa_table)
    of 193:
      193.getOrDismissAttr(asa_table)
    of 194:
      194.getOrDismissAttr(asa_table)
    of 195:
      195.getOrDismissAttr(asa_table)
    of 196:
      196.getOrDismissAttr(asa_table)
    of 197:
      197.getOrDismissAttr(asa_table)
    of 198:
      198.getOrDismissAttr(asa_table)
    of 199:
      199.getOrDismissAttr(asa_table)
    of 200:
      200.getOrDismissAttr(asa_table)
    of 201:
      201.getOrDismissAttr(asa_table)
    of 202:
      202.getOrDismissAttr(asa_table)
    of 203:
      203.getOrDismissAttr(asa_table)
    of 204:
      204.getOrDismissAttr(asa_table)
    of 205:
      205.getOrDismissAttr(asa_table)
    of 206:
      206.getOrDismissAttr(asa_table)
    of 207:
      207.getOrDismissAttr(asa_table)
    of 208:
      208.getOrDismissAttr(asa_table)
    of 209:
      209.getOrDismissAttr(asa_table)
    of 210:
      210.getOrDismissAttr(asa_table)
    of 211:
      211.getOrDismissAttr(asa_table)
    of 212:
      212.getOrDismissAttr(asa_table)
    of 220:
      220.getOrDismissAttr(asa_table)
    of 221:
      221.getOrDismissAttr(asa_table)
    of 222:
      222.getOrDismissAttr(asa_table)
    of 223:
      223.getOrDismissAttr(asa_table)
    of 224:
      224.getOrDismissAttr(asa_table)
    of 225:
      225.getOrDismissAttr(asa_table)
    of 226:
      226.getOrDismissAttr(asa_table)
    of 227:
      227.getOrDismissAttr(asa_table)
    of 228:
      228.getOrDismissAttr(asa_table)
    of 230:
      230.getOrDismissAttr(asa_table)
    of 231:
      231.getOrDismissAttr(asa_table)
    of 232:
      232.getOrDismissAttr(asa_table)
    of 233:
      233.getOrDismissAttr(asa_table)
    of 234:
      234.getOrDismissAttr(asa_table)
    of 235:
      235.getOrDismissAttr(asa_table)
    of 240:
      240.getOrDismissAttr(asa_table)
    of 241:
      241.getOrDismissAttr(asa_table)
    of 242:
      242.getOrDismissAttr(asa_table)
    of 243:
      243.getOrDismissAttr(asa_table)
    of 244:
      244.getOrDismissAttr(asa_table)
    of 249:
      249.getOrDismissAttr(asa_table)
    of 250:
      250.getOrDismissAttr(asa_table)
    of 251:
      251.getOrDismissAttr(asa_table)
    of 252:
      252.getOrDismissAttr(asa_table)
    of 254:
      254.getOrDismissAttr(asa_table)
    else: assert(false)

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
    asa_table: seq[JsonNode]
    device_info: seq[string]
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
  for dev in devices:
    smart_all = @[]
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
        continue
    let avail_id_list = getSmartAllAttrId(asa_table)
    for id in avail_id_list:
      smart_line_perDevice = getSmartDataField(
                                                smart_data,
                                                device_info,
                                                asa_table,
                                                id
                                              )
      for _, value in smart_line_perDevice.pairs:
        smart_all.add(value)
    smart_all_perDevice[device_info] = smart_all
  return smart_all_perDevice
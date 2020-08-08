template getOrDismissAttr*(id: int) =
  block this_attr:
    if asa_table == @[]:
      # Failed to acquire SMART attributes
      # because failed to read device.
      break this_attr
    let
      current_id = id
      node_table = smart_attr_node(current_id)
    if not node_table.hasKey("id") or
            node_table["id"].getInt != current_id:
      break this_attr
    var seqtable = initOrderedTable[seq[string], seq[string]]()
    seqtable[device_info] = get_final_smart_attr(node_table)
    return seqtable

template dataHarvester*() =
  # Possible fields per SMART ID:
  # id
  # name
  # value
  # worst
  # thresh
  # when_failed
  # flags (another JsonNode in itself)
  # raw (another JsonNode in itself)
  proc getDeviceTypeOrDefault(dev_type: string = ""): string =
    if dev_type != "":
      result = """ of type """ & """"""" & dev_type & """""""
  proc harvestRawData(dev: string, debug: bool = false, dev_type: string) =
    if not debug:
      (raw_smart_data, err_code) = execCmdEx(smart & smart_opts & "--device=" & dev_type & " " & dev)
  proc harvestRawData(dev: string, debug: bool = false) =
    if debug:
      (raw_smart_data, err_code) = execCmdEx("""bash -c "/usr/bin/fakesmartctl """ & dev &  """ " """)
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
  proc smart_attr_node(id: int): OrderedTable[string, JsonNode] =
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
  proc get_final_smart_attr(node_table: OrderedTable[string, JsonNode]): seq[string] =
    let
      smart_line  = @[
                        node_table["name"].getStr,
                        $node_table["value"],
                        $node_table["worst"],
                        $node_table["thresh"]
                      ]
    return smart_line
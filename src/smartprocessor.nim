template getOrDismissAttr*(id: int) =
  block this_attr:
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
  proc harvestRawData(dev: string, dev_type: string) =
    (raw_smart_data, err_code) = execCmdEx(smart & smart_opts & "--device=" & dev_type & dev)
  proc harvestRawData(dev: string, debug: bool = false) =
    if debug:
      (raw_smart_data, err_code) = execCmdEx("""bash -c "/usr/bin/fakesmartctl """ & dev &  """ " """)
    else:
      (raw_smart_data, err_code) = execCmdEx(smart & smart_opts & dev)
  proc harvestSmartData(dev: string, explicit: bool = false) =
    if explicit and not checkProcessExitCode(err_code):
      raise OS_PROCESS_ERROR.newException("Cannot determine device type of " & model_name)
    smart_data  = raw_smart_data.parseJson
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
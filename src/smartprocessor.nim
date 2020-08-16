template getOrDismissAttr*(id: int, asa_table: seq[untyped]) =
  block this_attr:
    let
      node_table = smart_attr_node(id, asa_table)
    if asa_table == @[] or not
       node_table.hasKey("id") or
       node_table["id"].getInt != id:
      # Failed to acquire SMART attributes
      # because failed to read device.
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
  discard
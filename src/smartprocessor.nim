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

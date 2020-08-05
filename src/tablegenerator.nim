import
  macros,
  tables,
  htmlgen

macro createSmartHtmlTableRow*(arg: varargs[untyped]): untyped =
  arg.expectLen 4
  var name= arg[0]
  var value= arg[1]
  var worst= arg[2]
  var thresh= arg[3]
  result = quote do:
    "<tr>" &
    th(`name`) &
    th(`value`) &
    th(`worst`) &
    th(`thresh`) &
    "</tr>"

macro createSmartHtmlTableTitleRow*(arg: varargs[untyped]): untyped =
  arg.expectLen 3
  var name= arg[0]
  var value= arg[1]
  var worst= arg[2]
  result = quote do:
    "<thead>" &
    "<tr>" &
    th(`name` & `value` & `worst`) &
    th("Value") &
    th("Worst") &
    th("Thresh") &
    "</tr>" &
    "</thead>"

proc createHtmlTableContent*(smart_data: OrderedTable[seq[string], seq[seq[string]]]): string =
  var
    attr_list: seq[seq[string]]
  for device_info, smart_attrs in smart_data:
    attr_list = smart_data[device_info]
    result.add """<table style="width:350px">""" &
               createSmartHtmlTableTitleRow(device_info[0], device_info[1], device_info[2])
    for attr in attr_list:
      result.add createSmartHtmlTableRow(attr[0], attr[1], attr[2], attr[3])
    result.add """</table>"""

macro createSmartHtmlTable*(arg: varargs[untyped]): untyped =
  arg.expectLen 1
  result = quote do:
    """<table style="width:350px">""" &
    createHtmlTableContent(`arg`) &
    """</table>"""

proc createHtmlTableList*(smart_data: OrderedTable[seq[string], seq[seq[string]]]): string =
  for device_info, smart_attrs in smart_data:
    result =  createSmartHtmlTable(smart_data)
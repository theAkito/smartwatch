import
  macros
from tables import
  OrderedTable,
  hasKey,
  pairs,
  `[]`

macro createSmartHtmlTableRow*(arg: varargs[untyped]): untyped =
  arg.expectLen 4
  var 
    name= arg[0]
    value= arg[1]
    worst= arg[2]
    thresh= arg[3]
  result = quote do:
    "<tr>" &
    "<th>" &
    `name` &
    "</th>" &
    "<th>" &
    `value` &
    "</th>" &
    "<th>" &
    `worst` &
    "</th>" &
    "<th>" &
    `thresh` &
    "</th>" &
    "</tr>"

macro createSmartHtmlTableTitleRow*(arg: varargs[untyped]): untyped =
  arg.expectLen 3
  var
    model_family= arg[0]
    model_name= arg[1]
    serial_number= arg[2]
  result = quote do:
    "<thead>" &
    "<tr>" &
    "<th>" &
    `model_family` & " " &
    `model_name` & " " &
    `serial_number` &
    "</th>" &
    """<th>Value</th>""" &
    """<th>Worst</th>""" &
    """<th>Thresh</th>""" &
    "</tr>" &
    "</thead>"

func createHtmlTableContent*(smart_data: OrderedTable[seq[string], seq[seq[string]]]): string =
  if not smart_data.hasKey(@[]):
    var
      attr_list: seq[seq[string]]
    for device_info, smart_attrs in smart_data:
      attr_list = smart_data[device_info]
      result.add """<table style="width:350px">""" &
                createSmartHtmlTableTitleRow(device_info[0], device_info[1], device_info[2])
      for attr in attr_list:
        result.add createSmartHtmlTableRow(attr[0], attr[1], attr[2], attr[3])
      result.add """</table>"""

macro createSmartHtmlTable*(smart_data: OrderedTable[seq[string], seq[seq[string]]]): untyped =
  result = quote do:
    createHtmlTableContent(`smart_data`)

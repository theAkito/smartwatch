import macros

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
import macros

macro createSmartHtmlRow*(arg: varargs[untyped]): untyped =
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
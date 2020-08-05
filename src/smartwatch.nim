# example.nim
import
  smartharvest,
  htmlgen,
  jester,
  tablegenerator
include
  depman

routes:
  get "/dashboard":
    redirect "/"
  get "/":
    let
      smart_all1: OrderedTable[seq[string], seq[seq[string]]] = getSmartDataAll(@["/dev/sda"])
      smart_all2: OrderedTable[seq[string], seq[seq[string]]] = getSmartDataAll(@["/dev/sdb"])
    proc createHtmlTable(smart_data: OrderedTable[seq[string], seq[seq[string]]]): string =
      var
        attr_list: seq[seq[string]]
      for device_info, smart_attrs in smart_data:
        attr_list = smart_data[device_info]
        result.add createSmartHtmlTableTitleRow(device_info[0], device_info[1], device_info[2])
        for attr in attr_list:
          result.add createSmartHtmlTableRow(attr[0], attr[1], attr[2], attr[3])
    resp """<!DOCTYPE html>
<head>
  <link rel="stylesheet" href="css/styles.css">
</head>
<header>
  <a href='/'>Logo</a>
  <label for='toggleMenu'>
    <img src='' alt='menu' />
  </label>
</header><input id='toggleMenu' type='checkbox' />
<nav>
  <ul>
    <li><a href='/dashboard'>Dashboard</a></li>
    <li><a href='/management'>Management</a></li>
    <li><a href='/settings'>Settings</a></li>
    <li><a href='/about'>About</a></li>
    <!--<li><a href='/test'>Test</a></li>-->
  </ul>
</nav>""" &
      br() &
      """<table style="width:350px">""" &
      createHtmlTable(smart_all1) &
      """</table>""" &
      """<table style="width:350px">""" &
      createHtmlTable(smart_all2) &
      """</table>"""
  get "/test":
    resp "Test succeeded!"
# example.nim
import
  smartharvester,
  htmlgen,
  jester,
  tablegenerator
include
  depman
  # smarttypes

routes:
  get "/dashboard":
    redirect "/"
  get "/":
    let
      smart_all: OrderedTable[seq[string], seq[seq[string]]] = getSmartDataAll(@["/dev/sda", "/dev/sdb"])
      # smart_one = smart_all[]
    var
      val: seq[seq[string]]
      attr1: seq[string]
      title1: seq[string]
    for key, value in smart_all:
      val = smart_all[key]
      attr1 = val[0]
      title1 = key
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
      createSmartHtmlTableTitleRow($title1[0], $title1[1], $title1[2]) &
      createSmartHtmlTableRow($attr1[0], $attr1[1], $attr1[2], $attr1[3]) &
      """</table>"""
  get "/test":
    resp "Test succeeded!"
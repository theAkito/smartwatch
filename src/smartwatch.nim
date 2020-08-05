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
      smart_all: OrderedTable[seq[string], seq[seq[string]]] = getSmartDataAll(@["/dev/sda", "/dev/sdb"])
      smart_all1: OrderedTable[seq[string], seq[seq[string]]] = getSmartDataAll(@["/dev/sda"])
      smart_all2: OrderedTable[seq[string], seq[seq[string]]] = getSmartDataAll(@["/dev/sdb"])
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
      createHtmlTableList(smart_all) &
      br()
  get "/test":
    resp "Test succeeded!"
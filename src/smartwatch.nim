# example.nim
import
  smartharvester,
  htmlgen,
  jester
include
  depman
  # smarttypes

let smart_example = getSmartData(devices = getAllDevices(), property = RAW_READ_ERROR_RATE)

routes:
  get "/dashboard":
    redirect "/"
  get "/":
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
      body($smart_example) &
      br() &
      br() &
      body("Body2")
  get "/test":
    resp "Test succeeded!"
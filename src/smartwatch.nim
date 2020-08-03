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
      smart_RAW_READ_ERROR_RATE = getSmartData(devices = getAllDevices(), property = RAW_READ_ERROR_RATE)
      smart_SPIN_UP_TIME = getSmartData(devices = getAllDevices(), property = SPIN_UP_TIME)
      smart_START_STOP_COUNT = getSmartData(devices = getAllDevices(), property = START_STOP_COUNT)
      smart_REALLOCATED_SECTOR_CT = getSmartData(devices = getAllDevices(), property = REALLOCATED_SECTOR_CT)
      smart_SEEK_ERROR_RATE = getSmartData(devices = getAllDevices(), property = SEEK_ERROR_RATE)
      smart_POWER_ON_HOURS = getSmartData(devices = getAllDevices(), property = POWER_ON_HOURS)
      smart_SPIN_RETRY_COUNT = getSmartData(devices = getAllDevices(), property = SPIN_RETRY_COUNT)
      smart_POWER_CYCLE_COUNT = getSmartData(devices = getAllDevices(), property = POWER_CYCLE_COUNT)
      smart_ENDTOEND_ERROR = getSmartData(devices = getAllDevices(), property = ENDTOEND_ERROR)
      smart_REPORTED_UNCORRECT = getSmartData(devices = getAllDevices(), property = REPORTED_UNCORRECT)
      smart_COMMAND_TIMEOUT = getSmartData(devices = getAllDevices(), property = COMMAND_TIMEOUT)
      smart_HIGH_FLY_WRITES = getSmartData(devices = getAllDevices(), property = HIGH_FLY_WRITES)
      smart_AIRFLOW_TEMPERATURE_CEL = getSmartData(devices = getAllDevices(), property = AIRFLOW_TEMPERATURE_CEL)
      smart_GSENSE_ERROR_RATE = getSmartData(devices = getAllDevices(), property = GSENSE_ERROR_RATE)
      smart_POWEROFF_RETRACT_COUNT = getSmartData(devices = getAllDevices(), property = POWEROFF_RETRACT_COUNT)
      smart_LOAD_CYCLE_COUNT = getSmartData(devices = getAllDevices(), property = LOAD_CYCLE_COUNT)
      smart_TEMPERATURE_CELSIUS = getSmartData(devices = getAllDevices(), property = TEMPERATURE_CELSIUS)
      smart_HARDWARE_ECC_RECOVERED = getSmartData(devices = getAllDevices(), property = HARDWARE_ECC_RECOVERED)
      smart_CURRENT_PENDING_SECTOR = getSmartData(devices = getAllDevices(), property = CURRENT_PENDING_SECTOR)
      smart_OFFLINE_UNCORRECTABLE = getSmartData(devices = getAllDevices(), property = OFFLINE_UNCORRECTABLE)
      smart_UDMA_CRC_ERROR_COUNT = getSmartData(devices = getAllDevices(), property = UDMA_CRC_ERROR_COUNT)
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
      createSmartHtmlRow(smart_RAW_READ_ERROR_RATE[0],
                           smart_RAW_READ_ERROR_RATE[1],
                           smart_RAW_READ_ERROR_RATE[2],
                           smart_RAW_READ_ERROR_RATE[3]) &
      createSmartHtmlRow(smart_SPIN_UP_TIME[0],
                           smart_SPIN_UP_TIME[1],
                           smart_SPIN_UP_TIME[2],
                           smart_SPIN_UP_TIME[3]) &
      createSmartHtmlRow(smart_START_STOP_COUNT[0],
                           smart_START_STOP_COUNT[1],
                           smart_START_STOP_COUNT[2],
                           smart_START_STOP_COUNT[3]) &
      createSmartHtmlRow(smart_REALLOCATED_SECTOR_CT[0], 
                           smart_REALLOCATED_SECTOR_CT[1],
                           smart_REALLOCATED_SECTOR_CT[2],
                           smart_REALLOCATED_SECTOR_CT[3]) &
      createSmartHtmlRow(smart_SEEK_ERROR_RATE[0], 
                           smart_SEEK_ERROR_RATE[1],
                           smart_SEEK_ERROR_RATE[2],
                           smart_SEEK_ERROR_RATE[3]) &
      createSmartHtmlRow(smart_POWER_ON_HOURS[0], 
                           smart_POWER_ON_HOURS[1],
                           smart_POWER_ON_HOURS[2],
                           smart_POWER_ON_HOURS[3]) &
      createSmartHtmlRow(smart_SPIN_RETRY_COUNT[0], 
                           smart_SPIN_RETRY_COUNT[1],
                           smart_SPIN_RETRY_COUNT[2],
                           smart_SPIN_RETRY_COUNT[3]) &
      createSmartHtmlRow(smart_POWER_CYCLE_COUNT[0], 
                           smart_POWER_CYCLE_COUNT[1],
                           smart_POWER_CYCLE_COUNT[2],
                           smart_POWER_CYCLE_COUNT[3]) &
      createSmartHtmlRow(smart_ENDTOEND_ERROR[0], 
                           smart_ENDTOEND_ERROR[1],
                           smart_ENDTOEND_ERROR[2],
                           smart_ENDTOEND_ERROR[3]) &
      createSmartHtmlRow(smart_REPORTED_UNCORRECT[0], 
                           smart_REPORTED_UNCORRECT[1],
                           smart_REPORTED_UNCORRECT[2],
                           smart_REPORTED_UNCORRECT[3]) &
      createSmartHtmlRow(smart_COMMAND_TIMEOUT[0], 
                           smart_COMMAND_TIMEOUT[1],
                           smart_COMMAND_TIMEOUT[2],
                           smart_COMMAND_TIMEOUT[3]) &
      createSmartHtmlRow(smart_HIGH_FLY_WRITES[0], 
                           smart_HIGH_FLY_WRITES[1],
                           smart_HIGH_FLY_WRITES[2],
                           smart_HIGH_FLY_WRITES[3]) &
      createSmartHtmlRow(smart_AIRFLOW_TEMPERATURE_CEL[0], 
                           smart_AIRFLOW_TEMPERATURE_CEL[1],
                           smart_AIRFLOW_TEMPERATURE_CEL[2],
                           smart_AIRFLOW_TEMPERATURE_CEL[3]) &
      createSmartHtmlRow(smart_GSENSE_ERROR_RATE[0], 
                           smart_GSENSE_ERROR_RATE[1],
                           smart_GSENSE_ERROR_RATE[2],
                           smart_GSENSE_ERROR_RATE[3]) &
      createSmartHtmlRow(smart_POWEROFF_RETRACT_COUNT[0], 
                           smart_POWEROFF_RETRACT_COUNT[1],
                           smart_POWEROFF_RETRACT_COUNT[2],
                           smart_POWEROFF_RETRACT_COUNT[3]) &
      createSmartHtmlRow(smart_LOAD_CYCLE_COUNT[0], 
                           smart_LOAD_CYCLE_COUNT[1],
                           smart_LOAD_CYCLE_COUNT[2],
                           smart_LOAD_CYCLE_COUNT[3]) &
      createSmartHtmlRow(smart_TEMPERATURE_CELSIUS[0], 
                           smart_TEMPERATURE_CELSIUS[1],
                           smart_TEMPERATURE_CELSIUS[2],
                           smart_TEMPERATURE_CELSIUS[3]) &
      createSmartHtmlRow(smart_HARDWARE_ECC_RECOVERED[0], 
                           smart_HARDWARE_ECC_RECOVERED[1],
                           smart_HARDWARE_ECC_RECOVERED[2],
                           smart_HARDWARE_ECC_RECOVERED[3]) &
      createSmartHtmlRow(smart_CURRENT_PENDING_SECTOR[0], 
                           smart_CURRENT_PENDING_SECTOR[1],
                           smart_CURRENT_PENDING_SECTOR[2],
                           smart_CURRENT_PENDING_SECTOR[3]) &
      createSmartHtmlRow(smart_OFFLINE_UNCORRECTABLE[0], 
                           smart_OFFLINE_UNCORRECTABLE[1],
                           smart_OFFLINE_UNCORRECTABLE[2],
                           smart_OFFLINE_UNCORRECTABLE[3]) &
      createSmartHtmlRow(smart_UDMA_CRC_ERROR_COUNT[0], 
                           smart_UDMA_CRC_ERROR_COUNT[1],
                           smart_UDMA_CRC_ERROR_COUNT[2],
                           smart_UDMA_CRC_ERROR_COUNT[3]) &
      """</table>"""
  get "/test":
    resp "Test succeeded!"
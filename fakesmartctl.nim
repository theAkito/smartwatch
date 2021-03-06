import parseopt, os

var
  SDA=false
  SDB=false
  SDC=false
  SDD=false

for kind, key, val in commandLineParams().getopt():
  case kind
    of cmdArgument:
      case key:
        of "/dev/sda": SDA = true
        of "/dev/sdb": SDB = true
        of "/dev/sdc": SDC = true
        of "/dev/sdd": SDD = true
    of cmdLongOption, cmdShortOption:
      discard
    of cmdEnd: assert(false)

if SDA:
  let smart_output =
    """{
  "json_format_version": [
    1,
    0
  ],
  "smartctl": {
    "version": [
      7,
      1
    ],
    "svn_revision": "5022",
    "platform_info": "armv7l-linux-4.19.66-v7+",
    "build_info": "(local build)",
    "argv": [
      "smartctl",
      "-a",
      "-d",
      "sat",
      "-T",
      "permissive",
      "--json",
      "/dev/sda"
    ],
    "messages": [
      {
        "string": "Warning: This result is based on an Attribute check.",
        "severity": "warning"
      }
    ],
    "exit_status": 100
  },
  "device": {
    "name": "/dev/sda",
    "info_name": "/dev/sda [SAT]",
    "type": "sat",
    "protocol": "ATA"
  },
  "model_family": "Seagate Constellation ES.2 (SATA 6Gb/s)",
  "model_name": "ST33000650NS",
  "serial_number": "000000",
  "wwn": {
    "naa": 5,
    "oui": 3152,
    "id": 1561923992
  },
  "firmware_version": "0006",
  "user_capacity": {
    "blocks": 5860533168,
    "bytes": 3000592982016
  },
  "logical_block_size": 512,
  "physical_block_size": 512,
  "rotation_rate": 7200,
  "form_factor": {
    "ata_value": 2,
    "name": "3.5 inches"
  },
  "in_smartctl_database": true,
  "ata_version": {
    "string": "ATA8-ACS T13/1699-D revision 4",
    "major_value": 496,
    "minor_value": 41
  },
  "sata_version": {
    "string": "SATA 3.0",
    "value": 32
  },
  "interface_speed": {
    "max": {
      "sata_value": 14,
      "string": "6.0 Gb/s",
      "units_per_second": 60,
      "bits_per_unit": 100000000
    },
    "current": {
      "sata_value": 3,
      "string": "6.0 Gb/s",
      "units_per_second": 60,
      "bits_per_unit": 100000000
    }
  },
  "local_time": {
    "time_t": 1596280507,
    "asctime": "Sat Aug  1 13:15:07 2020 CEST"
  },
  "smart_status": {
    "passed": true
  },
  "ata_smart_data": {
    "offline_data_collection": {
      "status": {
        "value": 130,
        "string": "was completed without error",
        "passed": true
      },
      "completion_seconds": 609
    },
    "self_test": {
      "status": {
        "value": 0,
        "string": "completed without error",
        "passed": true
      },
      "polling_minutes": {
        "short": 1,
        "extended": 448,
        "conveyance": 2
      }
    },
    "capabilities": {
      "values": [
        123,
        3
      ],
      "exec_offline_immediate_supported": true,
      "offline_is_aborted_upon_new_cmd": false,
      "offline_surface_scan_supported": true,
      "self_tests_supported": true,
      "conveyance_self_test_supported": true,
      "selective_self_test_supported": true,
      "attribute_autosave_enabled": true,
      "error_logging_supported": true,
      "gp_logging_supported": true
    }
  },
  "ata_sct_capabilities": {
    "value": 4285,
    "error_recovery_control_supported": true,
    "feature_control_supported": true,
    "data_table_supported": true
  },
  "ata_smart_attributes": {
    "revision": 10,
    "table": [
      {
        "id": 1,
        "name": "Raw_Read_Error_Rate",
        "value": 79,
        "worst": 63,
        "thresh": 44,
        "when_failed": "",
        "flags": {
          "value": 15,
          "string": "POSR-- ",
          "prefailure": true,
          "updated_online": true,
          "performance": true,
          "error_rate": true,
          "event_count": false,
          "auto_keep": false
        },
        "raw": {
          "value": 90699117,
          "string": "90699117"
        }
      },
      {
        "id": 3,
        "name": "Spin_Up_Time",
        "value": 93,
        "worst": 91,
        "thresh": 0,
        "when_failed": "",
        "flags": {
          "value": 3,
          "string": "PO---- ",
          "prefailure": true,
          "updated_online": true,
          "performance": false,
          "error_rate": false,
          "event_count": false,
          "auto_keep": false
        },
        "raw": {
          "value": 0,
          "string": "0"
        }
      },
      {
        "id": 4,
        "name": "Start_Stop_Count",
        "value": 92,
        "worst": 92,
        "thresh": 20,
        "when_failed": "",
        "flags": {
          "value": 50,
          "string": "-O--CK ",
          "prefailure": false,
          "updated_online": true,
          "performance": false,
          "error_rate": false,
          "event_count": true,
          "auto_keep": true
        },
        "raw": {
          "value": 8536,
          "string": "8536"
        }
      },
      {
        "id": 5,
        "name": "Reallocated_Sector_Ct",
        "value": 100,
        "worst": 100,
        "thresh": 36,
        "when_failed": "",
        "flags": {
          "value": 51,
          "string": "PO--CK ",
          "prefailure": true,
          "updated_online": true,
          "performance": false,
          "error_rate": false,
          "event_count": true,
          "auto_keep": true
        },
        "raw": {
          "value": 3,
          "string": "3"
        }
      },
      {
        "id": 7,
        "name": "Seek_Error_Rate",
        "value": 78,
        "worst": 60,
        "thresh": 30,
        "when_failed": "",
        "flags": {
          "value": 15,
          "string": "POSR-- ",
          "prefailure": true,
          "updated_online": true,
          "performance": true,
          "error_rate": true,
          "event_count": false,
          "auto_keep": false
        },
        "raw": {
          "value": 30646360733,
          "string": "30646360733"
        }
      },
      {
        "id": 9,
        "name": "Power_On_Hours",
        "value": 77,
        "worst": 77,
        "thresh": 0,
        "when_failed": "",
        "flags": {
          "value": 50,
          "string": "-O--CK ",
          "prefailure": false,
          "updated_online": true,
          "performance": false,
          "error_rate": false,
          "event_count": true,
          "auto_keep": true
        },
        "raw": {
          "value": 20836,
          "string": "20836"
        }
      },
      {
        "id": 10,
        "name": "Spin_Retry_Count",
        "value": 100,
        "worst": 100,
        "thresh": 97,
        "when_failed": "",
        "flags": {
          "value": 19,
          "string": "PO--C- ",
          "prefailure": true,
          "updated_online": true,
          "performance": false,
          "error_rate": false,
          "event_count": true,
          "auto_keep": false
        },
        "raw": {
          "value": 0,
          "string": "0"
        }
      },
      {
        "id": 12,
        "name": "Power_Cycle_Count",
        "value": 100,
        "worst": 100,
        "thresh": 20,
        "when_failed": "",
        "flags": {
          "value": 50,
          "string": "-O--CK ",
          "prefailure": false,
          "updated_online": true,
          "performance": false,
          "error_rate": false,
          "event_count": true,
          "auto_keep": true
        },
        "raw": {
          "value": 156,
          "string": "156"
        }
      },
      {
        "id": 184,
        "name": "End-to-End_Error",
        "value": 100,
        "worst": 100,
        "thresh": 99,
        "when_failed": "",
        "flags": {
          "value": 50,
          "string": "-O--CK ",
          "prefailure": false,
          "updated_online": true,
          "performance": false,
          "error_rate": false,
          "event_count": true,
          "auto_keep": true
        },
        "raw": {
          "value": 0,
          "string": "0"
        }
      },
      {
        "id": 187,
        "name": "Reported_Uncorrect",
        "value": 98,
        "worst": 98,
        "thresh": 0,
        "when_failed": "",
        "flags": {
          "value": 50,
          "string": "-O--CK ",
          "prefailure": false,
          "updated_online": true,
          "performance": false,
          "error_rate": false,
          "event_count": true,
          "auto_keep": true
        },
        "raw": {
          "value": 2,
          "string": "2"
        }
      },
      {
        "id": 188,
        "name": "Command_Timeout",
        "value": 100,
        "worst": 1,
        "thresh": 0,
        "when_failed": "",
        "flags": {
          "value": 50,
          "string": "-O--CK ",
          "prefailure": false,
          "updated_online": true,
          "performance": false,
          "error_rate": false,
          "event_count": true,
          "auto_keep": true
        },
        "raw": {
          "value": 1228379455780,
          "string": "1228379455780"
        }
      },
      {
        "id": 189,
        "name": "High_Fly_Writes",
        "value": 90,
        "worst": 90,
        "thresh": 0,
        "when_failed": "",
        "flags": {
          "value": 58,
          "string": "-O-RCK ",
          "prefailure": false,
          "updated_online": true,
          "performance": false,
          "error_rate": true,
          "event_count": true,
          "auto_keep": true
        },
        "raw": {
          "value": 10,
          "string": "10"
        }
      },
      {
        "id": 190,
        "name": "Airflow_Temperature_Cel",
        "value": 64,
        "worst": 36,
        "thresh": 45,
        "when_failed": "past",
        "flags": {
          "value": 34,
          "string": "-O---K ",
          "prefailure": false,
          "updated_online": true,
          "performance": false,
          "error_rate": false,
          "event_count": false,
          "auto_keep": true
        },
        "raw": {
          "value": 5781950431268,
          "string": "36 (Min/Max 26/55 #1346)"
        }
      },
      {
        "id": 191,
        "name": "G-Sense_Error_Rate",
        "value": 100,
        "worst": 100,
        "thresh": 0,
        "when_failed": "",
        "flags": {
          "value": 50,
          "string": "-O--CK ",
          "prefailure": false,
          "updated_online": true,
          "performance": false,
          "error_rate": false,
          "event_count": true,
          "auto_keep": true
        },
        "raw": {
          "value": 0,
          "string": "0"
        }
      },
      {
        "id": 192,
        "name": "Power-Off_Retract_Count",
        "value": 100,
        "worst": 100,
        "thresh": 0,
        "when_failed": "",
        "flags": {
          "value": 50,
          "string": "-O--CK ",
          "prefailure": false,
          "updated_online": true,
          "performance": false,
          "error_rate": false,
          "event_count": true,
          "auto_keep": true
        },
        "raw": {
          "value": 101,
          "string": "101"
        }
      },
      {
        "id": 193,
        "name": "Load_Cycle_Count",
        "value": 94,
        "worst": 94,
        "thresh": 0,
        "when_failed": "",
        "flags": {
          "value": 50,
          "string": "-O--CK ",
          "prefailure": false,
          "updated_online": true,
          "performance": false,
          "error_rate": false,
          "event_count": true,
          "auto_keep": true
        },
        "raw": {
          "value": 13100,
          "string": "13100"
        }
      },
      {
        "id": 194,
        "name": "Temperature_Celsius",
        "value": 36,
        "worst": 64,
        "thresh": 0,
        "when_failed": "",
        "flags": {
          "value": 34,
          "string": "-O---K ",
          "prefailure": false,
          "updated_online": true,
          "performance": false,
          "error_rate": false,
          "event_count": false,
          "auto_keep": true
        },
        "raw": {
          "value": 68719476772,
          "string": "36 (0 16 0 0 0)"
        }
      },
      {
        "id": 195,
        "name": "Hardware_ECC_Recovered",
        "value": 19,
        "worst": 7,
        "thresh": 0,
        "when_failed": "",
        "flags": {
          "value": 26,
          "string": "-O-RC- ",
          "prefailure": false,
          "updated_online": true,
          "performance": false,
          "error_rate": true,
          "event_count": true,
          "auto_keep": false
        },
        "raw": {
          "value": 90699117,
          "string": "90699117"
        }
      },
      {
        "id": 197,
        "name": "Current_Pending_Sector",
        "value": 100,
        "worst": 100,
        "thresh": 0,
        "when_failed": "",
        "flags": {
          "value": 18,
          "string": "-O--C- ",
          "prefailure": false,
          "updated_online": true,
          "performance": false,
          "error_rate": false,
          "event_count": true,
          "auto_keep": false
        },
        "raw": {
          "value": 1,
          "string": "1"
        }
      },
      {
        "id": 198,
        "name": "Offline_Uncorrectable",
        "value": 100,
        "worst": 100,
        "thresh": 0,
        "when_failed": "",
        "flags": {
          "value": 16,
          "string": "----C- ",
          "prefailure": false,
          "updated_online": false,
          "performance": false,
          "error_rate": false,
          "event_count": true,
          "auto_keep": false
        },
        "raw": {
          "value": 1,
          "string": "1"
        }
      },
      {
        "id": 199,
        "name": "UDMA_CRC_Error_Count",
        "value": 200,
        "worst": 200,
        "thresh": 0,
        "when_failed": "",
        "flags": {
          "value": 62,
          "string": "-OSRCK ",
          "prefailure": false,
          "updated_online": true,
          "performance": true,
          "error_rate": true,
          "event_count": true,
          "auto_keep": true
        },
        "raw": {
          "value": 0,
          "string": "0"
        }
      }
    ]
  },
  "power_on_time": {
    "hours": 20836
  },
  "power_cycle_count": 156,
  "temperature": {
    "current": 36
  },
  "ata_smart_error_log": {
    "summary": {
      "revision": 1,
      "count": 2,
      "logged_count": 2,
      "table": [
        {
          "error_number": 2,
          "lifetime_hours": 10519,
          "completion_registers": {
            "error": 64,
            "status": 81,
            "count": 0,
            "lba": 16777215,
            "device": 15
          },
          "error_description": "Error: UNC at LBA = 0x0fffffff = 268435455",
          "previous_commands": [
            {
              "registers": {
                "command": 96,
                "features": 0,
                "count": 128,
                "lba": 16777215,
                "device": 79,
                "device_control": 0
              },
              "powerup_milliseconds": 3062759262,
              "command_name": "READ FPDMA QUEUED"
            },
            {
              "registers": {
                "command": 96,
                "features": 0,
                "count": 128,
                "lba": 16777215,
                "device": 79,
                "device_control": 0
              },
              "powerup_milliseconds": 3062759262,
              "command_name": "READ FPDMA QUEUED"
            },
            {
              "registers": {
                "command": 96,
                "features": 0,
                "count": 128,
                "lba": 16777215,
                "device": 79,
                "device_control": 0
              },
              "powerup_milliseconds": 3062759262,
              "command_name": "READ FPDMA QUEUED"
            },
            {
              "registers": {
                "command": 96,
                "features": 0,
                "count": 128,
                "lba": 16777215,
                "device": 79,
                "device_control": 0
              },
              "powerup_milliseconds": 3062759262,
              "command_name": "READ FPDMA QUEUED"
            },
            {
              "registers": {
                "command": 96,
                "features": 0,
                "count": 128,
                "lba": 16777215,
                "device": 79,
                "device_control": 0
              },
              "powerup_milliseconds": 3062759262,
              "command_name": "READ FPDMA QUEUED"
            }
          ]
        },
        {
          "error_number": 1,
          "lifetime_hours": 9156,
          "completion_registers": {
            "error": 64,
            "status": 81,
            "count": 0,
            "lba": 16777215,
            "device": 15
          },
          "error_description": "Error: UNC at LBA = 0x0fffffff = 268435455",
          "previous_commands": [
            {
              "registers": {
                "command": 96,
                "features": 0,
                "count": 128,
                "lba": 16777215,
                "device": 79,
                "device_control": 0
              },
              "powerup_milliseconds": 2449399732,
              "command_name": "READ FPDMA QUEUED"
            },
            {
              "registers": {
                "command": 96,
                "features": 0,
                "count": 128,
                "lba": 16777215,
                "device": 79,
                "device_control": 0
              },
              "powerup_milliseconds": 2449399732,
              "command_name": "READ FPDMA QUEUED"
            },
            {
              "registers": {
                "command": 96,
                "features": 0,
                "count": 128,
                "lba": 16777215,
                "device": 79,
                "device_control": 0
              },
              "powerup_milliseconds": 2449399732,
              "command_name": "READ FPDMA QUEUED"
            },
            {
              "registers": {
                "command": 96,
                "features": 0,
                "count": 128,
                "lba": 16777215,
                "device": 79,
                "device_control": 0
              },
              "powerup_milliseconds": 2449399732,
              "command_name": "READ FPDMA QUEUED"
            },
            {
              "registers": {
                "command": 96,
                "features": 0,
                "count": 128,
                "lba": 16777215,
                "device": 79,
                "device_control": 0
              },
              "powerup_milliseconds": 2449399732,
              "command_name": "READ FPDMA QUEUED"
            }
          ]
        }
      ]
    }
  },
  "ata_smart_self_test_log": {
    "standard": {
      "revision": 1,
      "count": 0
    }
  },
  "ata_smart_selective_self_test_log": {
    "revision": 1,
    "table": [
      {
        "lba_min": 0,
        "lba_max": 0,
        "status": {
          "value": 0,
          "string": "Not_testing"
        }
      },
      {
        "lba_min": 0,
        "lba_max": 0,
        "status": {
          "value": 0,
          "string": "Not_testing"
        }
      },
      {
        "lba_min": 0,
        "lba_max": 0,
        "status": {
          "value": 0,
          "string": "Not_testing"
        }
      },
      {
        "lba_min": 0,
        "lba_max": 0,
        "status": {
          "value": 0,
          "string": "Not_testing"
        }
      },
      {
        "lba_min": 0,
        "lba_max": 0,
        "status": {
          "value": 0,
          "string": "Not_testing"
        }
      }
    ],
    "flags": {
      "value": 0,
      "remainder_scan_enabled": false
    },
    "power_up_scan_resume_minutes": 0
  }
}
    """
  echo(smart_output)
if SDB:
  let smart_output =
    """{"json_format_version":[1,0],"smartctl":{"version":[7,1],"svn_revision":"5022","platform_info":"armv7l-linux-5.4.51-v7l+","build_info":"(local build)","argv":["smartctl","--all","--json=c","--device=sat","/dev/sda"],"messages":[{"string":"Warning: This result is based on an Attribute check.","severity":"warning"}],"exit_status":4},"device":{"name":"/dev/sda","info_name":"/dev/sda [SAT]","type":"sat","protocol":"ATA"},"model_family":"Western Digital RE3 Serial ATA","model_name":"WDC WD5002ABYS-02B1B0","serial_number":"WD-W11111111111","wwn":{"naa":5,"oui":5358,"id":11506054137},"firmware_version":"02.03B03","user_capacity":{"blocks":976773168,"bytes":500107862016},"logical_block_size":512,"physical_block_size":512,"rotation_rate":7200,"in_smartctl_database":true,"ata_version":{"string":"ATA8-ACS (minor revision not indicated)","major_value":510,"minor_value":0},"sata_version":{"string":"SATA 2.5","value":14},"interface_speed":{"max":{"sata_value":6,"string":"3.0 Gb/s","units_per_second":30,"bits_per_unit":100000000}},"local_time":{"time_t":1596466648,"asctime":"Mon Aug  3 16:57:28 2020 CEST"},"smart_status":{"passed":true},"ata_smart_data":{"offline_data_collection":{"status":{"value":132,"string":"was suspended by an interrupting command from host"},"completion_seconds":9480},"self_test":{"status":{"value":0,"string":"completed without error","passed":true},"polling_minutes":{"short":2,"extended":112,"conveyance":5}},"capabilities":{"values":[123,3],"exec_offline_immediate_supported":true,"offline_is_aborted_upon_new_cmd":false,"offline_surface_scan_supported":true,"self_tests_supported":true,"conveyance_self_test_supported":true,"selective_self_test_supported":true,"attribute_autosave_enabled":true,"error_logging_supported":true,"gp_logging_supported":true}},"ata_sct_capabilities":{"value":12351,"error_recovery_control_supported":true,"feature_control_supported":true,"data_table_supported":true},"ata_smart_attributes":{"revision":16,"table":[{"id":1,"name":"Raw_Read_Error_Rate","value":200,"worst":200,"thresh":51,"when_failed":"","flags":{"value":47,"string":"POSR-K ","prefailure":true,"updated_online":true,"performance":true,"error_rate":true,"event_count":false,"auto_keep":true},"raw":{"value":0,"string":"0"}},{"id":3,"name":"Spin_Up_Time","value":184,"worst":178,"thresh":21,"when_failed":"","flags":{"value":39,"string":"POS--K ","prefailure":true,"updated_online":true,"performance":true,"error_rate":false,"event_count":false,"auto_keep":true},"raw":{"value":3800,"string":"3800"}},{"id":4,"name":"Start_Stop_Count","value":73,"worst":73,"thresh":0,"when_failed":"","flags":{"value":50,"string":"-O--CK ","prefailure":false,"updated_online":true,"performance":false,"error_rate":false,"event_count":true,"auto_keep":true},"raw":{"value":27084,"string":"27084"}},{"id":5,"name":"Reallocated_Sector_Ct","value":200,"worst":200,"thresh":140,"when_failed":"","flags":{"value":51,"string":"PO--CK ","prefailure":true,"updated_online":true,"performance":false,"error_rate":false,"event_count":true,"auto_keep":true},"raw":{"value":0,"string":"0"}},{"id":7,"name":"Seek_Error_Rate","value":100,"worst":253,"thresh":0,"when_failed":"","flags":{"value":46,"string":"-OSR-K ","prefailure":false,"updated_online":true,"performance":true,"error_rate":true,"event_count":false,"auto_keep":true},"raw":{"value":0,"string":"0"}},{"id":9,"name":"Power_On_Hours","value":86,"worst":86,"thresh":0,"when_failed":"","flags":{"value":50,"string":"-O--CK ","prefailure":false,"updated_online":true,"performance":false,"error_rate":false,"event_count":true,"auto_keep":true},"raw":{"value":10871,"string":"10871"}},{"id":10,"name":"Spin_Retry_Count","value":100,"worst":100,"thresh":0,"when_failed":"","flags":{"value":50,"string":"-O--CK ","prefailure":false,"updated_online":true,"performance":false,"error_rate":false,"event_count":true,"auto_keep":true},"raw":{"value":0,"string":"0"}},{"id":11,"name":"Calibration_Retry_Count","value":100,"worst":253,"thresh":0,"when_failed":"","flags":{"value":50,"string":"-O--CK ","prefailure":false,"updated_online":true,"performance":false,"error_rate":false,"event_count":true,"auto_keep":true},"raw":{"value":0,"string":"0"}},{"id":12,"name":"Power_Cycle_Count","value":100,"worst":100,"thresh":0,"when_failed":"","flags":{"value":50,"string":"-O--CK ","prefailure":false,"updated_online":true,"performance":false,"error_rate":false,"event_count":true,"auto_keep":true},"raw":{"value":52,"string":"52"}},{"id":192,"name":"Power-Off_Retract_Count","value":200,"worst":200,"thresh":0,"when_failed":"","flags":{"value":50,"string":"-O--CK ","prefailure":false,"updated_online":true,"performance":false,"error_rate":false,"event_count":true,"auto_keep":true},"raw":{"value":33,"string":"33"}},{"id":193,"name":"Load_Cycle_Count","value":191,"worst":191,"thresh":0,"when_failed":"","flags":{"value":50,"string":"-O--CK ","prefailure":false,"updated_online":true,"performance":false,"error_rate":false,"event_count":true,"auto_keep":true},"raw":{"value":27050,"string":"27050"}},{"id":194,"name":"Temperature_Celsius","value":111,"worst":90,"thresh":0,"when_failed":"","flags":{"value":34,"string":"-O---K ","prefailure":false,"updated_online":true,"performance":false,"error_rate":false,"event_count":false,"auto_keep":true},"raw":{"value":36,"string":"36"}},{"id":196,"name":"Reallocated_Event_Count","value":200,"worst":200,"thresh":0,"when_failed":"","flags":{"value":50,"string":"-O--CK ","prefailure":false,"updated_online":true,"performance":false,"error_rate":false,"event_count":true,"auto_keep":true},"raw":{"value":0,"string":"0"}},{"id":197,"name":"Current_Pending_Sector","value":200,"worst":200,"thresh":0,"when_failed":"","flags":{"value":50,"string":"-O--CK ","prefailure":false,"updated_online":true,"performance":false,"error_rate":false,"event_count":true,"auto_keep":true},"raw":{"value":0,"string":"0"}},{"id":198,"name":"Offline_Uncorrectable","value":200,"worst":200,"thresh":0,"when_failed":"","flags":{"value":48,"string":"----CK ","prefailure":false,"updated_online":false,"performance":false,"error_rate":false,"event_count":true,"auto_keep":true},"raw":{"value":0,"string":"0"}},{"id":199,"name":"UDMA_CRC_Error_Count","value":200,"worst":200,"thresh":0,"when_failed":"","flags":{"value":50,"string":"-O--CK ","prefailure":false,"updated_online":true,"performance":false,"error_rate":false,"event_count":true,"auto_keep":true},"raw":{"value":0,"string":"0"}},{"id":200,"name":"Multi_Zone_Error_Rate","value":200,"worst":200,"thresh":0,"when_failed":"","flags":{"value":8,"string":"---R-- ","prefailure":false,"updated_online":false,"performance":false,"error_rate":true,"event_count":false,"auto_keep":false},"raw":{"value":0,"string":"0"}}]},"power_on_time":{"hours":10871},"power_cycle_count":52,"temperature":{"current":36},"ata_smart_error_log":{"summary":{"revision":1,"count":0}},"ata_smart_self_test_log":{"standard":{"revision":1,"count":0}},"ata_smart_selective_self_test_log":{"revision":1,"table":[{"lba_min":0,"lba_max":0,"status":{"value":0,"string":"Not_testing"}},{"lba_min":0,"lba_max":0,"status":{"value":0,"string":"Not_testing"}},{"lba_min":0,"lba_max":0,"status":{"value":0,"string":"Not_testing"}},{"lba_min":0,"lba_max":0,"status":{"value":0,"string":"Not_testing"}},{"lba_min":0,"lba_max":0,"status":{"value":0,"string":"Not_testing"}}],"flags":{"value":0,"remainder_scan_enabled":false},"power_up_scan_resume_minutes":0}}"""
  echo(smart_output)
if SDC:
  let smart_output =
    """{"json_format_version":[1,0],"smartctl":{"version":[7,1],"svn_revision":"5022","platform_info":"armv7l-linux-5.4.51-v7l+","build_info":"(local build)","argv":["smartctl","--device=sat","--all","--json=c","/dev/sda"],"messages":[{"string":"Warning: This result is based on an Attribute check.","severity":"warning"}],"exit_status":4},"device":{"name":"/dev/sda","info_name":"/dev/sda [SAT]","type":"sat","protocol":"ATA"},"model_family":"Western Digital RE3 Serial ATA","model_name":"WDC WD5002ABYS-02B1B0","serial_number":"WD-W22222222222","wwn":{"naa":5,"oui":5358,"id":11506054137},"firmware_version":"02.03B03","user_capacity":{"blocks":976773168,"bytes":500107862016},"logical_block_size":512,"physical_block_size":512,"rotation_rate":7200,"in_smartctl_database":true,"ata_version":{"string":"ATA8-ACS (minor revision not indicated)","major_value":510,"minor_value":0},"sata_version":{"string":"SATA 2.5","value":14},"interface_speed":{"max":{"sata_value":6,"string":"3.0 Gb/s","units_per_second":30,"bits_per_unit":100000000}},"local_time":{"time_t":1596903277,"asctime":"Sat Aug  8 18:14:37 2020 CEST"},"smart_status":{"passed":true},"ata_smart_data":{"offline_data_collection":{"status":{"value":132,"string":"was suspended by an interrupting command from host"},"completion_seconds":9480},"self_test":{"status":{"value":0,"string":"completed without error","passed":true},"polling_minutes":{"short":2,"extended":112,"conveyance":5}},"capabilities":{"values":[123,3],"exec_offline_immediate_supported":true,"offline_is_aborted_upon_new_cmd":false,"offline_surface_scan_supported":true,"self_tests_supported":true,"conveyance_self_test_supported":true,"selective_self_test_supported":true,"attribute_autosave_enabled":true,"error_logging_supported":true,"gp_logging_supported":true}},"ata_sct_capabilities":{"value":12351,"error_recovery_control_supported":true,"feature_control_supported":true,"data_table_supported":true},"ata_smart_attributes":{"revision":16,"table":[{"id":1,"name":"Raw_Read_Error_Rate","value":200,"worst":200,"thresh":51,"when_failed":"","flags":{"value":47,"string":"POSR-K ","prefailure":true,"updated_online":true,"performance":true,"error_rate":true,"event_count":false,"auto_keep":true},"raw":{"value":0,"string":"0"}},{"id":3,"name":"Spin_Up_Time","value":181,"worst":178,"thresh":21,"when_failed":"","flags":{"value":39,"string":"POS--K ","prefailure":true,"updated_online":true,"performance":true,"error_rate":false,"event_count":false,"auto_keep":true},"raw":{"value":3941,"string":"3941"}},{"id":4,"name":"Start_Stop_Count","value":73,"worst":73,"thresh":0,"when_failed":"","flags":{"value":50,"string":"-O--CK ","prefailure":false,"updated_online":true,"performance":false,"error_rate":false,"event_count":true,"auto_keep":true},"raw":{"value":27087,"string":"27087"}},{"id":5,"name":"Reallocated_Sector_Ct","value":200,"worst":200,"thresh":140,"when_failed":"","flags":{"value":51,"string":"PO--CK ","prefailure":true,"updated_online":true,"performance":false,"error_rate":false,"event_count":true,"auto_keep":true},"raw":{"value":0,"string":"0"}},{"id":7,"name":"Seek_Error_Rate","value":100,"worst":253,"thresh":0,"when_failed":"","flags":{"value":46,"string":"-OSR-K ","prefailure":false,"updated_online":true,"performance":true,"error_rate":true,"event_count":false,"auto_keep":true},"raw":{"value":0,"string":"0"}},{"id":9,"name":"Power_On_Hours","value":85,"worst":85,"thresh":0,"when_failed":"","flags":{"value":50,"string":"-O--CK ","prefailure":false,"updated_online":true,"performance":false,"error_rate":false,"event_count":true,"auto_keep":true},"raw":{"value":10992,"string":"10992"}},{"id":10,"name":"Spin_Retry_Count","value":100,"worst":100,"thresh":0,"when_failed":"","flags":{"value":50,"string":"-O--CK ","prefailure":false,"updated_online":true,"performance":false,"error_rate":false,"event_count":true,"auto_keep":true},"raw":{"value":0,"string":"0"}},{"id":11,"name":"Calibration_Retry_Count","value":100,"worst":253,"thresh":0,"when_failed":"","flags":{"value":50,"string":"-O--CK ","prefailure":false,"updated_online":true,"performance":false,"error_rate":false,"event_count":true,"auto_keep":true},"raw":{"value":0,"string":"0"}},{"id":12,"name":"Power_Cycle_Count","value":100,"worst":100,"thresh":0,"when_failed":"","flags":{"value":50,"string":"-O--CK ","prefailure":false,"updated_online":true,"performance":false,"error_rate":false,"event_count":true,"auto_keep":true},"raw":{"value":52,"string":"52"}},{"id":192,"name":"Power-Off_Retract_Count","value":200,"worst":200,"thresh":0,"when_failed":"","flags":{"value":50,"string":"-O--CK ","prefailure":false,"updated_online":true,"performance":false,"error_rate":false,"event_count":true,"auto_keep":true},"raw":{"value":33,"string":"33"}},{"id":193,"name":"Load_Cycle_Count","value":191,"worst":191,"thresh":0,"when_failed":"","flags":{"value":50,"string":"-O--CK ","prefailure":false,"updated_online":true,"performance":false,"error_rate":false,"event_count":true,"auto_keep":true},"raw":{"value":27053,"string":"27053"}},{"id":194,"name":"Temperature_Celsius","value":106,"worst":90,"thresh":0,"when_failed":"","flags":{"value":34,"string":"-O---K ","prefailure":false,"updated_online":true,"performance":false,"error_rate":false,"event_count":false,"auto_keep":true},"raw":{"value":41,"string":"41"}},{"id":196,"name":"Reallocated_Event_Count","value":200,"worst":200,"thresh":0,"when_failed":"","flags":{"value":50,"string":"-O--CK ","prefailure":false,"updated_online":true,"performance":false,"error_rate":false,"event_count":true,"auto_keep":true},"raw":{"value":0,"string":"0"}},{"id":197,"name":"Current_Pending_Sector","value":200,"worst":200,"thresh":0,"when_failed":"","flags":{"value":50,"string":"-O--CK ","prefailure":false,"updated_online":true,"performance":false,"error_rate":false,"event_count":true,"auto_keep":true},"raw":{"value":0,"string":"0"}},{"id":198,"name":"Offline_Uncorrectable","value":200,"worst":200,"thresh":0,"when_failed":"","flags":{"value":48,"string":"----CK ","prefailure":false,"updated_online":false,"performance":false,"error_rate":false,"event_count":true,"auto_keep":true},"raw":{"value":0,"string":"0"}},{"id":199,"name":"UDMA_CRC_Error_Count","value":200,"worst":200,"thresh":0,"when_failed":"","flags":{"value":50,"string":"-O--CK ","prefailure":false,"updated_online":true,"performance":false,"error_rate":false,"event_count":true,"auto_keep":true},"raw":{"value":0,"string":"0"}},{"id":200,"name":"Multi_Zone_Error_Rate","value":200,"worst":200,"thresh":0,"when_failed":"","flags":{"value":8,"string":"---R-- ","prefailure":false,"updated_online":false,"performance":false,"error_rate":true,"event_count":false,"auto_keep":false},"raw":{"value":0,"string":"0"}}]},"power_on_time":{"hours":10992},"power_cycle_count":52,"temperature":{"current":41},"ata_smart_error_log":{"summary":{"revision":1,"count":0}},"ata_smart_self_test_log":{"standard":{"revision":1,"count":0}},"ata_smart_selective_self_test_log":{"revision":1,"table":[{"lba_min":0,"lba_max":0,"status":{"value":0,"string":"Not_testing"}},{"lba_min":0,"lba_max":0,"status":{"value":0,"string":"Not_testing"}},{"lba_min":0,"lba_max":0,"status":{"value":0,"string":"Not_testing"}},{"lba_min":0,"lba_max":0,"status":{"value":0,"string":"Not_testing"}},{"lba_min":0,"lba_max":0,"status":{"value":0,"string":"Not_testing"}}],"flags":{"value":0,"remainder_scan_enabled":false},"power_up_scan_resume_minutes":0}}"""
  echo(smart_output)
if SDD:
  let smart_output =
    """{"json_format_version":[1,0],"smartctl":{"version":[7,1],"svn_revision":"5022","platform_info":"armv7l-linux-5.4.51-v7l+","build_info":"(local build)","argv":["smartctl","--device=sat","--all","--json=c","/dev/sda"],"messages":[{"string":"Warning: This result is based on an Attribute check.","severity":"warning"}],"exit_status":4},"device":{"name":"/dev/sda","info_name":"/dev/sda [SAT]","type":"sat","protocol":"ATA"},"model_family":"Western Digital RE3 Serial ATA","model_name":"WDC WD5002ABYS-02B1B0","serial_number":"WD-W33333333333","wwn":{"naa":5,"oui":5358,"id":11506054137},"firmware_version":"02.03B03","user_capacity":{"blocks":976773168,"bytes":500107862016},"logical_block_size":512,"physical_block_size":512,"rotation_rate":7200,"in_smartctl_database":true,"ata_version":{"string":"ATA8-ACS (minor revision not indicated)","major_value":510,"minor_value":0},"sata_version":{"string":"SATA 2.5","value":14},"interface_speed":{"max":{"sata_value":6,"string":"3.0 Gb/s","units_per_second":30,"bits_per_unit":100000000}},"local_time":{"time_t":1596903277,"asctime":"Sat Aug  8 18:14:37 2020 CEST"},"smart_status":{"passed":true},"ata_smart_data":{"offline_data_collection":{"status":{"value":132,"string":"was suspended by an interrupting command from host"},"completion_seconds":9480},"self_test":{"status":{"value":0,"string":"completed without error","passed":true},"polling_minutes":{"short":2,"extended":112,"conveyance":5}},"capabilities":{"values":[123,3],"exec_offline_immediate_supported":true,"offline_is_aborted_upon_new_cmd":false,"offline_surface_scan_supported":true,"self_tests_supported":true,"conveyance_self_test_supported":true,"selective_self_test_supported":true,"attribute_autosave_enabled":true,"error_logging_supported":true,"gp_logging_supported":true}},"ata_sct_capabilities":{"value":12351,"error_recovery_control_supported":true,"feature_control_supported":true,"data_table_supported":true},"ata_smart_attributes":{"revision":16,"table":[{"id":1,"name":"Raw_Read_Error_Rate","value":200,"worst":200,"thresh":51,"when_failed":"","flags":{"value":47,"string":"POSR-K ","prefailure":true,"updated_online":true,"performance":true,"error_rate":true,"event_count":false,"auto_keep":true},"raw":{"value":0,"string":"0"}},{"id":3,"name":"Spin_Up_Time","value":181,"worst":178,"thresh":21,"when_failed":"","flags":{"value":39,"string":"POS--K ","prefailure":true,"updated_online":true,"performance":true,"error_rate":false,"event_count":false,"auto_keep":true},"raw":{"value":3941,"string":"3941"}},{"id":4,"name":"Start_Stop_Count","value":73,"worst":73,"thresh":0,"when_failed":"","flags":{"value":50,"string":"-O--CK ","prefailure":false,"updated_online":true,"performance":false,"error_rate":false,"event_count":true,"auto_keep":true},"raw":{"value":27087,"string":"27087"}},{"id":5,"name":"Reallocated_Sector_Ct","value":200,"worst":200,"thresh":140,"when_failed":"","flags":{"value":51,"string":"PO--CK ","prefailure":true,"updated_online":true,"performance":false,"error_rate":false,"event_count":true,"auto_keep":true},"raw":{"value":0,"string":"0"}},{"id":7,"name":"Seek_Error_Rate","value":100,"worst":253,"thresh":0,"when_failed":"","flags":{"value":46,"string":"-OSR-K ","prefailure":false,"updated_online":true,"performance":true,"error_rate":true,"event_count":false,"auto_keep":true},"raw":{"value":0,"string":"0"}},{"id":9,"name":"Power_On_Hours","value":85,"worst":85,"thresh":0,"when_failed":"","flags":{"value":50,"string":"-O--CK ","prefailure":false,"updated_online":true,"performance":false,"error_rate":false,"event_count":true,"auto_keep":true},"raw":{"value":10992,"string":"10992"}},{"id":10,"name":"Spin_Retry_Count","value":100,"worst":100,"thresh":0,"when_failed":"","flags":{"value":50,"string":"-O--CK ","prefailure":false,"updated_online":true,"performance":false,"error_rate":false,"event_count":true,"auto_keep":true},"raw":{"value":0,"string":"0"}},{"id":11,"name":"Calibration_Retry_Count","value":100,"worst":253,"thresh":0,"when_failed":"","flags":{"value":50,"string":"-O--CK ","prefailure":false,"updated_online":true,"performance":false,"error_rate":false,"event_count":true,"auto_keep":true},"raw":{"value":0,"string":"0"}},{"id":12,"name":"Power_Cycle_Count","value":100,"worst":100,"thresh":0,"when_failed":"","flags":{"value":50,"string":"-O--CK ","prefailure":false,"updated_online":true,"performance":false,"error_rate":false,"event_count":true,"auto_keep":true},"raw":{"value":52,"string":"52"}},{"id":192,"name":"Power-Off_Retract_Count","value":200,"worst":200,"thresh":0,"when_failed":"","flags":{"value":50,"string":"-O--CK ","prefailure":false,"updated_online":true,"performance":false,"error_rate":false,"event_count":true,"auto_keep":true},"raw":{"value":33,"string":"33"}},{"id":193,"name":"Load_Cycle_Count","value":191,"worst":191,"thresh":0,"when_failed":"","flags":{"value":50,"string":"-O--CK ","prefailure":false,"updated_online":true,"performance":false,"error_rate":false,"event_count":true,"auto_keep":true},"raw":{"value":27053,"string":"27053"}},{"id":194,"name":"Temperature_Celsius","value":106,"worst":90,"thresh":0,"when_failed":"","flags":{"value":34,"string":"-O---K ","prefailure":false,"updated_online":true,"performance":false,"error_rate":false,"event_count":false,"auto_keep":true},"raw":{"value":41,"string":"41"}},{"id":196,"name":"Reallocated_Event_Count","value":200,"worst":200,"thresh":0,"when_failed":"","flags":{"value":50,"string":"-O--CK ","prefailure":false,"updated_online":true,"performance":false,"error_rate":false,"event_count":true,"auto_keep":true},"raw":{"value":0,"string":"0"}},{"id":197,"name":"Current_Pending_Sector","value":200,"worst":200,"thresh":0,"when_failed":"","flags":{"value":50,"string":"-O--CK ","prefailure":false,"updated_online":true,"performance":false,"error_rate":false,"event_count":true,"auto_keep":true},"raw":{"value":0,"string":"0"}},{"id":198,"name":"Offline_Uncorrectable","value":200,"worst":200,"thresh":0,"when_failed":"","flags":{"value":48,"string":"----CK ","prefailure":false,"updated_online":false,"performance":false,"error_rate":false,"event_count":true,"auto_keep":true},"raw":{"value":0,"string":"0"}},{"id":199,"name":"UDMA_CRC_Error_Count","value":200,"worst":200,"thresh":0,"when_failed":"","flags":{"value":50,"string":"-O--CK ","prefailure":false,"updated_online":true,"performance":false,"error_rate":false,"event_count":true,"auto_keep":true},"raw":{"value":0,"string":"0"}},{"id":200,"name":"Multi_Zone_Error_Rate","value":200,"worst":200,"thresh":0,"when_failed":"","flags":{"value":8,"string":"---R-- ","prefailure":false,"updated_online":false,"performance":false,"error_rate":true,"event_count":false,"auto_keep":false},"raw":{"value":0,"string":"0"}}]},"power_on_time":{"hours":10992},"power_cycle_count":52,"temperature":{"current":41},"ata_smart_error_log":{"summary":{"revision":1,"count":0}},"ata_smart_self_test_log":{"standard":{"revision":1,"count":0}},"ata_smart_selective_self_test_log":{"revision":1,"table":[{"lba_min":0,"lba_max":0,"status":{"value":0,"string":"Not_testing"}},{"lba_min":0,"lba_max":0,"status":{"value":0,"string":"Not_testing"}},{"lba_min":0,"lba_max":0,"status":{"value":0,"string":"Not_testing"}},{"lba_min":0,"lba_max":0,"status":{"value":0,"string":"Not_testing"}},{"lba_min":0,"lba_max":0,"status":{"value":0,"string":"Not_testing"}}],"flags":{"value":0,"remainder_scan_enabled":false},"power_up_scan_resume_minutes":0}}"""
  echo(smart_output)
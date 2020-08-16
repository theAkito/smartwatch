#TODO Maybe not necessary. Postponing this question with low priority.
type
  SmartProperty* = enum
    RAW_READ_ERROR_RATE,
    THROUGHPUT_PERFORMANCE,
    SPINUP_TIME,
    START_STOP_COUNT,
    REALLOCATED_SECTORS_COUNT,
    READ_CHANNEL_MARGIN,
    SEEK_ERROR_RATE,
    SEEK_TIME_PERFORMANCE,
    POWER_ON_HOURS,
    SPIN_RETRY_COUNT,
    CALIBRATION_RETRY_COUNT,
    POWER_CYCLE_COUNT,
    SOFT_READ_ERROR_RATE,
    CURRENT_HELIUM_LEVEL,
    AVAILABLE_RESERVED_SPACE,
    SSD_PROGRAM_FAIL_COUNT,
    SSD_ERASE_FAIL_COUNT,
    SSD_WEAR_LEVELING_COUNT,
    UNEXPECTED_POWER_LOSS_COUNT,
    POWER_LOSS_PROTECTION_FAILURE,
    ERASE_FAIL_COUNT,
    WEAR_RANGE_DELTA,
    USED_RESERVED_BLOCK_COUNT_TOTAL,
    UNUSED_RESERVED_BLOCK_COUNT_TOTAL,
    PROGRAM_FAIL_COUNT_TOTAL,
    ERASE_FAIL_COUNT_SAMSUNG,
    SATA_DOWNSHIFT_ERROR_COUNT,
    ENDTOEND_ERROR_IOEDC,
    HEAD_STABILITY,
    INDUCED_OPVIBRATION_DETECTION,
    REPORTED_UNCORRECTABLE_ERRORS,
    COMMAND_TIMEOUT,
    HIGH_FLY_WRITES,
    AIRFLOW_TEMPERATURE,
    GSENSE_ERROR_RATE,
    UNSAFE_SHUTDOWN_COUNT,
    LOAD_CYCLE_COUNT,
    TEMPERATURE_CELSIUS,
    HARDWARE_ECC_RECOVERED,
    REALLOCATION_EVENT_COUNT,
    CURRENT_PENDING_SECTOR_COUNT,
    OFFLINE_UNCORRECTABLE_SECTOR_COUNT,
    ULTRADMA_CRC_ERROR_COUNT,
    MULTIZONE_ERROR_RATE,
    SOFT_READ_ERROR_RATE_2,
    DATA_ADDRESS_MARK_ERRORS,
    RUN_OUT_CANCEL,
    SOFT_ECC_CORRECTION,
    THERMAL_ASPERITY_RATE,
    FLYING_HEIGHT,
    SPIN_HIGH_CURRENT,
    SPIN_BUZZ,
    OFFLINE_SEEK_PERFORMANCE,
    VIBRATION_DURING_WRITE_MAXTOR,
    VIBRATION_DURING_WRITE,
    SHOCK_DURING_WRITE,
    DISK_SHIFT,
    GSENSE_ERROR_RATE_2,
    LOADED_HOURS,
    LOAD_UNLOAD_RETRY_COUNT,
    LOAD_FRICTION,
    LOAD_UNLOAD_CYCLE_COUNT,
    LOAD_IN_TIME,
    TORQUE_AMPLIFICATION_COUNT,
    POWEROFF_RETRACT_CYCLE,
    GMR_OR_DRIVE_LIFE,
    LIFE_LEFT,
    ENDURANCE_REMAINING,
    MEDIA_WEAROUT_INDICATOR,
    MAXIMUM_ERASE_COUNT,
    GOOD_BLOCK_COUNT,
    HEAD_FLYING_HOURS,
    TOTAL_LBAS_WRITTEN,
    TOTAL_LBAS_READ,
    TOTAL_LBAS_WRITTEN_EXPANDED,
    TOTAL_LBAS_READ_EXPANDED,
    NAND_WRITES_1GIB,
    READ_ERROR_RETRY_RATE,
    MINIMUM_SPARES_REMAINING,
    NEWLY_ADDED_BAD_FLASH_BLOCK,
    FREE_FALL_PROTECTION
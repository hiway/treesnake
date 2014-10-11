# -*- coding: utf-8 -*-

import traceback
import logging
import logging.handlers

logger = logging.getLogger('treesnake')
logger.setLevel(logging.DEBUG)

handler = logging.handlers.SysLogHandler('/var/run/syslog')
logger.addHandler(handler)

def refresh_rate():
    return "10"

def command():
    try:
        return "Hello, world"
    except:
        tback = traceback.format_exc()
        logger.critical(tback)
        return "error: see Console.app"

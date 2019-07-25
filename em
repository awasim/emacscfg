#!/usr/bin/env python

import os, commands, sys

psresult = commands.getoutput('ps -a | grep [Ee]macs')

if psresult == '':
    print "Launching emacs..."
    os.system('emacs %s&' %sys.argv[1])
else:
    print "Launching emacsclient..."
    os.system('emacsclient -s /tmp/emacs1000/server %s&' %sys.argv[1])

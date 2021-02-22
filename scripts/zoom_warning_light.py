#!/usr/bin/env python3
import os
import psutil
# from threading import Thread
from time import sleep
import numpy as np

import pdb

class SimpleFilter:
    def __init__(self):
        self.n = 3
        self.data = np.zeros(self.n)
        self.index = 0
        self.threshold = 15
    def update(self, new_usage):
        self.data[self.index % self.n] = new_usage
        self.index += 1
    def in_meeting(self):
        avg = self.data.mean()
        return (self.data.mean() > self.threshold)

def get_pid(name):
    ret_pid = None
    for pid in psutil.pids():
        try:
            proc = psutil.Process(pid)
        except:
            # process probably exists only briefly
            pass
        else:
            if name == proc.name():
                if ret_pid is not None:   
                    ret_pid = max(ret_pid, pid)
                else:
                    ret_pid = pid
    return ret_pid

filter = SimpleFilter()
was_in_meeting = False
def main():
    global was_in_meeting
    global filter
    app_pid = get_pid("zoom")
    if app_pid is not None:
        proc = psutil.Process(app_pid)
        app_cpu = proc.cpu_percent(interval=1)
        # print(f'name: {proc.name()} pid: {app_pid} app_cpu: {app_cpu}') 
        filter.update(app_cpu)
        in_meeting = filter.in_meeting()
        if in_meeting and not was_in_meeting:
            os.system('echo "rileytuttle" | ssh -tt pi@bias-light-pi "sudo python3 rpi_ws281x/python/examples/control-bias-light.py --color 255 0 0 --wait 10"')
            print('turning on light')
        elif not in_meeting and was_in_meeting:
            os.system('echo "rileytuttle" | ssh -tt pi@bias-light-pi "sudo python3 rpi_ws281x/python/examples/control-bias-light.py --clear"')
            print('turning off light')
        was_in_meeting = in_meeting

# def myTimer(sleep_seconds):
#     sleep(sleep_seconds)
#     main()

if __name__ == "__main__":
    while True:
        main()
        sleep(1)
        # myThread = Thread(target=myTimer, args=(1,))
        # myThread.start()

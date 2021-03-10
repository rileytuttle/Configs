#!/usr/bin/env python3
import os
import psutil
# from threading import Thread
from time import sleep
import numpy as np
from argparse import ArgumentParser

import pdb

class DebugPrinter:
    def __init__(self, debug_level=False):
        self.debug_level = debug_level
        self.set_level(debug_level)
    def set_level(self, debug_level):
        self.debug_level = debug_level
        if debug_level != 0:
            print(f'with debug strings')
    def printf(self, string):
        print(string)

dp = DebugPrinter()

class SimpleFilter:
    def __init__(self, onthreshold=60, offthreshold=40, size=3, var_thresh=5, init_state=False):
        self.n = size
        self.data = dict()
        self.onthreshold = onthreshold
        self.offthreshold = offthreshold
        self.cur_in_meeting = init_state
        self.var_change_over_thresh = var_thresh
        self.index = 0

    def get_in_meeting_simple_thresh(self):
        avgs = []
        for key in self.data.keys():
            avgs.append(self.data[key][-3:].mean())
        # dp.printf(f'{avgs}')
        # dp.printf(f'all {all([avg < self.offthreshold for avg in avgs])}')
        # dp.printf(f'any {all([avg > self.onthreshold for avg in avgs])}')
        if self.cur_in_meeting:
            if all([avg < self.offthreshold for avg in avgs]):
                return(False)
        else:
            if any([avg > self.onthreshold for avg in avgs]):
                return(True)
        return(self.cur_in_meeting)

    def update(self, pid, new_usage):
        if pid not in self.data:
            dp.printf(f'adding pid {pid}')
            self.data[pid] = np.zeros(self.n)
            self.index = 0
        self.data[pid] = np.roll(self.data[pid], -1)
        self.data[pid][-1] = new_usage
        self.cur_in_meeting = self.get_in_meeting_simple_thresh()
        if self.index < 100:
            self.index += 1

    def get_in_meeting_variance(self):
        EX = np.mean(self.data[pid])
        Ex = np.mean(self.data[pid][-3:])
        VX = np.var(self.data[pid])
        Vx = np.var(self.data[pid][-3:])
        VXi = (self.data[pid][-1] - EX) ** 2
        Vxi = (self.data[pid][-1] - Ex) ** 2
        VVXi = (VXi - VX) ** 2
        VVxi = (Vxi - Vx) ** 2

    def in_meeting(self):
        return self.cur_in_meeting

    def print_buffer(self):
        for pid in self.data.keys():
            EX = np.mean(self.data[pid])
            Ex = np.mean(self.data[pid][-3:])
            VX = np.var(self.data[pid])
            Vx = np.var(self.data[pid][-3:])
            VXi = (self.data[pid][-1] - EX) ** 2
            Vxi = (self.data[pid][-1] - Ex) ** 2
            VVXi = (VXi - VX) ** 2
            VVxi = (Vxi - Vx) ** 2
            dp.printf(f'pid {pid} last 3: {self.data[pid][-3:]}, buffer at {self.index}')
            dp.printf(f'E(X)={EX:.2f}, V(X)={VX:.2f}, V(Xi)={VXi:.2f}, V(V(Xi))={VVXi:.2f}')
            dp.printf(f'E(x)={Ex:.2f}, V(x)={Vx:.2f}, V(xi)={Vxi:.2f}, V(V(xi))={VVxi:.2f}')
        dp.printf(f'in meeting {self.cur_in_meeting}')

def get_pid(name, use_max_only=False):
    ret_pids = []
    for pid in psutil.pids():
        try:
            proc = psutil.Process(pid)
        except:
            # process probably exists only briefly
            pass
        else:
            if name == proc.name():
                ret_pids.append(pid)
    if(use_max_only):
        return([max(ret_pids)])
    else:
        return(ret_pids)

def main(args, filter, was_in_meeting):
    app_pids = get_pid("zoom", use_max_only=True)
    # print(f'app_pids {app_pids}')
    for app_pid in app_pids:
        proc = psutil.Process(app_pid)
        app_cpu = proc.cpu_percent(interval=1)
        # print(f'name: {proc.name()} pid: {app_pid} app_cpu: {app_cpu}') 
        filter.update(app_pid, app_cpu)
    in_meeting = filter.in_meeting()
    filter.print_buffer()
    if in_meeting and not was_in_meeting:
        if not args.block:
            os.system('echo "rileytuttle" | ssh -tt pi@bias-light-pi "sudo python3 rpi_ws281x/python/examples/control-bias-light.py --color 255 0 0 --wait 10"')
        dp.printf('turning on light')
    elif not in_meeting and was_in_meeting:
        if not args.block:
            os.system('echo "rileytuttle" | ssh -tt pi@bias-light-pi "sudo python3 rpi_ws281x/python/examples/control-bias-light.py --clear"')
        dp.printf('turning off light')
    return in_meeting

def main2(args, filter, was_in_meeting):
    camera_use = int(os.popen('lsmod | grep -E "uvcvideo\s+" | awk -F \' +\' \'{print $3}\'').read())
    dp.printf(f'camera_use = {camera_use}')
    in_meeting = True if camera_use == 1 else False
    if in_meeting and not was_in_meeting:
        if not args.block:
            os.system('echo "rileytuttle" | ssh -tt pi@bias-light-pi "sudo python3 rpi_ws281x/python/examples/control-bias-light.py --color 255 0 0 --wait 10"')
        dp.printf('turning on light')
    elif not in_meeting and was_in_meeting:
        if not args.block:
            os.system('echo "rileytuttle" | ssh -tt pi@bias-light-pi "sudo python3 rpi_ws281x/python/examples/control-bias-light.py --clear"')
        dp.printf('turning off light')
    return in_meeting

if __name__ == "__main__":
    parser = ArgumentParser(description="This will run the zoom warning light functions")
    parser.add_argument("--debug", action="store_true", default=False)
    parser.add_argument("--block", action="store_true", default=False, help="set this if you want to block sending command to light")
    parser.add_argument("--onoff-thresh", type=int, dest="onoff_thresh", nargs=2, default=[70, 30], help="set the on off threshold in cpu percentage")
    parser.add_argument("--delta-t", type=float, default=1.0, help="set the number of seconds between samples. values can be fractional")
    parser.add_argument("--filter-size", type=int, default=3, help="set the size of the filter")
    parser.add_argument("--init", default=False, help="set the initial state of the filter")
    args = parser.parse_args()
    dp.set_level(args.debug)
    filter = SimpleFilter(onthreshold=args.onoff_thresh[0], offthreshold=args.onoff_thresh[1], size=args.filter_size, init_state=args.init)
    was_in_meeting = args.init;
    while True:
        try:
            was_in_meeting = main2(args, filter, was_in_meeting)
        except Exception as e:
            dp.printf(e)
        sleep(args.delta_t)

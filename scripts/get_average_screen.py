#!/usr/bin/env python3

import numpy as np
import pyautogui

image = np.array(pyautogui.screenshot())
means = image.mean(axis=(0,1))
print(f'{int(means[0])} {int(means[1])} {int(means[2])}')

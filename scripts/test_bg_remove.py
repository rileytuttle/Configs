#!/usr/bin/env python3

import cv2

height, width = 720, 1280
cap = cv2.VideoCapture('/dev/video0')
cap.set(cv2.CAP_PROP_FRAME_WIDTH, width)
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, height)
cap.set(cv2.CAP_PROP_FPS, 60)

# while True:
#     success, frame = cap.read()

success, frame = cap.read()
cv2.imwrite("test.jpg", frame)

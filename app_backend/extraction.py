import re
import cv2
import numpy as np
import pytesseract
from pytesseract import Output
import argparse
import os

erosion_size = 0
max_elem = 2
max_kernel_size = 21
title_trackbar_element_shape = 'Element:\n 0: Rect \n 1: Cross \n 2: Ellipse'
title_trackbar_kernel_size = 'Kernel size:\n 2n +1'
title_erosion_window = 'Erosion Demo'
title_dilation_window = 'Dilation Demo'

def getmessage(imagefile):

    img_path = imagefile
    image = cv2.imread(img_path)
    if image is None:
        raise ValueError("Image not loaded. Please check the file path and integrity of the image")
    b,g,r = cv2.split(image)
    rgb_img = cv2.merge([r,g,b])


    gray = get_grayscale(image)
    thresh = thresholding(gray)
    opened  = opening(gray)
    cannied = canny(gray)
    images = {'gray': gray,
            'thresh': thresh,
            'opening': opened,
            'canny': canny}
    pytesseract.pytesseract.tesseract_cmd = r'C:\\Program Files\\Tesseract-OCR\\tesseract.exe'
    custom_config = r'--oem 3 --psm 6'
    message = pytesseract.image_to_string(image ,config=custom_config)

    return message

def morph_shape(val):
    if val == 0:
        return cv2.MORPH_RECT
    elif val == 1:
        return cv2.MORPH_CROSS
    elif val == 2:
        return cv2.MORPH_ELLIPSE


# get grayscale image
def get_grayscale(image):
    return cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

# noise removal
def remove_noise(image):
    return cv2.fastNlMeansDenoising(image,None,10,10,7,21)


#thresholding
def thresholding(image):
    blur = cv2.GaussianBlur(image,(5,5),0)
    return cv2.threshold(blur,0,255,cv2.THRESH_BINARY+cv2.THRESH_OTSU)[1]

#dilation
def dilate(image):
    
    dilatation_size = cv2.getTrackbarPos(title_trackbar_kernel_size, title_dilation_window)
    dilation_shape = morph_shape(cv2.getTrackbarPos(title_trackbar_element_shape, title_dilation_window))
    element = cv2.getStructuringElement(dilation_shape, (2 * dilatation_size + 1, 2 * dilatation_size + 1),
    (dilatation_size, dilatation_size))
    return cv2.dilate(image, element)

#erosion
def erode(image):
    erosion_size = cv2.getTrackbarPos(title_trackbar_kernel_size, title_erosion_window)
    erosion_shape = morph_shape(cv2.getTrackbarPos(title_trackbar_element_shape, title_erosion_window))

    element = cv2.getStructuringElement(erosion_shape, (2 * erosion_size + 1, 2 * erosion_size + 1),
    (erosion_size, erosion_size))

    return cv2.erode(image, element)

#opening - erosion followed by dilation
def opening(image):
    kernel = np.ones((5,5),np.uint8)
    return cv2.morphologyEx(image, cv2.MORPH_OPEN, kernel)

#canny edge detection
def canny(image):
    return cv2.Canny(image, 100, 200)

#skew correction
def deskew(image):
    coords = np.column_stack(np.where(image > 0))
    angle = cv2.minAreaRect(coords)[-1]
    if angle < -45:
        angle = -(90 + angle)
    else:
        angle = -angle
    (h, w) = image.shape[:2]
    center = (w // 2, h // 2)
    M = cv2.getRotationMatrix2D(center, angle, 1.0)
    rotated = cv2.warpAffine(image, M, (w, h), flags=cv2.INTER_CUBIC, borderMode=cv2.BORDER_REPLICATE)
    return rotated

#template matching
def match_template(image, template):
    return cv2.matchTemplate(image, template, cv2.TM_CCOEFF_NORMED)
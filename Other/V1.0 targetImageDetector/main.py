import cv2 as cv
import numpy as np
import os, time

os.chdir(os.path.dirname(os.path.abspath(__file__)))

class ImageVision:

    targetImage = None
    sourceImage = None
    w = 0
    h = 0
    method = None

    def __init__(self, targetImage_path='targetImage.png', sourceImage_path='sourceImage.png', method=None, preMethod=None):

        self.targetImage_path = targetImage_path
        self.targetImage = cv.imread(self.targetImage_path, preMethod)

        self.sourceImage_path = sourceImage_path
        self.sourceImage = cv.imread(self.sourceImage_path, preMethod)

        #This information is needed right away, which is why the targetImage_path attribute is filled
        self.w = self.targetImage.shape[1]
        self.h = self.targetImage.shape[0]

        #Creating a property then referencing it like this is only useful if you'll be refernencing it in the method somewhere
        self.method = method
    
    def targetImageDetector(self, threshold=None, debugMode=None):

        result = cv.matchTemplate(self.sourceImage, self.targetImage, self.method)

        coordinates = np.where(result >= threshold)
        coordinates = list(zip(*coordinates[::-1]))

        #Using the rectangle shape in [x, y, w, h] format
        shapes = []
        for coord in coordinates:
            shapeCord = [int(coord[0]), int(coord[1]), self.w, self.h]
            shapes.append(shapeCord)
            shapes.append(shapeCord)
            #This bypasses 2-coordinate requirement to qualify as a shape

        shapes, weights = cv.groupRectangles(shapes, 1, 0.25)

        markerCoords = []
        if len(shapes):
            print('Hit(s) Found!')
            time.sleep(2)
            print('Processing . . .')

            line_color = (0, 128, 128)
            line_type = cv.LINE_4
            marker_color = (0, 128, 128)
            marker_type = cv.MARKER_STAR
            
            for (x, y, w, h) in shapes:

                centerX = x + int(self.w/2)
                centerY = y + int(self.h/2)
                markerCoords.append((centerX, centerY))

                if debugMode == 'shapes':

                    top_left = (x, y)
                    bottom_right = (x + self.w, y + self.h)

                    cv.rectangle(self.sourceImage, top_left, bottom_right, line_color, line_type)

                elif debugMode == 'markerCoords':

                    cv.drawMarker(self.sourceImage, (centerX, centerY), marker_color, marker_type)
                
                elif debugMode == 'all':

                    top_left = (x, y)
                    bottom_right = (x + self.w, y + self.h)

                    cv.rectangle(self.sourceImage, top_left, bottom_right, line_color, line_type)

                    cv.drawMarker(self.sourceImage, (centerX, centerY), marker_color, marker_type)

            if debugMode:
                cv.imshow('Hit(s)', self.sourceImage)
                cv.imwrite('hit_s.jpg', self.sourceImage)
                print('Here is The Perliminary Analysis - Press Any Key to Continue!')
                cv.waitKey()

            print("Hit Coordinates: " + str(shapes))
            time.sleep(2)

            print("Analysis Complete - Check Directory for 'hit_s.jpg' !")
            return shapes

        else: 
            print("No Hits Found!")

imageVision = ImageVision()
imageVision.__init__('targetImage.png', 'sourceImage.png', method=cv.TM_CCOEFF_NORMED, preMethod=cv.IMREAD_COLOR)
imageVision.targetImageDetector(threshold=0.9, debugMode='all')

''' Original Function (Non-Class)

def targetImageDetector (targetImage_path, sourceImage_path, threshold=0.5, debugMode=None):

        targetImage = cv.imread(targetImage_path, cv.IMREAD_COLOR)
        sourceImage = cv.imread(sourceImage_path, cv.IMREAD_COLOR)

        w = targetImage.shape[1]
        h = targetImage.shape[0]

        methods = ['cv.TM_CCOEFF', 'cv.TM_CCOEFF_NORMED', 'cv.TM_CCORR', 'cv.TM_CCORR_NORMED', 'cv.TM_SQDIFF', 'cv.TM_SQDIFF_NORMED']
        method = cv.TM_CCOEFF_NORMED

        result = cv.matchTemplate(sourceImage, targetImage, method)

        coordinates = np.where(result >= threshold)
        coordinates = list(zip(*coordinates[::-1]))

        #Using the rectangle shape in [x, y, w, h] format
        shapes = []
        for coord in coordinates:
            shapeCord = [int(coord[0]), int(coord[1]), w, h]
            shapes.append(shapeCord)
            shapes.append(shapeCord)
            #This bypasses 2-coordinate requirement to qualify as a shape

        shapes, weights = cv.groupRectangles(shapes, 1, 0.25)

        markerCoords = []
        if len(shapes):
            print('Hit(s) Found!')
            time.sleep(2)
            print('Processing . . .')

            line_color = (0, 128, 128)
            line_type = cv.LINE_4
            marker_color = (0, 128, 128)
            marker_type = cv.MARKER_STAR
            
            for (x, y, w, h) in shapes:

                centerX = x + int(w/2)
                centerY = y + int(h/2)
                markerCoords.append((centerX, centerY))

                if debugMode == 'shapes':

                    top_left = (x, y)
                    bottom_right = (x + w, y + h)

                    cv.rectangle(sourceImage, top_left, bottom_right, line_color, line_type)

                elif debugMode == 'markerCoords':

                    cv.drawMarker(sourceImage, (centerX, centerY), marker_color, marker_type)
                
                elif debugMode == 'all':

                    top_left = (x, y)
                    bottom_right = (x + w, y + h)

                    cv.rectangle(sourceImage, top_left, bottom_right, line_color, line_type)

                    cv.drawMarker(sourceImage, (centerX, centerY), marker_color, marker_type)

            if debugMode:
                cv.imshow('Hit(s)', sourceImage)
                cv.imwrite('hit_s.jpg', sourceImage)
                print('Here is The Perliminary Analysis - Press Any Key to Continue!')
                cv.waitKey()

            print("Hit Coordinates: " + str(shapes))
            time.sleep(2)

            print("Analysis Complete - Check Directory for 'hit_s.jpg' !")
            return shapes

        else: 
            print("No Hits Found!")

targetImageDetector('targetImage.png', 'sourceImage.png', threshold=0.9, debugMode='all')
'''
                
            

        

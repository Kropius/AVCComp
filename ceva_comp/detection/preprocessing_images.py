from imutils import face_utils
import numpy as np
import argparse
import imutils
import dlib
import cv2
import sys


def detecting_face_parts(image_path):
    detector = dlib.get_frontal_face_detector()
    predictor = dlib.shape_predictor("detection/static/shape_predictor_68_face_landmarks.dat")

    # load the input image, resize it, and convert it to grayscale
    image = cv2.imread(image_path)
    image = imutils.resize(image, width=500)
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    # detect faces in the grayscale image
    rects = detector(gray, 1)
    # loop over the face detections
    output_coords = []
    for (i, rect) in enumerate(rects):

        shape = predictor(gray, rect)
        shape = face_utils.shape_to_np(shape)

        for (name, (i, j)) in face_utils.FACIAL_LANDMARKS_IDXS.items():

            clone = image.copy()
            cv2.putText(clone, name, (10, 30), cv2.FONT_HERSHEY_SIMPLEX,
                        0.7, (0, 0, 255), 2)

            # loop over the subset of facial landmarks, drawing the
            # specific face part
            for (x, y) in shape[i:j]:
                cv2.circle(clone, (x, y), 1, (0, 0, 255), -1)
                # print(x,y)
                # cv2.imshow("Image", clone)
                # cv2.waitKey(0)

            my_out = list(map(lambda x: [int(x[0]), int(x[1])], shape[i:j]))

            my_out = list(map(lambda x: tuple(x), my_out))
            output_coords.append({name: my_out})
            # extract the ROI of the face region as a separate image
            (x, y, w, h) = cv2.boundingRect(np.array([shape[i:j]]))
            roi = image[y:y + h, x:x + w]
            roi = imutils.resize(roi, width=250, inter=cv2.INTER_CUBIC)

            # show the particular face part
            # cv2.imshow("ROI", roi)
            # cv2.imshow("Image", clone)
            # cv2.waitKey(0)

        # visualize all facial landmarks with a transparent overlay

        cv2.waitKey(0)
        # build_input_from_photo(output_coords)
    return build_input_from_photo(output_coords)


def build_input_from_photo(array_of_coordinates):
    array_of_coordinates = {x: y for i in array_of_coordinates for x, y in i.items()}
    output = dict()
    mounth = prepare_mouth(array_of_coordinates['mouth'][:12])
    left_eye = array_of_coordinates['left_eye']
    right_eye = array_of_coordinates['right_eye']

    output['left_mouth'] = mounth[0]
    output['right_mouth'] = mounth[1]
    output['left_eye'] = left_eye
    output['right_eye'] = right_eye
    print(output)
    return output


def prepare_mouth(mouth):
    left_side_up = mouth[:4]
    right_side_up = mouth[4:7]
    right_side_down = mouth[7:9]
    left_side_down = mouth[9:12]
    left_side = left_side_up + left_side_down
    right_side = right_side_up + right_side_down
    mean_left, variance_left = get_mean_variance(left_side)
    mean_right, variance_right = get_mean_variance(right_side)
    print(left_side, right_side)
    return left_side, right_side


def get_mean_variance(mouth):
    mean_y = np.mean(list(map(lambda x: x[1], mouth)))
    variance_y = np.var(list(map(lambda x: x[1], mouth)))
    return mean_y, variance_y

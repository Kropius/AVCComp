from keras.layers import Dense, Activation
from keras.models import Sequential, load_model
from keras.activations import sigmoid
from keras.optimizers import Adagrad
from keras.datasets import mnist
import numpy as np
from keras.utils import to_categorical
import numpy as np


class builder:
    def __init__(self, data):
        self.mouth = (data['left_mouth'], data['right_mouth'])
        self.corners = (data['left_mouth_corner'], data['right_mouth_corner'])
        self.left_eye = data['left_eye']
        self.right_eye = data['right_eye']
        self.smiley_corners = data['smiley_corners']
        self.texting_test = data['texting_test']
        self.speech_test = data['speech_test']
        self.distances = (data['upper_point'], data['lower_point'])
        self.distances_smiling = (data['upper_point_smiling'], data['lower_point_smiling'])
        print(self.calculate_distance_bettween_corners(), self.calculate_distance_bettween_smiling_corners())

    def calculate_distance_bettween_corners(self):
        return np.linalg.norm(np.array(self.corners[0]) - np.array(self.corners[1]))

    def calculate_distance_bettween_smiling_corners(self):
        return np.linalg.norm(np.array(self.smiley_corners[0]) - np.array(self.smiley_corners[1]))


def build_neural(learning_rate, input_size, layer1_size, layer2_size, output_size):
    model = Sequential(
        [Dense(layer1_size, input_shape=input_size),
         Activation("relu"),
         Dense(layer2_size),
         Activation("relu"),
         Dense(output_size), Activation("softmax")]
    )
    model.compile(loss='mean_squared_error', optimizer='adagrad', metrics=['accuracy'])
    return model


def load(file_path):
    return load_model(file_path, compile=True)


def train():
    pass


def preditct():
    pass


(X_train, y_train), (X_test, y_test) = mnist.load_data()
X_train = X_train.reshape(60000, 784)
X_test = X_test.reshape(10000, 784)
X_train = X_train.astype('float32')
X_test = X_test.astype('float32')

n_classes = 10
print("Shape before one-hot encoding: ", y_train.shape)
Y_train = to_categorical(y_train, n_classes)
Y_test = to_categorical(y_test, n_classes)
print("Shape after one-hot encoding: ", Y_train.shape)

model = build_neural(0.05, (784,), 512, 512, 10)
print(X_train)
history = model.fit(X_train, Y_train,
                    batch_size=128, epochs=20,
                    verbose=2,
                    validation_data=(X_test, Y_test))

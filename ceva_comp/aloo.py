import SpeechRecognition as sr
import numpy as np
from scipy.io import wavfile
from scipy.io.wavfile import write

r = sr.Recognizer()

print("Speak Anything :")
# audio = r.listen(source)

# with open("Recording.m4a","rb") as my_file:
#     ccontent = my_file.read()
# wavio.write("wav_recording.wav",ccontent,22050)
# print(audio.__dir__())
with sr.AudioFile("Recording (3).wav") as source:
    #reads the audio file. Here we use record instead of
    #listen
    audio = r.record(source)

try:
    text = r.recognize_google(audio)
    print(text)
    print("You said : {}".format(text))
except:
    print("Sorry could not recognize what you said")
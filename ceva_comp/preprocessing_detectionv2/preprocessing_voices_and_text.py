import speech_recognition as sr
from stroke_apis import conn


def get_text_from_wav(wav_file):
    r = sr.Recognizer()
    with sr.AudioFile(wav_file) as source:
        # reads the audio file. Here we use record instead of
        # listen
        audio = r.record(source)

    try:
        text = r.recognize_google(audio)
        print(text)
        return text
    except:
        print("Sorry could not recognize what you said")


def check_slurred_speech(wav_text, id_text):
    # aflam ceea ce trebuia sa zica folosind
    text = conn.execute("select text from texts where id = (?)", (id_text,)).fetchone()[0]
    return compare_two_texts(wav_text, text)


def compare_two_texts(text_said, original_text):
    # todo maybe upgrade
    text_said = text_said.split(' ')
    original_text = original_text.split(' ')
    mistakes = 0
    for i in range(len(text_said)):
        if text_said[i] != original_text[i]:
            mistakes += 1
    return mistakes


def check_similarity(original_text_id, input_text):
    # TODO MAYBE UPGRADE
    text = conn.execute("select text from texts where id = (?)", (original_text_id,)).fetchone()[0]
    input_text = input_text.split(' ')
    input_text = list(filter(lambda x: x != "", input_text))
    text = text.split(' ')
    minim_length = min(len(input_text), len(text))
    differences = 0
    for word in range(minim_length):
        differences += len(list(map(lambda x, y: x != y, text[word], input_text[word])))
    differences += len("".join(input_text[minim_length:]))
    differences += len("".join(text[minim_length:]))
    print(text)
    return differences, len("".join(text))
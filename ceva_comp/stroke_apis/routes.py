from flask import request, jsonify
from stroke_apis import app, conn
import json
from werkzeug.utils import secure_filename
# from detection import preprocessing_images
from detection import preprocessing, take_decision
import os, random, json


@app.route('/check_symmetry_send_img', methods=['GET', 'POST'])
def check_symmetry():
    if request.method == 'POST':
        preprocess = preprocessing.preprocess_data()

        # print(request.files)
        f = request.files['image']
        filename = f.filename
        f.save(os.path.join(app.config['UPLOAD_FOLDER_PHOTOS'], filename))

    return jsonify(
        preprocess.return_face_parts(os.path.join(app.config['UPLOAD_FOLDER_PHOTOS'], filename)))


@app.route('/get_text', methods=['GET'])
def get_voices():
    if request.method == "GET":
        texts = conn.cursor().execute("select * from text").fetchall()
        id, text = random.choice(texts)
    return jsonify({"id": id, "text": text})


@app.route('/parse_voice', methods=['GET', 'POST'])
def parse_voice():
    if request.method == "POST":
        # recordingul
        preprocess = preprocessing.preprocess_data()
        f = request.files['recording']
        # id-ul textului
        id_text = request.form.getlist('id_text')
        filename = f.filename
        f.save(os.path.join(app.config['UPLOAD_FOLDER_RECORDINGS'], filename))
        # aflam ce a zis de fapt vorbitorul
        said = preprocess.get_text_from_wav(
            os.path.join(app.config['UPLOAD_FOLDER_RECORDINGS'], filename))
        # vrem sa determinam asemanarea dintre ce a zis si ce trebuia sa zica
        nr_mistakes = preprocess.check_slurred_speech(said, int(id_text[0]))
    return jsonify({"speech_test":nr_mistakes})


@app.route('/send_texting_test', methods=['GET', 'POST'])
def send_texting_test():
    if request.method == 'POST':
        preprocess = preprocessing.preprocess_data()
        id_text = int(request.form.getlist('id_text')[0])
        input_text = request.form.getlist('input_text')[0]
        # print(id_text)
        differences = preprocess.check_similarity(id_text, input_text)
    return jsonify({"mistakes": differences[0], "total_letters": differences[1]})


@app.route('/get_smiley_corners', methods=['GET', 'POST'])
def get_smiley_corners():
    if request.method == 'POST':
        preprocess = preprocessing.preprocess_data()
        f = request.files['image']
        filename = f.filename
        f.save(os.path.join(app.config['UPLOAD_FOLDER_PHOTOS'], filename))

    return jsonify(preprocess.return_smile_corners(os.path.join(app.config['UPLOAD_FOLDER_PHOTOS'], filename)))


@app.route('/send_final_result', methods=['GET', 'POST'])
def send_final_result():
    if request.method == "POST":
        # todo build the dictionary for the class that takes decidsion
        preprocess = preprocessing.preprocess_data()
        data = request.get_data()
        # print(data)
        x=request.form.getlist('secondPhotoDetails')

        print(x)

        # data = preprocess.build_data_for_decision(data)
        # builder = take_decision.builder(data)
        # print(builder)
        # print(builder)
    return jsonify({"ceva":"ceva"})

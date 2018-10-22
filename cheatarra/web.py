import json
from collections import OrderedDict
from itertools import product

from flask import Flask, render_template, request, Response
from flask.json import jsonify

from cheatarra.constants import SCALES, TUNINGS, OCTAVE, DEBUG
from cheatarra.theory import Fretboard, Key
from cheatarra.leds import strip, Color

app = Flask(__name__)

NOTES_MAP = OrderedDict([(n.name, n) for n in OCTAVE])
SCALES_MAP = OrderedDict([(s.name, s) for s in SCALES])
TUNINGS_MAP = OrderedDict([(t.name, t) for t in TUNINGS])


@app.route('/')
def home():
    return render_template('index.j2')


@app.route('/cheatarra.js')
def cheatarra_js():
    tuning_names = list(TUNINGS_MAP.keys())
    note_names = list(NOTES_MAP.keys())
    scale_names = list(SCALES_MAP.keys())
    return render_template('cheatarra.js',
                           tunings=json.dumps(tuning_names),
                           notes=json.dumps(note_names),
                           scales=json.dumps(scale_names),
                           cur_note=note_names[0],
                           cur_scale=scale_names[0],
                           cur_tuning=tuning_names[0],
                           )


@app.route('/pick', methods=['POST'])
def pick():
    note = NOTES_MAP[request.json['note']]
    scale = SCALES_MAP[request.json['scale']]
    tuning = TUNINGS_MAP[request.json['tuning']]

    fretboard = Fretboard(tuning, Key(note, scale))

    fretboard_colors = fretboard.dump()

    # if DEBUG:
    #     fretboard_colors = fretboard_colors[::6]

    print(Fretboard.get_leds_count())
    for i, color in enumerate(fretboard_colors[0:Fretboard.get_leds_count()][0:10]):
        print(i, color)

    for i in range(Fretboard.get_leds_count()):
        strip.setPixelColorRGB(i, 0, 0, 0)
    strip.show()

    for i, color in enumerate(fretboard_colors[0:Fretboard.get_leds_count()]):
        strip.setPixelColorRGB(i, color.red, color.green, color.blue)
    strip.show()

    return Response({}, status=200)


@app.route('/cheatarra.json')
def cheatarra_json():
    print(SCALES)
    print(TUNINGS)
    # print(Freatboard(TUNINGS[0], Key(C, SCALES[1])).dump())

    tuning_names = [t.name for t in TUNINGS]
    note_names = [n.name for n in OCTAVE]
    scale_names = [s.name for s in SCALES]

    all_variants = product(TUNINGS, OCTAVE, SCALES)

    out = dict(
        tunings=tuning_names,
        notes=note_names,
        scales=scale_names,
        leds={'{tuning.name}:{note.name}:{scale.name}'.format(tuning=tuning, note=note, scale=scale):
                  Fretboard(tuning, Key(note, scale)).dump()
              for tuning, note, scale in all_variants},
    )
    return jsonify(out)

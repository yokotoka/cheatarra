package cheatarra;

import thx.Ints;
import thx.Error;

import cheatarra.Common.Storeable;
import cheatarra.Theory.Note;
import cheatarra.Theory.Const;
import cheatarra.Theory.Tuning;
import cheatarra.Common.TLedsScheme;

typedef TString = Array<Note>;
typedef TFretboard = Array<TString>;


@:keep
class Fretboard extends Storeable {
    public var tuning:Tuning;
    public var strings(default,null):Int;
    public var frets(default,null):Int;
    public var notesScheme(default,null):TFretboard;

    public function new(tuning:Tuning, ?strings:Int, ?frets:Int) {
        this.strings = (strings == null) ? Const.STRINGS_COUNT : strings;
        this.frets = (frets == null) ? Const.FRETS_COUNT : frets;
        if (this.strings < 1) {
            throw new Error('Are you kidding? Your fretboard has no one string!');
        }
        if (this.strings != tuning.scheme.length) {
            throw new Error('Mismatch tuning(${tuning.scheme.length}) and strings($strings) count');
        }
        this.notesScheme = new TFretboard();
        this.set_tuning(tuning);
    }
    
    public function set_tuning(tuning:Tuning) {
        this.tuning = tuning;
        for (stringIdx in Ints.range(this.strings)) {
            this.notesScheme.insert(stringIdx, new TString());
            for (fretIdx in Ints.range(this.frets)) {
                var currentNote = null;
                if (fretIdx == 0) {
                    currentNote = tuning.scheme[this.strings - stringIdx - 1];
                } else {
                    currentNote = this.notesScheme[stringIdx][fretIdx - 1].transpose(1);
                }
                this.notesScheme[stringIdx].insert(fretIdx, currentNote);
            }
        }
    }

    override public function toString() {
        var fretboard = '';
        var string = '';
        for (stringIdx in Ints.range(this.strings)) {
            string = this.notesScheme[stringIdx].join(',');
            fretboard += '$string\n';
        }
        return '\n<Fretboard\n$fretboard>';
    }
}






@:keep
class CheatarraFreatboard extends Fretboard {
    public var ledsScheme(default,null):TLedsScheme;
    public var ledNoteMap(default,null):Map<Int, Note>;

    public function new(tuning:Tuning, ?strings:Int, ?frets:Int, ?ledsScheme:TLedsScheme) {
        this.ledsScheme = (ledsScheme == null) ? Const.LEDS_SCHEME : ledsScheme; //IT MUST BE BEFORE super()!!!
        this.ledNoteMap = new Map<Int, Note>(); //IT MUST BE BEFORE super()!!!

        super(tuning, strings, frets);

        if (this.ledsScheme.length != this.notesScheme.length) {
            throw new Error('Mismatch count of strings between ledsScheme (${this.ledsScheme.length})
            and notesScheme (${this.notesScheme.length}})');
        }
        if (this.ledsScheme[0].length != this.notesScheme[0].length) {
            throw new Error('Mismatch count of frets between ledsScheme (${this.ledsScheme[0].length})
            and notesScheme (${this.notesScheme[0].length}})');
        }
    }

    override public function set_tuning(tuning:Tuning) {
        super.set_tuning(tuning);

        for (stringIdx in Ints.range(this.strings)) {
            for (fretIdx in Ints.range(this.frets)) {
                this.ledNoteMap.set(
                    this.ledsScheme[stringIdx][fretIdx],
                    this.notesScheme[stringIdx][fretIdx]);
            }
        }
    }

}

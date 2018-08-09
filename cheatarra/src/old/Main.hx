package cheatarra;

import cheatarra.Common.Printable;
import cheatarra.Common.Interval;
import cheatarra.Common.AbstractNote;

import thx.error.AbstractMethod;
import cheatarra.Main.CheatarraFreatboard;
import thx.fp.Lists.StringList;
import cheatarra.Main.Tuning;
import thx.Error;
import thx.Ints;
using thx.Functions;
using thx.Ints;
using thx.Iterators;
using thx.Iterables;
using thx.Arrays;
using thx.Maps;
using StringTools;







typedef JsonTuning = {
    var name:String;
    var scheme:String;
}

typedef LedsScheme = Array<Array<Int>>;


@:keep
class Lib {
    public static function str(obj:Printable):String {
        return obj.toString();
    }

    public static function trace(obj:Dynamic):Void {
        return trace(Std.string(obj));
    }
}


@:keep
class Const {
    // singletone technique
//    public static var instance(default, null):Const = new Const();
//    private function new () {}  // private constructor
    public function new() {}
    public static inline var PI = 3.1415;

    public static var A4_NOTE(default, never):Note = new Note(AbstractNote.A, 4);

    // Order started from C because octave delimiter located between B and C
    public static var CHROMATIC(default, null): Array<AbstractNote> = [
        AbstractNote.C,
        AbstractNote.Db,
        AbstractNote.D,
        AbstractNote.Eb,
        AbstractNote.E,
        AbstractNote.F,
        AbstractNote.Gb,
        AbstractNote.G,
        AbstractNote.Ab,
        AbstractNote.A,
        AbstractNote.Bb,
        AbstractNote.B,
    ];



    public static var INTERVALS(default, null): Array<Interval> = [
        Interval.P1_PerfectUnison,
        Interval.m2_MinorSecnod,
        Interval.M2_MajorSecond,
        Interval.m3_MinorThird,
        Interval.M3_MajorThird,
        Interval.P4_PerfectFourth,
        Interval.TT_A4_d5_Tritone,
        Interval.P5_PerfectFifth,
        Interval.m6_MinorSixth,
        Interval.M6_MajorSixth,
        Interval.m7_MinorSeventh,
        Interval.M7_MajorSeventh,
    ];

    public static var NOTE_ALIASES(default, null):Map<String, AbstractNote> = [
        'A'  => AbstractNote.A,
        'A#' => AbstractNote.Bb,
        'Bb' => AbstractNote.Bb,
        'B'  => AbstractNote.B,
        'C'  => AbstractNote.C,
        'C#' => AbstractNote.Db,
        'Db' => AbstractNote.Db,
        'D'  => AbstractNote.D,
        'D#' => AbstractNote.Eb,
        'Eb' => AbstractNote.Eb,
        'E'  => AbstractNote.E,
        'F'  => AbstractNote.F,
        'F#' => AbstractNote.Gb,
        'Gb' => AbstractNote.Gb,
        'G'  => AbstractNote.G,
        'G#' => AbstractNote.Ab,
        'Ab' => AbstractNote.Ab,
    ];



}

@:keep
class Config {
    public function new () {
//        this.NOTE_ALIAS_MAP.set('C#', AbstractNote.Db);
    }

    public var STRINGS_COUNT:Int = 6;
    public var FRETS_COUNT:Int = 22;
    public var LEDS_SCHEME:LedsScheme = [
        //  neck                                                              bridge
        //   1 2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17  18  19  20  21  22
        [6,7, 18,19,30,31,42,43,54,55,66,67,78,79,90,91,102,103,114,115,126,127], //slim
        [5,8, 17,20,29,32,41,44,53,56,65,68,77,80,89,92,101,104,113,116,125,128],
        [4,9, 16,21,28,33,40,45,52,57,64,69,76,81,88,93,100,105,112,117,124,129],
        [3,10,15,22,27,34,39,46,51,58,63,70,75,82,87,94,99,106, 111,118,123,130],
        [2,11,14,23,26,35,38,47,50,59,62,71,74,83,86,95,98,107, 110,119,122,131],
        [1,12,13,24,25,36,37,48,49,60,61,72,73,84,85,96,97,108, 109,120,121,132], //FAT
    ];

    public var TUNINGS:Array<Tuning> = [
        new Tuning('Standard', [
            new Note(AbstractNote.E, 2),
            new Note(AbstractNote.A, 2),
            new Note(AbstractNote.D, 3),
            new Note(AbstractNote.G, 3),
            new Note(AbstractNote.B, 3),
            new Note(AbstractNote.E, 4),
        ]),
        new Tuning('DADGAD', [
            new Note(AbstractNote.D, 2),
            new Note(AbstractNote.A, 2),
            new Note(AbstractNote.D, 3),
            new Note(AbstractNote.G, 3),
            new Note(AbstractNote.A, 3),
            new Note(AbstractNote.D, 4)])
    ];


    public var A4_FREQUENCY(default, never):Int = 440;



    public var SCALES: Array<Scale> = [
        new Scale('Major', [
            Interval.P1_PerfectUnison,
            Interval.M2_MajorSecond,
            Interval.M3_MajorThird,
            Interval.P4_PerfectFourth,
            Interval.P5_PerfectFifth,
            Interval.M6_MajorSixth,
            Interval.M7_MajorSeventh]),
        new Scale('Minor Pentatonic', [
            Interval.P1_PerfectUnison,
            Interval.m3_MinorThird,
            Interval.P4_PerfectFourth,
            Interval.P5_PerfectFifth,
            Interval.m7_MinorSeventh]),


    ];
}

@:keep
class NoteStringName {
    var note: AbstractNote;
    var sharp_name: String;
    var flat_name: String;

    public function new (note:AbstractNote, sharp_name:String, flat_name:String) {
        this.sharp_name = sharp_name;
        this.flat_name = flat_name;
        this.note = note;
    }
}






class Trash implements Printable {
    public function new() {}
    public function toString() {
        return '';
    }
}


@:keep
class Note implements Printable {
    var note:AbstractNote;
    var octave:Int;
    public var midi_note_number(get, never):Int;
    public function get_midi_note_number():Int {
        return ((this.octave + 1) * Const.CHROMATIC.length) + Const.CHROMATIC.indexOf(note);
    }

    public function new(note:AbstractNote, octave:Int) {
        this.note = note;
        this.octave = octave;

    }

    public static function new_from_string(string:String):Note {
        var note_and_octave:Array<String> = string.split('_');
        if (note_and_octave.length != 2) {
            throw new Error('Must be in "{{NOTE}}_{{OCTAVE}}" format! Given: $note_and_octave');
        }
        var note_alias = note_and_octave[0];
        if (!Const.NOTE_ALIASES.exists(note_alias)) {
            throw new Error('Must be one of existing note alias! Given: $note_alias');
        }
        var abstract_note = Const.NOTE_ALIASES[note_alias];
        var octave = Ints.parse(note_and_octave[1]);
        return new Note(abstract_note, octave);
    }

    public static function new_from_midi_number(midi_note_number:Int):Note {
        var octave = Std.int(midi_note_number / Const.CHROMATIC.length) - 1;
        var note_index = midi_note_number % Const.CHROMATIC.length;
        if (note_index < 0) {
            note_index = Const.CHROMATIC.length + note_index;
            octave -= 1;
        }
        var abstract_note = Const.CHROMATIC[note_index];
        //trace('new_from_midi $this: ${abstract_note}_$octave (nn:$midi_note_number/idx:$note_index)');
        return new Note(abstract_note, octave);
    }

    public function transpose(semitones:Int=0):Note {
        if (semitones == 0) {
            return this;
        }
        var target_note_number = this.midi_note_number + semitones;
//        trace('transpose $this: ${this.midi_note_number} => $target_note_number');
        return new_from_midi_number(target_note_number);
    }

    public function toString() {
        return '${this.note}_${this.octave}';
    }
}


@:keep
class Scale implements Printable {
    var name:String;
    public var interval_set:Array<Interval>;

    public function new(name:String, interval_set:Array<Interval>) {
        this.name = name;
        this.interval_set = interval_set;
    }

    public static function from_json() {
        //TODO
    }

    public function toString() {
        return Std.string(this.name);
    }
}



@:keep
class Key implements Printable {
    var root:AbstractNote;
    var scale:Scale;
    var notes:Array<AbstractNote>;
    var config:Config;

    public function new (root:AbstractNote, scale:Scale) {
        this.root = root;
        this.scale = scale;
        this.notes = [];

        var chromatic_from_root:Array<AbstractNote> = [];
        var root_start_index = Const.CHROMATIC.indexOf(this.root);
        Lib.trace(root_start_index);

        // for 12 times we repeat all notes started from root. (We need a chromatic scale starting from root).
        for (i in 0...Const.CHROMATIC.length) {
            var cur_idx = (root_start_index + i) % Const.CHROMATIC.length;
            chromatic_from_root.push(Const.CHROMATIC[cur_idx]);
        }

        // filter chromatic scale with needed intervals
        for (current_interval in this.scale.interval_set) {
            var interval_index = Const.INTERVALS.indexOf(current_interval);
            var interval_note = chromatic_from_root[interval_index];
            this.notes.push(interval_note);
        }

        Lib.trace(chromatic_from_root);
        Lib.trace(this.notes);
    }

    public function toString() {
        return '<Scale ${this.root} ${this.scale} ${this.notes}>';
    }
}

@:keep
class Tuning implements Printable {
    var name:String;
    public var scheme(default,null):Array<Note>; //from FAT to slim, eg EADGBE, DADGAD, ...
    var strings_count:Int;

    public function new (name:String, scheme:Array<Note>) {
        this.name = name;
        this.scheme = scheme;
        this.strings_count = scheme.length;
    }

    public static function from_json(json:Dynamic):Tuning {
        var tuning:JsonTuning = haxe.Json.parse(json);
        var scheme:Array<Note> = [];
        var scheme_items: Array<String> = tuning.scheme.split(',').map.fn(_.trim());
        for(item in scheme_items) {
            scheme.push(Note.new_from_string(item));
        }
        return new Tuning(tuning.name, scheme);
//        return new Config().TUNINGS[0];
    }

    public function toString() {
        return '<Tuning ${this.name} ${this.scheme}>';
    }
}

typedef TString = Array<Note>;
typedef TFretboard = Array<TString>;



@:keep
class FretboardOld {
    public var tuning(default,set):Tuning;
    public var strings(default,null):Int;
    public var frets(default,null):Int;
    public var notes_scheme(default,null):TFretboard;

    public function new(tuning:Tuning, strings:Int, frets:Int) {
        this.strings = strings;
        this.frets = frets;
        if (strings < 1) {
            throw new Error('Are you kidding? Your fretboard has no one string!');
        }
        if (strings != tuning.scheme.length) {
            throw new Error('Mismatch tuning(${tuning.scheme.length}) and strings($strings) count');
        }
        this.notes_scheme = new TFretboard();

        this.set_tuning(tuning);
    }

    public function set_tuning(tuning:Tuning) {
        this.tuning = tuning;
        for (string_i in Ints.range(this.strings)) {
            this.notes_scheme.insert(string_i, new TString());
            for (fret_i in Ints.range(this.frets)) {
                var current_note = null;
                if (fret_i == 0) {
                    current_note = tuning.scheme[this.strings - string_i - 1];
                } else {
                    current_note = this.notes_scheme[string_i][fret_i - 1].transpose(1);
                }
                this.notes_scheme[string_i].insert(fret_i, current_note);
            }
        }
    }

    public function toString() {
        var fretboard = '';
        var string = '';
        for (string_i in Ints.range(this.strings)) {
            string = this.notes_scheme[string_i].join(',');
            fretboard += '$string\n';
        }
        return '\n<Fretboard\n$fretboard>';
    }
}


@:keep
class CheatarraFreatboard extends FretboardOld {
    public var leds_scheme(default,null):LedsScheme;
    public var led_note_map(default,null):Map<Int, Note>;

    public function new(tuning:Tuning, strings:Int, frets:Int, leds_scheme:LedsScheme) {
        this.leds_scheme = leds_scheme; //IT MUST BE BEFORE super()!!!
        this.led_note_map = new Map<Int, Note>(); //IT MUST BE BEFORE super()!!!

        super(tuning, strings, frets);

        if (this.leds_scheme.length != this.notes_scheme.length) {
            throw new Error('Mismatch count of strings between leds_scheme (${this.leds_scheme.length})
            and notes_scheme (${this.notes_scheme.length}})');
        }
        if (this.leds_scheme[0].length != this.notes_scheme[0].length) {
            throw new Error('Mismatch count of frets between leds_scheme (${this.leds_scheme[0].length})
            and notes_scheme (${this.notes_scheme[0].length}})');
        }
    }

    override public function set_tuning(tuning:Tuning) {
        super.set_tuning(tuning);

        for (string_i in Ints.range(this.strings)) {
            for (fret_i in Ints.range(this.frets)) {
                this.led_note_map.set(
                    this.leds_scheme[string_i][fret_i],
                    this.notes_scheme[string_i][fret_i]);
            }
        }
    }

}
















@:keep
class Foo {
    var v:String;
    public function new(v:String) {
        this.v = v;
    }

    

    public function toString() {
        return 'V:${this.v}';
    }
}





@:keep
class Main {
    public static function main () {
        var config = new Config();
//        trace(Lib.str(new Note(AbstractNote.A, 2)));
//        trace(Lib.str(new Key(AbstractNote.C, config.SCALES[0])));
        trace("hello");
        //trace(Lib.str(new CheatarraFreatboard(config.TUNINGS[0], config.STRINGS_COUNT, config.FRETS_COUNT, config.LEDS_SCHEME)));

        var foo = new Foo('ccc');
        var fb = new CheatarraFreatboard(config.TUNINGS[0], config.STRINGS_COUNT, config.FRETS_COUNT, config.LEDS_SCHEME);

        trace('${foo}');
        trace('${fb}');
//
//        trace(Tuning.from_json('{"name":"Standard", "scheme": "E_2, A_2, D_3, G_3, B_3, E_4"}').toString());
//        trace(config.TUNINGS[1].toString());

//        var new_note = new Note(AbstractNote.A, 4);
//        trace(Lib.str(new_note));
//        trace(Lib.str(new_note.transpose(-1)));
//        trace(Lib.str(new_note.transpose()));
//        trace(Lib.str(new_note.transpose(1)));
//        trace(Lib.str(new_note.transpose(2)));
//        trace(Lib.str(new_note.transpose(3)));
//        trace(Lib.str(new_note.transpose(4)));
//        var new_note2 = new Note(AbstractNote.C, -1);
////        trace(Lib.str(new_note2.transpose(-13)));
////        trace(Lib.str(new_note2.transpose(-2)));
////        trace(Lib.str(new_note2.transpose(-1)));
//        trace(Lib.str(new_note2.transpose(0)));
//        trace(Lib.str(new_note2.transpose(-1)));
//        trace(Lib.str(new_note2.transpose(-2)));
//        trace(Lib.str(new_note2.transpose(-3)));
//        trace(Lib.str(new_note2.transpose(-4)));
//        trace(Lib.str(new_note2.transpose(-5)));
//        trace(Lib.str(new_note2.transpose(-6)));
//        trace(Lib.str(new_note2.transpose(-7)));
//        trace(Lib.str(new_note2.transpose(-8)));
//        trace(Lib.str(new_note2.transpose(-9)));
//        trace(Lib.str(new_note2.transpose(-10)));
//        trace(Lib.str(new_note2.transpose(-11)));
//        trace(Lib.str(new_note2.transpose(-12)));
//        trace(Lib.str(new_note2.transpose(-13)));




        //
    }

}
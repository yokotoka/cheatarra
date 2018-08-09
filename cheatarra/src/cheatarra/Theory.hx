package cheatarra;

import haxe.EnumTools;
import thx.Error;

import cheatarra.Common.AbstractNote;
import cheatarra.Common.Interval;
import cheatarra.Common.Storeable;
import cheatarra.Common.Misc;
import cheatarra.Common.TScale;
import cheatarra.Common.TKey;
import cheatarra.Common.TTuning;
import cheatarra.Common.TLedsScheme;
//import cheatarra.Common.TNote;

using StringTools;


@:keep
class Const {
    public function new() {}
    
    public static var A4_NOTE(default, never):Note = new Note(AbstractNote.A, 4);
    public static var A4_FREQUENCY(default, never):Int = 440;
    public static var STRINGS_COUNT(default, never):Int = 6;
    public static var FRETS_COUNT(default, never):Int = 22;
    public static var LEDS_SCHEME(default, never):TLedsScheme = [
    //  neck                                                              bridge
    //   1 2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17  18  19  20  21  22
        [6,7, 18,19,30,31,42,43,54,55,66,67,78,79,90,91,102,103,114,115,126,127], //slim
        [5,8, 17,20,29,32,41,44,53,56,65,68,77,80,89,92,101,104,113,116,125,128],
        [4,9, 16,21,28,33,40,45,52,57,64,69,76,81,88,93,100,105,112,117,124,129],
        [3,10,15,22,27,34,39,46,51,58,63,70,75,82,87,94,99,106, 111,118,123,130],
        [2,11,14,23,26,35,38,47,50,59,62,71,74,83,86,95,98,107, 110,119,122,131],
        [1,12,13,24,25,36,37,48,49,60,61,72,73,84,85,96,97,108, 109,120,121,132], //FAT
    ];

    public static var FILLED(default, never):String = 'o';
    public static var EMPTY(default, never):String = '.';

    public static var NOTE_ALIASES(default, never):Map<String, AbstractNote> = [
        'a'  => AbstractNote.A,
        'a#' => AbstractNote.Bb,
        'bb' => AbstractNote.Bb,
        'b'  => AbstractNote.B,
        'c'  => AbstractNote.C,
        'c#' => AbstractNote.Db,
        'db' => AbstractNote.Db,
        'd'  => AbstractNote.D,
        'd#' => AbstractNote.Eb,
        'eb' => AbstractNote.Eb,
        'e'  => AbstractNote.E,
        'f'  => AbstractNote.F,
        'f#' => AbstractNote.Gb,
        'gb' => AbstractNote.Gb,
        'g'  => AbstractNote.G,
        'g#' => AbstractNote.Ab,
        'ab' => AbstractNote.Ab,
    ];
}


@:keep
class Note extends Storeable {
    var abstract_note:AbstractNote;
    var octave:Int;
    
    public var noteNumber(get, never):Int;
    
    public function get_noteNumber():Int {
        return ((this.octave + 1) * Misc.chromaticLen) + Type.enumIndex(this.abstract_note);
    }

    public function new(abstract_note:AbstractNote, octave:Int) {
        this.abstract_note = abstract_note;
        this.octave = octave;
    }

    public static function newFromNoteNumber(get_noteNumber:Int):Note {
        var octave = Std.int(get_noteNumber / Misc.chromaticLen) - 1;
        var note_index = get_noteNumber % Misc.chromaticLen;
        if (note_index < 0) {
            note_index = Misc.chromaticLen + note_index;
            octave -= 1;
        }
        var abstract_note = AbstractNote.createByIndex(note_index);
        return new Note(abstract_note, octave);
    }

    public function transpose(semitones:Int=0):Note {
        if (semitones == 0) {
            return Note.newFromNoteNumber(this.noteNumber);
        }
        var targetNoteNumber = this.noteNumber + semitones;
        return Note.newFromNoteNumber(targetNoteNumber);
    }

    public override static function ofObj(o: String): Note {
        var note_and_octave:Array<String> = o.split('_');
        if (note_and_octave.length != 2) {
            throw new Error('Must be in "{{NOTE}}_{{OCTAVE}}" format! Given: $note_and_octave');
        }
        var note_alias = note_and_octave[0].trim().toLowerCase();
        if (!Const.NOTE_ALIASES.exists(note_alias)) {
            throw new Error('Must be one of existing abstract_note alias! Given: $note_alias');
        }
        var abstract_note = Const.NOTE_ALIASES[note_alias];
        var octave = Std.parseInt(note_and_octave[1].trim());
        return new Note(abstract_note, octave);
    }

    public override function toObj(): String {
        return '${this.abstract_note}_${this.octave}';
    }
}


@:keep
class Scale extends Storeable {
    public var name: String;
    public var intervalSet: Array<Interval>;

    public function new(name:String, intervalSet:Array<Interval>) {
        this.name = name;
        this.intervalSet = intervalSet;
    }

    public override function toObj(): TScale {
        var intervalSet = '';
        for (idx in 0...Misc.chromaticLen) {
            var currentInterval:Interval = EnumTools.createByIndex(Interval, idx);
            if (this.intervalSet.indexOf(currentInterval) > -1) {
                intervalSet = intervalSet + Const.FILLED;
            } else {
                intervalSet = intervalSet + Const.EMPTY;
            }
        }
        var result:TScale = {
            name: this.name, 
            intervalSet: intervalSet,
        }
        return result;
    }

    public static override function ofObj(o:TScale): Scale {
        var intervalSet: Array<Interval> = [];
        for (idx in 0...o.intervalSet.length) {
            if (o.intervalSet.charAt(idx) == Const.FILLED) {
                var currentInterval:Interval = EnumTools.createByIndex(Interval, idx);
                intervalSet.push(currentInterval);
            }
        }
        return new Scale(o.name, intervalSet);
    }
}


@:keep
class Key extends Storeable {
    var root:AbstractNote;
    var scale:Scale;
    var notes:Array<AbstractNote>;

    public function new (root:AbstractNote, scale:Scale) {
        this.root = root;
        this.scale = scale;
        this.notes = [];

        var chromatic_from_root:Array<AbstractNote> = [];
        var root_start_index = Type.enumIndex(this.root);

        // for 12 times we repeat all notes started from root. (We need a chromatic scale starting from root).
        for (i in 0...Misc.chromaticLen) {
            var cur_idx = (root_start_index + i) % Misc.chromaticLen;
            chromatic_from_root.push(Type.createEnumIndex(AbstractNote, cur_idx));
        }

        // filter chromatic scale with needed intervals
        for (current_interval in this.scale.intervalSet) {
            var interval_index = Type.enumIndex(current_interval);
            var interval_note = chromatic_from_root[interval_index];
            this.notes.push(interval_note);
        }
    }

    public override function toObj(): TKey {
        var result:TKey = {
            root: Std.string(this.root), 
            scale: this.scale.toObj(),
        }
        return result;
    }

    public static override function ofObj(o:TKey): Key {
        var scale: Scale = Scale.ofObj(o.scale);
        var root: AbstractNote = EnumTools.createByName(AbstractNote, o.root);
        return new Key(root, scale);
    }
}


@:keep
class Tuning extends Storeable {
    var strings_count:Int;
    var name:String;
    public var scheme(default,null):Array<Note>; //from FAT to slim, eg EADGBE, DADGAD, ...

    public function new (name:String, scheme:Array<Note>) {
        this.name = name;
        this.scheme = scheme;
        this.strings_count = scheme.length;
    }

     public override function toObj(): TTuning {
        var result:TTuning = {
            name: this.name, 
            scheme: [for (note in this.scheme) note.toObj()].join(','),
        }
        return result;
    }

    public static override function ofObj(o:TTuning): Tuning {
        var note_objs = o.scheme.split(',');
        var scheme: Array<Note> = [];
        for (note_obj in note_objs) {
            scheme.push(Note.ofObj(note_obj.trim()));
        }
        return new Tuning(o.name, scheme);
    }   

    public override function toString() {
        return '<Tuning ${this.name} ${this.scheme}>';
    }
}


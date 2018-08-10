package cheatarra;

import haxe.EnumTools;
import thx.Error;

import cheatarra.Common.Const;
import cheatarra.Common.AbstractNote;
import cheatarra.Common.Interval;
import cheatarra.StorageTypes.Storeable;
import cheatarra.Common.Misc;
import cheatarra.StorageTypes.TScale;
import cheatarra.StorageTypes.TKey;
import cheatarra.StorageTypes.TTuning;
import cheatarra.Common.TLedsScheme;
//import cheatarra.Common.TNote;

using StringTools;


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

    override public static function ofObj(o: String): Note {
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

    override public function toObj(): String {
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

    override public function toObj(): TScale {
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

    override public static function ofObj(o:TScale): Scale {
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

    override public function toObj(): TKey {
        var result:TKey = {
            root: Std.string(this.root), 
            scale: this.scale.toObj(),
        }
        return result;
    }

    override public static function ofObj(o:TKey): Key {
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

    override public function toObj(): TTuning {
        var result:TTuning = {
            name: this.name, 
            scheme: [for (note in this.scheme) note.toObj()].join(','),
        }
        return result;
    }

    override public static function ofObj(o:TTuning): Tuning {
        var note_objs = o.scheme.split(',');
        var scheme: Array<Note> = [];
        for (note_obj in note_objs) {
            scheme.push(Note.ofObj(note_obj.trim()));
        }
        return new Tuning(o.name, scheme);
    }   

    override public function toString() {
        return '<Tuning ${this.name} ${this.scheme}>';
    }
}


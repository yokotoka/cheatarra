package ;


import haxe.ds.ObjectMap;

abstract ObjectSet<T : {}>(ObjectMap<T, Bool>) {
    inline public function new() {
        this = new ObjectMap<T, Bool>();
    }

    inline public function add(v : T) : Void {
        this.set(v, true);
    }

    inline public function exists(v : T) : Bool {
        return this.exists(v);
    }

    inline public function remove(v : T) : Void {
        this.remove(v);
    }
}

@:keep
class Config {
    public function new () {}

    public var A4_FREQUENCY(default, never):Int = 440;
    public var A4_SPECIFIC_NOTE(default, never):Note = new Note(AbstractNote.A, 4);
    public var CHROMATIC: Array<AbstractNote> = [
        AbstractNote.A,
        AbstractNote.Bb,
        AbstractNote.B,
        AbstractNote.C,
        AbstractNote.Db,
        AbstractNote.D,
        AbstractNote.Eb,
        AbstractNote.E,
        AbstractNote.F,
        AbstractNote.Gb,
        AbstractNote.G,
        AbstractNote.Ab
    ];

//    public static var CHROMATIC_STRING_NAMES: Map<AbstractNote, NoteStringName> = [
//        AbstractNote.A => new NoteStringName('A', 'A'),
//    ];

    public var CHROMATIC_STRING_NAMES:Map<AbstractNote, NoteStringName> = [
        AbstractNote.A  => new NoteStringName(AbstractNote.A,  'A',  'A'),
        AbstractNote.Bb => new NoteStringName(AbstractNote.Bb, 'A#', 'Bb'),
        AbstractNote.B  => new NoteStringName(AbstractNote.B,  'B',  'B'),
        AbstractNote.C  => new NoteStringName(AbstractNote.C,  'C',  'C'),
        AbstractNote.Db => new NoteStringName(AbstractNote.Db, 'C#', 'Db'),
        AbstractNote.D  => new NoteStringName(AbstractNote.D,  'D',  'D'),
        AbstractNote.Eb => new NoteStringName(AbstractNote.Eb, 'D#', 'Eb'),
        AbstractNote.E  => new NoteStringName(AbstractNote.E,  'E',  'E'),
        AbstractNote.F  => new NoteStringName(AbstractNote.F,  'F',  'F'),
        AbstractNote.Gb => new NoteStringName(AbstractNote.Gb, 'F#', 'Gb'),
        AbstractNote.G  => new NoteStringName(AbstractNote.G,  'G',  'G'),
        AbstractNote.Ab => new NoteStringName(AbstractNote.Ab, 'G#', 'Ab'),

    ];

    public var INTERVALS: Array<Interval> = [
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

@:keep
enum AbstractNote {
    A;
    Bb;
    B;
    C;
    Db;
    D;
    Eb;
    E;
    F;
    Gb;
    G;
    Ab;
}


@:keep
enum Interval {
    P1_PerfectUnison;
    m2_MinorSecnod;
    M2_MajorSecond;
    m3_MinorThird;
    M3_MajorThird;
    P4_PerfectFourth;
    TT_A4_d5_Tritone;
    P5_PerfectFifth;
    m6_MinorSixth;
    M6_MajorSixth;
    m7_MinorSeventh;
    M7_MajorSeventh;
}




@:keep
class Note {
    var note:AbstractNote;
    var octave:Int;

    public function new(note:AbstractNote, octave:Int) {
        this.note = note;
        this.octave = octave;

    }

    public function toString() {
        return this.note + '_' + this.octave;
    }
}


@:keep
class Scale {
    var name:String;
    public var interval_set:Array<Interval>;

    public function new(name:String, interval_set:Array<Interval>) {
        this.name = name;
        this.interval_set = interval_set;
    }

    public function toString() {
        return this.name;
    }
}



@:keep
class Key {
    var root:AbstractNote;
    var scale:Scale;
    var notes:Array<AbstractNote>;
    var config:Config;

    public function new (root:AbstractNote, scale:Scale, config:Config) {
        this.config = config;
        this.root = root;
        this.scale = scale;
        this.notes = [];
        //this.settings.CHROMATIC

        var chromatic_from_root:Array<AbstractNote> = [];
        var root_start_index = this.config.CHROMATIC.indexOf(this.root);
        trace(root_start_index);

        for (i in 0...this.config.CHROMATIC.length) {
            var cur_idx = (root_start_index + i) % this.config.CHROMATIC.length;
            chromatic_from_root.push(this.config.CHROMATIC[cur_idx]);
        }

        for (current_interval in this.scale.interval_set) {
            var interval_index = this.config.INTERVALS.indexOf(current_interval);
            var interval_note = chromatic_from_root[interval_index];
            this.notes.push(interval_note);
        }

        trace(chromatic_from_root);
        trace(this.notes);


    }

    public function toString() {
        return '<Scale ' + this.root + ' ' + this.scale + ' ' + this.notes + '>';
    }
}


@:keep
class Theory {
    public static function main () {
        var config = new Config();

        trace(new Note(AbstractNote.A, 2));
        trace(new Key(AbstractNote.C, config.SCALES[0], config));
    }

}
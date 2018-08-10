package cheatarra;

import thx.Error;


typedef TLedsScheme = Array<Array<Int>>;


@:keep
enum AbstractNote {
    C;
    Db;
    D;
    Eb;
    E;
    F;
    Gb;
    G;
    Ab;
    A;
    Bb;
    B;
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
class Misc {
    public static var chromaticLen(get,never):Int;

    public static function get_chromaticLen() {
        var abstractNoteLen = AbstractNote.getConstructors().length;
        var intervalLen = Interval.getConstructors().length;
        if (abstractNoteLen == intervalLen) {
            return abstractNoteLen;
        } else {
            throw new Error('Length of abstract note enum and interval enum must be same');
        }
    }
}

@:keep
class Const {
    public function new() {}
    
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

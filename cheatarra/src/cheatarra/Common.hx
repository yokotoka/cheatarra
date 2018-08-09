package cheatarra;

import thx.Error;

@:keepSub
class Storeable {
    public function toObj(): Dynamic {
        throw new Error('Must be implemented dump() method');
    }
    public static function ofObj(o:Dynamic): Storeable {
        throw new Error('Must be implemented load() method');
    }

    public function toString(): String {
        return '${this.toObj()}';
    }
}


typedef TLedsScheme = Array<Array<Int>>;

typedef TScale = {
    var name: String;
    var intervalSet: String;
}

typedef TKey = {
    var root: String;
    var scale: TScale;
}

typedef TTuning = {
    var name: String;
    var scheme: String;
}


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

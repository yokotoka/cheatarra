package cheatarra;

import thx.Error;

import cheatarra.Common.TLedsScheme;

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

typedef TFretboard = {
    var tuning: TTuning;
    var strings: Int;
    var frets: Int;
}

typedef TCheatarraFreatboard = { > TFretboard,
    var ledsScheme: TLedsScheme;
}

package cheatarra;

import cheatarra.Fretboard.CheatarraFreatboard;
using StringTools;

import cheatarra.StorageTypes.TTuning;
import cheatarra.Theory.Tuning;
import cheatarra.Theory.Key;
import cheatarra.StorageTypes.TKey;
import cheatarra.Theory.Scale;
//import cheatarra.Common.Jsonable;
import cheatarra.Common.Const;
import cheatarra.Common.Interval;
import cheatarra.Common.Misc;
import cheatarra.Theory.Note;
import cheatarra.Fretboard.Fretboard;


@:keep
class Main {
    public static function main () {
/*         var x = new Scale('Hello', [Interval.P5_PerfectFifth, Interval.M3_MajorThird]);
        trace(x.toObj());
        var y:Scale = Scale.ofObj(x.toObj());
        trace('$x\n$y');
        trace(haxe.Json.stringify(y.toObj())); */

        var key:TKey = {
            root: 'A',
            scale: {
                name: 'Major',
                intervalSet: 'o.o.oo.o.o.o',
            },
        }

    /*     trace(Key.ofObj(key));
        trace(haxe.Json.stringify(Key.ofObj(key).toObj()));
         */
        var tuning:TTuning = {
            name: 'DADGAD',
            scheme: 'D_2,a_2,D_3,G_3,A_3,D_4',
        }

        trace(Tuning.ofObj(tuning));
        trace(haxe.Json.stringify(Tuning.ofObj(tuning).toObj()));

        var fb:CheatarraFreatboard = new CheatarraFreatboard(Tuning.ofObj(tuning));
        trace(Std.string(fb));
        trace(haxe.Json.stringify(fb.toObj()));

        //trace(Std.string())
//        var n = Note.load('a_2');
//        for (i in 0...20) {
//            trace('$n, ${n.noteNumber}');
//            n = n.transpose(1);           
//        }
//        trace(Type.enumIndex(Interval.M7_MajorSeventh));
//        trace(Std.string(Interval.getConstructors().length));
//        trace("hello");
//        //trace(Misc.abstractNoteLen);
//        trace(Std.string(Interval.P1_PerfectUnison));
//        trace(Std.string(Note.load('A_2')));
//        trace(Std.string(n.transpose(1)));

    }
}



package ;

@:keep
interface Printable {
    public function toString():String;
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




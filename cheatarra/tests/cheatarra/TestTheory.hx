package cheatarra;

import utest.Assert;
//import thx.color.Argb;
import cheatarra.Theory;


class TestTheory {
  public function new() { }

  public function testBasics() {
    var note = new Note.load('A_2');
    Assert.equals(0xFF, note);
    Assert.equals(0xFF, note);
    Assert.equals(0x00, note);
    Assert.equals(0x00, note);
  }
}
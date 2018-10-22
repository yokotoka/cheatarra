import cheatarra.colors as c
from cheatarra.theory import AbstractNote, Scale, Tuning, Note

# DEBUG = True
DEBUG  = False
C = AbstractNote('C')
Db = AbstractNote('C#', {'Db'})
D = AbstractNote('D')
Eb = AbstractNote('D#', {'Eb'})
E = AbstractNote('E')
F = AbstractNote('F')
Gb = AbstractNote('F#', {'Gb'})
G = AbstractNote('G')
Ab = AbstractNote('G#', {'Ab'})
A = AbstractNote('A')
Bb = AbstractNote('A#', {'Bb'})
B = AbstractNote('B')


COLORS = (c.RED1, c.ORANGE, c.YELLOW1, c.GREEN, c.CYAN2, c.BLUE, c.VIOLETRED)

OCTAVE = (C, Db, D, Eb, E, F, Gb, G, Ab, A, Bb, B)

SCALES = (
    Scale('Major', 'o.o.oo.o.o.o'),
    Scale('Minor', 'o.oo.o.oo.o.'),
    Scale('Major Pentatonic', 'o.o.o..o.o..'),
    Scale('Minor Pentatonic', 'o..o.o.o..o.'),
    Scale('Chromatic', 'oooooooooooo'),
)

TUNINGS = (
    Tuning('Standard', Note.from_compact('E_2, A_2, D_3, G_3, B_3, E_4')),
    Tuning('DADGAD', Note.from_compact('D_2, A_2, D_3, G_3, A_3, D_4')),
    Tuning('EAEEBE', Note.from_compact('E_2, A_2, E_3, E_3, B_3, E_4')),
    Tuning('EABEBE', Note.from_compact('E_2, A_2, B_2, E_3, B_3, E_4')),
)


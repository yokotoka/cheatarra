import json
from collections import defaultdict
from itertools import product, chain
from pprint import pprint
from typing import NamedTuple, Set, Tuple, List, Dict
import cheatarra.colors as c


class AbstractNote:
    # name: str
    # aliases: Set[str]

    def __init__(self, name, aliases=None):
        self.name = name
        self.aliases = {name}
        if aliases:
            self.aliases |= set(aliases)

    def __repr__(self):
        return '{name}'.format(name=self.name)


class Note:
    # abstract_note: AbstractNote
    # octave: int

    def __init__(self, abstract_note, octave):
        self.abstract_note = abstract_note
        self.octave = octave

    def __repr__(self):
        return '{abstract_note}_{octave}'.format(abstract_note=self.abstract_note, octave=self.octave)

    @classmethod
    def from_str(cls, note: str):
        from cheatarra.constants import OCTAVE
        assert '_' in note
        name, octave = note.split('_')
        for abs_note in OCTAVE:
            if name in abs_note.aliases:
                return cls(abs_note, int(octave))

    @classmethod
    def from_list(cls, notes: List[str]):
        return tuple([cls.from_str(n) for n in notes])

    @classmethod
    def from_compact(cls, notes: str):
        return cls.from_list([n.strip() for n in notes.split(',')])

    # def __eq__(self, other):
    #     if self.octave == other.octave and self.abstract_note == other.abstract_note:
    #         return True
    #     return False

    def next_note(self):
        from cheatarra.constants import OCTAVE
        current_index = OCTAVE.index(self.abstract_note)
        next_index = (current_index + 1) % len(OCTAVE)

        octave = self.octave + 1 if next_index == 0 else self.octave

        return self.__class__(OCTAVE[next_index], octave)


class Scale:
    # name: str
    # interval_set: Set[int]
    # colors: Dict[int, c.RGB]

    def __init__(self, name, interval_set):
        from cheatarra.constants import COLORS
        color_idx = 0
        self.colors = {}
        assert len(interval_set) == 12
        self.name = name
        if isinstance(interval_set, str):
            self.interval_set = set()
            for i, symbol in enumerate(interval_set):
                if symbol != '.':
                    self.interval_set.add(i)
                    if color_idx + 1 <= len(COLORS):
                        self.colors[i] = COLORS[color_idx]
                    else:
                        self.colors[i] = c.WHITE
                    color_idx += 1

    def __repr__(self):
        return '{name} {interval_set}'.format(name=self.name, interval_set=self.interval_set)


class Tuning:
    # name: str
    # scheme: Tuple[Note]

    def __init__(self, name, scheme):
        self.name = name
        self.scheme = scheme

    def __repr__(self):
        scheme = ",".join(str(n) for n in self.scheme)
        return '{name} {scheme}'.format(name=self.name, scheme=scheme)


class Key:
    # abstract_note: AbstractNote
    # scale: Scale

    def __init__(self, abstract_note, scale):
        self.abstract_note = abstract_note
        self.scale = scale

    @property
    def notes_colors_map(self):
        from cheatarra.constants import OCTAVE
        result = defaultdict(lambda: c.BLACK)
        root_idx = OCTAVE.index(self.abstract_note)
        for interval in self.scale.interval_set:
            note_position = (root_idx + interval) % len(OCTAVE)
            abstract_note = OCTAVE[note_position]
            color = self.scale.colors.get(interval, c.BLACK)
            result[abstract_note] = color
        return result

    def __repr__(self):
        return '{abstract_note} {scale}'.format(abstract_note=self.abstract_note, scale=self.scale)


class Fretboard:
    # strings_count: int
    # frets_count: int

    # leds: Tuple[Tuple[int]] = (
    leds = (
        (5, 6,  17, 18, 29, 30, 41, 42, 53, 54, 65, 66, 77, 78, 89, 90, 101, 102, 113, 114, 125, 126, 137),
        (4, 7,  16, 19, 28, 31, 40, 43, 52, 55, 64, 67, 76, 79, 88, 91, 100, 103, 112, 115, 124, 127, 136),
        (3, 8,  15, 20, 27, 32, 39, 44, 51, 56, 63, 68, 75, 80, 87, 92, 99,  104, 111, 116, 123, 128, 135),
        (2, 9,  14, 21, 26, 33, 38, 45, 50, 57, 62, 69, 74, 81, 86, 93, 98,  105, 110, 117, 122, 129, 134),
        (1, 10, 13, 22, 25, 34, 37, 46, 49, 58, 61, 70, 73, 82, 85, 94, 97,  106, 109, 118, 121, 130, 133),
        (0, 11, 12, 23, 24, 35, 36, 47, 48, 59, 60, 71, 72, 83, 84, 95, 96,  107, 108, 119, 120, 131, 132),
    )

    @classmethod
    def get_leds_count(cls):
        from cheatarra.constants import DEBUG
        if DEBUG:
            return 100
        return len(list(chain(*cls.leds)))

    # notes: Tuple[Tuple[Note]]
    # led_note_map: Dict[int, Note]
    #
    # tuning: Tuning
    # key: Key

    def _note_gen(self, zero_note, frets_count):
        yield zero_note
        note = zero_note
        for i in range(1, frets_count):
            note = note.next_note()
            yield note

    def __init__(self, tuning, key):
        self.tuning = tuning
        self.key = key
        self.strings_count = len(self.leds)
        self.frets_count = len(self.leds[0])
        self.led_note_map = {}

        notes = []
        for string_i in range(self.strings_count):
            zero_note = self.tuning.scheme[string_i]
            string_notes = tuple(self._note_gen(zero_note, self.frets_count))
            notes.append(string_notes)
        self.notes = tuple(notes)

        for string_i, frets in enumerate(reversed(self.leds)):
            for fret_i, led_num in enumerate(frets):
                self.led_note_map[led_num] = self.notes[string_i][fret_i]

    def __repr__(self):
        return '\n'.join([
            ','.join([str(n) for n in notes_on_string])
            for notes_on_string in reversed(self.notes)
        ])

    def dump(self):
        colors = []
        notes_colors_map = self.key.notes_colors_map
        for led_idx, note in sorted(self.led_note_map.items()):
            color = notes_colors_map[note.abstract_note]
            colors.append(color)
        return colors

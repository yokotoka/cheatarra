from rpi_ws281x import *
from cheatarra.theory import Fretboard

leds_count = Fretboard.get_leds_count()

strip = Adafruit_NeoPixel(leds_count, pin=10, dma=10, brightness=63, strip_type=ws.WS2812_STRIP)
strip.begin()

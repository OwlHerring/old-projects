Impulse imp => 
LPF lpf =>
dac;

lpf.freq(Std.mtof(6*12 + 0));
.5::second => dur flatlineDur;
lpf.Q(lpf.freq() * (2*flatlineDur/second));
 
// The following is the paradigm on which this thing is designed, but isn't actually accurate for all frequencies, or even any frequencies to be honest famalam
// It seems to be most applicable from 220 Hz to 880 Hz or so.
// However, it does succeed in subverting the natural relationship between freq and the resulting flatline.
// Now, frequencies around 110 Hz don't last so long compared to 1760 Hz's ding.
// In short, all frequencies have a similar enough fadeout, so that it sounds like the same instrument.
// Sweet.
//
// interesting discovery:
// Another way to describe Q is, in this specific case,
// how many sine waves until it more or less flatlines
// (not very mathematical)
// how many sine waves until the zenith of the sine wave is less than 0.003 or so, as measured by Audacity?
// (probably doesn't apply to higher values of Q.)
// In any case, given a Q of X and frequency of F, it flatlines in the span of X periods of F.
// In other words, it flatlines in X Fths of a second.
// In other words: X::(second/F) => dur flatline;
// 
// in order to derive X from a known F and desired flatline (flatlineFloat::second):
// 5::second => dur flatline;
// F*(flatline/second) => float X;
//           and finally
// lpf.Q(X);
//           or even more simply(?)...
// lpf.freq(myFreq);
// 5::second => dur flatline;
// lpf.Q(lpf.freq()*(flatline/second));

// with a constant Q (which is >=1?), the higher the freq, the higher the gain.
// the higher the amplitudes of the resulting sine wave.

// lpf.set(880, 5): "p-!"
// lpf.set(880, 5 thru 40): various "pop!"s
// lpf.set(880, 50): begins to sound like a mallet instrument.
// lpf.set(Std.mtof(6*12 + 9), 100): this is absolutely a mallet instrument.
//                                // Std.mtof(6*12 + 9) == 880
// lpf.set(Std.mtof(6*12 + 9), 300): "ping!" a bit like a bell or a piano.

imp.next(1);
1::second => now;
imp.next(1);
1::second => now;
imp.next(1);
10::second => now;

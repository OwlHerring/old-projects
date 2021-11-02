Impulse imp => 
LPF lpf =>
dac;

lpf.freq(Std.mtof(5*12 + 9));
lpf.Q(5); // how pitched is the sound? 
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

// with a constant Q (which is >=1?), the higher the freq, the higher the gain.
// the higher the amplitudes of the resulting sine wave.

// lpf.set(880, 5): "p-!"
// lpf.set(880, 5 thru 40): various "pop!"s
// lpf.set(880, 50): begins to sound like a mallet instrument.
// lpf.set(Std.mtof(6*12 + 9), 100): this is absolutely a mallet instrument.
//                                // Std.mtof(6*12 + 9) == 880
// lpf.set(Std.mtof(6*12 + 9), 300): "ping!" a bit like a bell or a piano.

imp.next(1);
5::second => now;
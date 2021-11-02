Impulse imp => Delay d => JCRev r1 => LPF lpf => JCRev r => dac;

d => Gain g => d; // The reason for this is to give the initial strike some shape, instead of a simple impulse.
g.gain(0.9); // This affects attack. Makes it sound like a stronger beat.

lpf.freq(400); // makes it a high or low pitched percussive strike.
lpf.Q(1); // makes it pitched.
r1.mix(.5); // the sum of these two affects the attack and length.
r.mix(.1);

imp.next(0.5);

5::second => now;
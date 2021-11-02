Step imp => 
LPF lpf =>
Delay d =>
dac;

lpf.freq(400);
lpf.Q(10);

//d => Gain g => d;
//g.gain(0.9);
//d.delay((second-samp) / 880);


imp.next(0.5);
.5::second => now;
imp.next(0);
4.5::second => now;
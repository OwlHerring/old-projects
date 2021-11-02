Step imp => 
LPF lpf =>
Delay d =>
dac;

lpf.freq(600);
lpf.Q(10);

//d => Gain g => d;
//g.gain(0.9);
//d.delay((second-samp) / 880);


.5::second + now => time later;
while(now<later)
{
    imp.next(0.5);
    3::(second/lpf.freq()) => now;
    imp.next(0);
    3::(second/lpf.freq()) => now;
}

4.5::second => now;
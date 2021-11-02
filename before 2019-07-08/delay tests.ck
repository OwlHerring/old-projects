Step imp =>
Delay d =>
Delay d2 =>
dac;

d => 
Gain g => 
d;
d2 =>
Gain g2 =>
d2;

110 => float freq;
second / freq => dur period;
d.delay(period);
g.gain(.9);
d2.delay(1.5::period);
g2.gain(.6);

SinOsc LFO => blackhole;
LFO.gain(.49);
LFO.freq(1);
Phasor LFO2 => blackhole;
LFO2.gain(1);
LFO2.freq(.125);

while(true)
{
    .125::second + now => time later;
    
    //d2.delay((1+LFO.last())::period);
    
    imp.next(1);
    (.5+LFO.last()+LFO2.last())::ms => now;
    imp.next(0);
    
    later => now;
}
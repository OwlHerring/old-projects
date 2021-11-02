second / samp => float SRATE; // how many samples there are in a second. Either 44100 or 48000, or others.

private class sqrPizz extends Chubgraph
{
    .01*SRATE => float freq; // by default, freq's period is 100 samples long.
    second / freq - 1::samp => dur period;
    
    Step pizz => outlet;              // The sound itself.
         pizz => Delay d1 => outlet;  // The sound after delay d1...
    d1 => Gain g => d1;               // d1 is repeated at g.gain()^n gain.
    d1.delay(period); // - samp
    g.gain(.95);
    
    d1 => Delay d2 => outlet;
    d2.delay(.5::period);
    d2.gain(-1);
    
    fun void hitSpork()
    {
        pizz.next(1);
        .5::period => now;
        pizz.next(0);
    }
    
    fun void setFreq(float newFreq)
    {
        newFreq => freq;
        second / freq - 1::samp => period;
        
        d1.delay(period);
        d2.delay(.5::period);
    }
}






sqrPizz sqr => dac;
1*sqr.freq => sqr.setFreq;

spork ~ sqr.hitSpork();

while(true)
    second => now;


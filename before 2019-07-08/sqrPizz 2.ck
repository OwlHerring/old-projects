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
    
    fun void hitSpork(float vol)
    {
        pizz.next(vol);
        .5::period => now;
        pizz.next(0);
    }
    fun void hitSpork()
    {
        hitSpork(1);
    }
    
    fun void setFreq(float newFreq)
    {
        newFreq => freq;
        second / freq - 1::samp => period;
        
        d1.delay(period);
        d2.delay(.5::period);
    }
}

private class sawMinusSqrPizz extends Chubgraph
{
    SawOsc saw => Gain g => LPF lpf => outlet;
    g.op(2);
    sqrPizz sqr => g;
    .5*sqr.freq => sqr.setFreq;
    1*sqr.freq => saw.freq;
    saw.phase(.25);
    
    lpf.freq(4000);
    lpf.Q(1);
    
    fun void hitDontSpork(float vol)
    {
        saw.gain(vol);
        spork ~ sqr.hitSpork(vol);
    }
    fun void hitDontSpork()
    {
        hitDontSpork(1);
    }
    
    fun void setFreq(float newFreq)
    {
        newFreq => sqr.setFreq;
        sqr.freq => saw.freq;
    }
}

sawMinusSqrPizz sqr => dac;
[
60,
62,
63,
65,
67,
68,
70,
72
]
@=> int pitches[];
0 => int pitchesCount;

0.5 => float vol;
3 => int repetitions;

.75::second => dur bar;

while(true)
{
    
    
    0.5 => vol;
    spork ~ volControl((.999*repetitions)::bar, .3, .667);
    
    repeat(repetitions-1)
    {
        Std.mtof(pitches[pitches.size() %=> pitchesCount]) => sqr.setFreq;
        pitchesCount++;
        1 => float localVolMulti;
        for(now + bar => time later; now < later; ((.01*maybe)+.071)::second => now)
        {
            sqr.hitDontSpork(localVolMulti*vol);
            .99 *=> localVolMulti;
        }
    }
    
    Std.mtof(pitches[pitches.size() %=> pitchesCount]) => sqr.setFreq;
    pitchesCount++;
    1 => float localVolMulti;
    for(now + bar => time later; now < later; ((.01*maybe)+.081)::second => now)
    {
        sqr.hitDontSpork(localVolMulti*vol);
        .97 *=> localVolMulti;
    }
}

fun void volControl(dur length, float swell, float attackPercent) // needs a variable called vol to function.
{
    vol => float baseVol;
    Step constant => ADSR env => blackhole;
    constant.next(1);
    env.gain(swell);
    env.set(attackPercent::length, (1-attackPercent)::length, 0.0, 0::length);
    
    env.keyOn(1);
    for(now + length => time later; now < later; ms => now)
    {
        baseVol + env.last() => vol;
    }
    baseVol => vol;
}
private class newPizz extends Chubgraph
{
    Step imp =>
    Delay d =>
    Delay d2 =>
    outlet;
    
    d =>
    Gain g =>
    d;
    d2 =>
    Gain g2 =>
    d2;
    
    1 => float d1Delay; // in terms of periods
    2 => float d2Delay; // in terms of periods
    .7 =>float d1Gain;
    .6 =>float d2Gain;
    
    220 => float freq;
    second / freq => dur period;
    d.delay(d1Delay::period);
    g.gain(d1Gain);
    d2.delay(d2Delay::period);
    g2.gain(d2Gain);
    
    1 => float hitLength; // in milliseconds.
    1 => float stepGain;  // how hard you hit it.
    
    fun void hitSpork()
    {
        imp.next(stepGain);
        hitLength::ms => now;
        imp.next(0);
    }
    fun void hitSpork(float newHit)
    {
        newHit => hitLength;
        hitSpork();
    }
    fun void hitSpork(float newHit, float newGain)
    {
        newGain => stepGain;
        newHit => hitLength;
        hitSpork();
    }
    
    fun void setBase()
    {
        second / freq => period;
        
        d.delay(d1Delay::period);
        d2.delay(d2Delay::period);
    }
    fun void setFreq(float newFreq)
    {
        newFreq => freq;
        setBase();
    }
    fun void setd1Delay(float newd1Delay)
    {
        newd1Delay => d1Delay;
        setBase();
    }
    fun void setd1Gain(float newd1Gain)
    {
        newd1Gain => d1Gain;
        g.gain(d1Gain);
    }
    fun void setd2Delay(float newd2Delay)
    {
        newd2Delay => d2Delay;
        setBase();
    }
    fun void setd2Gain(float newd2Gain)
    {
        newd2Gain => d2Gain;
        g2.gain(d2Gain);
    }
}

440 => float baseFreq;
[
baseFreq * 1.0,
baseFreq * 1.125,
baseFreq * 1.2,
baseFreq * 1.3333,
baseFreq * 1.5,
baseFreq * 1.5,
baseFreq * 1.5,
baseFreq * 1.5
]
@=> float pitches[];
[
3,5,7
]
@=> int rests[];

newPizz p => dac;
p.setd1Gain(.8);
p.setd2Delay(.8);
p.setd2Gain(-.7);

.5 => p.stepGain;

0 => int pitchesCount;
.25::second => dur beat;

SinOsc vibrato => blackhole;
vibrato.gain(division(baseFreq,100));
vibrato.freq(7.6);

while(true)
{
    Math.random2(6,7) => int repetition;
    
    if(isItAnyOfThese(pitchesCount,rests)) 
    repeat(1)
    {
        p.setFreq(pitches[pitches.size() %=> pitchesCount]+vibrato.last());
    
        spork ~ p.hitSpork();
        division(1,1)::beat => now;
    }
    else
    repeat(repetition)
    {
        p.setFreq(pitches[pitches.size() %=> pitchesCount]+vibrato.last());
    
        spork ~ p.hitSpork();
        division(1,repetition)::beat => now;
    }
    
    pitchesCount++;
}






fun float division(float num, float div)
{
    num => float result;
    div /=> result;
    return result;
}
fun int isItAnyOfThese(int count, int test[])
{
    0 => int boolean;
    for(0 => int testCount; testCount < test.size(); testCount++)
    {
        if(test[testCount]==count) 1 => boolean;
    }
    return boolean;
}
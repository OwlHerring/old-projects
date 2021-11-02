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
    3 => float d2Delay; // in terms of periods
    .8 =>float d1Gain;
    .7 =>float d2Gain;
    
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

[1.0, 1.5] @=> float mel[];
0 => int melCount;

330 => float baseFreq;
.9 =>  float based1Gain;
1  =>  float based1Delay;
.8 =>  float based2Gain;
2  =>  float based2Delay;
3 => int num;
10 => float offset; offset-1 /=> offset;

randOffset(num, 1, offset) @=> float pOffset[];
newPizz p[num]; Gain g => dac;
for(0 => int pCount; pCount < p.size(); pCount++)
{
    p[pCount] => g;
    p[pCount].setFreq(baseFreq
                               * pOffset[pCount]
                               );
    p[pCount].setd1Gain(based1Gain * pOffset[pCount]);
    p[pCount].setd1Delay(based1Delay * pOffset[pCount]);
    p[pCount].setd2Gain(based2Gain * pOffset[pCount]);
    p[pCount].setd2Delay(based2Delay * pOffset[pCount]);
}
g.gain(Math.pow(p.size(),-1));


while(true)
{
    for(0 => int pCount; pCount < p.size(); pCount++)
    {
        p[pCount].setFreq(baseFreq
                                   * pOffset[pCount]
                                   * mel[mel.size()%=>melCount]
                                   );
        spork ~ p[pCount].hitSpork();
    }
    melCount++;
    .5::second => now;
}






fun float[] randOffset(int num, float base, float offset)
{
    float myOffset[num];
    for(0 => int offsetCount; offsetCount < myOffset.size(); offsetCount++)
    {
        base * Math.random2f(offset,Math.pow(offset,-1)) => myOffset[offsetCount];
    }
    return myOffset;
}








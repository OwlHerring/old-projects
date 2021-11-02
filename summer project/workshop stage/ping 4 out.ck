private class PingSuper extends Chubgraph
{
    LPF lpf => outlet;
    
    220 => float freq;
    1::second => dur approxFadeDur;
    
    s();
    
    fun void s()
    {
        lpf.freq(freq);
        lpf.Q(freq * (approxFadeDur/second));
    }
    
    
    fun void set(dur fadeDur) { fadeDur => approxFadeDur; s(); }
    fun void set(float myFreq) { myFreq => freq; s(); }
    fun void set(dur fadeDur, float myFreq) { fadeDur => approxFadeDur; myFreq => freq; s(); }
    
    fun void hit(float Hit) { }
    
    // for Ping3.
    1 => int reps;
    1 => float fade; // gotta be between 1 and 0 (maybe 1 and -1)
    samp => dur delay; // between successive impulses.
    
    fun dur freqPeriod() { return second / freq; }
    // this does absolutely nothing, except in the case of Ping3. Why the hell did I type all this out
    fun void setR(int rep){ rep => reps; } 
    fun void setF(float fad){ fad => fade; } 
    fun void setD(dur dela){ dela => delay; }
    fun void setShwip(int rep, float fad, dur dela){ setR(rep), setF(fad), setD(dela); }
}

private class Ping extends PingSuper
{
    Impulse imp => lpf;
    fun void hit(float Hit) { imp.next(Hit); }
}

private class Ping2 extends PingSuper
{
    Step constant => ADSR env => lpf;
    constant.next(1);
    env.set(samp, samp, .5, samp);
    
    0::second => dur susTime; // whatever the effects of changing this are, they won't affect already-sounding notes, I think.
    
    fun void set(dur attack, dur decay, float sus, dur release) { env.set(attack, decay, sus, release); }
    
    fun void hit(float Hit, dur length)
    {
        env.target(Hit);
        spork ~ hitComponent();
    }
    fun void hitComponent()
    {
        env.attackTime() + env.decayTime() + susTime => now;
        env.keyOff(1);
    }
}
private class Ping3 extends PingSuper
{
    Impulse imp => lpf;
    
    fun void hit(float Hit){ spork ~ hitComponent(Hit); }
    fun void hitComponent(float Hit)
    {
        for(0 => int repCount; repCount < reps; repCount++)
        {
            imp.next(Hit*Math.pow(fade,repCount));
            delay => now;
        }
    }
}
private class PingDelay extends PingSuper
{
    .9 => fade;
    100::samp => delay;
    
    Impulse imp => Delay d => lpf;
    d => Gain g => d; g.gain(fade);
    
    
    second/delay => float delayFreq;
    setupDelay();
    
    fun void setupDelay() { d.delay(second / delayFreq); d.delay() => delay; }
    fun void setDelayFreq(float myFreq) { myFreq => delayFreq; setupDelay(); }
    
    fun void setF(float fad){ fad => fade; g.gain(fade); }
    fun void setD(dur dela){ dela => delay; delay => d.delay; second/delay => float delayFreq;}

    fun void hit(float Hit) { imp.next(Hit); }
}

private class PingDelayPitch extends PingDelay // this seems broken at the moment.
{
    1 => float ratio;
    ratio*freq => delayFreq;
    fun void setupDelay() { ratio*freq => delayFreq; d.delay(second / delayFreq); d.delay() => delay; }
    fun void setDelayRatio(float myRatio) { myRatio => ratio; setupDelay(); }
    
    fun void set(float myFreq) { myFreq => freq; setupDelay(); s(); }
    fun void set(dur fadeDur, float myFreq) { fadeDur => approxFadeDur; myFreq => freq; setupDelay(); s(); }

}
private class PingAdditive extends Chubgraph
{
    Gain g => outlet;
    
    1 => int num;
    Ping p[num];
    
    0.5 => float aVar;                 // first term of the geometric series determining gain.
    fun float a(float newA) { newA => aVar; setup(); return a(); }
    fun float a() { return aVar;     } // (please use these two functions for reference.) 
    fun float r() { return 1 - aVar; } // second term of said series divided by first term.
    
    220 => float freq;
    1::second => dur approxFadeDur;
    
    setup();
    
    fun void setup()
    {
        for(0 => int pCount; pCount < p.size(); pCount++)
        {
            if(!p[pCount].isConnectedTo(g)) p[pCount] => g;
            
            a() * Math.pow(r(), pCount-(pCount == p.size()-1)) => p[pCount].gain; // wow, that's so much simpler.
            
            p[pCount].set(
                          Math.pow(.5, pCount)::approxFadeDur,
                          freq*(pCount+1)
            );
        }
    }
    fun void add(int howMany) // Be very careful as you go up. It seems different a()s have different behaviors, though they all ultimately approach painful snaps. 
    { // maybe just stick to 6 at most for now.
        repeat(howMany)
        {
            p << new Ping;
        }
        p.size() => num;
        setup();
    }
    fun void set(dur fadeDur) { fadeDur => approxFadeDur; setup(); }
    fun void set(float myFreq) { myFreq => freq; setup(); }
    fun void set(dur fadeDur, float myFreq) { fadeDur => approxFadeDur; myFreq => freq; setup(); }
    fun void hit(float Hit)
    {
        for(0 => int pCount; pCount < p.size(); pCount++) p[pCount].hit(Hit);
    }
}









// first, before anything else, a blast from the past:...
Gain safeG => Dyno safeD => Envelope fadeout => dac;

fadeout.value(1); fadeout.duration(9::second);
.5 => float maxAmp;
safeG.gain(maxAmp);
safeD.thresh(maxAmp);
safeD.slopeBelow(1.0);
safeD.slopeAbove(0.0);

PingDelay p => safeG;


p.setDelayFreq(55);
p.delayFreq => float start;

while(true)
{
    start => p.delayFreq;
    Math.random2(2,48) => int EDO;
    p.set((Math.pow(EDO,-.3)*2)::second, start*Math.random2(8,16));
    
    for(0 => int gliss; p.delayFreq < 8*start; gliss++)
    {
        start * Math.pow(Math.pow(2, Math.pow(EDO,-1) ),gliss) => p.setDelayFreq;
        p.hit(1);
        Math.pow(EDO,-1)::second => now;
    }
}

5::second => now;



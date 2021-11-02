private class noiseSuper extends Chubgraph
{
    fun void next(float input) { }
    
    // Feel free to add more to either of these in the body of the code.
    [ 1.0, -1.0 ] @=> float outputs[]; // This will choose between these inputs randomly. 
    
    [ 1.0, 1.5, 2.0 ] @=> float ratios[];
    
    //PulseOsc doesntexist;
    880 => float baseFreq;// => doesntexist.freq; // yes, this is a way to smuggle a modifiable frequency into sporkThis().
    
    0 => int on;
    
    fun void sporkThis()
    {
        1 => on;
        while(true)
        {
            while(on)
            {
                this.next(outputs[Math.random2(0,outputs.size()-1)]);
                second / (baseFreq * ratios[Math.random2(0,ratios.size()-1)]) => now;
            }
            0 => on;
            while(!on)
                3::ms => now;
        }
    }
    fun void toggle(int tog){ tog => on; }
}
private class noiseImpulse extends noiseSuper
{
    Impulse imp => outlet;
    
    fun void next(float input){ imp.next(input); }
}
private class noiseStep extends noiseSuper
{
    Step imp => outlet;
    
    fun void next(float input){ imp.next(input); }
}



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
    
    // for Ping4. (and Ping2.)
    .1::second => dur attack; .1::second => dur decay; 
    fun void set(dur Att, dur Dec){ Att => attack; Dec => decay; }
    
    .5 => float sustain; .1::second => dur release;
    fun void set(dur att, dur dec, float sus, dur rel) { }
    
    0 => int holding;
    fun void hold(int Holding) { (Holding != 0) => holding; if(Holding==0) 0 => sustain;} // (for Ping4) Will it sustain 
    
    Event stop;
    fun void stopBowing() { stop.broadcast(); }
    
    float baseFreq;
    fun void setBow(float freq) { freq => baseFreq; }
    
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
private class PingB extends Ping // all this does is add two sine waves of the same frequency, more or less.
{
    .5 => float anti;
    
    fun void hit(float Hit) { spork ~ hitComponent(Hit); }
    fun void hitComponent(float Hit)
    { 
        imp.next(Hit);
        if(anti>0) anti::freqPeriod() => now;
        else samp => now;
        imp.next(-Hit); 
    }
}
private class Ping2 extends PingSuper
{
    Step constant => ADSR env => lpf;
    constant.next(1);
    env.set(samp, samp, .5, samp);
    
    0::second => dur susTime; // whatever the effects of changing this are, they won't affect already-sounding notes, I think.
    
    fun void set(dur att, dur dec, float sus, dur rel) { env.set(att, dec, sus, rel); }
    
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
private class Ping4 extends PingSuper
{
    noiseStep noise => Envelope env => lpf;
    
    spork ~ noise.sporkThis();
    
    .01::second => attack;
    .01::second => decay;
    0 => sustain;
    .01::second => release;
    
    880 => baseFreq;
    
    fun void setBow(float newFreq)
    {
        newFreq => baseFreq => noise.baseFreq;
    }
    
    fun void set(dur att, dur dec, float sus, dur rel) { att => attack; dec => decay; sus => sustain; rel => release; }
    
    fun void hit(float Hit){ spork ~ hitComponent(Hit); }
    fun void hitComponent(float Hit)
    { 
        noise.toggle(1);
        
        env.target(Hit);
        env.duration(attack);
        attack => now; 
        
        env.target(sustain * Hit);
        env.duration(decay);
        
        if(holding) stop => now;
        else decay => now;
        
        env.target(0);
        env.duration(release);
        
        noise.toggle(0);
    }
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
    .5 => float fadeRatio;
    // if fadeRatio is .5, then
    // p[0] will last 1::approxFadeDur, 
    // p[1] will last .5::approxFadeDur,
    // p[2] will last .25::approxFadeDur, etc.
    // if fadeRatio is 1.5, then
    // p[0] will last 1::approxFadeDur,
    // p[1] will last 1.5::approxFadeDur,
    // p[2] will last 2.25::approxFadeDur, etc.
    
    setup();
    
    fun void setup()
    {
        for(0 => int pCount; pCount < p.size(); pCount++)
        {
            if(!p[pCount].isConnectedTo(g)) p[pCount] => g;
            
            a() * Math.pow(r(), pCount-(pCount == p.size()-1)) => p[pCount].gain; // wow, that's so much simpler.
            
            p[pCount].set(
                          Math.pow(fadeRatio, pCount)::approxFadeDur,
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
    fun void setFadeRatio(float fr) { fr => fadeRatio; setup(); }
    fun void set(dur fadeDur) { fadeDur => approxFadeDur; setup(); }
    fun void set(float myFreq) { myFreq => freq; setup(); }
    fun void set(dur fadeDur, float myFreq) { fadeDur => approxFadeDur; myFreq => freq; setup(); }
    fun void hit(float Hit)
    {
        for(0 => int pCount; pCount < p.size(); pCount++) p[pCount].hit(Hit);
    }
}
private class PingSuperAdditive extends Chubgraph
{
    Gain g => outlet;
    
    1 => int num;
    PingSuper @ p[num];
    
    0 => int allowSetup;
    
    0.5 => float aVar;                 // first term of the geometric series determining gain.
    fun float a(float newA) { newA => aVar; setup(); return a(); }
    fun float a() { return aVar;     } // (please use these two functions for reference.) 
    fun float r() { return 1 - aVar; } // second term of said series divided by first term.
    
    220 => float freq;
    1::second => dur approxFadeDur;
    .5 => float fadeRatio;
    // if fadeRatio is .5, then
    // p[0] will last 1::approxFadeDur, 
    // p[1] will last .5::approxFadeDur,
    // p[2] will last .25::approxFadeDur, etc.
    // if fadeRatio is 1.5, then
    // p[0] will last 1::approxFadeDur,
    // p[1] will last 1.5::approxFadeDur,
    // p[2] will last 2.25::approxFadeDur, etc.
    
    // for Ping4.
    .1::second => dur attack; .1::second => dur decay; .5 => float sustain; .1::second => dur release;
    
    setup();
    
    fun void allow() // this indicates you are done and that no null references remain in p.
    {
        1 => allowSetup;
        setup();
    }
    fun void setup() // this is for use by other class functions.
    {
        if(allowSetup)
        {
            for(0 => int pCount; pCount < p.size(); pCount++)
            {
                if(!p[pCount].isConnectedTo(g)) p[pCount] => g;
                
                a() * Math.pow(r(), pCount-(pCount == p.size()-1)) => p[pCount].gain; // wow, that's so much simpler.
                
                p[pCount].set(
                            Math.pow(fadeRatio, pCount)::approxFadeDur,
                            freq*(pCount+1)
                );
                
                attack => p[pCount].attack;
                decay => p[pCount].decay;
                sustain => p[pCount].sustain;
                release => p[pCount].release;
            }
        }
    }
    fun void add(int howMany) // don't do this after allow().
    { 
        p.size(p.size()+howMany);
        p.size() => num;
    }
    // for Ping4B.
    fun void hold(int Holding) { for(0 => int pCount; pCount < p.size(); pCount++) p[pCount].hold(Holding); }
    fun void stopBowing() { for(0 => int pCount; pCount < p.size(); pCount++) p[pCount].stopBowing(); }
    fun void set(dur att, dur dec, float sus, dur rel) { att => attack; dec => decay; sus => sustain; rel => release; setup(); } 
    880 => float baseFreq;
    fun void setBow(float newFreq) { for(0 => int pCount; pCount < p.size(); pCount++) newFreq => baseFreq => p[pCount].setBow; }
    
    fun void setFadeRatio(float fr) { fr => fadeRatio; setup(); }
    fun void set(dur fadeDur) { fadeDur => approxFadeDur; setup(); }
    fun void set(float myFreq) { myFreq => freq; setup(); }
    fun void set(dur fadeDur, float myFreq) { fadeDur => approxFadeDur; myFreq => freq; setup(); }
    fun void set(dur Att, dur Dec) { Att => attack; Dec => decay; setup();} // this is for Ping4.
    fun void hit(float Hit) // until you pick which descendent of PingSuper each one is, and turn startConnectingToG on, this will make no sound. 
    {
        for(0 => int pCount; pCount < p.size(); pCount++) p[pCount].hit(Hit);
    }
}
private class PingSuperAdditiveMetallic extends PingSuperAdditive
{
    80 => float offsetNum; // effectively, offset is 80/79.
    fun float offset(){ return offsetNum * Math.pow(offsetNum-1,-1); }
    
    fun void setup()
    {
        if(allowSetup)
        {
            for(0 => int pCount; pCount < p.size(); pCount++)
            {
                if(!p[pCount].isConnectedTo(g)) p[pCount] => g;
                
                a() * Math.pow(r(), pCount-(pCount == p.size()-1)) => p[pCount].gain; // wow, that's so much simpler.
                
                if(pCount == 0)
                {
                    p[pCount].set(
                                  Math.pow(fadeRatio, pCount)::approxFadeDur,
                                  freq * (pCount+1)
                    );
                }
                else
                {
                    p[pCount].set(
                                  Math.pow(fadeRatio, pCount)::approxFadeDur,
                                  forloopRandom2f(pCount-1, offset() * freq * (pCount+1), Math.pow(offset(),-1) * freq * (pCount+1))
                    );
                }
                
                
                attack => p[pCount].attack;
                decay => p[pCount].decay;
            }
        }
    }
}

private class Cello extends PingSuperAdditive
{
    add(7);
    
    for(0 => int pCount; pCount < num; pCount++)
    {
        new Ping4 @=> p[pCount];
    }
    
    setFadeRatio(1.5); // This is the ratio between the fading times of harmonic N and harmonic N+1. Be careful < .5!  
    a(.25);             // This is the relative strength of harmonics. Closer to .001: ponticello. Closer to .99: sul tasto.
    set(.3::second, .2::second, .5, .1::second); // sets ADSR of the noise being filtered.
    allow();
    hold(1);
    
    setBow(440);
}
private class Cellos extends Chubgraph
{
    220 => float freq;
    96 => float offsetNum;
    Gain g => outlet;
    Cello c[0];
    float offset[0];
    add(2);
    setFadeRatio(1.5);
    setBow(110);
    set(second, freq);
    setA(.25);
    
    fun void setA(float newA) { for(0 => int cCount; cCount < c.size(); cCount++) { newA*offset[cCount] => c[cCount].a; } }
    
    fun void add(int num)
    {
        for(0 => int count; count < num; count++)
        {
            c << new Cello;
        }
        s();
    }
    fun void s()
    {
        setOffset();
        for(0 => int cCount; cCount < c.size(); cCount++)
        {
            if(!c[cCount].isConnectedTo(g)){ c[cCount] => g; }
        }
        set(freq);
        g.gain(Math.pow(c.size(),-1));
    }
    
    fun void set(float newFreq)
    { 
        if(newFreq != freq) newFreq => freq;
        for(0 => int cCount; cCount < c.size(); cCount++) { c[cCount].set( freq*offset[cCount] ); }
    }
    fun void set(dur fadeDur) { for(0 => int cCount; cCount < c.size(); cCount++) { c[cCount].set( offset[cCount]::fadeDur ); } }
    fun void set(dur fadeDur, float freq) { set(fadeDur); set(freq); }
    fun void setFadeRatio(float fadeRatio) { for(0 => int cCount; cCount < c.size(); cCount++){ c[cCount].setFadeRatio( fadeRatio*offset[cCount] ); } } // be even more careful with this, since one will be slightly below and one slightly above.
    fun void setBow(float bowFreq) { for(0 => int cCount; cCount < c.size(); cCount++){ c[cCount].setBow( bowFreq*offset[cCount] ); } }
    fun void hit(float Hit) { for(0 => int cCount; cCount < c.size(); cCount++){ c[cCount].hit( Hit*offset[cCount] ); } }
    fun void stopBowing() { for(0 => int cCount; cCount < c.size(); cCount++) c[cCount].stopBowing(); }
    
    fun void setOffset() { setOffset(offsetNum); }
    fun void setOffset(float newOffsetNum)
    {
        if(newOffsetNum != offsetNum)
        {
            newOffsetNum => offsetNum;
            offset.clear();
        }
        if(offset.size() < c.size()) // (which it will after the above if statement occurs)
        {
            offset.size() => int oldSize;
            for(oldSize => int count; count < c.size(); count++)
            {
                offset << forloopRandom2f(count, division(offsetNum,offsetNum-1), division(offsetNum-1,offsetNum));
            }
        }
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

Cello p => 
// you know what, fuck the cello section. Cello already sounds like a cello sections rather than a single one anyway
safeG;

p.a(.18);
p.setFadeRatio(1.2);
p.set(.3::second);

110 => float freq;
[freq, freq*1.125, freq*1.25] @=> float freqs[];
0 => int freqsCount;

1::second => dur beat;

while(true)
{
    p.set(freqs[freqsCount%freqs.size()]); // sets basically the ring of the string. Too low and it'll be very airy no matter what. Too high and it'll always be laissez vibre
    p.hit(1);

    beat => now;
    
    p.stopBowing(); // note that this must happen a duration after p.hit() greater than the attack.
    
    //beat => now;
    
    
    freqsCount++; 
}






fun float division(float num, float denom)
{
    return num * Math.pow(denom, -1);
}
fun int forloopMaybe(int count)
{ 
    maybe => int Maybe; 
    if(count == 0) return Maybe;
        else if(count == 1) return !Maybe;
            else if(count > 1) return maybe;
}
fun int forloopRandom2(int count, int floor, int cap)
{
    maybe => int Maybe;
    cap - floor => int difference;
    if(count == 0) return floor + Maybe*difference;
        else if(count == 1) return floor + (!Maybe)*difference;
            else if(count > 1) return Math.random2(floor, cap);
}
fun float forloopRandom2f(int count, float floor, float cap)
{
    maybe => int Maybe;
    cap - floor => float difference;
    if(count == 0) return floor + ((Maybe==1)*difference);
        else if(count == 1) return floor + ((Maybe!=1)*difference);
            else if(count > 1) return Math.random2f(floor, cap);
}








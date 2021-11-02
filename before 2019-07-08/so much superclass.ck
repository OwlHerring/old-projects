
private class noiseSuper extends Chubgraph
{
    fun void next(float input) { } // placeholder for the other two.
    
    // Feel free to add more to either of these in the body of the code.
    [ 1.0, -1.0 ] @=> float outputs[]; // This will choose between these inputs randomly. 
    
    [ 
    1.0, 
    1.5, 
    2.0
    ] @=> float ratios[];
    
    880 => float baseFreq; // as long as baseFreq is a member of a class (which, being here, it is), it appears changes to it can sneak into a sporked shred all the same.
    
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
    fun void toggle(){ !on => on; }
    fun void setFreq(float newFreq){ newFreq => baseFreq; }
}
private class noiseImpulse extends noiseSuper
{
    Impulse imp => outlet;
    
    fun void next(float input){ imp.next(input); }
}
private class noiseStep extends noiseSuper
{
    Step imp => outlet;
    imp.next(0);
    
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
    
    // gliss! Yes, another feature!
    0 => int isGlissing;
    .1::second => dur glissDur;
    1.2 => float radius;
    1 => int radiusOn;
    .03::second => dur radiusDur;
    fun void setRadius(float newRad){ newRad => radius; }
    fun void setGlissDur(dur newDur){ newDur => glissDur; }
    fun void setRadiusDur(dur newDur){ newDur => radiusDur; }
    fun void gliss(float myFreq)
    {
        spork ~ glissComponent(myFreq);
    }
    fun void glissComponent(float myFreq)
    {
        0::second => dur prevGlissDur;
        
        if(isGlissing) { 0 => isGlissing; samp => now; setGlissDur(glissDur - samp); } // if it is currently glissing, then it forces the other glissing to stop. Then it advances by 1 sample and shortens the glissDur by 1 sample.
        if(radiusOn && freq > myFreq*radius)
        {
            radiusDur => prevGlissDur;
            glissComponent(radiusDur, myFreq*radius); // it should cut from freq to myFreq straight away. If freq > myFreq*radius, then it ought to cut to myFreq*radius. If freq < Math.pow(radius,-1)*myFreq, then it ought to cut to myFreq/radius.
        }
        else if(radiusOn && freq < Math.pow(radius,-1)*myFreq)
        {
            radiusDur => prevGlissDur;
            glissComponent(radiusDur, Math.pow(radius,-1)*myFreq);
        }
        
        1 => isGlissing;
        Envelope e => blackhole;
        e.value(freq);
        e.target(myFreq);
        e.duration(glissDur - prevGlissDur);
        while(isGlissing && e.value() != e.target())
        {
            2::ms => now;
            e.value() => set;
        }
        myFreq => set;
        e =< blackhole;
        0 => isGlissing;
    }
    // fun void gliss(dur diffDur, float myFreq) { spork ~ glissComponent(diffDur, myFreq); } 
    fun void glissComponent(dur diffDur, float myFreq)
    {
        if(isGlissing) { 0 => isGlissing; samp => now; samp -=> diffDur; } // if it is currently glissing, then it forces the other glissing to stop. Then it advances by 1 sample and shortens the glissDur by 1 sample.
        
        1 => isGlissing;
        Envelope e => blackhole;
        e.value(freq);
        e.target(myFreq);
        e.duration(diffDur);
        while(isGlissing && e.value() != e.target())
        {
            2::ms => now;
            e.value() => set;
        }
        myFreq => set;
        e =< blackhole;
        0 => isGlissing;
    }
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
    fun void setup() // this is for use by other class functions. I wonder if there's a way to shorten it to whatever's relevant at the time? This has to cost a bit of CPU.
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
                
                //p[pCount].setGlissDur(glissDur); // never mind. the additive's gliss will have nothing to do with the individual glisses of each harmonic.
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
    
    // gliss!!!!!
    0 => int isGlissing;
    .1::second => dur glissDur;
    1.2 => float radius;
    1 => int radiusOn;
    .03::second => dur radiusDur;
    fun void setRadius(float newRad){ newRad => radius; }
    fun void setGlissDur(dur newDur){ newDur => glissDur; }
    fun void setRadiusDur(dur newDur){ newDur => radiusDur; }
    fun void gliss(float myFreq)
    {
        spork ~ glissComponent(myFreq);
    }
    fun void glissComponent(float myFreq)
    {
        0::second => dur prevGlissDur;
        
        if(isGlissing) { 0 => isGlissing; samp => now; setGlissDur(glissDur - samp); } // if it is currently glissing, then it forces the other glissing to stop. Then it advances by 1 sample and shortens the glissDur by 1 sample.
        if(radiusOn && freq > myFreq*radius)
        {
            radiusDur => prevGlissDur;
            glissComponent(radiusDur, myFreq*radius); // it should cut from freq to myFreq straight away. If freq > myFreq*radius, then it ought to cut to myFreq*radius. If freq < Math.pow(radius,-1)*myFreq, then it ought to cut to myFreq/radius.
        }
        else if(radiusOn && freq < Math.pow(radius,-1)*myFreq)
        {
            radiusDur => prevGlissDur;
            glissComponent(radiusDur, Math.pow(radius,-1)*myFreq);
        }
        
        1 => isGlissing;
        Envelope e => blackhole;
        e.value(freq);
        e.target(myFreq);
        e.duration(glissDur - prevGlissDur);
        while(isGlissing && e.value() != e.target())
        {
            2::ms => now;
            e.value() => set;
        }
        myFreq => set;
        e =< blackhole;
        0 => isGlissing;
    }
    // fun void gliss(dur diffDur, float myFreq) { spork ~ glissComponent(diffDur, myFreq); } 
    fun void glissComponent(dur diffDur, float myFreq)
    {
        if(isGlissing) { 0 => isGlissing; samp => now; samp -=> diffDur; } // if it is currently glissing, then it forces the other glissing to stop. Then it advances by 1 sample and shortens the glissDur by 1 sample.
        
        1 => isGlissing;
        Envelope e => blackhole;
        e.value(freq);
        e.target(myFreq);
        e.duration(diffDur);
        while(isGlissing && e.value() != e.target())
        {
            2::ms => now;
            e.value() => set;
        }
        myFreq => set;
        e =< blackhole;
        0 => isGlissing;
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










// first, before anything else, a blast from the past:...
Gain safeG => Dyno safeD => Envelope fadeout => dac;

fadeout.value(1); fadeout.duration(9::second);
.5 => float maxAmp;
safeG.gain(maxAmp);
safeD.thresh(maxAmp);
safeD.slopeBelow(1.0);
safeD.slopeAbove(0.0);

PingSuperAdditive p => // it would appear that PingSuperAdditiveMetallic is too dissonant to sustain very well.
Chorus c =>
safeG;

p =>
ResonZ r1 =>
c;
r1.freq(220*Math.pow(.6667, 0));
r1.Q(4);
p =>
ResonZ r2 =>
c;
r2.freq(220*Math.pow(.6667, 1));
r2.Q(4);
p =>
ResonZ r3 =>
c;
r3.freq(220*Math.pow(.6667, 2));
r3.Q(4);
p =>
ResonZ r4 =>
c;
r4.freq(220*Math.pow(.6667, 3));
r4.Q(4);

c.modFreq(6.4);
c.modDepth(0.004); // this gets a decent vibrato.
c.mix(.5); // 0: just the original; 1: just something going up and down the old; 0.5: half both.

p.add(11);
for(0 => int ppCount; ppCount < p.num; ppCount++)
{
    new Ping4 @=> p.p[ppCount];
}

// The 'real' volume is something like sustain * [whatever I specify for hit]. 

p.setFadeRatio(1.7); // This is the ratio between the fading times of harmonic N and harmonic N+1. Be careful < .5!  
p.a(.12);             // This is the relative strength of harmonics. Closer to .001: ponticello. Closer to .99: sul tasto.
p.set(.1::second, .05::second, .8, .3::second); // sets ADSR of the noise being filtered. Sustain: 0 is just outta the Sevcik; 0.2 works best with higher string ring; 0.5 is fuller (noisier); 0.8 is very noisy.
p.allow();
p.hold(1);

p.setRadius(1.05); // less than 1 is just weird, but functional (less functional as you get farther from 1); 1.01 is pointless; 1.05 is just below noticeable; 1.1 is lightly noticeable; 1.2 is noticeable; 1.3 sounds a bit silly.
p.setRadiusDur(.01::second);
p.setGlissDur(.12::second); // less than .03 is less than radiusDur so please don't; .05 sounds instantaneous; .1 sounds about right; .2 is where it starts to get emphasized.

150 => float freq;
[freq, freq*1.2, freq*1.5] @=> float freqs[];
0 => int freqsCount;

freqs[0]* 1.5 => float bowFreq;
[1.0, .9] @=> float bowRatio[]; // upbow or downbow?
0 => int bowCount;

1::second => dur beat;

while(true)
{
    p.gliss(freqs[freqsCount%freqs.size()]);
    
    p.setBow(880 * bowRatio[bowCount%bowRatio.size()] );
    p.set(.2::second); // sets basically the ring of the string. Too low and it'll be very airy no matter what. Too high and it'll always be laissez vibre
    p.hit(.3);
    
    beat => now;
    
    p.stopBowing(); // note that this must happen a duration after p.hit() greater than the attack.
    
    beat => now;
    
    freqsCount++; bowCount++;
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
    if(count == 0) return floor + Maybe*difference;
    else if(count == 1) return floor + (!Maybe)*difference;
    else if(count > 1) return Math.random2f(floor, cap);
}








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
    
    setup();
    
    fun void setup()
    {
        if(allowSetup)
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
    }
    fun void add(int howMany) // Be very careful as you go up. It seems different a()s have different behaviors, though they all ultimately approach painful snaps. 
    { // maybe just stick to 6 at most for now.
        p.size(p.size()+howMany);
        p.size() => num;
        setup();
    }
    fun void set(dur fadeDur) { fadeDur => approxFadeDur; setup(); }
    fun void set(float myFreq) { myFreq => freq; setup(); }
    fun void set(dur fadeDur, float myFreq) { fadeDur => approxFadeDur; myFreq => freq; setup(); }
    fun void hit(float Hit) // until you pick which descendent of PingSuper each one is, and turn startConnectingToG on, this will make no sound. 
    {
        for(0 => int pCount; pCount < p.size(); pCount++) p[pCount].hit(Hit);
    }
}
private class PingSuperAdditiveChoral extends PingSuperAdditive
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
                
                p[pCount].set(
                            Math.pow(.5, pCount)::approxFadeDur,
                            forloopRandom2f(pCount, offset() * freq * (pCount+1), Math.pow(offset(),-1) * freq * (pCount+1))
                );
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


.6::second => dur beat;

Event theBells;
spork ~ bellsBellsBells(1, .8, 4, 1);

35::beat => now;
theBells => now;

spork ~ bellsBellsBells(1, .6, 7, 0);

35::beat => now;
theBells => now;

spork ~ bellsBellsBells(1.5, .2, 8, 0);
spork ~ bellsBellsBells(1.5, .5, 3, 0);

35::beat => now;
theBells => now;

spork ~ bellsBellsBells(2, .9, 9, 0);
spork ~ bellsBellsBells(1, .9, 5, 0);

35::beat => now;
theBells => now;

fun void bellsBellsBells(float beatModifier, float A, int Add, int forWhom)
{
    PingSuperAdditiveChoral p => safeG; 
    p.add(Add);
    p.a(.7);
    for(0 => int ppCount; ppCount < p.num; ppCount++)
    {
        if(maybe) new Ping3 @=> p.p[ppCount];
        else new PingB @=> p.p[ppCount];
        p.p[ppCount].setShwip(forloopRandom2(ppCount, 13, 15), .8 + .1*forloopMaybe(ppCount), (.005 + .005*forloopRandom2(ppCount,1,6))::second);
    }
    //89 => p.offsetNum;
    1 => p.allowSetup;
    
    0 => int gradual;
    
    beatModifier::beat => dur myBeat;
    
    while(true)
    {
        for(0 => int ppCount; ppCount < p.num; ppCount++)
        {
            p.p[ppCount].setShwip(forloopRandom2(ppCount, 11, 15+gradual), .8 + .1*forloopMaybe(ppCount), (.002 + .007*forloopRandom2f(ppCount,1,6))::second);
        }
    
    
    
        300 + 100*Math.random2(0+gradual,4+gradual) => float next;
        Math.random2(2,3) => int nextRatio;
        Math.random2(0,19)==19 => int heavy;
    
        p.set((5+gradual + (heavy*20))::second, next);
        p.hit(1 + heavy);
        (heavy*7 + 1)::myBeat => now;
        
        if((maybe || forWhom) && heavy) theBells.broadcast();
        p.set(1::second, division(nextRatio,nextRatio+1)*next);
        p.hit(1);
        (1+heavy)*(maybe+2)::myBeat => now;
    
        if(gradual < 20) gradual++;
        else if(Math.random2(0,4)) 0 => gradual;
            
        if(forWhom && (!Math.random2(0,3))) theBells.broadcast();
    }
}




5::second => now;



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








private class Ping extends Chubgraph
{
    Impulse imp => LPF lpf => outlet;
    
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
    
    fun void hit(float Hit) { imp.next(Hit); }
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

private class Ping2 extends Chubgraph
{
    Step constant => ADSR env => LPF lpf => outlet;
    constant.next(1);
    env.set(samp, samp, .0, samp);
    env.sustainLevel(0);
    
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
    fun void set(dur attack, dur decay, float sus, dur release) { env.set(attack, decay, sus, release); }
    
    fun void hitNoSus(float Hit)
    { 
        env.target(Hit); 
        env.attackTime() => now;
        env.decayTime() => now;
        env.keyOff(1);
    }
    fun void hitSus(float Hit, dur length)
    {
        env.target(Hit);
        env.attackTime() + env.decayTime() + length => now;
        env.keyOff(1);
    }
}
private class Ping3 extends Chubgraph
{
    Impulse imp => LPF lpf => outlet;
    
    220 => float freq;
    1::second => dur approxFadeDur;
    
    s();
    
    1 => int reps;
    1 => float fade; // gotta be between 1 and 0 (maybe 1 and -1)
    samp => dur delay;
    
    fun void s()
    {
        lpf.freq(freq);
        lpf.Q(freq * (approxFadeDur/second));
    }
    fun void set(dur fadeDur) { fadeDur => approxFadeDur; s(); }
    fun void set(float myFreq) { myFreq => freq; s(); }
    fun void set(dur fadeDur, float myFreq) { fadeDur => approxFadeDur; myFreq => freq; s(); }
    
    fun void hitSpork(float Hit)
    {
        for(0 => int repCount; repCount < reps; repCount++)
        {
            imp.next(Hit*Math.pow(fade,repCount));
            delay => now;
        }
    }
}

// what is the frequency of something with a period of 1 sample?
// depends on sample rate.
// 
// SR samples = 1 second.
// SR = 1 second / sample.
// 
// if freq is F Hz...
// period = (1 / F) seconds.
// period = (1 / F) * SR samples.
// period = (SR/ F) samples.
// if period is 1 sample...
// SR samples = 1 second.
// sample = (1 /SR) seconds.
// (1 / F) seconds = (1 /SR) seconds.
// yada yada 
// F = SR.
// oh? the rate of samples per second is the frequency in inverse seconds?? go figure









// first, before anything else, a blast from the past:...
Gain safeG => Dyno safeD => Envelope fadeout => dac;

fadeout.value(1); fadeout.duration(9::second);
.5 => float maxAmp;
safeG.gain(maxAmp);
safeD.thresh(maxAmp);
safeD.slopeBelow(1.0);
safeD.slopeAbove(0.0);

Ping3 p => dac;

440 => float freq;

// what frequency modifier is needed if I want a constant shwip?
.2 => float shwipRatio;
11 => p.reps;
.97=> p.fade;
second/(shwipRatio*freq) => p.delay;

p.set(second, freq);

spork ~ p.hitSpork(1);
5::second => now;














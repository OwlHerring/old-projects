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













// first, before anything else, a blast from the past:...
Gain safeG => Dyno safeD => Envelope fadeout => dac;
fadeout.value(1);
.5 => float maxAmp;
safeG.gain(maxAmp);
safeD.thresh(maxAmp);
safeD.slopeBelow(1.0);
safeD.slopeAbove(0.0);


60 => int Do;
[
0,
2,
4,
5,
7,
9,
11,
12
]@=> int scale[];

.125::second => dur beat;

PingAdditive p => safeG;
// Be very careful as you go up. It seems different a()s have different behaviors, though they all ultimately approach painful snaps.
p.a(.2);
p.add(7);
p.set(.1::second);

repeat(8)
{
    p.a(.2);
    repeat(4)
    {
        for(0 => int scaleCount; scaleCount < scale.size(); scaleCount++)
        {
            p.set(Std.mtof(Do + scale[scaleCount]));
            p.hit(1);
            
            beat => now;
        }
        
        beat => now;
        
        for(scale.size()-2 => int scaleCount; scaleCount >= 0; scaleCount--)
        {
            p.set(Std.mtof(Do + scale[scaleCount]));
            p.hit(1);
            
            beat => now;
        }
        
        p.a() + .2 => p.a; 
    }
    4::beat => now;
    
    p.approxFadeDur + .5::second => p.set;
}


5::second => now;
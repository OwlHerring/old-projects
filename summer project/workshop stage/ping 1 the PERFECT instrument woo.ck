private class PingSimple extends Chubgraph
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
private class PingSimpleAdditive extends Chubgraph
{
    Gain g => outlet;
    
    1 => int num;
    PingSimple p[num];
    
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
            p << new PingSimple;
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
Gain safeG =>  NRev r => Dyno safeD => Envelope fadeout => dac;
     safeG =>PRCRev r2=>      safeD;

fadeout.value(.5); fadeout.duration(9::second);
.5 => float maxAmp;
safeG.gain(maxAmp);
safeD.thresh(maxAmp);
safeD.slopeBelow(1.0);
safeD.slopeAbove(0.0);
r.mix(.05);
r2.mix(.2);
r.gain(.7);
r2.gain(1 - r.gain());

[
0,-2, -4, -5, 
0, 2, -4, -2,
0,-2, -3, -5, 
0, 2,  5, -7,
-7,-2, -7, -2,
-9,-3,  3, -8,
-1,-8, -3, -1,
 0,-6, -5, -7
]@=> int transpose[];
0 => int transposeCount;
58 => int Do;
[
0,
2,
4,
7,
11,
12
]@=> int scale[];

.0625::second => dur beat;

(scale.size()-1)::beat => dur scaleUp;
2::scaleUp => dur scaleUpDown;
8::scaleUpDown => dur phrase;

32::phrase + now => time fade;

SinOsc LFO => blackhole;
LFO.freq(second/phrase);
LFO.gain(0.49);
LFO.phase(0.2);

PingSimpleAdditive p => 
safeG;

// Be very careful as you go up. It seems different a()s have different behaviors, though they all ultimately approach painful snaps.
p.a(.5 + LFO.last());
p.set(6::second);
p.add(6);

safeG.gain(4);
1 => int reps;

0 => int fadeCheck;

while(true)
{
    if(now >= fade && !fadeCheck) { fadeout.target(0); fadeout.duration(9::second); 1 => fadeCheck; }
    
    .5 + LFO.last() => p.a;
    
    repeat(8)
    {
        for(1 => int scaleCount; scaleCount < scale.size(); scaleCount++)
        {
            p.set(Std.mtof(transpose[transposeCount % transpose.size()] + Do + scale[scaleCount]));
            
            maybe => int repMod;
            for(0 => int repCount; repCount < reps+repMod; repCount++)
            {
                .5 + LFO.last() => p.a;
                
                p.hit(Math.pow(.8,repCount));
                Math.pow(reps+repMod,-1)::beat => now;
            }
        }
        
        //scale.size()::beat => now;
        
        for(scale.size()-2 => int scaleCount; scaleCount >= 0; scaleCount--)
        {
            p.set(Std.mtof(transpose[transposeCount % transpose.size()] + Do + scale[scaleCount]));
        
            for(0 => int repCount; repCount < reps; repCount++)
            {
                .5 + LFO.last() => p.a;
                
                p.hit(Math.pow(.8,repCount));
                Math.pow(reps,-1)::beat => now;
            }
        }
        
        //scale.size()::beat => now;
    
        p.a()-.11 => p.a; 
    }
    
    transposeCount++;
    
    if(fadeout.last() == 0) break;
}

2::second => now;
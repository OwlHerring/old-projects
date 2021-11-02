// external classes used: ./00.ck

// Safety first.
Gain safeG => Dyno safeD => Envelope fadeout => dac;
// Gain safeGL => Dyno safeD => Envelope fadeout => dac;
// Gain safeGR => safeD;
fadeout.value(1);
0.5 => float maxAmp;
safeG.gain(maxAmp);
//safeGL.gain(maxAmp);
//safeGR.gain(maxAmp);
safeD.thresh(maxAmp);
safeD.slopeBelow(1.0);
safeD.slopeAbove(0.0);

private class myImp extends Chubgraph
{
    Step i => Envelope e => outlet;
    inlet => outlet;
    e.value(1); e.duration(ms);
    i.next(0);
    
    samp => dur hitDurVar;
    fun dur hitDur(){return hitDurVar;} fun dur hitDur(dur nD){nD => hitDurVar; return hitDur();}
    
    1 => float volVar;
    fun float vol(){return volVar;} fun float vol(float nV){nV => volVar; return vol();}
    
    fun void set(dur h, float v){h => hitDur; v => vol;}
    
    fun void hit(){spork ~ sporkComp();}
    fun void hit(dur h){h => hitDur; hit();}
    fun void hit(float v){v => vol; hit();}
    fun void hit(dur h, float v){(h,v) => set; hit();}
    fun void sporkComp() // sporked by every hit().
    {
        i.next(vol()); 
        hitDur() => now; 
        i.next(0);
    }
}
private class myDelay extends Chubgraph
{
    inlet => Delay d => outlet;
    d => Gain g => d; g.gain(.98);
    d.delay(Ini.division(1, 440)::second);
    
    440 => float f;
    fun float freq(){d.delay(Ini.division(1,f)::second); return f;}fun float freq(float nF){nF=>f;return freq();}
    fun float gGain(){return g.gain();}fun float gGain(float nG){nG => g.gain; return gGain();}
    fun void set(float f, float g){f => freq; g => gGain;}
}

8 => int iC;
myImp m[iC];
myDelay d[iC];
JCRev r => safeG;
r.mix(.1);

for(0=>int c; c<m.size(); c++)
{
    m[c]=>d[c]=>r;
    m[c].set(Std.rand2(4,8)::samp, .5);
    d[c].set(Std.rand2(8,14) * Ini.division(220,Math.pow(2,Std.rand2(1,3))), .9);
}

fun void sporkThis(int c, dur period)
{
    now + minute => time later;
    while(now<later)
    {
        m[c].hit();
        period => now;
        m[c].e.target(.96*m[c].e.value());
    }
}

.5::second => dur low;

while(true)
{
    for(0=>int c; c<m.size(); c++)
    {
        m[c].e.target(1);
        spork ~ sporkThis(c, Std.rand2f(1,1.5)::low);
        10::second => now;
    }
    20::second => now;
}
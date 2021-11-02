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


// first, before anything else, a blast from the past:...
Gain safeG => Dyno safeD => Envelope fadeout => dac;

fadeout.value(1); fadeout.duration(9::second);
.5 => float maxAmp;
safeG.gain(maxAmp);
safeD.thresh(maxAmp);
safeD.slopeBelow(1.0);
safeD.slopeAbove(0.0);


noiseImpulse n => safeG;

n.setFreq(400);


spork ~ n.sporkThis();



while(true)
{
    second => now;
    
    n.setFreq(50 * Math.random2(8,12)); // yep, I can hear it.
}
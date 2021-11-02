// This is an ADSR with some extended functionality, determined by extendDecayOn (set via the first argument of setExtend() ).
// 0 (default): acts like it does normally. keyOn means it stays on until keyOff.
// 1: keyOn means it attacks, then decays, then sustains for extendDecay duration (set via the second argument of setExtend() ), then keyOffs automatically.
// 2: keyOn means it attacks, then decays, then keyOffs automatically.

public class ADSRextend extends Chubgraph
{
    inlet => ADSR env => outlet;
    
    fun dur attackTime(){ return env.attackTime(); }
    fun dur attackTime(dur att){ env.attackTime(att); return env.attackTime(); }
    fun dur decayTime(){ return env.decayTime(); }
    fun dur decayTime(dur dec){ env.decayTime(dec); return env.decayTime(); }
    // eh
    fun dur releaseTime(){ return env.releaseTime(); }
    fun dur releaseTime(dur rel){ env.releaseTime(rel); return env.releaseTime(); }
    
    fun void set(dur att, dur dec, float sus, dur rel){ env.set(att, dec, sus, rel); }
    //fun int state(){ return env.state(); } // at the moment I'm in the mood to be extra spartan with redundant functions. Rich coming from me but
    
    0 => int extendDecayOn; // 0: keyOn stays on until you turn it off. 1: keyOn means it sustains as long as extendDecay. 2: keyOn means it keyOffs right after beginning sustain.
    0::second => dur extendDecay;
    
    fun void setExtend(int on, dur ext){ on => extendDecayOn; ext => extendDecay; }
    
    fun void keyOn(int one)
    {
        env.keyOn(one);
        if(extendDecayOn) spork ~ component(one);
    }
    fun void component(int one)
    {
        // right after env.keyOn(one).
        env.attackTime() + env.decayTime() => now;
        if(extendDecayOn != 2) extendDecay => now;
        env.keyOff(one);
    }
    fun void keyOn(int on, int one)
    {
        on => extendDecayOn;
        keyOn(one);
    }
    fun void keyOff(int one){ env.keyOff(one); }
}
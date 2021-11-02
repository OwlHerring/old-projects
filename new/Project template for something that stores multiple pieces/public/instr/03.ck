// SEH: Sawtooth Extend HPF.
// a simple setup. 
// 
// Requires ADSRextend from a previous file (but it's really easy to wean it off of ADSRextend and back onto ADSR. However, its subclasses assume ADSRextend).

public class SEH extends Chubgraph // recently changed name to SEH
{
    SawOsc saw => ADSRextend env => HPF hpf => outlet;
    fun void sync(int sy){saw.sync(sy);}
    fun void connectInlet(UGen myUGen) // you do this instead of myUGen => mySawEnvHPF. Is this compatible with the typical UGen format? e.g. SinOsc s => sawEnvHPF mySaw.connectUGen;
    {
        if(!inlet.isConnectedTo(saw)) inlet => saw;
        myUGen => inlet;
    }
    // defaults:
    float ratioVar; // of hpf's freq compared to saw's freq.
    
    //freq(220); // these two give nullpointer issues when you also have SEHGliss down there.
    //set(1, 6);
    
    set(.1::second, .01::second, 0.2, .2::second);
    setExtend(1, .1::second);
    
    fun void freqComponent(float F){ F => saw.freq; } // separated from main function so that SEHGliss can change just this painlessly
    
    fun float freq(){ return saw.freq(); }
    fun float freq(float F){ freqComponent(F); freq()*ratio() => hpf.freq; return freq(); }
    fun float ratio(){ return ratioVar; }
    fun float ratio(float R){ R => ratioVar; freq()*ratio() => hpf.freq; return ratio(); }
    fun float Q(){ return hpf.Q(); }
    fun float Q(float q){ q => hpf.Q; return Q(); }
    fun void set(float R, float q){ R => ratio; q => Q; }
    fun void set(float F, float R, float q){ F => freq; R => ratio; q => Q; }
    
    fun void set(dur att, dur dec, float sus, dur rel){ env.set(att, dec, sus, rel); }
    fun void setExtend(int on, dur ext){ env.setExtend(on, ext); }
    
    // goddamn it, this bit is required for the subclass SEHGroupGliss. It's the curse of superclasses
    fun dur glissDur(){ } 
    fun dur glissDur(dur nD){ }
    
    fun void keyOn(int one){ env.keyOn(one); }
    fun void keyOff(int one){ env.keyOff(one); }
    fun void keyOn(int on, int one){ on => env.extendDecayOn; env.keyOn(one); }
    //the function below is pure excess and I think using it, mySEH.state(), instead of mySEH.env.state() or actually mySEH.env.env.state(), will probably only serve to slightly hamper performance.
    //fun int state(){ return env.state(); } // for reference: attack=0, decay=1 , sustain=2, release=3, done=4
}
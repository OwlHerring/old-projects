// SEHGroup: a set of several SEHs, that gives the sound some polyphonic capacity.
// Picks the SEH that plays based on two factors: 
// 1) Their ADSR(extend)'s state(). Priority on higher values (0 means attack, 1 means decay, 2 means sustain, 3 means release and 4 means off. So if something is 4 it prefers that to something that's 3, but if nothing is 4 then it prefers 3 over 1.)
// 2) Their index in the array. Priority on lower indices (if s[0] is 4 and s[1] is 4, it doesn't even consider s[1] because it's already chosen s[0]).

public class SEHGroup extends Chubgraph
{
    SEH s[0];
    fun void connectInlet(UGen myUGen) // you do this instead of myUGen => mySawEnvHPF. Is this compatible with the typical UGen format? e.g. SinOsc s => sawEnvHPF mySaw.connectUGen;
    {
        if(!inlet.isConnectedTo(s[s.size()-1])) // if the topmost (last added) SEH is not connected to inlet, then
        {
            for(0 => int count; count < s.size(); count++) // it checks each SEH to see if they're connected to inlet.
            {
                if(!inlet.isConnectedTo(s[count])) inlet => s[count].connectInlet; // if not it connects them.
            }
        }
        myUGen => inlet; // then it connects the old one.
    }
    fun void add(int howMany)
    {
        for(s.size() => int oldSize => int count; count < oldSize+howMany; count++)
        {
            s << new SEH;
            s[count] => outlet;
        }
    }
    
    add(1);
    allSet(220, 1, 6, .1::second, .01::second, 0.2, .2::second, 1, .1::second);
    
    
    //freq(220);
    //set(1, 6);
    //set(.1::second, .01::second, 0.2, .2::second);
    //setExtend(1, .1::second);
    
    fun float ratio(){ return s[Count()].ratio(); }
    fun float ratio(float R){ R => s[Count()].ratio; return ratio(); } 
    fun float ratio(int which){ return s[which%s.size()].ratio(); }
    fun float ratio(int which,float R){ R => s[which%s.size()].ratio; return ratio(which); }
    
    fun float freq(){ return s[Count()].freq(); }
    fun float freq(float F){ F => s[Count()].freq; return freq(); }
    fun float freq(int which){ return s[which%s.size()].freq(); }
    fun float freq(int which,float F){ F => s[which%s.size()].freq; return freq(); }
    
    fun float Q(                 ){ return s[Count()].Q(); }
    fun float Q(          float q){ q => s[Count()].Q; return Q(); }
    fun float Q(int which        ){ return s[which%s.size()].Q(); }
    fun float Q(int which,float q){ q => s[which%s.size()].Q; return Q(); }
    
    fun void set(                    float R, float q){ R => ratio; q => Q; }
    fun void set(int which,          float R, float q){ which, R => ratio; which, q => Q; }
    fun void set(           float F, float R, float q){ F => freq; R => ratio; q => Q; }
    fun void set(int which, float F, float R, float q){ which, F => freq; which, R => ratio; which, q => Q; }
    
    fun void set(           dur att, dur dec, float sus, dur rel){ s[Count()].set(att, dec, sus, rel); }
    fun void set(int which, dur att, dur dec, float sus, dur rel){ s[which%s.size()].set(att, dec, sus, rel); }
    
    fun void setExtend(           int on, dur ext){ s[Count()].setExtend(on, ext); }
    fun void setExtend(int which, int on, dur ext){ s[which%s.size()].setExtend(on, ext); }
    
    //                           freq,    ratio,   Q,      (ADSR)attack,  decay,   sustain,   release, (Extend)setting,extendDur.
    fun void grandSet(           float F, float R, float q,      dur att, dur dec, float sus, dur rel,         int on, dur ext) { set(F,R,q); set(att,dec,sus,rel); setExtend(on, ext); }
    fun void grandSet(int which, float F, float R, float q,      dur att, dur dec, float sus, dur rel,         int on, dur ext) { set(which,F,R,q); set(which,att,dec,sus,rel); setExtend(which,on, ext); }
    fun void allSet  (           float F, float R, float q,      dur att, dur dec, float sus, dur rel,         int on, dur ext) { for(0 => int sCount; sCount < s.size(); sCount++){grandSet(sCount,F,R,q,att,dec,sus,rel,on,ext);} }
    // I think I've gone overboard.
    
    // now to the meat of it.
    // for reference: attack=0, decay=1 , sustain=2, release=3, done=4. Also, to get state() from the horse's mouth I'll need an "s[#].env.env.state()".
    fun int Count() // I want something that gives me 0 (as in the zeroth member of an array) unless s[0].env.env.state()<4, in which case gives me 1 unless s[1].env.env.state()<4, in which case... And if it reaches the end of the forloop and still hasn't found an available SEH, it cuts the loop and resorts to a different selection method based on other numbers.
    {               // Alright, I got this
        int done;   // done starts out at 0, because it's not done
        for(4 => int preferredState; done == 0; preferredState--) // the loop is contingent on the variable 'done'. This places preference on the first, least recently-sounded s[#] this function encounters.
        {
            for(0 => int sCount; sCount < s.size() && done == 0; sCount++) // if this loop ends because sCount is no longer < s.size(), the outer loop begins again. If this loop ends because done isn't false, the whole thing pops.
            {
                if(s[sCount].env.env.state() >= preferredState) // the greater than part shouldn't factor in at all. Should I cut that? Eh
                {
                    1 => done;
                    return sCount; // The one that satisfies the Count() gets to return home.
                    me.exit();
                }                  // In the simpler language I've been working with lately, return just ends a called function. I dunno if it does so here too (in which case the done variable is pointless)
            }
        }
    }
    // it's done. That is my magnum opus, just above
    
    // this returns a value that you can later redeem at the keyOff function.
    fun int keyOn(int one){ Count() => int ticket; s[ticket].keyOn(one); return ticket;}
    fun int keyOn(int on, int one){ Count() => int ticket; on => s[ticket].env.extendDecayOn; s[ticket].keyOn(one); return ticket; }
    // feed the above into below in order to pick it out and kill it.
    // unfortunately I cannot spare the time to figure out how to proof this system for if s[myInteger] has been .keyOffed already. I just can't, I am sorely tempted to but the day passes at an alarming rate
    
    // if you tell it which one to kill, it kills that one.
    fun void keyOff(int ticket, int one){s[ticket].keyOff(one);} 
    // if you don't specify, it kills all of them. 
    fun void keyOff(int one){for(0=>int sCount;sCount<s.size();sCount++){ keyOff(sCount, one); }}
}
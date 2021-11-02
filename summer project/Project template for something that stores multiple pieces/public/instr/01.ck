public class PingSuper extends Chubgraph
{
    float dynamicVar; // this should be set in different Pings to be their specific mezzo. Then Hit would be in relation to that mezzo.
    fun float dynamic()
    {
        return dynamicVar;
    }
    fun float dynamic(float multiplier)
    {
        return multiplier*dynamicVar;
    }
    
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
}
// external classes used: ./00.ck
// because god knows I'm not gonna reinvent the wheel with that blasted modulo stuff.



// Safety first.
Gain safeG => Dyno safeD => Envelope fadeout => dac;
fadeout.value(1);
0.5 => float maxAmp;
safeG.gain(maxAmp);
safeD.thresh(maxAmp);
safeD.slopeBelow(1.0);
safeD.slopeAbove(0.0);

///

PRCRev r => safeG;
r.mix(.12);

// plan:
// First, I'll make a private class. 
//
// Then, I'll give it a static float array for the major scale freq ratios: 1:1 as bottom and 2:1 as top.)
//
// Then, I'll give it a variable: a tonic.
//
// Then, I'll give it a function that takes two inputs: the frequency of the tonic, and the scale degree (0 = c, 4 = g, 7 = c', -1 = B), and returns the frequency of the scale degree above or below that tonic.
// // -- inputs:
// // -- 1. float: the frequency of the tonic.
// // -- 2. int: the scale degree. (0: scale degree 1. 7: scale degree 1, up an octave.)
// 

private class Scale
{
    // this is the major scale for all instances of Scale.
    [ 1.0, 1.125, 1.25, 1.333, 1.5, 1.667, 1.875 ] @=> static float majScale[];
    //  0      1     2      3    4      5      6     7...
    
    // this is the tonic frequency for this particular Scale object.
    // you can set it to something new with tF(a new freq), or return the freq with tF(). You can also return the freq with tF(new freq) if the context required it I suppose
    float tonVar;
    tF(440); // default setting is 440
    fun float tF(){return tonVar;}
    fun float tF(float nF){nF => tonVar; return tF();} 
    
    // there will be two versions of this function: 
    // one which takes only int sDeg and uses the existing tF(), 
    // and one which also sets tF() to a new value.
    fun float scale(int sDeg)
    {
        return 
        tF()
        *
        majScale[Ini.modPlus(sDeg, majScale.size(), 0)]
        *
        Math.pow(2,Ini.modPlus(sDeg, majScale.size(), 1))
        ;
    }
    fun float scale(int sDeg, float nF)
    {
        nF => tF;
        return scale(sDeg);
    }
}

private class myInst extends Chubgraph
{
    LPF lpf => ADSR adsr => outlet;
    
    SawOsc s; 
    SqrOsc s2;
    if(maybe){s=>lpf;}else{s2=>lpf;}
    
    lpf.set(4000,0.9);
    set(0.01::second,0.2::second,.1,0.25::second);
    freq(440);
    
    // adsr setup
    fun void set(dur a, dur d, float s, dur r){adsr.set(a,d,s,r);}
    fun float value(){return adsr.value();} fun float value(float nV){adsr.value(nV); return value();}
    fun void keyOn(int on){adsr.keyOn(on);}
    fun void keyOff(int off){adsr.keyOff(off);}
    
    // saw setup
    fun float freq(){return s.freq();} fun float freq(float nF){nF => s.freq; nF => s2.freq; return freq();}
}


//<<< myS.tF() >>>; 
//<<< Ini.modPlus(-2, 7, 0) >>>;
//<<< Ini.modPlus(-2, 7, 1) >>>;
[0, 4, 3, 2, 3, 2, 0, 1, 2, 3, 2, 1, 2, 1, 0, -1, -2, 0, -1, -3] @=> int mel[];

private class Player
{
    static int Count; // how many players are active at this moment.
    
    Scale myS; // each one gets a scale
    
    myInst s => r; // connect new myTri s to external reverb r.
    tF(440); // change Scale myS's tF (tonic freq) to 440 by default.
    
    second => dur playLengthVar;
    fun dur playLength(){return playLengthVar;} fun dur playLength(dur nD){nD => playLengthVar; return playLength();}
    fun float tF(){return myS.tF();} fun float tF(float nF){nF => myS.tF; return tF();}
    
    fun void set(dur pL, float t){playLength(pL); tF(t);}
    
    fun void sporkThis(dur pL, float t, dur beat)
    {
        0 => int offset => int oldOffset;
        
        s.set(.01::beat,.2::beat,.1,2::beat);
        
        set(pL,t);
        
        now + playLength() => time later;
        Count++;
        while(now<later)
        {
            for(0 => int c; c < mel.size(); c++)
            {    
                //s.freq(myS.scale(mel[c + offset]));
                s.freq(myS.scale(mel[c]+offset));
                
                s.keyOn(1);
                .9::beat => now;
                s.keyOff(1);
                .1::beat => now;
            }
            
            while(offset==oldOffset){Std.rand2(-3,4)=>offset;}
            offset=>oldOffset; // these two lines make it reroll until it gets something different from last time.
            
            3::beat => now;
        }
        Count--;
        <<< "A player has stopped. " + Count + " player(s) remaining.">>>;
        
        //Std.rand2(-3,4) => offset;
    }
    
    
}

0.5::second => dur beat;

2.75::minute + now => time end;

Player p[9];
200 => float myFreq;
0 => int c;

spork ~ p[Ini.modPlus(c, p.size(), 0)].sporkThis(8*(mel.size()+2)::beat, myFreq, 1::beat);
c++;

2*mel.size()::beat => now;
.5::beat => now;

Ini.division(4,3) *=> myFreq;

spork ~ p[Ini.modPlus(c, p.size(), 0)].sporkThis(8*(mel.size()+2)::beat, myFreq, 1::beat);
c++;

while(now < end)
{            // usually 2, sometimes 1 and sometimes 4
    Math.pow(2,maybe+maybe)*mel.size()::beat => now;
    (.5*maybe)::beat => now;
    
    maybe => int P4orP5; // if 0, a P5; if 1, a P4.
    
    ((P4orP5+2+maybe)/(P4orP5+2)) *=> myFreq; // myFreq may or may not rise by a perfect fifth or fourth.
    if(myFreq > 1200){ Math.pow(2,Std.rand2(2,5)) /=> myFreq; } // above a certain pitch, myFreq must be lowered by either 2, 3 or 4 octaves.
    
    spork ~ p[Ini.modPlus(c, p.size(), 0)].sporkThis(8*(mel.size()+2)::beat, myFreq, Math.pow(2,1-maybe-maybe+maybe+maybe)::beat);
    c++;
}

while(true){second => now;}


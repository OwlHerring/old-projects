
private class safeGFirst extends Chubgraph
{
    inlet => Gain safeG => Dyno safeD => outlet; 
    .5 => float maxAmp;
    safeG.gain(maxAmp);
    safeD.thresh(maxAmp);
    safeD.slopeBelow(1.0);
    safeD.slopeAbove(0.0);
}
private class noiseSuper extends Chubgraph
{
    fun void next(float input) { }
    
    // Feel free to add more to either of these in the body of the code.
    [ 1.0, -1.0 ] @=> float outputs[]; // This will choose between these inputs randomly. 
    
    [ 1.0, 1.5, 2.0 ] @=> float ratios[];
    
    880 => float baseFreq;
    
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
}
private class noiseImpulse extends noiseSuper
{
    Impulse imp => outlet;
    
    fun void next(float input){ imp.next(input); }
}
private class noiseStep extends noiseSuper
{
    Step imp => outlet;
    
    fun void next(float input){ imp.next(input); }
}



private class PingSuper extends Chubgraph
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

private class Ping extends PingSuper
{
    Impulse imp => lpf;
    fun void hit(float Hit) { imp.next(Hit); }
}
private class PingB extends Ping // all this does is add two sine waves of the same frequency, more or less.
{
    .5 => float anti;
    
    fun void hit(float Hit) { spork ~ hitComponent(Hit); }
    fun void hitComponent(float Hit)
    { 
        imp.next(Hit);
        if(anti>0) anti::freqPeriod() => now;
        else samp => now;
        imp.next(-Hit); 
    }
}
private class Ping2 extends PingSuper
{
    Step constant => ADSR env => lpf;
    constant.next(1);
    env.set(samp, samp, .5, samp);
    
    0::second => dur susTime; // whatever the effects of changing this are, they won't affect already-sounding notes, I think.
    
    fun void set(dur att, dur dec, float sus, dur rel) { env.set(att, dec, sus, rel); }
    
    fun void hit(float Hit, dur length)
    {
        env.target(Hit);
        spork ~ hitComponent();
    }
    fun void hitComponent()
    {
        env.attackTime() + env.decayTime() + susTime => now;
        env.keyOff(1);
    }
}
private class Ping3 extends PingSuper
{
    1.0 => dynamicVar;
    
    Impulse imp => lpf;
    
    fun void hit(float Hit){ spork ~ hitComponent(dynamic()*Hit); }
    fun void hitComponent(float Hit)
    {
        for(0 => int repCount; repCount < reps; repCount++)
        {
            imp.next(Hit*Math.pow(fade,repCount));
            delay => now;
        }
    }
}
private class PingDelay extends PingSuper
{
    .9 => fade;
    100::samp => delay;
    
    Impulse imp => Delay d => lpf;
    d => Gain g => d; g.gain(fade);
    
    
    second/delay => float delayFreq;
    setupDelay();
    
    fun void setupDelay() { d.delay(second / delayFreq); d.delay() => delay; }
    fun void setDelayFreq(float myFreq) { myFreq => delayFreq; setupDelay(); }
    
    fun void setF(float fad){ fad => fade; g.gain(fade); }
    fun void setD(dur dela){ dela => delay; delay => d.delay; second/delay => float delayFreq;}

    fun void hit(float Hit) { imp.next(Hit); }
}

private class PingDelayPitch extends PingDelay // this seems broken at the moment.
{
    1 => float ratio;
    ratio*freq => delayFreq;
    fun void setupDelay() { ratio*freq => delayFreq; d.delay(second / delayFreq); d.delay() => delay; }
    fun void setDelayRatio(float myRatio) { myRatio => ratio; setupDelay(); }
    
    fun void set(float myFreq) { myFreq => freq; setupDelay(); s(); }
    fun void set(dur fadeDur, float myFreq) { fadeDur => approxFadeDur; myFreq => freq; setupDelay(); s(); }

}
private class Ping4 extends PingSuper
{
    .01 => dynamicVar;
    
    noiseStep noise => Envelope env => lpf;
    
    spork ~ noise.sporkThis();
    
    .01::second => attack;
    .01::second => decay;
    0 => sustain;
    .01::second => release;
    
    880 => baseFreq;
    
    fun void setBow(float newFreq)
    {
        newFreq => baseFreq => noise.baseFreq;
    }
    
    fun void set(dur att, dur dec, float sus, dur rel) { att => attack; dec => decay; sus => sustain; rel => release; }
    
    fun void hit(float Hit){ spork ~ hitComponent(Hit); }
    fun void hitComponent(float Hit)
    { 
        noise.toggle(1);
        
        env.target(dynamic() * Hit);
        env.duration(attack);
        attack => now; 
        
        env.target(dynamic() * sustain * Hit);
        env.duration(decay);
        
        if(holding) stop => now;
        else decay => now;
        
        env.target(0);
        env.duration(release);
        
        noise.toggle(0);
    }
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
    .5 => float fadeRatio;
    // if fadeRatio is .5, then
    // p[0] will last 1::approxFadeDur, 
    // p[1] will last .5::approxFadeDur,
    // p[2] will last .25::approxFadeDur, etc.
    // if fadeRatio is 1.5, then
    // p[0] will last 1::approxFadeDur,
    // p[1] will last 1.5::approxFadeDur,
    // p[2] will last 2.25::approxFadeDur, etc.
    
    setup();
    
    fun void setup()
    {
        for(0 => int pCount; pCount < p.size(); pCount++)
        {
            if(!p[pCount].isConnectedTo(g)) p[pCount] => g;
            
            a() * Math.pow(r(), pCount-(pCount == p.size()-1)) => p[pCount].gain; // wow, that's so much simpler.
            
            p[pCount].set(
                          Math.pow(fadeRatio, pCount)::approxFadeDur,
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
    fun void setFadeRatio(float fr) { fr => fadeRatio; setup(); }
    fun void set(dur fadeDur) { fadeDur => approxFadeDur; setup(); }
    fun void set(float myFreq) { myFreq => freq; setup(); }
    fun void set(dur fadeDur, float myFreq) { fadeDur => approxFadeDur; myFreq => freq; setup(); }
    fun void hit(float Hit)
    {
        for(0 => int pCount; pCount < p.size(); pCount++) p[pCount].hit(Hit);
    }
}
private class PingSuperAdditive extends Chubgraph
{
    Gain g => outlet;
    
    1 => int num;
    PingSuper @ p[num];
    
    0 => int allowSetup;
    
    0.5 => float aVar;                 // first term of the geometric series determining gain.
    fun float a(float newA) { newA => aVar; setup(); return a(); }
    fun float a() { return aVar;     } // (please use these two functions for reference.) 
    fun float r() { return 1 - aVar; } // second term of said series divided by first term.
    
    220 => float freq;
    1::second => dur approxFadeDur;
    .5 => float fadeRatio;
    // if fadeRatio is .5, then
    // p[0] will last 1::approxFadeDur, 
    // p[1] will last .5::approxFadeDur,
    // p[2] will last .25::approxFadeDur, etc.
    // if fadeRatio is 1.5, then
    // p[0] will last 1::approxFadeDur,
    // p[1] will last 1.5::approxFadeDur,
    // p[2] will last 2.25::approxFadeDur, etc.
    
    // for Ping3.
    1 => int reps;
    1 => float fade; // gotta be between 1 and 0 (maybe 1 and -1)
    samp => dur delay; // between successive impulses.
    
    // for Ping4.
    .1::second => dur attack; .1::second => dur decay; .5 => float sustain; .1::second => dur release;
    
    setup();
    
    fun void allow() // this indicates you are done and that no null references remain in p.
    {
        1 => allowSetup;
        setup();
    }
    fun void setup() // this is for use by other class functions.
    {
        if(allowSetup)
        {
            for(0 => int pCount; pCount < p.size(); pCount++)
            {
                if(!p[pCount].isConnectedTo(g)) p[pCount] => g;
                
                a() * Math.pow(r(), pCount-(pCount == p.size()-1)) => p[pCount].gain; // wow, that's so much simpler.
                
                p[pCount].set(
                            Math.pow(fadeRatio, pCount)::approxFadeDur,
                            freq*(pCount+1)
                );
                
                p[pCount].setShwip(reps, fade, delay);
                
                attack => p[pCount].attack;
                decay => p[pCount].decay;
                sustain => p[pCount].sustain;
                release => p[pCount].release;
            }
        }
    }
    fun void add(int howMany) // don't do this after allow().
    { 
        p.size(p.size()+howMany);
        p.size() => num;
    }
    // for Ping4B.
    fun void hold(int Holding) { for(0 => int pCount; pCount < p.size(); pCount++) p[pCount].hold(Holding); }
    fun void stopBowing() { for(0 => int pCount; pCount < p.size(); pCount++) p[pCount].stopBowing(); }
    fun void set(dur att, dur dec, float sus, dur rel) { att => attack; dec => decay; sus => sustain; rel => release; setup(); } 
    880 => float baseFreq;
    fun void setBow(float newFreq) { for(0 => int pCount; pCount < p.size(); pCount++) newFreq => baseFreq => p[pCount].setBow; }
    
    fun void setFadeRatio(float fr) { fr => fadeRatio; setup(); }
    fun void set(dur fadeDur) { fadeDur => approxFadeDur; setup(); }
    fun void set(float myFreq) { myFreq => freq; setup(); }
    fun void set(dur fadeDur, float myFreq) { fadeDur => approxFadeDur; myFreq => freq; setup(); }
    fun void set(dur Att, dur Dec) { Att => attack; Dec => decay; setup();} // this is for Ping4.
    // for Ping3.
    fun void setR(int rep){ rep => reps; } 
    fun void setF(float fad){ fad => fade; } 
    fun void setD(dur dela){ dela => delay; }
    fun void setShwip(int rep, float fad, dur dela){ setR(rep), setF(fad), setD(dela); }
    
    fun void hit(float Hit) // until you pick which descendent of PingSuper each one is, and turn startConnectingToG on, this will make no sound. 
    {
        for(0 => int pCount; pCount < p.size(); pCount++) p[pCount].hit(Hit);
    }
}
private class PingSuperAdditiveMetallic extends PingSuperAdditive
{
    80 => float offsetNum; // effectively, offset is 80/79.
    fun float offset(){ return offsetNum * Math.pow(offsetNum-1,-1); }
    
    fun void setup()
    {
        if(allowSetup)
        {
            for(0 => int pCount; pCount < p.size(); pCount++)
            {
                if(!p[pCount].isConnectedTo(g)) p[pCount] => g;
                
                a() * Math.pow(r(), pCount-(pCount == p.size()-1)) => p[pCount].gain; // wow, that's so much simpler.
                
                if(pCount == 0)
                {
                    p[pCount].set(
                                  Math.pow(fadeRatio, pCount)::approxFadeDur,
                                  freq * (pCount+1)
                    );
                }
                else
                {
                    p[pCount].set(
                                  Math.pow(fadeRatio, pCount)::approxFadeDur,
                                  forloopRandom2f(pCount-1, offset() * freq * (pCount+1), Math.pow(offset(),-1) * freq * (pCount+1))
                    );
                }
                
                
                attack => p[pCount].attack;
                decay => p[pCount].decay;
            }
        }
    }
}

private class Cello extends PingSuperAdditive
{
    add(7);
    
    for(0 => int pCount; pCount < num; pCount++)
    {
        new Ping4 @=> p[pCount];
    }
    
    setFadeRatio(1.2); // This is the ratio between the fading times of harmonic N and harmonic N+1. Be careful < .5!  
    a(.2);             // This is the relative strength of harmonics. Closer to .001: ponticello. Closer to .99: sul tasto.
    set(.2::second, .1::second, .8, .5::second); // sets ADSR of the noise being filtered.
    allow();
    hold(1);
    set(.3::second);
    
    setBow(440);
}

private class Reverb1 extends Chubgraph
{
    inlet => Delay e => outlet;
    inlet => Delay e2=> outlet;
    
    e => Gain gE => e; gE.gain(.7); e.delay(.05::second); e.max(.1::second);
    e2=> Gain gE2=> e2;gE2.gain(.6);e2.delay(.09::second);e2.max(.1::second);
}


private class EDO 
{
    // default is 12.
    12 => static int tone;
    fun int toneNum(){ return tone; }                                  // returns tones per octave.
    fun float toneInv(){ return Math.pow(tone,-1); }                   // returns inverse of above.
    fun float semi(){ return Math.pow(2, toneInv()); }                 // returns ratio of a single semitone.
    fun float semi(int count){ return Math.pow(this.semi(), count); }  // returns ratio of X semitones.
    1 => int halfstepSize;
    fun int accidental(int halfsteps){ return halfstepSize * halfsteps; }
    
    32 => static float C0; // This is the pitch standard. (C3 is 256 Hz. A4 is (in 12tet) 432 Hz.)
    [
    0, //C
    2, //D
    4, //E
    5, //F
    7, //G
    9, //A
    11 //B
    ]
    @=> int letterSemitones[]; // Won't with fewer than 7.
    
    [
    // Cb, Dbb, Ebb, Fb, Gb, Abb, Bbb
      [-1, -2, -2, -1, -1, -2, -2],  // 0
    // Cb, Db, Ebb, Fb, Gb, Abb, Bbb
      [-1, -1, -2, -1, -1, -2, -2],  // 1
    // Cb, Db, Ebb, Fb, Gb, Ab, Bbb
      [-1, -1, -2, -1, -1, -1, -2],  // 2
    // Cb, Db, Eb, Fb, Gb, Ab, Bbb
      [-1, -1, -1, -1, -1, -1, -2],  // 3
    // Cb, Db, Eb, Fb, Gb, Ab, Bb
      [-1, -1, -1, -1, -1, -1, -1],  // 4
    // Cb, Db, Eb, F, Gb, Ab, Bb
      [-1, -1, -1, 0, -1, -1, -1],   // 5
    // C, Db, Eb, F, Gb, Ab, Bb
      [0, -1, -1, 0, -1, 0, -1],     // 6
    // C, Db, Eb, F, G, Ab, Bb
      [0, -1, -1, 0, 0, -1, -1],     // 7
    // C, D, Eb, F, G, Ab, Bb
      [0, 0, -1, 0, 0, -1, -1],      // 8
    // C, D, Eb, F, G, A, Bb
      [0, 0, -1, 0, 0, 0, -1],       // 9
    // C, D, E, F, G, A, Bb
      [0, 0, 0, 0, 0, 0,-1],         // 10
    // C, D, E, F, G, A, B
      [0, 0, 0, 0, 0, 0, 0],         // 11
    // C, D, E, F#,G, A, B
      [0, 0, 0, 1, 0, 0, 0],         // 12
    // C#,D, E, F#,G, A, B
      [1, 0, 0, 1, 0, 0, 0],         // 13
    // C#,D, E, F#,G#,A, B
      [1, 0, 0, 1, 1, 0, 0],         // 14
    // C#,D#,E, F#,G#,A, B
      [1, 1, 0, 1, 1, 0, 0],         // 15
    // C#,D#,E, F#,G#,A#,B
      [1, 1, 0, 1, 1, 1, 0],         // 16
    // C#,D#,E#,F#,G#,A#,B
      [1, 1, 1, 1, 1, 1, 0],         // 17
    // C#,D#,E#,F#,G#,A#,B#
      [1, 1, 1, 1, 1, 1, 1],         // 18
    // C#,D#,E#,Fx,G#,A#,B#
      [1, 1, 1, 2, 1, 1, 1],         // 19
    // Cx,D#,E#,Fx,G#,A#,B#
      [2, 1, 1, 2, 1, 1, 1],         // 20
    // Cx,D#,E#,Fx,Gx,A#,B#
      [2, 1, 1, 2, 2, 1, 1],         // 21
    // Cx,Dx,E#,Fx,Gx,A#,B#
      [2, 2, 1, 2, 2, 1, 1]          // 22
    ]
    @=> int keySig[][]; // keySig[11] is the key of C. 
    11 => int CMajor => int key;
    fun void setKey(int newKey){ if(newKey >= -11 && newKey <= 11){ newKey + CMajor => key; } else{ <<<"Wrong again.">>>; } } // this way, setKey(0) sets it at C Major. The only inputs acceptable are from -11 to 11. Anything less or more would yield an error, so it's off limits.
    fun int readKey(){ return key - CMajor; } // returns positions on the circle of fifths away from C Major.
    
    [0, 0, 0, 0, 0, 0, 0] @=> int chromAlt[]; // NOTE: chromAlt is in chromatic semitones and alters the major scale of each key, while keySig is in diatonic semitones and modifies CDEFGAB no matter what. 
    fun int tonic() // this returns the pitch class tonic of the current major key. In order to synchronize with above.
    {
        //     pitch class of:           4 (that is, a fifth) times the number of fifths above or below C Major. (octave equivalence) (0 means it's the modulus function)
        return modPlus(        Std.ftoi( 4                    *readKey()),                                       letterSemitones.size(),0);
    }
    fun int tonicMinor() { return tonic() - 2; } // this doesn't do modulus, be warned.
    fun void setChromAlt(int newChromAlt[])
    {
        for(0 => int chromAltCount; chromAltCount < chromAlt.size() && chromAltCount < newChromAlt.size(); chromAltCount++)
        {
            newChromAlt[chromAltCount] => chromAlt[chromAltCount];
        }
    }
    
    
    //  returns, in Hertz: (x octaves times EDO, plus distance between white keys, plus chromatic alterations to the major scale, plus diatonic alterations to CDEFGAB) semitones above C0.
    fun float C(int oct, int acci){ return C0 * semi(tone*oct + letterSemitones[0] + chromAlt[modPlus(tonic()-0,letterSemitones.size(),0)] + accidental(acci + keySig[key][0])); }
    fun float C(int oct)          { return C(oct, 0); }
    fun float D(int oct, int acci){ return C0 * semi(tone*oct + letterSemitones[1] + chromAlt[modPlus(tonic()-1,letterSemitones.size(),0)] + accidental(acci + keySig[key][1])); }
    fun float D(int oct)          { return D(oct, 0); }
    fun float E(int oct, int acci){ return C0 * semi(tone*oct + letterSemitones[2] + chromAlt[modPlus(tonic()-2,letterSemitones.size(),0)] + accidental(acci + keySig[key][2])); }
    fun float E(int oct)          { return E(oct, 0); }
    fun float F(int oct, int acci){ return C0 * semi(tone*oct + letterSemitones[3] + chromAlt[modPlus(tonic()-3,letterSemitones.size(),0)] + accidental(acci + keySig[key][3])); }
    fun float F(int oct)          { return F(oct, 0); }
    fun float G(int oct, int acci){ return C0 * semi(tone*oct + letterSemitones[4] + chromAlt[modPlus(tonic()-4,letterSemitones.size(),0)] + accidental(acci + keySig[key][4])); }
    fun float G(int oct)          { return G(oct, 0); }
    fun float A(int oct, int acci){ return C0 * semi(tone*oct + letterSemitones[5] + chromAlt[modPlus(tonic()-5,letterSemitones.size(),0)] + accidental(acci + keySig[key][5])); }
    fun float A(int oct)          { return A(oct, 0); }
    fun float B(int oct, int acci){ return C0 * semi(tone*oct + letterSemitones[6] + chromAlt[modPlus(tonic()-6,letterSemitones.size(),0)] + accidental(acci + keySig[key][6])); }
    fun float B(int oct)          { return B(oct, 0); }
    
    // because the above is less crazy-automatic-shit-friendly, the following puts a number to it.
    // let's do something nuts.
    // letter represents the position on the C diatonic scale. 0 is C, 6 is B.
    // if letter is 1...
        // acts just like D(oct, acci).
        // normal.
    // if letter is -6...
        // should act like D(oct-1, acci).
        // should act like dia(letter+7, oct-1, acci).
        //                          dia(letter+
    // if letter is 7...
        // should act like dia(letter-7, oct+1, acci);
    fun float dia(int letter, int oct, int acci) // if you want easy transposing, define the melody in terms of tonic() + x.
    {
        //     C0 in Hz times the following semitones: [semitones per octave] times (the sum of [octaves above 0] and any extra octaves (from inputting 8 diatonic steps or something)), plus the semitone value of the inputted diatonic steps (mod diatonic scale size),  plus designated chromatic alteration of any given step (same as previous),            plus accidental modifier based on key signature                                          and any additional accidental beyond that.
        return C0       *     semi(                    tone                   *     (oct                          +   modPlus(letter,letterSemitones.size(),1))                          +    letterSemitones[      modPlus(letter, letterSemitones.size(),0)]            + chromAlt[                             modPlus(letter-tonic(), letterSemitones.size(),0)] +    accidental(                  keySig[key][modPlus(letter, letterSemitones.size(),0)] +  acci)                                );
    }
    fun float dia(int letter, int oct)
    {
        return dia(letter, oct, 0);
    }
    
    fun float chrom(int semitoneCount) {return C(0, semitoneCount);} // same as using C(0, acci). Just for clarity.
    
    fun void setup(int newTone, int newHalfstepSize, int newLetters[])
    {
        newTone => tone;
        newHalfstepSize => halfstepSize;
        for(0 => int letterCount; letterCount < letterSemitones.size(); letterCount++)
        {
            newLetters[letterCount%newLetters.size()] => letterSemitones[letterCount]; 
        }
    }
}

private class Note
{
    220 => float freq;
    second => dur length;
    1 => float gain;
    // I still need to add: some way to distinguish a note from a rest. Articulation in general.
    
    1 => int isANote; // (and not a rest)
    1 => int slur; // from previous note
}
fun Note createNote(float freq, dur length, float gain, int isANote, int slur)
{
    Note newNote;
    freq => newNote.freq;
    length => newNote.length;
    gain => newNote.gain;
    isANote => newNote.isANote;
    slur => newNote.slur;
    
    return newNote;
}









//
// // // Pure mechanics functions:

fun int booleanRatio(int num, int denom)
{
    return (Math.random2(1, denom) <= num);
}

fun int forloopMaybe(int count)
{ 
    maybe => int Maybe; 
    if(count == 0) return Maybe;
        else if(count == 1) return !Maybe;
            else if(count > 1) return maybe;
}
fun int forloopRandom2(int count, int floor, int cap)
{
    maybe => int Maybe;
    cap - floor => int difference;
    if(count == 0) return floor + Maybe*difference;
        else if(count == 1) return floor + (!Maybe)*difference;
            else if(count > 1) return Math.random2(floor, cap);
}
fun float forloopRandom2f(int count, float floor, float cap)
{
    maybe => int Maybe;
    cap - floor => float difference;
    if(count == 0) return floor + ((Maybe==1)*difference);
        else if(count == 1) return floor + ((Maybe!=1)*difference);
            else if(count > 1) return Math.random2f(floor, cap);
}

// setting is 0: normal mod function, works negative too.
// setting is 1: instead, it says (negative) how many additions or subtractions of the mod were needed.
fun int modPlus(int moddee, int mod, int setting) 
{
    if( mod <= 0 ) { <<< "Get outta here. (modPlus negative mod error)" >>>; me.exit(); }
    
    moddee => int modToBe;
    
    0 => int outCount;
    
    if(modToBe >= mod)
    {
        while(modToBe >= mod)
        {
            mod -=> modToBe;
            outCount++;
        }
    }
    //else if(modToBe < mod && modToBe >= 0), nothing happens at all.
    else if(modToBe < 0)
    {
        while(modToBe < 0)
        {
            mod +=> modToBe;
            outCount--;
        }
    }
    
    if(setting) return outCount;
    else return modToBe;
}

// This is just division. / doesn't seem to work in many cases, except in /=>.
fun float division(float numerator, float denominator)
{
    denominator /=> numerator;
    return numerator;
}
fun dur divisionDur(dur numerator, float denominator)
{
    division(1, denominator) => float inverse;
    inverse::numerator => numerator;
    return numerator;
}
// This is even simpler.
fun float itof(int integer)
{
    integer => float floatValue;
    return floatValue;
}
// These must exist already, I imagine, but I can't find them.
fun int arrayIntSum(int array[])
{
    return arrayIntSum(array, array.size());
}
fun int arrayIntSum(int array[], int upTo)
{
    if(upTo > array.size())
    {
        <<< "Stop that at once." >>>;
        return arrayIntSum(array);
    }
    else
    {
        0 => int sum;
        for (0 => int myCount; myCount < upTo; myCount++)
        {
            array[myCount] +=> sum;
        }
        return sum;
    }
}
fun float arrayIntAverage(int array[])
{
    return arrayIntAverage(array, array.size());
}
fun float arrayIntAverage(int array[], int upTo)
{
    if(upTo > array.size())
    {
        <<< "Stop that at once." >>>;
        return arrayIntAverage(array);
    }
    else
    {
        0 => float average;
        for (0 => int myCount; myCount < upTo; myCount++)
        {
            array[myCount] +=> average;
        }
        upTo /=> average;
        return average;
    }
}
fun float arrayPercent(int array[], int whichOne)
{
    array[whichOne] => float percent;
    arrayIntSum(array) /=> percent;
    return percent;
}
fun float arrayPercentf(float array[], int whichOne)
{
    array[whichOne] => float percent;
    arrayfSum(array) /=> percent;
    return percent;
}
fun float arrayfSum(float array[])
{
    return arrayfSum(array, array.size());
}
fun float arrayfSum(float array[], int upTo)
{
    if(upTo > array.size())
    {
        <<< "Stop that at once." >>>;
        return arrayfSum(array);
    }
    else
    {
        0 => float sum;
        for (0 => int myCount; myCount < upTo; myCount++)
        {
            array[myCount] +=> sum;
        }
        return sum;
    }
}
fun float arrayfAverage(float array[])
{
    return arrayfAverage(array, array.size());
}
fun float arrayfAverage(float array[], int upTo)
{
    if(upTo > array.size())
    {
        <<< "Stop that at once." >>>;
        return arrayfAverage(array);
    }
    else
    {
        0 => float average;
        for (0 => int myCount; myCount < upTo; myCount++)
        {
            array[myCount] +=> average;
        }
        upTo /=> average;
        return average;
    }
}
// Arrange all of the values in an int array in order from least to greatest.
fun int[] numericalOrder(int array[])
{
    int newArray[array.size()];
    array @=> int tempArray[];
    for (0 => int newArrayCount; newArrayCount < newArray.size(); newArrayCount++)
    {
        
        tempArray.size()-1 => int arrayTesterNum;
        tempArray[arrayTesterNum] => int arrayTester;
        for (tempArray.size()-2 => int arrayCount; arrayCount >= 0; arrayCount--)
        {
            if(tempArray[arrayCount] < arrayTester)
            {
                arrayCount => arrayTesterNum;
                tempArray[arrayCount] => arrayTester;
            }   
        }
        
        tempArray[tempArray.size()-1] => tempArray[arrayTesterNum];
        arrayTester => tempArray[tempArray.size()-1];
        
        tempArray.popBack();
        
        arrayTester => newArray[newArrayCount];
    }
    
    return newArray;
}
// The same, for a set of float values.
fun float[] numericalOrderf(float array[])
{
    float newArray[array.size()];
    array @=> float tempArray[];
    for (0 => int newArrayCount; newArrayCount < newArray.size(); newArrayCount++)
    {
        
        tempArray.size()-1 => int arrayTesterNum;
        tempArray[arrayTesterNum] => float arrayTester;
        for (tempArray.size()-2 => int arrayCount; arrayCount >= 0; arrayCount--)
        {
            if(tempArray[arrayCount] < arrayTester)
            {
                arrayCount => arrayTesterNum;
                tempArray[arrayCount] => arrayTester;
            }   
        }
        
        tempArray[tempArray.size()-1] => tempArray[arrayTesterNum];
        arrayTester => tempArray[tempArray.size()-1];
        
        tempArray.popBack();
        
        arrayTester => newArray[newArrayCount];
    }
    
    return newArray;
}
// Picks the highest member of an int array. (Note: no provisions for if there are multiple highest members.)
fun int maximumMember(int array[])
{
    -24390239 => int arrayTest;
    0 => int arrayTestMember;
    
    for(0 => int arrayCount; arrayCount < array.size(); arrayCount++)
    {
        if(array[arrayCount] >= arrayTest)
        {
            arrayCount => arrayTestMember;
            array[arrayCount] => arrayTest;
        }
    }
    return arrayTestMember;
}
// Picks the highest member of a float array.
fun int maximumMemberf(float array[])
{
    -24390239 => float arrayTest;
    0 => int arrayTestMember;
    
    for(0 => int arrayCount; arrayCount < array.size(); arrayCount++)
    {
        if(array[arrayCount] >= arrayTest)
        {
            arrayCount => arrayTestMember;
            array[arrayCount] => arrayTest;
        }
    }
    return arrayTestMember;
}
// Picks the highest value of an int array. (Note: no provisions for if there are multiple highest members.)
fun int maximumValue(int array[])
{
    -24390239 => int arrayTest;
    0 => int arrayTestMember;
    
    for(0 => int arrayCount; arrayCount < array.size(); arrayCount++)
    {
        if(array[arrayCount] >= arrayTest)
        {
            arrayCount => arrayTestMember;
            array[arrayCount] => arrayTest;
        }
    }
    return arrayTest;
}
// Picks the highest value of a float array.
fun float maximumValuef(float array[])
{
    -24390239 => float arrayTest;
    0 => int arrayTestMember;
    
    for(0 => int arrayCount; arrayCount < array.size(); arrayCount++)
    {
        if(array[arrayCount] >= arrayTest)
        {
            arrayCount => arrayTestMember;
            array[arrayCount] => arrayTest;
        }
    }
    return arrayTest;
}
// Adds a value to each member of an int array.
fun int[] transposeArray(int array[], int byHowMuch)
{
    for (0 => int arrayCount; arrayCount < array.size(); arrayCount++)
    {
        byHowMuch +=> array[arrayCount];
    }
    return array;
}
fun float[] transposeArrayf(float array[], float byHowMuch)
{
    for (0 => int arrayCount; arrayCount < array.size(); arrayCount++)
    {
        byHowMuch +=> array[arrayCount];
    }
    return array;
}
// The same as the above two, but instead of adding by a given amount, it adds by some amount to get to a given target amount for the lowest value.
fun int[] transposeArrayTo(int array[], int target)
{
    numericalOrder(array) @=> int tempArray[]; 
    target - tempArray[0] => int difference;   
    
    return transposeArray(array, difference);
}
fun int[] transposeArrayTo(int array[])
{
    return transposeArrayTo(array, 0);
}
fun float[] transposeArrayTof(float array[], float target)
{
    numericalOrderf(array) @=> float tempArray[]; 
    target - tempArray[0] => float difference;   
    
    return transposeArrayf(array, difference);
}
fun float[] transposeArrayTof(float array[])
{
    return transposeArrayTof(array, 0);
}
// A function that takes the values of myArray[#][X] (every #, the X specified by you) and returns a single array with all of X in a single array.
fun int[] twoDimensionaltoOne(int array[][], int whichOne)
{
    int newArray[array.size()];
    for(0 => int arrayCount; arrayCount<array.size(); arrayCount++)
    {
        array[arrayCount][whichOne] => newArray[arrayCount];
    }
    return newArray;
}
fun float[] twoDimensionaltoOnef(float array[][], int whichOne)
{
    float newArray[array.size()];
    for(0 => int arrayCount; arrayCount<array.size(); arrayCount++)
    {
        array[arrayCount][whichOne] => newArray[arrayCount];
    }
    return newArray;
}
// A function that converts an array like [ a, b, c, d ] into [ a, a+b, a+b+c, a+b+c+d ].
fun int[] arraySummation(int array[])
{
    int newArray[array.size()];
    for(0 => int arrayCount; arrayCount<array.size(); arrayCount++)
    {
        arrayIntSum(array, arrayCount+1) => newArray[arrayCount];
    }
    return newArray;
}
fun float[] arraySummationf(float array[])
{
    float newArray[array.size()];
    for(0 => int arrayCount; arrayCount<array.size(); arrayCount++)
    {
        arrayfSum(array, arrayCount+1) => newArray[arrayCount];
    }
    return newArray;
}



// The following is not (easily) used outside of this program. It needs two global arrays, int beats[][] and int bars[], to function.
//fun void addXTimetoEachPartOfArraysbeatsandbars(dur byHowLong)
//{
//    for(0 => int barCount; barCount < bars.size(); barCount++)
//    {
//        byHowLong +=> bars[barCount];
//    }
//    for(0 => int barCount; barCount < beats.size(); barCount++)
//    {
//        for(0 => int beatCount; beatCount < beats[barCount].size(); beatCount++)
//        {
//            byHowLong +=> beats[barCount][beatCount];
//        }
//    }
//}
// The following variant might have nice uses in rubato (not strict rubato)
//fun void addXTimetoEachPartOfArraysbeatsandbars(time Now, dur byHowLong)
//{
//    for(0 => int barCount; barCount < bars.size(); barCount++)
//    {
//        if(bars[barCount] > Now)
//        {
//            byHowLong +=> bars[barCount];
//        }
//    }
//    for(0 => int barCount; barCount < beats.size(); barCount++)
//    {
//        for(0 => int beatCount; beatCount < beats[barCount].size(); beatCount++)
//        {
//            if(beats[barCount][beatCount] > Now)
//            {
//                byHowLong +=> beats[barCount][beatCount];
//            }
//        }
//    }
//}
// Another variant, for stricter rubato.
//fun void addXTimetoEachPartOfArraysbeatsandbars(time Now, time Until, dur byHowLong)
//{
//    for(0 => int barCount; barCount < bars.size(); barCount++)
//    {
//        if(bars[barCount] > Now && bars[barCount] < Until)
//        {
//            byHowLong +=> bars[barCount];
//        }
//    }
//    for(0 => int barCount; barCount < beats.size(); barCount++)
//    {
//        for(0 => int beatCount; beatCount < beats[barCount].size(); beatCount++)
//        {
//            if(beats[barCount][beatCount] > Now && beats[barCount][beatCount] < Until)
//            {
//                byHowLong +=> beats[barCount][beatCount];
//            }
//        }
//    }
//}
//fun void addXTimetoEachPartOfArraysBeatsBarsSimpleBeatsandCues(dur byHowLong)
//{
//    for(0 => int barCount; barCount < bars.size(); barCount++)
//    {
//        byHowLong +=> bars[barCount];
//    }
//    for(0 => int barCount; barCount < beats.size(); barCount++)
//    {
//        for(0 => int beatCount; beatCount < beats[barCount].size(); beatCount++)
//        {
//            byHowLong +=> beats[barCount][beatCount];
//        }
//    }
//    for(0 => int beatCount; beatCount < simpleBeats.size(); beatCount++)
//    {
//        byHowLong +=> simpleBeats[beatCount];
//    }
//    for(0 => int cueCount; cueCount < cues.size(); cueCount++)
//    {
//        byHowLong +=> cues[cueCount];
//    }
//}





// 
// // // Timbre functions:

// Does a variety of things. Very proud of this one.
// Must be atchucked to another ADSR in order to lock it into existence.
// Oh shoot
// How do I change the fundamental of an existing note
// Argghhhh
fun ADSR additiveSynth1(float harmonic[][], float fundamental, float gain)
{
    if(harmonic.size() != 0)
    {
        // This segment calibrates all the listed gains (in each harmonic[x][1]) to the stated float 'gain'.
        0 => float harmonicGainSum; // The sum of all harmonic[x][1]. Starts at zero.
        float harmonicGainPercent[harmonic.size()]; // A percentage for each harmonic[x][1]. Unspecified at the start.
        // How much gain is there in harmonic?
        for (0 => int harmCount; harmCount < harmonic.size(); harmCount++)
        {
            harmonic[harmCount][1] +=> harmonicGainSum; // This adds every harmonic[harmCount][1] to harmonicGainSum. It's not zero anymore.
        }
        // What percentage of this total does each harmonic[#][1] constitute?
        for (0 => int harmCount; harmCount < harmonic.size(); harmCount++)
        {
            harmonic[harmCount][1] => harmonicGainPercent[harmCount]; // First we take each harmonic[harmCount][1].
            harmonicGainSum /=> harmonicGainPercent[harmCount]; // Then we divide that by the sum to get a percentage for each harmonic. (Strictly speaking, it's a decimal, not a percentage.)
        }
        
        // Now we create a SinOsc for each harmonic, and a single ADSR envelope.
        SinOsc voice[harmonic.size()];
        ADSR adsr;
        
        for (0 => int voiceCount; voiceCount < voice.size(); voiceCount++)
        {
            fundamental * harmonic[voiceCount][0] => voice[voiceCount].freq; // We multiply the fundamental by the harmonic (or non-harmonic) multiplier listed in harmonic[voiceCount][0], and give that to voice[voiceCount]'s frequency.
            
            harmonicGainPercent[voiceCount] * gain => voice[voiceCount].gain; // We multiply the total gain by the percentage we obtained previously for each voiceCount.
            
            voice[voiceCount] => adsr;
        }
        
        return adsr;
    }
    else
    {
        <<< "Harmonic array cannot be zero size." >>>;
        
        ADSR dummy;
        return dummy;
    }
}
// I'm proud of this one two, but maybe it's a bit much.
// Requires an adsr[][] in order to create an independent attack, decay, sustain and release for every single harmonic, Christ. I wonder if ADSR finalenv could be replaced by Gain g or something.
fun ADSR additiveSynth2(float harmonic[][], float fundamental, float gain, float adsr[][])
{
    if(harmonic.size() != 0)
    {
        // This segment calibrates all the listed gains (in each harmonic[x][1]) to the stated float 'gain'.
        0 => float harmonicGainSum; // The sum of all harmonic[x][1]. Starts at zero.
        float harmonicGainPercent[harmonic.size()]; // A percentage for each harmonic[x][1]. Unspecified at the start.
        // How much gain is there in harmonic?
        for (0 => int harmCount; harmCount < harmonic.size(); harmCount++)
        {
            harmonic[harmCount][1] +=> harmonicGainSum; // This adds every harmonic[harmCount][1] to harmonicGainSum. It's not zero anymore.
        }
        // What percentage of this total does each harmonic[#][1] constitute?
        for (0 => int harmCount; harmCount < harmonic.size(); harmCount++)
        {
            harmonic[harmCount][1] => harmonicGainPercent[harmCount]; // First we take each harmonic[harmCount][1].
            harmonicGainSum /=> harmonicGainPercent[harmCount]; // Then we divide that by the sum to get a percentage for each harmonic. (Strictly speaking, it's a decimal, not a percentage.)
        }
        
        // Now we create a SinOsc for each harmonic, and an ADSR envelope for each SinOsc, and another ADSR envelope for all of them to plug into in the end. 
        SinOsc voice[harmonic.size()];
        ADSR env[voice.size()];
        ADSR finalenv;
        
        for (0 => int voiceCount; voiceCount < voice.size(); voiceCount++)
        {
            fundamental * harmonic[voiceCount][0] => voice[voiceCount].freq; // We multiply the fundamental by the harmonic (or non-harmonic) multiplier listed in harmonic[voiceCount][0], and give that to voice[voiceCount]'s frequency.
            
            harmonicGainPercent[voiceCount] * gain => voice[voiceCount].gain; // We multiply the total gain by the percentage we obtained previously for each voiceCount.
            
            voice[voiceCount] => env[voiceCount];
        }
        
        // Here we modify the sound of each env[#] based on the float adsr[#] supplied.
        for (0 => int envCount; envCount < env.size(); envCount++)
        {
            if(envCount<adsr.size())
            {
                env[envCount].set(adsr[envCount][0]::second, adsr[envCount][1]::second, adsr[envCount][2], 0.1::second);
            }
            else
            {
                env[envCount].set(0.1::second, 0.1::second, 0.0, 0.1::second);
            }
            env[envCount].keyOn(1);
            env[envCount] => finalenv;
        }
        
        
        return finalenv;
    }
    else
    {
        <<< "Harmonic array cannot equal zero." >>>;
        ADSR dummy;
        return dummy;
    }
}
// This is the old version of the above two. As of yet, it's the only one capable of slurring pitches.
fun void newPitchSinOscArray(UGen chuckee, SinOsc voice[], float harmonic[][], float gain, float newFreq)
{
    if(voice.size() == harmonic.size() && harmonic.size() != 0)
    {
        0 => float harmonicGainSum;
        float harmonicGainPercent[harmonic.size()];
        for (0 => int harmCount; harmCount < harmonic.size(); harmCount++)
        {
            harmonic[harmCount][1] +=> harmonicGainSum;
        }
        for (0 => int harmCount; harmCount < harmonic.size(); harmCount++)
        {
            harmonic[harmCount][1] => harmonicGainPercent[harmCount];
            harmonicGainSum /=> harmonicGainPercent[harmCount];
        }
        
        for (0 => int voiceCount; voiceCount < voice.size(); voiceCount++)
        {
            newFreq * harmonic[voiceCount][0] => voice[voiceCount].freq;
            
            harmonicGainPercent[voiceCount] * gain => voice[voiceCount].gain;
            
            if(voice[voiceCount].isConnectedTo(chuckee))
            {}
            else
            {
                voice[voiceCount] => chuckee;
            }
        }
    }
    else
    {
        <<< "Voice array and harmonic array must be of equal size, and cannot equal zero." >>>;
    }
}

// This one should work for my purposes.
// Actually, never mind. Instead I'm splitting its functions into additiveSynth3a (assign to an ADSR) and additiveSynth3b (change pitch and gain).
fun ADSR additiveSynth3(float harmonic[][], SinOsc voice[], float fundamental, float gain)
{
    if(harmonic.size() != 0 && harmonic.size() == voice.size())
    {
        // This segment calibrates all the listed gains (in each harmonic[x][1]) to the stated float 'gain'.
        0 => float harmonicGainSum; // The sum of all harmonic[x][1]. Starts at zero.
        float harmonicGainPercent[harmonic.size()]; // A percentage for each harmonic[x][1]. Unspecified at the start.
        // How much gain is there in harmonic?
        for (0 => int harmCount; harmCount < harmonic.size(); harmCount++)
        {
            harmonic[harmCount][1] +=> harmonicGainSum; // This adds every harmonic[harmCount][1] to harmonicGainSum. It's not zero anymore.
        }
        // What percentage of this total does each harmonic[#][1] constitute?
        for (0 => int harmCount; harmCount < harmonic.size(); harmCount++)
        {
            harmonic[harmCount][1] => harmonicGainPercent[harmCount]; // First we take each harmonic[harmCount][1].
            harmonicGainSum /=> harmonicGainPercent[harmCount]; // Then we divide that by the sum to get a percentage for each harmonic. (Strictly speaking, it's a decimal, not a percentage.)
        }
        
        // Now we create a single ADSR envelope for all SinOscs.
        ADSR adsr;
        
        for (0 => int voiceCount; voiceCount < voice.size(); voiceCount++)
        {
            fundamental * harmonic[voiceCount][0] => voice[voiceCount].freq; // We multiply the fundamental by the harmonic (or non-harmonic) multiplier listed in harmonic[voiceCount][0], and give that to voice[voiceCount]'s frequency.
            
            harmonicGainPercent[voiceCount] * gain => voice[voiceCount].gain; // We multiply the total gain by the percentage we obtained previously for each voiceCount.
            
            voice[voiceCount] => adsr; // We connect each one to adsr.
        }
        
        return adsr; // In order to solidify this thing's existence, use @=> to explicitly assign it to an existing or new ADSR object.
    }
    else
    {
        <<< "Voice array and harmonic array must be of equal size, and cannot equal zero." >>>;
        
        ADSR dummy;
        return dummy;
    }
}
fun ADSR additiveSynth3a(float harmonic[][], SinOsc voice[])
{
    if(harmonic.size() != 0 && harmonic.size() == voice.size())
    {
        // We create a single ADSR envelope for all SinOscs.
        ADSR adsr;
        
        for (0 => int voiceCount; voiceCount < voice.size(); voiceCount++)
        {
            voice[0].freq() * harmonic[voiceCount][0] => voice[voiceCount].freq; // We multiply the fundamental by the harmonic (or non-harmonic) multiplier listed in harmonic[voiceCount][0], and give that to voice[voiceCount]'s frequency.
            
            voice[voiceCount] => adsr; // We connect each one to adsr.
        }
        
        return adsr; // In order to solidify this thing's existence, use @=> to explicitly assign it to an existing or new ADSR object.
    }
    else
    {
        <<< "Voice array and harmonic array must be of equal size, and cannot equal zero." >>>;
        
        ADSR dummy;
        return dummy;
    }
}
fun void additiveSynth3b(float harmonic[][], SinOsc voice[], float fundamental, float gain)
{
    if(harmonic.size() != 0 && harmonic.size() == voice.size())
    {
        // This segment calibrates all the listed gains (in each harmonic[x][1]) to the stated float 'gain'.
        0 => float harmonicGainSum; // The sum of all harmonic[x][1]. Starts at zero.
        float harmonicGainPercent[harmonic.size()]; // A percentage for each harmonic[x][1]. Unspecified at the start.
        // How much gain is there in harmonic?
        for (0 => int harmCount; harmCount < harmonic.size(); harmCount++)
        {
            harmonic[harmCount][1] +=> harmonicGainSum; // This adds every harmonic[harmCount][1] to harmonicGainSum. It's not zero anymore.
        }
        // What percentage of this total does each harmonic[#][1] constitute?
        for (0 => int harmCount; harmCount < harmonic.size(); harmCount++)
        {
            harmonic[harmCount][1] => harmonicGainPercent[harmCount]; // First we take each harmonic[harmCount][1].
            harmonicGainSum /=> harmonicGainPercent[harmCount]; // Then we divide that by the sum to get a percentage for each harmonic. (Strictly speaking, it's a decimal, not a percentage.)
        }
        
        for (0 => int voiceCount; voiceCount < voice.size(); voiceCount++)
        {
            fundamental * harmonic[voiceCount][0] => voice[voiceCount].freq; // We multiply the fundamental by the harmonic (or non-harmonic) multiplier listed in harmonic[voiceCount][0], and give that to voice[voiceCount]'s frequency.
            
            harmonicGainPercent[voiceCount] * gain => voice[voiceCount].gain; // We multiply the total gain by the percentage we obtained previously for each voiceCount.
        }
    }
    else
    {
        <<< "Voice array and harmonic array must be of equal size, and cannot equal zero." >>>;
        
    }
}


//
//
// // // Time and duration functions:



private class Meter
{
    now => time start;
    //Meter meter; // could I pull this off with null reference shenanigans? Check later.
    
    
}

//
// // Time-setting functions (no modification of now)

// Converting metronome marking (for my convenience)
fun dur mmtoDur(float tempo)
{
    1 => float tempoInv; tempo /=> tempoInv;
    
    tempoInv::minute => dur tempoDur;
    
    return tempoDur;
}

// Sets up a simple beat, derived from a total duration. 
fun time[] totalDurtoMeter(time start, dur totalDur, int beatNum)
{
    1 => float beatNumInv; beatNum /=> beatNumInv;
    beatNumInv::totalDur => dur beatDur;
    
    time beat[beatNum+1]; // barNum+1 if you want the last barline to be the end.
    
    for (0 => int beatCount; beatCount < beat.size(); beatCount++)
    {
        start + beatCount::beatDur => beat[beatCount];
        
    }
    return beat;
}
fun time[] totalDurtoMeter(dur totalDur, int beatNum)
{
    return totalDurtoMeter(now, totalDur, beatNum);
}

fun time[] beatDurtoMeter(time start, dur beatDur, int beatNum)
{
    
    time beat[beatNum+1]; // barNum+1 if you want the last barline to equal end.
    
    for (0 => int beatCount; beatCount < beat.size(); beatCount++)
    {
        start + beatCount::beatDur => beat[beatCount];
        
    }
    return beat;
}
fun time[] beatDurtoMeter(dur beatDur, int beatNum)
{
    return beatDurtoMeter(now, beatDur, beatNum);
}
// Another one much like the above.
fun time[] timeIntervaltoMeter(time start, time end, int beatNum)
{
    end - start => dur totalDur;
    
    1 => float beatNumInv; beatNum /=> beatNumInv;
    beatNumInv::totalDur => dur beatDur;
    
    time beat[beatNum+1]; // barNum+1 if you want the last barline to be the end.
    
    for (0 => int beatCount; beatCount < beat.size(); beatCount++)
    {
        start + beatCount::beatDur => beat[beatCount];
        
    }
    return beat;
}
fun time[] microGen(int fractions[], time start, time end)  
{
    if(fractions.size() > 0)
    {
        0 => int equalFlag;
        for(1 => int dangerCount; dangerCount < fractions.size(); dangerCount++)
        {
            if(fractions[dangerCount-1] == fractions[dangerCount]) true => equalFlag;
        }
        // I have this flag set up, but at the moment, I'm skipping on actually having them do anything. 
        
        if(fractions[0] == 0)
        {
            time genBar[fractions.size()];
            end - start => dur barDur;
            1 => float inv; fractions[fractions.size()-1] /=> inv;
            
            for (0 => int beatCount; beatCount < fractions.size(); beatCount++)
            {
                start + (fractions[beatCount]*inv)::barDur => genBar[beatCount];
            }
            return genBar;
        }
        else
        {
            <<< "I'll assume you meant this:" >>>;
            int newFractions[fractions.size()+1]; 
            0 => newFractions[0];
            for(0 => int arrayCount; arrayCount < fractions.size(); arrayCount++)
            {
                fractions[arrayCount] => newFractions[arrayCount+1];
            }
            return microGen(newFractions, start, end);
        }
    }
    else
    {
        <<< "Get that shit outta here." >>>;
    }
}
fun time[] microGenf(float fractions[], time start, time end)  
{
    if(fractions.size() > 0)
    {
        0 => int equalFlag;
        for(1 => int dangerCount; dangerCount < fractions.size(); dangerCount++)
        {
            if(fractions[dangerCount-1] == fractions[dangerCount]) true => equalFlag;
        }
        // I have this flag set up, but at the moment, I'm skipping on actually having them do anything. 
        
        if(fractions[0] == 0.0)
        {
            time genBar[fractions.size()];
            end - start => dur barDur;
            1 => float inv; fractions[fractions.size()-1] /=> inv;
            
            for (0 => int beatCount; beatCount < fractions.size(); beatCount++)
            {
                start + (fractions[beatCount]*inv)::barDur => genBar[beatCount];
            }
            return genBar;
        }
        else
        {
            <<< "I'll assume you meant this:" >>>;
            float newFractions[fractions.size()+1]; 0.0 => newFractions[0];
            for(0 => int arrayCount; arrayCount < fractions.size(); arrayCount++)
            {
                fractions[arrayCount] => newFractions[arrayCount+1];
            }
            return microGenf(newFractions, start, end);
        }
    }
    else
    {
        <<< "Get that shit outta here." >>>;
    }
}




// A timekeeping function. 
fun int currentBeat(time Now, time beat[])
{
    if(Now >= beat[0] && Now < beat[beat.size()-1])
    {
        0 => int beatCount;
        
        while (Now > beat[beatCount])
        {
            beatCount++;
        }
        if(Now == beat[beatCount])
        {
            return beatCount;
        }
        if(Now < beat[beatCount])
        {
            return (beatCount-1);
        }
        
    }
    else
    {
        <<< "You playing me for a fool?" >>>;
    }
}
fun time currentBeatTime(time Now, time beat[])
{
    if(Now >= beat[0] && Now < beat[beat.size()-1])
    {
        0 => int beatCount;
        
        while (Now > beat[beatCount])
        {
            beatCount++;
        }
        if(Now == beat[beatCount])
        {
            return beat[beatCount];
        }
        if(Now < beat[beatCount])
        {
            return beat[beatCount-1];
        }
    }
    else
    {
        <<< "You playing me for a fool?" >>>;
    }
}
fun int currentBeat(time beat[])
{
    return currentBeat(now, beat);
}
fun time currentBeatTime(time beat[])
{
    return currentBeatTime(now, beat);
}

// A timekeeping function.
// format: nextBeat(now, beat) => int theNextBeat;
fun int nextBeat(time Now, time beat[])
{
    if(Now >= beat[0] && Now < beat[beat.size()-1])
    {
        0 => int beatCount;
        
        while (Now >= beat[beatCount])
        {
            beatCount++;
        }
        return beatCount;
    }
    else
    {
        <<< "You playing me for a fool?" >>>;
    }
}
fun time nextBeatTime(time Now, time beat[])
{
    if(Now >= beat[0] && Now < beat[beat.size()-1])
    {
        0 => int beatCount;
        
        while (Now >= beat[beatCount])
        {
            beatCount++;
        }
        return beat[beatCount];
    }
    else
    {
        <<< "You playing me for a fool?" >>>;
    }
}
fun int nextBeat(time beat[])
{
    return nextBeat(now, beat);
}
fun time nextBeatTime(time beat[])
{
    return nextBeatTime(now, beat);
}
//fun int beatsFromCurrentBeat(time Now, time beat[], int count)
//{
//    
//    
//    
//fun int beatsFromCurrentBeat(time beat[], int count)
//{
//    return beatsFromCurrentBeat(n, beat, count);
//}















safeGFirst safe => Envelope fadeout => dac; // there's gotta be some way to manage multiple channels with this.
fadeout.value(1); fadeout.duration(9::second);


EDO my; 
my.setup(// 17 semitones per octave; diatonic halfstep is 2;   C, D, E, F, G,  A,  B
            17,                      2,                       [0, 3, 6, 7, 10, 13, 16]
         // 19,                      1,                       [0, 3, 6, 8, 11, 14, 17]
         );

my.setChromAlt( [0, 0, 0, 0, 0, 0, 0] );

my.setKey(1); // G Major / E minor.
minute / 60 => dur beat;
1 => int oct;
[
//                                 E  2      length   gain,note (not rest),not slurred from previous note.
createNote( my.dia(my.tonicMinor()+7, oct), .75::beat, .7 ,1,0),
createNote( my.dia(my.tonicMinor()+6, oct), .25::beat, .7 ,1,1),
createNote( my.dia(my.tonicMinor()+7, oct),   1::beat, .7 ,1,1),
createNote( my.dia(my.tonicMinor()+4, oct),   1::beat, .67 ,1,0),

createNote( my.dia(my.tonicMinor()+5, oct), .75::beat, .7 ,1,1),
createNote( my.dia(my.tonicMinor()+4, oct), .25::beat, .7 ,1,0),
createNote( my.dia(my.tonicMinor()+5, oct),   1::beat, .7 ,1,1),
createNote( my.dia(my.tonicMinor()+2, oct),   1::beat, .65,1,0),

createNote( my.dia(my.tonicMinor()+3, oct), .75::beat, .65,1,1),
createNote( my.dia(my.tonicMinor()+2, oct), .25::beat, .6 ,1,0),
createNote( my.dia(my.tonicMinor()+3, oct),   1::beat, .6 ,1,1),
createNote( my.dia(my.tonicMinor()+1, oct),   1::beat, .6 ,1,0),

createNote( my.dia(my.tonicMinor()+4, oct),   2::beat, .5 ,1,0),
createNote( my.dia(my.tonicMinor()+0, oct),   1::beat, .5 ,1,1)

]
@=> Note music[];
0 => int musicCount;



Cello p => 
Reverb1 r =>
safe;

//p.set(.2::second, .1::second, .8, .5::second);

p.a(.25);
p.setFadeRatio(1.5);
p.set(.5::second); // sets basically the ring of the string. Too low and it'll be very airy no matter what. Too high and it's impossible to decrescendo.

while(true)
{
    p.set(music[musicCount%music.size()].freq); 
    p.hit(music[musicCount%music.size()].gain);
    
    music[musicCount%music.size()].length + now => time later;
    
    if(!music[(musicCount+1)%music.size()].slur)
    {
        later - .1::second => now;
        p.stopBowing();
    }
    
    later => now;
    
    musicCount++; 
}







fun void BB(dur repDur, dur totalDur, int repNum, float pitch, dur release, UGen ug) // arguments: time in which repetitions occur, time before code resumes/ends, number of repetitions (initial note included), frequency, time for last note to fade, UGen to connect sound to.
{
    SawOsc voice => ADSR env => ug;
    pitch => voice.freq; 0.125 => voice.gain;
    env.set(0.01::second, 0.01::second, 1, 0.1::second);
    
    1 => float repNumInv; repNum /=> repNumInv;
    
    now => time earlier;
    
    for(0 => int repCount; repCount < repNum; repCount++)
    {
        if(repCount==repNum-1){release => env.releaseTime;}
        1 => env.keyOn;
        .5*repNumInv::repDur => now;
        1 => env.keyOff;
        .5*repNumInv::repDur => now;
    }
    
    now - earlier => dur elapsed; // If totalDur / repDur < repNum/repNum (i.e. 1), then exceptions occur.
    totalDur - elapsed => now;
} 

fun void BBB(dur repDur, dur totalDur, int repNum, float pitch, dur release, UGen ug) // arguments: time in which repetitions occur, time before code resumes/ends, number of repetitions (final note excluded), frequency, time for last note to fade, UGen to connect sound to.
{
    SawOsc voice => ADSR env => ug;
    pitch => voice.freq; 0.125 => voice.gain;
    env.set(0.01::second, 0.01::second, 1, 0.1::second);
    
    1 => float repNumInv; repNum /=> repNumInv;
    
    now => time earlier;
    
    for(0 => int repCount; repCount <= repNum; repCount++)
    {
        if(repCount==repNum){release => env.releaseTime;}
        1 => env.keyOn;
        .5*repNumInv::repDur => now;
        1 => env.keyOff;
        .5*repNumInv::repDur => now;
    }
    
    now - earlier => dur elapsed; // If totalDur / repDur <= (repNum+1)/repNum, then exceptions occur.
    totalDur - elapsed => now;
    
}

//
//
// times:
dur t[17];
8::second => t[0];
t[0]/2 => t[1];
for (2 => int tCount; tCount<t.cap(); tCount++)
{
    t[1]/tCount=>t[tCount];
}


//
//
// score:

Chorus chorus => JCRev r => dac; 0.1 => r.mix; 0.25 => chorus.mix;

while(true)
{
    t[16] => dur beat;
    Math.random2(6,12) => float pitch;
    if(pitch<8){4 -=> pitch;}
    
    spork ~ BB(beat, beat*1.5, 1, pitch*50, beat*4, chorus);
    beat => now;
    spork ~ BBB(beat, beat*1.5, Math.random2(2,6), pitch*75, beat*4, chorus);
    beat => now;
}
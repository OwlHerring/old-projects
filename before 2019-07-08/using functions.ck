JCRev r => dac; 0.1 => r.mix;

0.25::second => dur beat;

[0.8333, 1.0, 1.125, 1.2, 1.333, 1.5, 1.6, 1.8, 2.0] @=> float intervals[];

//8 :: beat => now;

//spork ~ CAGE(4::beat, 550, 0.5::second, 0.1::second, 1, 0.3::beat, r);

//8 :: beat => now;

//spork ~ CAGE(6::beat, 412.5, 0.5::second, 0.1::second, 1, 0.3::beat, r);

//8 :: beat => now;

400 => float myPitch;

2 => int cageCounter;

while(true)
{
    Math.random2(3,10) => int trillspeedmultiplier;
    
    spork ~ trill(0.05::second, 0.005*trillspeedmultiplier::second, myPitch*intervals[(cageCounter)%intervals.size()], intervals[2], 0.1::second, 0.5, 0.00001, 1.01, r); // argument 6 (7th) needs at least 4 zeros after the decimal

    .5 :: second => now;

    spork ~ trill(0.05::second, 0.005*trillspeedmultiplier::second, myPitch*intervals[(cageCounter+1)%intervals.size()], intervals[2], 0.1::second, 0.5, 0.00005, 1.01, r);

    .5 :: second => now;
    
    spork ~ CAGE(1::second, myPitch * intervals[(cageCounter%6)+1], r);
    spork ~ trill(0.05::second, 0.005*trillspeedmultiplier::second, myPitch*intervals[(cageCounter+2)%intervals.size()], intervals[2], 0.1::second, 0.5, 0.00005, 1.01, r); // argument 6 (7th) needs at least 4 zeros after the decimal

    .5 :: second => now;
    
    spork ~ trill(0.05::second, 0.005*trillspeedmultiplier::second, myPitch*intervals[(cageCounter+3)%intervals.size()], intervals[2], 0.1::second, 0.5, 0.00005, 1.01, r); // argument 6 (7th) needs at least 4 zeros after the decimal

    .5 :: second => now;
    
    cageCounter++;
}






fun void CAGE(dur input, float pitch, UGen thingtoconnectto)
{
    TriOsc voice => ADSR env => thingtoconnectto;
    0.5 => voice.gain;
    pitch => voice.freq;
    env.set(0.5::second, 0.1::second, 1, 0.075::second);
    
    1 => float onethird; 3/=>onethird; 
    
    now + input => time later; later - 0.5::env.releaseTime() => time bitlessthanlater;
    
    1 => env.keyOn;
    while(bitlessthanlater>now)
    {
        samp => now;
    }
    
    env.set(0.01::second, 0.1::second, 0.5*env.sustainLevel(), 0.075::second);
    
    1 => env.keyOff;
    
    5 *=> pitch; 6/=> pitch;
    pitch => voice.freq;
    env.releaseTime() => now;
    
    1 => env.keyOn;
    
    8 *=> pitch; 9/=> pitch;
    pitch => voice.freq;
    env.releaseTime() => now;
    
    5 *=> pitch; 6/=> pitch;
    pitch => voice.freq;
    env.releaseTime() => now;
    
    1 => env.keyOff; env.releaseTime() => env.duration;
    
    while(env.value()>0.0001)
    {
        samp => now;
    }
}

fun void trill(dur input, dur trillspeed, float pitch, float trillsize, dur drop, float sustain, float releaseIncrement, float slowdown, UGen thingtoconnectto)
{
    SawOsc voice => ADSR env => thingtoconnectto;
    0.25 => voice.gain;
    pitch => voice.freq;
    env.set(input, drop, 0.5*sustain, 0.01::second);
    
    now + input => time later;
    
    1 => env.keyOn; 
    while(later > now)
    {
        samp => now;
    }
    
    [pitch, pitch] @=> float pitches[];
    trillsize *=> pitches[1];
    
    0 => int pitchCount => int sampCount;
    1 => float target;
    
    while(env.value()>0.0001)
    {
        if(now>later)
        {
            now + trillspeed => later;
            pitches[pitchCount%2] => voice.freq;
            pitchCount++;
            slowdown *=> trillspeed;
        }
        
        
        samp => now;
        sampCount++;
        
        target - releaseIncrement * sampCount => env.target;
    }
}


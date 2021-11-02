fun void CAGE(dur input, float pitch, dur attack, dur drop, float sustain, dur release, UGen thingtoconnectto)
{
    TriOsc voice => ADSR env => thingtoconnectto;
    0.5 => voice.gain;
    pitch => voice.freq;
    env.set(attack, drop, sustain, release);
    
    1 => float onethird; 3/=>onethird; 
    
    now + input => time later; later - 0.5::release => time bitlessthanlater;
    
    1 => env.keyOn;
    while(bitlessthanlater>now)
    {
        samp => now;
    }
    
    env.set(0.01::second, 0.1::second, 0.5*sustain, release);
    
    1 => env.keyOff;
    
    5 *=> pitch; 6/=> pitch;
    pitch => voice.freq;
    release => now;
    
    1 => env.keyOn;
    
    8 *=> pitch; 9/=> pitch;
    pitch => voice.freq;
    release => now;
    
    5 *=> pitch; 6/=> pitch;
    pitch => voice.freq;
    release => now;
    
    1 => env.keyOff; release => env.duration;
    
    while(env.value()>0.0001)
    {
        samp => now;
    }
    
}
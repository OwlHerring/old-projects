fun void trill(dur input, dur trillspeed, float pitch, float trillsize, dur drop, float sustain, float releaseIncrement, float slowdown, UGen thingtoconnectto)
{
    TriOsc voice => ADSR env => thingtoconnectto;
    0.5 => voice.gain;
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
    
    while(env.value()>0.00001)
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


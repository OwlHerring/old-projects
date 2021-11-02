fun void lower()
{
    SinOsc vibrato => TriOsc sound => ADSR env => dac;
    2 => sound.sync;
    0.5 => sound.gain;
    env.set(0.1 :: second, 0.2 :: second, 0.8*sound.gain(), 0.8 :: second);
    
    6 => vibrato.freq;
    1 => vibrato.gain;
    
    110 => sound.freq;
    
    second => dur t1;
    
    while(true)
    {
        1 => env.keyOn;
        t1 => now;
    }
}

fun void upper()
{
    SinOsc vibrato => TriOsc sound => ADSR env => dac;
    2 => sound.sync;
    0.5 => sound.gain;
    env.set(0.1 :: second, 0.2 :: second, 0.8*sound.gain(), 0.8 :: second);
    
    6 => vibrato.freq;
    1 => vibrato.gain;
    
    220 => sound.freq;
    
    second => dur t1;
    
    while(true)
    {
        1 => env.keyOn;
        Math.random2f(0.8,1.2)::t1 => now;
    }
}

spork ~ upper();
spork ~ lower();

second => dur t1;

while(true)
{
    t1 => now;
}

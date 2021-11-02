0 => int ticker;

second => dur t1;
15::t1 => dur loop;

fun void lower()
{
    SinOsc vibrato => TriOsc sound => ADSR env => dac;
    2 => sound.sync;
    0.5 => sound.gain;
    env.set(0.1 :: second, 0.2 :: second, 0.8*sound.gain(), 0.8 :: second);
    
    6 => vibrato.freq;
    1 => vibrato.gain;
    
    110 => sound.freq;
    
    while(true)
    {
        1 => env.keyOn;
        0.5::t1 => now;
        1 => env.keyOff;
        0.5::t1 => now;
    }
}

fun void upper()
{
    SinOsc vibrato => TriOsc sound => ADSR env => dac;
    2 => sound.sync;
    0.25 => sound.gain;
    env.set(0.1 :: second, 0.2 :: second, 0.25*sound.gain(), 0.5 :: second);
    
    6 => vibrato.freq;
    1 => vibrato.gain;
    
    220 => sound.freq;
    
    float provisoryt1;
    1 => float baseprovisoryt1;
    
    while(true)
    {
        if(ticker<8)
        {
            baseprovisoryt1 => provisoryt1;
        }
        else
        {
            if(ticker%4)
            {}
            else
            {
                Math.random2(5,10) => int modifier;
                modifier - 1 => baseprovisoryt1; modifier /=> baseprovisoryt1;
            }
            baseprovisoryt1 => provisoryt1;
        }
                
        1 => env.keyOn;
        0.5*provisoryt1::t1 => now;
        1 => env.keyOff;
        0.5*provisoryt1::t1 => now;
    }
}


fun void solo()
{
    SinOsc vibrato => ADSR vibratoenv => SawOsc sound => ADSR env => dac;
    2 => sound.sync;
    0.4 => sound.gain;
    env.set(0.05 :: second, 0.11 :: second, 0.2*sound.gain(), 0.9 :: second);
    
    7 => vibrato.freq;
    5 => vibrato.gain;
    vibratoenv.set(2 :: second, 0.5 :: second, 2, 2 :: second);
    
    330 => float startfreq => sound.freq;
    
    now => time localstart => time start;
    
    while(true)
    {
        1 => vibratoenv.keyOn;
        1 => env.keyOn;
        
        while(now<localstart+loop)
        {
            Math.random2f(0.8,1.2)::t1 => now;
            
            if (now>localstart+4::t1)
            {
                Math.random2f(3,5) => vibrato.freq;
                1 => vibratoenv.keyOff;
            }
            if (now>localstart+8::t1)
            {
                Math.random2f(5,10) => vibrato.freq;
                10 => vibrato.gain;
                vibratoenv.set(0.2 :: second, 0.5 :: second, 5, 2 :: second);
                1 => vibratoenv.keyOn;
            }
            if (now>localstart+9::t1)
            {
                Math.random2f(6,8) => vibrato.freq;
                5 => vibrato.gain;
            }
            if (now>localstart+10::t1)
            {
                Math.random2f(5,7) => vibrato.freq;
                3 => vibrato.gain;
            }
            if (now>localstart+11::t1)
            {
                Math.random2f(5,6) => vibrato.freq;
                2 => vibrato.gain;
            }
            if (now>localstart+12::t1)
            {
                Math.random2f(3,5) => vibrato.freq;
                1 => vibrato.gain;
            }
            if (now>localstart+13::t1)
            {
                Math.random2f(2,4) => vibrato.freq;
                1 => vibratoenv.keyOff;
            }
        }
        1 => env.keyOff;
        2::t1 => now;
        
        Math.random2(3,6) => int multiplier;
        Math.random2(multiplier-1,multiplier+1) => int divider;
        multiplier => float ratio; divider /=> ratio;
        sound.freq() * ratio => sound.freq;
        now => localstart;
        
        if (localstart>start+4::loop)
        {
            startfreq => sound.freq;
            localstart => start;
        }
    }
}
spork ~ lower();

while(true)
{
    ticker++;
    <<< ticker >>>;
    
    t1 => now;
    
    if(ticker==4)
    {
        spork ~ upper();
    }
    if(ticker==16)
    {
        spork ~ solo();
    }
    <<< ticker >>>;
}

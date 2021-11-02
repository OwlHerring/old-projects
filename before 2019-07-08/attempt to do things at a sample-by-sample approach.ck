fun void kyrie()
{
    SndBuf sound1 => dac;
    SndBuf sound2 => blackhole;
    me.dir()+"/kyrie_1_mass_1.wav" => sound1.read;
    me.dir()+"/kyrie_1_mass_1.wav" => sound2.read;
    
    Math.random2(1,8) => float randomfraction; 4/=>randomfraction;
    randomfraction => sound1.rate;
    1 => sound2.rate;
    
    while(true)
    {
        sound2.pos() => sound1.pos;
        25*randomfraction::samp => now;
        
        if (sound1.pos() >= sound1.samples())
        {
            me.exit();
        }
    }
}

SndBuf sound;
me.dir()+"/kyrie_1_mass_1.wav" => sound.read;

sound.samples()*.3333 => float thirdofthefile;

9 * thirdofthefile => float threefileslong;
now + threefileslong::samp => time later;

while(now < later)
{
    spork ~ kyrie();
    thirdofthefile :: samp => now;
}

while(true)
{
    samp => now;
}
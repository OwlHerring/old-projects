SndBuf sound1 => dac;
SndBuf sound2 => blackhole;
me.dir()+"/Tinikling.wav" => sound1.read;
me.dir()+"/Tinikling.wav" => sound2.read;

1 => sound1.loop;
1 => sound2.loop;

44000 => int sampspersecond;

0.1 => sound1.rate;

while(true)
{
    0 => sound1.pos;
    0 => sound2.pos;
    
    now + 9::second => time later;
    10 * sound1.rate() => sound1.rate;
    while(now<later)
    {
        sound2.pos() => sound1.pos;
        2::samp => now;
    }
}

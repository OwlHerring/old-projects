SndBuf sound1 => dac;
SndBuf sound2 => blackhole;
me.dir()+"/Tinikling.wav" => sound1.read;
me.dir()+"/Tinikling.wav" => sound2.read;

1 => sound2.loop;

while(true)
{
    
    180 => sound1.rate;
    sound2.pos() => sound1.pos;
    
    4::samp => now;
}

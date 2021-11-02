SndBuf sound1 => dac;
SndBuf sound2 => blackhole;
me.dir()+"/Tinikling.wav" => sound1.read;
me.dir()+"/Tinikling.wav" => sound2.read;

1 => sound2.loop;

0 => int counter;

while(true)
{
    200::samp => now;
    
    1 +=> counter;
    
    Math.max(Math.sin(counter)+0.5,Math.cos(counter)+0.5) => sound1.rate;
    //sound2.pos() => sound1.pos;
}

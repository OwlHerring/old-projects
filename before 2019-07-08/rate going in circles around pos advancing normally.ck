SndBuf sound1 => dac;
SndBuf sound2 => blackhole;
me.dir()+"/Tinikling.wav" => sound1.read;
me.dir()+"/Tinikling.wav" => sound2.read;

1000 => int counter;

while(true)
{
    counter::samp => now;
    
    counter++;
    
    Math.sin(counter*.5) => sound1.rate;
    sound2.pos() => sound1.pos;
    
    if(counter>10000)
    {
        1000 => counter;
    }
}

SndBuf sound1 => dac.left;
//SndBuf sound2 => dac.right;
me.dir()+"/Tinikling.wav" => sound1.read;
//me.dir()+"/Tinikling.wav" => sound2.read;

while(true)
{
    2::samp => now;
    
    sound1.pos()-maybe => sound1.pos;
    sound1.pos()+maybe => sound1.pos;
}

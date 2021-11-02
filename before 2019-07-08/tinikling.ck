SndBuf voice => dac;

me.dir()+"/tinikling.wav" => voice.read;

0.005 => float modifier;

1 => int faster;

while(true)
{
   0.75 => voice.rate;
   
   10::second => now;
   
   1.5 => voice.rate;
   
   10::second => now;
    
    //if(faster)
    //{
    //    voice.rate() + modifier => voice.rate;
    //    if(voice.rate()>1.5)
    //    {
    //        false => faster;
    //        0.005 +=> modifier;
    //    }
    //}
    //else
    //{
    //    voice.rate() - modifier => voice.rate;
    //    if(voice.rate()<0.75)
    //    {
    //        true => faster;
    //        0.005 +=> modifier;
    //    }
    //}
    
}
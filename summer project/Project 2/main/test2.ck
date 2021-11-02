Ping p[3];
2 => int baseStep;
3 => int oct;
[
EDO.dia(baseStep+0,oct),
EDO.dia(baseStep+1,oct), 
EDO.dia(baseStep+2,oct), 
EDO.dia(baseStep+3,oct), 
EDO.dia(baseStep+4,oct), 
EDO.dia(baseStep+5,oct), 
//EDO.dia(baseStep+6,oct),
//EDO.dia(baseStep+7,oct),
//EDO.dia(baseStep+6,oct),
//EDO.dia(baseStep+5,oct),
EDO.dia(baseStep+4,oct),
EDO.dia(baseStep+3,oct),
EDO.dia(baseStep+2,oct),
EDO.dia(baseStep+1,oct)
] @=> float freqs[];
int freqCount[p.size()];
p[0] => dac.left;
p[1] => dac;
p[2] => dac.right;

while(true)
{
    if(Conductor.whichBeat==0)
    {
        for(0 => int pCount; pCount < p.size(); pCount++)
        {
            p[pCount].set(freqs[freqCount[pCount] % freqs.size()]);
        }
        Conductor.onCue();
        for(0 => int pCount; pCount < p.size(); pCount++)
        {
            p[pCount].hit(
                          //Math.pow(p.size(),-.5));
                          1);
            freqCount[pCount]++;
        }
    }
    else
    {
        Math.random2(0,p.size()-1) => int whichP;
        
        p[whichP].set(freqs[freqCount[whichP] % freqs.size()]);
        Conductor.onCue();
        p[whichP].hit(1);
        
        freqCount[whichP]++;
    }
}
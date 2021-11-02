private class Bows extends Chubgraph
{
    LPF g => outlet;
    SawOsc s[4];
    SinOsc vib[2];
    
    g.freq(4400);
    
    division(60,59) => float offset;
    
    randOffset(2, 1, offset) @=> float vibOffset[];
    [
    Math.pow(offset,-.5),
    Math.pow(offset, .5),
    Math.random2f(Math.pow(offset,-1),1),
    Math.random2f(1, Math.pow(offset, 1))
    ]
    @=> float freqOffset[];
    
    220 => float freq;
    5 => float vibFreq;
    
    // note: still possible to change s.size() or vib.size()
    
    fun void setup()
    {
        vib[0] => s[0] => g; s[0].sync(2);
        vib[1] => s[1] => g; s[1].sync(2);
        
        for(2 => int sCount; sCount < s.size(); sCount++)
        {
            vib[maybe] => s[sCount] => g;
            inlet => s[sCount];
            s[sCount].sync(2);
        }
        g.gain(division(1,s.size()));
        
        setFreq();
    }
    
    fun void addS(int newS)
    {
        for(0 => int newSCount; newSCount < newS; newSCount++)
        {
            s << new SawOsc;
        }
    }
    fun void setFreq()
    {
        for(0 => int vibCount; vibCount < vib.size(); vibCount++)
        {
            vib[vibCount].freq(vibOffset[vibCount%vibOffset.size()]*vibFreq);
        }
        for(0 => int sCount; sCount < s.size(); sCount++)
        {
            s[sCount].freq(freqOffset[sCount%freqOffset.size()]*freq);
        }
    }
    fun void setFreqS(float newFreq)
    {
        newFreq => freq;
        setFreq();
    }
    fun void setFreqV(float newVFreq)
    {
        newVFreq => vibFreq;
        setFreq();
    }
    fun void setFreq(float newFreq, float newVFreq)
    {
        newFreq => freq;
        newVFreq => vibFreq;
        setFreq();
    }
}

0.25::second => dur beat;
Std.mtof(60) => float baseFreq;
[
 [division(1,1), 1.0],
 [division(6,5), 0.25],
 [division(0,5), 0.75],
 [division(1,1), 1.0],
 [division(6,5), 0.25],
 [division(0,5), 0.75],
 [division(6,5), 0.5],
 [division(9,8), 0.5],
 [division(6,5), 0.25],
 [division(0,5), 0.75],
 [division(6,5), 0.5],
 [division(9,8), 0.5],
 [division(6,5), 0.25],
 [division(0,5), 0.75]
]
@=> float notes1[][];

NRev r => Envelope fadeout => dac;
fadeout.value(1);
r.mix(.05);

Bows b1 => 
Envelope cresc1 => 
r;

Bows b2 =>
Envelope cresc2 =>
r;

b1.addS(1);
b1.setup();
cresc1.duration(.05::second);

while(true)
{
    for(0 => int notes1Count; notes1Count < notes1.size(); notes1Count++)
    {
        if(notes1[notes1Count][0] > 0) 
        {
            cresc1.target(.9);
            b1.setFreqS(baseFreq * notes1[notes1Count][0]);
        }
        else 
        {
            cresc1.target(.0);
        }
        notes1[notes1Count][1]::beat => now;
    }
}


cresc1.target(0);
3::second => now;













fun float division(float num, float denom)
{
    return denom /=> num;
}
fun float[] randOffset(int num, float base, float offset)
{
    float myOffset[num];
    for(0 => int offsetCount; offsetCount < myOffset.size(); offsetCount++)
    {
        base * Math.random2f(offset,Math.pow(offset,-1)) => myOffset[offsetCount];
    }
    return myOffset;
}
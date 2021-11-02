private class vibAdditive extends Chubgraph
{
    Gain g => outlet;
    
    220 => float freq;
    4 => int instrNum;
    SinOsc s[instrNum];
    float baseFreq[instrNum];
    for(0 => int sCount; sCount < s.size(); sCount++)
    {
        s[sCount] => g;
    }
    gainSetup();
    setFreq(freq);
    
    fun void add(int num)
    {
        s.size() => int newest;
        repeat(num)
        {
            s << new SinOsc;
        }
        baseFreq.size(s.size());
        for(newest => int sCount; sCount < s.size(); sCount++)
        {
            s[sCount] => g;
        }
        setFreq(freq);
        gainSetup();
    }
    fun void setFreq(float newFreq)
    {
        newFreq => freq;
        for(0 => int sCount; sCount < s.size(); sCount++)
        {
            freq * (sCount+1) => baseFreq[sCount];
        }
    }
    fun void gainSetup()
    {
        for(0 => int sCount; sCount < s.size(); sCount++)
        {
            if(sCount < s.size()-1)
                s[sCount].gain(Math.pow((Math.pow(2,sCount+1)),-1));
            else
                s[sCount].gain(Math.pow((Math.pow(2,sCount)),-1));
        }
    }
    
    SinOsc vibrato => blackhole;
    3.1 => vibrato.freq;
    0.05 => vibrato.gain; // a little differently
    
    fun void sporkThis()  // this will be what actually sets frequencies.
    {
        while(true)
        {
            for(0 => int sCount; sCount < s.size(); sCount++)
            {
                Math.pow(2, Math.pow(sCount+1,.1)*vibrato.last()) * baseFreq[sCount] => s[sCount].freq;
            }
            ms => now;
        }
    }
}

vibAdditive addit => dac;

addit.gain(.5);
addit.add(2);
addit.vibrato.freq(0.05);
addit.vibrato.gain(0.03);
spork ~ addit.sporkThis();

addit.setFreq(220);
2::second => now;
addit.setFreq(275);
.5::second=> now;
addit.setFreq(330);
1.5::second=>now;


while(true)
{
    addit.setFreq(220);
    2::second => now;
    addit.setFreq(220 + 55*Math.random2(1,2));
    (Math.random2(1,4)*.25) => float length;
    length::second=> now;
    addit.setFreq(220 + 55*Math.random2(3,5));
    length::second=>now;
}














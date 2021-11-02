Step imp =>
Delay d =>
NRev r =>
dac;

220 => float baseFreq => float freq;
second / freq => dur period;

[
[division(1,1), 1.0],
[division(9,8), 1.0],
[division(6,5), 2.0],
[division(3,2), 2.0]
]
@=> float mel[][];
0 => int melCount;
.5::second => dur beat;

d => Gain g => d;
g.gain(.94);
d.delay(period);

r.mix(.05);

.2 => float strikeGain;
3 => int strikeSubdiv;
4::ms => dur totalStrike;

while(true)
{
    baseFreq*mel[mel.size()%=>melCount][0] => freq;
    second / freq => period;
    d.delay(period);
    
    mel[melCount][1]::beat + now => time later;
    
    melCount++;
    
    for(strikeSubdiv => int strikeCount; strikeCount > 0; strikeCount--)
    {
        imp.next(division(strikeCount,strikeSubdiv)*strikeGain);
        division(1,strikeSubdiv)::totalStrike => now;
    }
    
    imp.next(0);
    
    later => now;
}


fun float division(float num, float denom)
{
    num => float result;
    denom /=> result;
    return result;
}
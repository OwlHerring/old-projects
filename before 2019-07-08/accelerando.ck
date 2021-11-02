private class Beat
{
    second => dur beatDur;
    
    time start;
    time end;
    set();
    
    fun void setStart()
    {
        now => start;
    }
    fun void setEnd()
    {
        start + beatDur => end;
    }
    fun void set(){ setStart(); setEnd(); }
    
    0 => int beatPassIsOn;
    fun void beatPass()
    {
        if(!beatPassIsOn)
        {
            1 => beatPassIsOn;
            if(now >= end) set();
            end => now;
            set();
            0 => beatPassIsOn;
        }
        else
        {
            end => now;
        }
    }
    fun void changeBeatDur(dur newBeatDur)
    {
        newBeatDur => beatDur;
        if(!beatPassIsOn) set();
        else if(beatPassIsOn && start + beatDur < now) {  } // it does nothing. beatPass will do the deed already.
        else setEnd(); // if beatPass is occurring at the moment, then as long as start + newBeatDur => end; doesn't cause end < now (causing a dest negative exception), the function does so (making the currently-occurring function end earlier than it would have otherwise).
    }
}

1 => int keepGoing;
Event tickers[33 - 8];
Envelope fadeout => dac;
fadeout.value(1);
100 => float baseFreq;

for(0 => int tickerCount; tickerCount < tickers.size(); tickerCount++)
{
    spork ~ tickTock(tickerCount);
    tickers[tickerCount] => now;
}
fadeout.target(0);
fadeout.duration(10::second);
fadeout.duration() => now;

fun void tickTock(int tickCount)
{
    Beat b;
    second / 800 => dur period;
    
    //16::period 
    256::period
    => b.changeBeatDur;
    
    Impulse imp => LPF lpf => fadeout;
    lpf.freq(baseFreq + .125*baseFreq*tickCount);
    lpf.Q(.5);
    
    spork ~ tick(imp, b);
    
    repeat(2) b.beatPass();
    
    division(Math.random2(0,4),5)::period => now;
    
    tickers[tickCount].broadcast();
    
    30 => float div;
    division(1,32) => float ratio;
    3::second => dur howLongToGetThere;
    now + howLongToGetThere => time later;
    
    b.beatDur => dur oldBeatDur;
    for(0 => int count; count < div; count++)
    {
        Math.pow(div,-1)::howLongToGetThere => now;
        Math.pow(Math.pow(ratio, Math.pow(div,-1)), count+1)::oldBeatDur => b.changeBeatDur;
    }
    
    later+b.beatDur => later;
    later => now;
    //tickers[tickCount].broadcast();
    
    b.beatPass();
    
    while(keepGoing)
    {
        second => now;
    }
    5::second => now;
}



fun void tick(Impulse imp, Beat b)
{
    while(keepGoing)
    {
        imp.next(1);
        b.beatPass();
    }
}

fun float division(float num, float denom)
{
    return num * Math.pow(denom,-1);
}
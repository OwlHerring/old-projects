private class MetricGroup
{
    MetricGroup @ prev;
    
    1 => int size;
    MetricUnit beat[0];
    s();
    beat[0].length() => dur lengthDur;
    
    fun void s()
    {
        for(0 => int bCount; bCount < size; bCount++)// only happens if size > beat.size(), at the moment.
        {
            if(bCount == beat.size())
                beat << new MetricUnit;
            if(bCount > 0)
                beat[bCount].link(beat[bCount-1]);
        }
    }
    fun void s(int nSize){ nSize => size; s(); }
    
    fun time start()
    {
        if(linkTest())
        {
            prev.end() => beat[0].start;
            return prev.end();
        }
        else
            return beat[0].start();
    }
    fun time start(time nStart){ nStart => beat[0].start; return start(); }
    fun time end(){ return beat[beat.size()-1].end(); }
    //fun time end(time nEnd)
    fun dur length(){ return lengthDur; }
    fun dur length(dur nLen[]){ for(0 => int bCount; bCount < beat.size(); bCount++){ beat[bCount].length( nLen[ bCount % nLen.size() ] ); } return nLen[0]; }
    // in order to have them all a consistent length, just input .length([myDur]);.
    
    fun int currentBeat(time Now)
    {
        -1 => int beatCount;
        if(Now >= beat[0].start() && Now < beat[beat.size()-1].end())
        {
            0 => beatCount;
            
            while (Now >= beat[beatCount].end())
            {
                beatCount++;
            }
            return beatCount; 
        }
        else if(Now < beat[0].start()) return beatCount;
    }
    fun int currentBeat(){ return currentBeat(now); }
    
    fun time toNextBeat(time Now)
    {
        if(currentBeat(Now) < 0) return start(); // could happen.
        else if(Now >= beat[beat.size()-1].end()){ return now; } // shouldn't happen. 
        else return beat[currentBeat(Now)].end(); // the intended scenario.
    }
    fun time toNextBeat(){ return toNextBeat(now); }
    
    
    fun void link(MetricGroup myPrevious) 
    {
        myPrevious @=> prev;
        prev.end() => beat[0].start;
    }
    fun int linkTest()
    {
        if(prev == null)
        {
            return 0;
        }
        else
            return 1;
    }
}


[
1.0,
1.25,
1.5,
2,
2.5,
3,
4
]@=> float intervals[];
[
[0, 3, 2, 1], 
[0, 2, 1, 3, 4, 3, 0, 2, 1, 3, 4, 3, 4, 3, 2, 1]
]
@=> int interShape[][];

ADSR env[intervals.size()];
SinOsc sMod[env.size()];

SinOsc s => dac; s.sync(1); s.gain(.5);

for(0 => int envCount; envCount < env.size(); envCount++)
{
    sMod[envCount] => env[envCount] => s;
    sMod[envCount].freq(220*intervals[envCount]);
    
    env[envCount].set(.01::second, (.5*Math.pow(envCount+1,-.5))::second, 0, second);
    env[envCount].gain(.5);
}

.125::second => dur beat;

for(0 => int bCount; bCount < 3; bCount++)
{
    MetricGroup bar;
    bar.s(4);
    bar.length([beat]);
    
    
    while(bar.toNextBeat() != now)
    {
        env[interShape[0][bar.currentBeat() % interShape[0].size()]].keyOn(1); bar.toNextBeat() => now;
    }
}

env[0].keyOn(1);
4::beat => now;

0 => int eCount;
for(0 => int bCount; bCount < 4; bCount++)
{
    MetricGroup bar;
    bar.s(4);
    bar.length([beat]);
    
    
    while(bar.toNextBeat() != now)
    {
        env[interShape[1][eCount % interShape[1].size()]].keyOn(1); bar.toNextBeat() => now;
        eCount++;
    }
}
0 => eCount;

for(0 => int bCount; bCount < 3; bCount++)
{
    MetricGroup bar;
    bar.s(4);
    bar.length([beat]);
    
    
    while(bar.toNextBeat() != now)
    {
        env[interShape[0][bar.currentBeat() % interShape[0].size()]].keyOn(1); bar.toNextBeat() => now;
    }
}

env[0].keyOn(1);
4::beat => now;
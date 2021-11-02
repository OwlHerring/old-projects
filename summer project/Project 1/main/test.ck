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
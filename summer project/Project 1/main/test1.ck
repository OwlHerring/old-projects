EDO edo;
Conductor cond;

4 => int oct;
[
 [11,12,13,14],
 [11,10,9, 8],
 [5, 6, 7, 8],
 [5, 4, 3, 2],
 [-1,0 ,1, 2],
 [-4,-3,-2,-1],
 [-4,-5,-6,-7],
 [-10,-9,-8,-7]//,
 //[-10,-11,-12,-13]
]@=> int notes[][];

PingSuper p[notes.size()][0];

[-.95, -.4, 0.0, .4, .95]@=> float pos[];
Pan2 pan[pos.size()];
safeGFirst safe[2];
safe[0] => Envelope right => dac.right;
safe[1] => Envelope left  => dac.left;
right.value(1);
left.value(1);

//<<< pan[0].channels() >>>;
for(0 => int posCount; posCount < pos.size(); posCount++)
{
    pan[posCount].chan(0) => safe[0];
    pan[posCount].chan(1) => safe[1];
    
    Math.pow(1 - Std.fabs(pos[posCount]),.1) => pan[posCount].gain;
    Math.pow(pos[posCount],5) => pan[posCount].pan;
}

for(0 => int pC; pC < p.size(); pC++)
{
    p[pC] << new Ping4;
    p[pC] << new Ping4;
    
    for(0 => int ppC; ppC < p[pC].size(); ppC++)
    {
        p[pC][ppC] => pan[Std.ftoi(Math.round(pC*Math.pow(notes.size(),-1)*pos.size()))];
        //<<<Std.ftoi(Math.round(pC*Math.pow(notes.size(),-1)*pos.size()))>>>;
        
        p[pC][ppC].set( 3::second );
        p[pC][ppC].set(.2::second, .3::second, 0.5, second);
    }
} 
int pPlaying[p.size()];
int ppPlaying[p.size()][p[0].size()];
0 => int ppCount;

for(0 => int pC; pC < p.size(); pC++)
{
    for(0 => int ppC; ppC < p[pC].size(); ppC++)
    {
        1 => ppPlaying[pC][ppC];
    }
    spork ~ pPlay(pC);
}

fun void pPlay(int which)
{
    0 => int globalNC;
    0 => pPlaying[which];
    while(true)
    {
        while(pPlaying[which])
        {
            cond.cue[globalNC%cond.cue.size()] => now;
            edo.dia(notes[which][globalNC%notes[which].size()], oct) => p[which][ppCount%p[which].size()].set;
            p[which][ppCount%p[which].size()].hit(ppPlaying[which][ppCount%ppPlaying[which].size()]);
            ppCount++;
            globalNC++;
        }
        if(Math.random2(0,9)==0 && globalNC!=0){globalNC--;}
        while(!pPlaying[which])
        {
            cond.cue[globalNC%cond.cue.size()] => now;
            globalNC++;
        }
    }
}

Ini ini;

now+2.5::minute => time Time1;

Std.ftoi(Math.trunc(pPlaying.size())) => int breadthA;
Std.ftoi(breadthA*.5) => int breadthB; 
pPlaying.size()-1 => int notesCap;
notes.size()-1 => int notesFloor;

while(ini.arrayIntSum(pPlaying) < breadthA)
{
    Math.random2(2,6)*1.3::second => now;
    repeat(1 + maybe)
    {
        true => pPlaying[Math.random2(notesCap,notesFloor)];
        if(notesFloor>0) notesFloor--;
    }
}

while(now < Time1)
{
    if( (ini.arrayIntSum(pPlaying) < breadthA && Math.random2(0,9)) || // if fewer than half playing at the moment, 90% chance one of them is turned on.
                                                               maybe) // otherwise just a 50% chance. 
        repeat(Math.random2(1,2))
    { true => pPlaying[Math.random2(0,notesCap)]; }
    else
        repeat(Math.random2(1,3))
    {
        false => pPlaying[Math.random2(0,notesCap)];
    }
    
    (Math.random2(1,5)*1.2)::second => now;
}

notes.size()-2 => notesFloor;

while(ini.arrayIntSum(pPlaying) > 1)
{
    repeat(Math.random2(1,3))
    {
        false => pPlaying[Math.random2(notesFloor,notesCap)];
        if(ini.arrayIntSum(pPlaying) == ini.arrayIntSum(pPlaying,notesCap-1) && notesCap > 0) notesCap--;
    }
    if(notesFloor>0) notesFloor--;
    
    (Math.random2(2,7)*1.1)::second => now;
}

(Math.random2(6,14)*1.1)::second => now;

left.target(0);
left.duration(.5::second);
right.target(0);
left.duration(.8::second);


3::second => now;
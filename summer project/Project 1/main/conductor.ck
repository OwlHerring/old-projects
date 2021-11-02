<<< "Success." >>>;

public class Conductor
{
    static Event @ cue[0];
    repeat(4)
    {
        cue << new Event;
    }
    static dur beatDur;
}

Ini ini;
EDO edo;
edo.setup(17, 2, [0,3,6,7,10,13,16]);
//edo.setup(19, 1, [0,3,6,8,11,14,17]);

Conductor cond;
.25::second => cond.beatDur;

ini.add(2, "test1");
0 => int cueCount;
while(true)
{
    cond.beatDur => now;
    cond.cue[cueCount%cond.cue.size()].broadcast();
    cueCount++;
}
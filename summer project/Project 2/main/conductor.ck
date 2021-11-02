<<< "Success." >>>;

public class Conductor
{
    static Event @ cue[0];
    
    static dur beatDur;
    
    static int whichBeat;
    
    static int howManyBeats;
    
    fun static void setup()
    {
        if(howManyBeats > cue.size())
        {
            until(howManyBeats == cue.size()) cue << new Event;
        }
        else if(howManyBeats < cue.size())
        {
            cue.size(howManyBeats);
            howManyBeats %=> whichBeat;
        }
    }
    fun static void setup(int nBeats)
    {
        nBeats => howManyBeats;
        setup();
    }
    
    // these aren't used by the conductor, but by conducted shreds.
    fun static void onCue(){ cue[whichBeat] => now; }
    fun static void onCue(int which){ cue[which % cue.size()] => now; }
    // waits a given time, then rejoins the beat.
    fun static void onCue(dur wait){ wait => now; onCue(); }
    // waits a given time, then rejoins the beat on the nth beat.
    fun static void onCue(dur wait, int which){ wait => now; onCue(which); }
    // waits for the nth beat, then waits a little bit after.
    fun static void onCue(int which, dur howLong){ onCue(which); howLong => now; }
    // note: to do the above for the next beat, simply use cond.onCue(cond.whichBeat, howLong);
    
    // this is used by the conductor, below.
    fun static void cueBeat()
    {
        cue[whichBeat].broadcast();
        whichBeat++;
        cue.size() %=> whichBeat;
    }
}

Ini ini;
EDO edo;
edo.setup(17, 2, [0,3,6,7,10,13,16]);
//edo.setup(19, 1, [0,3,6,8,11,14,17]);

[0, 4, 6, 9] @=> int timeInts[];

Conductor cond;
ini.mmtoDur(110) => cond.beatDur;
cond.setup(timeInts.size()-1);

ini.add(2, "test2");
cond.beatDur => now;

while(true)
{
    cond.beatDur + now => time later;
    ini.microGen(timeInts, now, later) @=> time beats[];
    
    for(1 => int beatsCount; beatsCount < beats.size(); beatsCount++)
    {
        cond.cueBeat();
        beats[beatsCount] => now;
    }
}
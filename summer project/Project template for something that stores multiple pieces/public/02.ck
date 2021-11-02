// a timetracker class. 
//
// Records 'now' at instantiation as the first/only member of an array of timestamps
// Has a default beat duration. (and a bar duration? Or perhaps a float representing beats per bar?)
// A function that tells the time in beats since either the start or the last timestamp (not sure).
// - It takes 'now' (if you don't supply an alternate time), then compares it to the last in this array of timestamps (which, if unchanged, is the time of instantiation).
// - Note that the primary usage is to tell how many beats have passed since a timestamp. It's beats since, not beats until.
// After that, functions that return the time values of 

public class Timetracker 
{
    [now] @=> time stamps[]; // stamps is an array of size 1, with the instantiation time as its 0th member.
    
    4.0 => float barLengthVar; // e.g. a bar is barLength()::beatDur() long. Currently not fully implemented, but usable.
    fun int barLengthInt(){return Std.ftoi(barLength());}
    fun float barLength(){return barLengthVar;} 
    fun float barLength(float bl){bl => barLengthVar; return barLength();}
    
    second => dur beatDurVar;
    fun dur beatDur(){return beatDurVar;}
    fun dur beatDur(dur bd){bd => beatDurVar; return beatDur();}
    
    fun dur barDur(){return barLength()::beatDur();}
    // what will changing barDur do? Two options:
    // 0) Bar's length in beats stays constant. beatDur() changes to accommodate. (give it 5::beatDur(), and it goes from 4/4 in 60 bpm, to 4/4 in 48 bpm).
    // 1) beatDur() stays constant, bar is now a different length of beats. (give it 5::beatDur(), and it goes from 4/4 in 60 bpm to 5/4 in 60 bpm).
    fun dur barDur(dur bd){return barDur(bd, 0);}
    fun dur barDur(dur bd, int setting)
    {
        // goddamn, my head is not mathematically inclined today. Spent a good twenty minutes on just the below, by overthinking it.
        //(what fraction a beat is of a bar) * the new bar dur = the new beat dur
        if(!setting){ Math.pow(barLength(),-1)           ::bd              => beatDur; }
        else { bd / beatDur() => barLength; }
        return barDur();
    }
    
    fun int stampCheck(int Stamp)
    {
        Stamp => int st;
        if(st >= stamps.size()){ <<< "No such stamp exists, you silly goose" >>>; -1 => st;} // if the functions using stampCheck get -1, that's the killswitch.
        else if(st < 0){ <<< "Don't give me a negative stamp, you dumb motherfucker" >>>; -1 => st; }
        return st;
    }
    fun float beatCountF(time Now, int Stamp) 
    {
        if(stampCheck(Stamp) < 0) me.exit(); // because something is wrong, so don't try to bandage it, ye dumb bitch 
        // say 1.5 beatDurs has passed since stamps[Stamp]. 
        // returns 1.5.
        // what if stamps[Stamp] happens to come 1.5 beatDurs after Now?
        // returns -1.5.
        // okay, there shouldn't be any problems negative or positive, so long as it's just analysis and not usage.
        Now - stamps[Stamp] => dur durSince;
        durSince / beatDur() => float beatsSince;
        return beatsSince;
    }
    fun float beatCountF(time Now){return beatCountF(Now, stamps.size()-1);}
    fun float beatCountF(int Stamp){return beatCountF(now, Stamp);}
    fun float beatCountF(){return beatCountF(now, stamps.size()-1);}
    
    // the positive will then round down to 1 (1 beat after), and the negative will round down to -2 (2 beats before)? Is that right? 
    // Yes. 1.5 after 4/4 downbeat: "the And of 2" (1 + 1 = 2); 1.5 before 4/4 downbeat: "the And of 3" (5 - 2 = 3). 
    // (note: we're talking musical beats here, so 1,2,3,4,... is in fact 0,1,2,3,... )
    fun int beatCount(time Now, int Stamp){ return Std.ftoi(beatCountF(Now, Stamp)); } 
    fun int beatCount(time Now){ return beatCount(Now, stamps.size()-1); }
    fun int beatCount(int Stamp){ return beatCount(now, Stamp); }
    fun int beatCount(){ return beatCount(now, stamps.size()-1); }
    
    
    // does the exact same thing for bars.
    fun float barCountF(time Now, int Stamp) 
    {
        if(stampCheck(Stamp) < 0) me.exit(); // because something is wrong, so don't try to bandage it, ye dumb bitch 
        
        Now - stamps[Stamp] => dur durSince;
        durSince / barDur() => float barsSince;
        return barsSince;
    }
    fun float barCountF(time Now){return barCountF(Now, stamps.size()-1);}
    fun float barCountF(int Stamp){return barCountF(now, Stamp);}
    fun float barCountF(){return barCountF(now, stamps.size()-1);}
    
    fun int barCount(time Now, int Stamp){ return Std.ftoi(barCountF(Now, Stamp)); } 
    fun int barCount(time Now){ return barCount(Now, stamps.size()-1); }
    fun int barCount(int Stamp){ return barCount(now, Stamp); }
    fun int barCount(){ return barCount(now, stamps.size()-1); }
    
    // now adding:
    // a mechanism to use the beat and bar stuff above in conjunction to derive position within a bar.
    // - e.g. if 3.5 beats have passed and a bar is 2 beats long, this function might return...
    // - - 1.5 beats? (after the downbeat)
    // - - .75 of the way into the bar? 
    // - - I think the former is ideal.
    // - note that the implication is that the stamps[#] being used is necessarily the downbeat. Might not be.
    // - no idea how negatives would work. I think they might not.
    fun float beatInBarF(time Now, int Stamp)
    {
        if(stampCheck(Stamp) < 0) me.exit();
        
        beatCountF(Now, Stamp) % barLength() => float position;
        return position;
    }
    fun float beatInBarF(time Now){return beatInBarF(Now, stamps.size()-1);}
    fun float beatInBarF(int Stamp){return beatInBarF(now, Stamp);}
    fun float beatInBarF(){return beatInBarF(now, stamps.size()-1);}
    fun int beatInBar(time Now, int Stamp){ return Std.ftoi(beatInBarF(Now, Stamp)); } 
    fun int beatInBar(time Now){ return beatInBar(Now, stamps.size()-1); }
    fun int beatInBar(int Stamp){ return beatInBar(now, Stamp); }
    fun int beatInBar(){ return beatInBar(now, stamps.size()-1); }
    
    
    
    // these will not be chucked to now. They'll be used by the functions that follow, that will be chucked to now.
    fun time thisBeat(time Now, int Stamp) { return stamps[Stamp] + beatCount(Now, Stamp)::beatDur(); }
    fun time thisBeat(time Now){return thisBeat(Now, stamps.size()-1);} fun time thisBeat(int Stamp){return thisBeat(now, Stamp);} fun time thisBeat(){return thisBeat(now, stamps.size()-1);}
    fun time thisBar(time Now, int Stamp) { return stamps[Stamp] + barCount(Now, Stamp)::barDur(); }
    fun time thisBar(time Now){return thisBar(Now, stamps.size()-1);} fun time thisBar(int Stamp){return thisBar(now, Stamp);} fun time thisBar(){return thisBar(now, stamps.size()-1);}
    
    // these will be used. (Maybe went a bit overboard.)
    fun time nextBeat(time Now, int Stamp) { return beatsFromThisBeat(1, Now, Stamp); }
    fun time nextBeat(time Now){return nextBeat(Now, stamps.size()-1);} fun time nextBeat(int Stamp){return nextBeat(now, Stamp);} fun time nextBeat(){return nextBeat(now, stamps.size()-1);}
    fun time nextBar(time Now, int Stamp) { return barsFromThisBar(1, Now, Stamp); }
    fun time nextBar(time Now){return nextBar(Now, stamps.size()-1);} fun time nextBar(int Stamp){return nextBar(now, Stamp);} fun time nextBar(){return nextBar(now, stamps.size()-1);}
    
    fun time beatsFromThisBeat(float bNum, time Now, int Stamp) { return thisBeat(Now, Stamp) + bNum::beatDur(); }
    fun time beatsFromThisBeat(float bNum, time Now){return beatsFromThisBeat(bNum, Now, stamps.size()-1);} fun time beatsFromThisBeat(float bNum, int Stamp){return beatsFromThisBeat(bNum, now, Stamp);} fun time beatsFromThisBeat(float bNum){return beatsFromThisBeat(bNum, now, stamps.size()-1);} 
    fun time beatsFromThisBar(float bNum, time Now, int Stamp) { return thisBar(Now, Stamp) + bNum::beatDur(); }
    fun time beatsFromThisBar(float bNum, time Now){return beatsFromThisBar(bNum, Now, stamps.size()-1);} fun time beatsFromThisBar(float bNum, int Stamp){return beatsFromThisBar(bNum, now, Stamp);} fun time beatsFromThisBar(float bNum){return beatsFromThisBar(bNum, now, stamps.size()-1);} 
    fun time barsFromThisBeat(float bNum, time Now, int Stamp) { return thisBeat(Now, Stamp) + bNum::barDur(); }
    fun time barsFromThisBeat(float bNum, time Now){return barsFromThisBeat(bNum, Now, stamps.size()-1);} fun time barsFromThisBeat(float bNum, int Stamp){return barsFromThisBeat(bNum, now, Stamp);} fun time barsFromThisBeat(float bNum){return barsFromThisBeat(bNum, now, stamps.size()-1);} 
    fun time barsFromThisBar(float bNum, time Now, int Stamp) { return thisBar(Now, Stamp) + bNum::barDur(); }
    fun time barsFromThisBar(float bNum, time Now){return barsFromThisBar(bNum, Now, stamps.size()-1);} fun time barsFromThisBar(float bNum, int Stamp){return barsFromThisBar(bNum, now, Stamp);} fun time barsFromThisBar(float bNum){return barsFromThisBar(bNum, now, stamps.size()-1);} 
    
    
    // need to add:
    // a mechanism for new stamps.
    // - a new stamp would be vital in order to change meter, or tempo, etc. Perhaps this mechanism would include provisions for that.
    // - - Order:
    // - - Add the new timestamp. Either just add 'now', or perhaps add something like barCount()::barDur() (in reference to the most recent downbeat), or (barCount()+1)::barDur() (in reference to the next downbeat).
    // - - Change around all the stuff. Unfortunately, if you change those things, everything prior to the newest timestamp will effectively be unanalyzable, because all the counts will be using the newest change as their metric.
    
    fun void set(float myBarLength, dur myBeatDur)
    {
        if(myBarLength > 0) barLength(myBarLength); else <<< "Bad bar length." >>>;
        if(myBeatDur > 0::second) beatDur(myBeatDur); else <<< "Bad beat duration." >>>;
    }
    fun void newStamp(int newOrReplace)
    {
        if(newOrReplace) now => stamps[stamps.size()-1];
        else stamps << now;
    }
    fun void newStamp(int newOrReplace, float myBarLength, dur myBeatDur)
    {
        newStamp(newOrReplace);
        set(myBarLength, myBeatDur);
    }
    // some way to accomodate for ritard and accel. (But I am really, really getting ahead of myself there.)
}
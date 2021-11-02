public class MetricGroup
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
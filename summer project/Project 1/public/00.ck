// MetricUnit class. 
// (At the moment I can't figure out how to get Machine.add to execute the file that starts with 00 (regardless of anything that comes after it), so this'll have to be named 00.ck for now.)

public class MetricUnit // i.e. a beat, bar, etc. Generalized.
{
    MetricUnit @ prev;
    
    now => time startTime;
    second => dur lengthDur;
    fun time start()
    {
        if(linkTest())
        {
            prev.end() => startTime;
            return prev.end(); 
        }
        else
            return startTime; // it's so beautiful
    }
    fun time start(time nStart){ nStart => startTime; return start(); } // if linked to another MetricUnit, this will have no function at all.
    fun time end(){ return start() + length(); }
    fun time end(time nEnd){ nEnd - start() => length; return end(); }
    fun dur length(){ return lengthDur; }
    fun dur length(dur nLen){ nLen => lengthDur; return length(); } // start times will remain the same, and end times will shift.
    
    fun void link(MetricUnit myPrevious) 
    {
        myPrevious @=> prev;
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
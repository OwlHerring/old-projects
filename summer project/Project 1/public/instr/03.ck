public class PingB extends Ping // all this does is add two sine waves of the same frequency, more or less.
{
    .5 => float anti;
    
    fun void hit(float Hit) { spork ~ hitComponent(Hit); }
    fun void hitComponent(float Hit)
    { 
        imp.next(Hit);
        if(anti>0) anti::freqPeriod() => now;
        else samp => now;
        imp.next(-Hit); 
    }
}
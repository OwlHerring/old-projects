public class Ping3 extends PingSuper
{
    1.0 => dynamicVar;
    
    Impulse imp => lpf;
    
    fun void hit(float Hit){ spork ~ hitComponent(dynamic()*Hit); }
    fun void hitComponent(float Hit)
    {
        for(0 => int repCount; repCount < reps; repCount++)
        {
            imp.next(Hit*Math.pow(fade,repCount));
            delay => now;
        }
    }
}
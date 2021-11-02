public class Ping extends PingSuper
{
    Impulse imp => lpf;
    fun void hit(float Hit) { imp.next(Hit); }
}
public class Ping2 extends PingSuper
{
    Step constant => ADSR env => lpf;
    constant.next(1);
    env.set(samp, samp, .5, samp);
    
    .2::second => dur susTime; // whatever the effects of changing this are, they won't affect already-sounding notes, I think.
    
    fun void set(dur att, dur dec, float sus, dur rel) { env.set(att, dec, sus, rel); }
    
    fun void hit(float Hit, dur length)
    {
        env.target(Hit);
        spork ~ hitComponent();
    }
    fun void hitComponent()
    {
        env.attackTime() + env.decayTime() + susTime => now;
        env.keyOff(1);
    }
}
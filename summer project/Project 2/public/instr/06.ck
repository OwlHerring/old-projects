public class Ping4 extends PingSuper
{
    .01 => dynamicVar;
    
    Noise noise => Envelope env => lpf;
    
    .01::second => attack;
    .01::second => decay;
    0 => sustain;
    .01::second => release;
    
    fun void set(dur att, dur dec, float sus, dur rel) { att => attack; dec => decay; sus => sustain; rel => release; }
    
    fun void hit(float Hit){ spork ~ hitComponent(Hit); }
    fun void hitComponent(float Hit)
    { 
        env.target(dynamic() * Hit);
        env.duration(attack);
        attack => now; 
        
        env.target(dynamic() * sustain * Hit);
        env.duration(decay);
        
        if(holding) stop => now;
        else decay => now;
        
        env.target(0);
        env.duration(release);
    }
}
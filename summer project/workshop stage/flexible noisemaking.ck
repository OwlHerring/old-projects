private class noiseSuper extends Chubgraph
{
    fun void next(float input) { }
    
    // Feel free to add more to either of these in the body of the code.
    [ 1.0, -1.0 ] @=> float outputs[]; // This will choose between these inputs randomly. 
    float frequencies[24]; // This will choose between their periods randomly. The resulting sound will be dreadful.
    for(0 => int pitchCount; pitchCount < frequencies.size(); pitchCount++)
    {
        Std.mtof(pitchCount+18) => frequencies[pitchCount];
    }
    
    0 => int on;
    
    fun void sporkThis()
    {
        1 => on;
        while(true)
        {
            this.next(outputs[Math.random2(0,outputs.size()-1)]);
            (second / frequencies[Math.random2(0,frequencies.size()-1)]) => now;
        }
        0 => on;
    }
}
private class noiseImpulse extends noiseSuper
{
    Impulse imp => outlet;
    
    fun void next(float input){ imp.next(input); }
}
private class noiseStep extends noiseSuper
{
    Step imp => outlet;
    
    fun void next(float input){ imp.next(input); }
}

noiseStep i => dac;

spork ~ i.sporkThis();

while(true)
{
    second => now;
}
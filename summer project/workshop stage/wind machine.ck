private class stepNoise extends Chubgraph
{
    Step step => outlet; step.next(0);
    fun void sporkThis()
    {
        step.next(1);
        while(true)
        {
            Math.random2(1,8)::samp => now;
            step.next(-1 * step.last());
        }
    }
}

private class Windy extends Chubgraph
{
    stepNoise n =>
    ADSR env =>
    HPF hpf;
    
    env.set(0.15::second, 0.05::second, .5, second);
    
    spork ~ n.sporkThis();
    
    220 => float hpfFreq;
    .5  => float qRatio; // this one can go above 1, no problem. Careful when < .5.
    200 => float Q;
    .2  => float gRatio; // this one needs to be < 1.
    
    LPF lpf[0];
    
    [3.0, 5.0, 7.0, 9.0] @=> float harmonics[];
    
    fun void setup()
    {
        1 - gRatio => float A;
        
        hpfFreq => hpf.freq;
        Q => hpf.Q;
        
        for(0 => int harmCount; harmCount < harmonics.size(); harmCount++)
        {
            lpf << new LPF;
            lpf[harmCount].freq(hpfFreq  * harmonics[harmCount]);
            lpf[harmCount].Q(Q * Math.pow(qRatio,harmCount)); // the first LPF's Q == hpfQ.
            if(harmCount != harmonics.size()-1){ lpf[harmCount].gain(A * Math.pow(gRatio,harmCount)); }
            else{ lpf[harmCount].gain(A * Math.pow(gRatio,harmCount-1)); }
            
            hpf => lpf[harmCount] => outlet;
        }
    }
    fun void setFreq(float newFreq)
    {
        newFreq => hpfFreq;
        
        hpfFreq => hpf.freq;
        for(0 => int harmCount; harmCount < lpf.size(); harmCount++)
        {
            lpf[harmCount].freq(hpfFreq * harmonics[harmCount]);
        }
    }
    
    fun void hit(float Hit)
    {
        n.gain(Hit);
        spork ~ hitComponent();
    }
    fun void hitComponent()
    {
        env.keyOn(1);
        env.attackTime() + env.decayTime() => now;
        env.keyOff(1);
    }
}

100 => float baseFreq;
[
1.0,
1.125,
1.2,
1.333,
1.5,
1.667,
1.875,
2.0,
2.25,
2.4,
2.667,
3.0,
3.333,
3.75,
4.0
]
@=> float scale[];
0 => int scaleCount;

Windy w => dac;
w.env.attackTime(.01::second);
w.env.decayTime(.02::second);
w.env.releaseTime(.1::second);
w.env.sustainLevel(.9);
w.harmonics << 13 << 14 << 15 << 19 << 20 << 21;
.8  => w.gRatio;
1.5   => w.qRatio;
100  => w.Q;
w.setup();

Windy w2=> dac;
w2.env.attackTime(.01::second);
w2.env.decayTime(.01::second);
w2.env.releaseTime(.08::second);
w2.env.sustainLevel(.9);
.5  => w2.gRatio;
.8 => w2.qRatio;
100 => w2.Q;
w2.setup();
int w2Parallel;
int w2ScaleCount;

Windy w3=> dac;
w3.env.attackTime(.08::second);
w3.env.decayTime(.04::second);
w3.env.releaseTime(.01::second);
w3.env.sustainLevel(.9);
w3.harmonics << 13 << 14 << 15 << 19 << 20 << 21;
.8  => w3.gRatio;
1.2 => w3.qRatio;
100 => w3.Q;
w3.setup();
7 => int w3ScaleCount;

Windy w4=> dac;
w4.env.attackTime(.08::second);
w4.env.decayTime(.01::second);
w4.env.releaseTime(.01::second);
w4.env.sustainLevel(.9);
.5  => w4.gRatio;
.8 => w4.qRatio;
100 => w4.Q;
w4.setup();
int w4Parallel;
int w4ScaleCount;

1.2::second => dur beat;
16::beat => dur phrase;

SawOsc LFO => blackhole;
LFO.freq(second / phrase);
LFO.gain(.1);
LFO.phase(.75);

while(true)
{
    now => time start;
    // (now - start) / phrase: how many phrases have passed since time start.
    
    while(8+howManyDursHavePassedSince(start,phrase) <= scale.size())
    {
        Math.random2(0,2)!=0 => w2Parallel; 
        Math.random2(0,4)!=0 => w4Parallel; 
        
        Std.ftoi(Math.pow(2,Math.random2(0,3)+(Math.random2(0,4)==0))) => int div;
        repeat(div)
        {
            if(w2Parallel) maxInt(scaleCount-2, howManyDursHavePassedSince(start,phrase)) => w2ScaleCount;
            else howManyDursHavePassedSince(start,phrase) => w2ScaleCount;
            
            if(w4Parallel) minInt(w3ScaleCount+2, minInt(8+howManyDursHavePassedSince(start,phrase),scale.size())-1) => w4ScaleCount;
            else minInt(8+howManyDursHavePassedSince(start,phrase),scale.size())-1 => w4ScaleCount;
            
            w.setFreq(baseFreq*scale[scaleCount]); // I could generalize this to anything with setFreq() and hit()
            w2.setFreq(baseFreq*scale[w2ScaleCount]);
            w3.setFreq(2*baseFreq*scale[w3ScaleCount]);
            w4.setFreq(2*baseFreq*scale[w4ScaleCount]);
            
            w.hit(.15+LFO.last());
            w3.hit(.15+LFO.last());
            if((div > 1 && Math.random2(0,3)) || div == 1)
                w2.hit(.15+LFO.last());
            if((div > 1 && Math.random2(0,3)) || div == 1)
                w4.hit(.15+LFO.last());
            Math.pow(div,-1)::beat => now;
            
            randomStepwiseMotion(scaleCount,   howManyDursHavePassedSince(start,phrase), minInt(8+howManyDursHavePassedSince(start,phrase),scale.size()), 1+2*    (scaleCount < 2 || scaleCount > scale.size()-3)) => scaleCount;
            randomStepwiseMotion(w3ScaleCount, howManyDursHavePassedSince(start,phrase), minInt(8+howManyDursHavePassedSince(start,phrase),scale.size()), 1+2*(w3ScaleCount < 2 || w3ScaleCount > scale.size()-3)) => w3ScaleCount;
        }
    }
}

fun float division(float num, float denom)
{
    return num * Math.pow(denom,-1);
}
fun int maxInt(float n1, float n2)
{
    return Std.ftoi(Math.max(n1,n2));
}
fun int minInt(float n1, float n2)
{
    return Std.ftoi(Math.min(n1,n2));
}
fun float howManyDursHavePassedSincef(time start, dur duration)
{
    (now - start) => dur howLongSince;
    return howLongSince / duration;
}
fun int howManyDursHavePassedSince(time start, dur duration)
{
    return Std.ftoi(howManyDursHavePassedSincef(start, duration));
}
fun int randomStepwiseMotion(int arrayCount, int arraySize, int stepSize) // modifies an existing arrayCount.
{
    return randomStepwiseMotion(arrayCount, 0, arraySize, stepSize);
}
fun int randomStepwiseMotion(int arrayCount, int arrayZero, int arraySize, int stepSize) // modifies an existing arrayCount.
{
    arrayCount => int count;
    while(count == arrayCount)
    {
        Math.random2(Std.ftoi(Math.max(arrayZero,arrayCount-stepSize)), Std.ftoi(Math.min(arrayCount+stepSize, arraySize-1))) => count;
    }
    
    return count;
}
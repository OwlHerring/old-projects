private class safeGFirst extends Chubgraph
{
    inlet => Gain safeG => Dyno safeD => outlet; 
    .5 => float maxAmp;
    safeG.gain(maxAmp);
    safeD.thresh(maxAmp);
    safeD.slopeBelow(1.0);
    safeD.slopeAbove(0.0);
}
private class safeGFirstPan extends safeGFirst
{
    safeD =< outlet;
    safeD => Pan2 p => outlet;
    
    fun void setPan(float newPan)
    {
        p.pan(newPan);
    }
}

private class customPan extends Chubgraph
{
    inlet => Delay dL => LPF left;
    inlet => Delay dR => LPF right;
    
    SinOsc LFO => blackhole;
    
    2000 => float filterFreq;
    left.freq(filterFreq); left.Q(.5);
    right.freq(filterFreq); right.Q(.5);
    
    1.25  => float interval;
    16::second => dur rotationLength;
    
    0 => float phase => LFO.phase;
    
    fun void setup()
    {
        left => dac.left;
        right => dac.right;
    }
    
    fun void sporkThis()
    {
        while(true)
        {
            LFO.freq(second / rotationLength);
            
            left.freq(filterFreq * Math.pow(interval,LFO.last()));
            right.freq(filterFreq * Math.pow(Math.pow(interval,-1),LFO.last()));
            
            samp => now;
        }
    }
    
    fun void setFreq(float newFreq)
    {
        newFreq => filterFreq;
    }
    
    fun void setPhase(float newPhase)
    {
        newPhase => phase => LFO.phase;
    }
    
}

private class Toggle
{
    0 => int togVar;
    
    [1, 0] @=> int states[];
    0 => int stateCount;
    
    fun int toggle()
    {
        stateCount++;
        states.size() %=> stateCount;
        
        states[stateCount] => togVar;
        
        return togVar;
    }
    fun void addState(int newState){ states << newState; }
    fun void addState(int newStates[]){ for(0 => int count; count < newStates.size(); count++){ states << newStates[count]; } }
    fun void replaceStates(int newStates[]){ states.clear(); newStates @=> states; }
}

private class Tock extends Chubgraph
{
    Step imp => LPF h => SinOsc s => outlet;
    
    Toggle t;
    
    //t.replaceStates( [1, -1] );
    
    
    
    float freq; float Q;
    
    setFreq(220);
    setQ(10);
    
    s.sync(1);
    
    fun void setFreq(float f){ f => freq; h.freq(freq); }
    fun void setQ   (float q){ q => Q;    h.Q   (Q);    }
    fun void set(float f, float q) { setFreq(f); setQ(q); }
    
    fun void hit(float Hit) // has a bit of a problem: what if, when t is 1, Hit is changed to .5? The next one will still be as loud as when Hit was 1. It won't be quieter until the next one.
    {
        imp.next(Hit * t.toggle());
    }
}
private class Tock2 extends Tock
{
    ms => dur hitLength;
    fun void hit(float Hit)
    {
        spork ~ hitComponent(Hit);
    }
    fun void hitComponent(float Hit)
    {
        imp.next(0);
        hitLength => now;
        imp.next(Hit * t.toggle());
    }
}

Tock2 t[6];
safeGFirst safe[t.size()];
customPan p[t.size()];

.25 => float deGain;

for(0 => int tCount; tCount < t.size(); tCount++)
{
    t[tCount] => safe[tCount];
    safe[tCount] => p[tCount];
    p[tCount].setup();
    
    safe[tCount].gain(deGain);
    p[tCount].gain(Math.pow(deGain,-1));
    
    spork ~ p[tCount].sporkThis();
    
    tCount * Math.pow(t.size(),-1) 
    => p[tCount].setPhase;
    
    t[tCount].hit(1); // the frequency is so low or something that this makes no sound, thus nullifying the initial thing.
}

minute / 1440 => dur beat;
6::beat => dur measure; // each of these phrases is 4 measures long.
4::measure => dur phrase;

SinOsc LFO => blackhole;
LFO.gain(.45);
LFO.freq(second / 256::phrase);
LFO.phase(.75); // I'd like it to start at .75, but unfortunately the initial two strikes are proving a problem. That problem is drowned out at .25.


25 => float baseFreq;
[
 [
 Std.mtof(60),Std.mtof(67),Std.mtof(75)],
 [
 Std.mtof(63),Std.mtof(72),Std.mtof(79)],
 [
 Std.mtof(65),Std.mtof(69),Std.mtof(77)],
 
 
 [
 Std.mtof(60),Std.mtof(67),Std.mtof(75)],
 [
 Std.mtof(63),Std.mtof(72),Std.mtof(79)],
 [
 Std.mtof(62),Std.mtof(70),Std.mtof(77)],
 
 
 [
 Std.mtof(60),Std.mtof(67),Std.mtof(75)],
 [
 Std.mtof(63),Std.mtof(72),Std.mtof(79)],
 [
 Std.mtof(65),Std.mtof(69),Std.mtof(77)],
 
 
 [
 Std.mtof(60),Std.mtof(67),Std.mtof(75)],
 [
 Std.mtof(63),Std.mtof(72),Std.mtof(79)],
 [
 Std.mtof(62),Std.mtof(70),Std.mtof(79)],
 
 
 [
 Std.mtof(60),Std.mtof(67),Std.mtof(75)],
 [
 Std.mtof(63),Std.mtof(72),Std.mtof(79)],
 [
 Std.mtof(65),Std.mtof(69),Std.mtof(77)],
 
 
 [
 Std.mtof(60),Std.mtof(67),Std.mtof(75)],
 [
 Std.mtof(63),Std.mtof(72),Std.mtof(79)],
 [
 Std.mtof(62),Std.mtof(70),Std.mtof(77)],
 
 
 [
 Std.mtof(60),Std.mtof(67),Std.mtof(75)],
 [
 Std.mtof(63),Std.mtof(72),Std.mtof(79)],
 [
 Std.mtof(65),Std.mtof(69),Std.mtof(77)],
 
 
 [
 Std.mtof(60),Std.mtof(67),Std.mtof(75)],
 [
 Std.mtof(63),Std.mtof(72),Std.mtof(79)],
 [
 Std.mtof(67),Std.mtof(70),Std.mtof(79)]
]
@=> float freqs[][];
0 => int phraseCount;

0 => int count;

Envelope onoff => blackhole;
onoff.value(1);

while(true)
{
    for(0 => int tC; tC < freqs[phraseCount%freqs.size()].size(); tC++)
    {   
        if(tC >= t.size())
        {
            freqs[phraseCount%freqs.size()][tC] => t[tC%t.size()].setFreq; // results in the ones that start each r
        }
        else
        {
            
            spork ~ T(tC, onoff);
        }
        count++;
        6::beat => now;
    }
    phraseCount++;
    
    5::beat => now; onoff.value(0); beat => now; onoff.value(1);
}





fun void T(int count, Envelope onoff)
{
    t[count].set(freqs[phraseCount%freqs.size()][count%freqs[phraseCount%freqs.size()].size()], 50);
    
    while(Std.ftoi(onoff.value()))
    {
        t[count].hit(.5 + LFO.last());
        beat => now;
    }
}

fun float panCount(int count, int size, float rootSpacerThing) // spaces things out evenly among a set of Pan2s set up by a forloop. What rootSpacerThing does is space them out more with by taking a root of some sort from their absolute value. 
{
    count + 1 => float output;
    Math.pow(size+1,-1) *=> output;
    2.0 *=> output;
    1.0 -=> output;
    
    Std.sgn(output) => float sign; // takes the sign of what we have so far
    Std.fabs(output) => output;    // absolute value (because otherwise the root spacer thing won't work)
    Math.pow(output, rootSpacerThing) => output; 
    sign *=> output;
    
    return output;
}



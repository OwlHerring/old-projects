// Safety first.
Gain safeG => Dyno safeD => Envelope fadeout => dac;
fadeout.value(1);
0.5 => float maxAmp;
safeG.gain(maxAmp);
safeD.thresh(maxAmp);
safeD.slopeBelow(1.0);
safeD.slopeAbove(0.0);

//
//
// // Tuning. 
// (I am using 17TET.)
EDOsetup(17) @=> float TET[]; // TET[0]: 13; TET[1]: 1/13; TET[2]: 13th root of 2.
16 * semitones(0, TET) => float C; // C0. Major 6th lower than the lowest note on a piano. Sine waves inaudible.

float gamut[Std.ftoi(TET[0]*12)];
for (0 => int gamutCount; gamutCount < gamut.size(); gamutCount++) // This for loop will occur once for every octave from 0 to 8.
{
    semitonesOver(gamutCount, TET, C) => gamut[gamutCount];
}
// 0, 17, 34, 51, 68, 85, 102, 119


0.1 => float aBit;
1.0 => float base;
base*.5 => float halfofbase;
base*.25 => float fourthofbase;
10.0 => float aLot;
0.5 => float incre;
[ 
 //0
 [
  [ 0.0, 1.0], 
  [ 0.9, 4.0], 
  [ 1.0, 1.0],
  [-1.0, 1.0],
  [-0.9, 4.0],
  [ 0.0, 1.0]
 ],
 //1
 [
  [ 1.0, 1.0],
  [-1.0, 1.0]
 ],
 //2
 [
  [ 0.0, 1.0],
  [ 1.0, 1.0],
  [ 0.9, aBit],
  [ 0.8, 1.0],
  [ 0.7, aBit],
  [ 0.6, 1.0],
  [ 0.5, aBit],
  [ 0.4, 1.0],
  [ 0.3, aBit],
  [ 0.2, 1.0],
  [ 0.1, aBit],
  [ 0.0, 1.0],
  [-0.1, aBit],
  [-0.2, 1.0],
  [-0.3, aBit],
  [-0.4, 1.0],
  [-0.5, aBit],
  [-0.6, 1.0],
  [-0.7, aBit],
  [-0.8, 1.0],
  [-0.9, aBit],
  [-1.0, 1.0],
  [ 0.0, 1.0]
 ],
 //3
 [
  [ 0.0, 1.0],
  [ 1.0,aLot],
  [ 0.8, 1.0],
  [ 0.6, 1.0],
  [ 0.4, 1.0],
  [ 0.2, 1.0],
  [ 0.0,aLot],
  [-0.2, 1.0],
  [-0.4, 1.0],
  [-0.6, 1.0],
  [-0.8, 1.0],
  [-1.0,aLot],
  [ 0.0, 1.0]
 ],
 //4 A lot like a sawtooth wave.
 [
  [ 0.0, 1.0],
  [-0.2, 1.0],
  [-0.4, 1.0],
  [-0.6, 1.0],
  [-0.8, 1.0],
  [-1.0, 0.5],
  [ 1.0, 0.5],
  [ 0.8, 1.0],
  [ 0.6, 1.0],
  [ 0.4, 1.0],
  [ 0.2, 1.0]
 ],
 //5
 [
  [ 0.0, 1.0],
  [ 1.0, 1.0],
  [ 0.8, 1.0],
  [ 0.6, 1.0],
  [ 0.4, 1.0],
  [ 0.2, 1.0],
  [ 0.0, 1.0],
  [-0.2, 1.0],
  [-0.4, 1.0],
  [-0.6, 1.0],
  [-0.8, 1.0],
  [-1.0, 1.0],
  [ 0.0, 1.0]
 ],
 //6
 [
  [ 0.0, 1.0],
  [-0.5, 0.1],
  [ 0.5, 0.1],
  [-1.0,10.0],
  [ 1.0,10.0],
  [ 0.0, 1.0]
 ],
 //7
 [
  [ 0.0, 1.0],
  [ 1.0, 1.0],
  [ 0.1, aBit],
  [ 0.8, 1.0],
  [-0.1, aBit],
  [ 0.6, 1.0],
  [ 0.1, aBit],
  [ 0.4, 1.0],
  [-0.1, aBit],
  [ 0.2, 1.0],
  [ 0.1, aBit],
  [ 0.0, 1.0],
  [-0.1, aBit],
  [-0.2, 1.0],
  [ 0.1, aBit],
  [-0.4, 1.0],
  [-0.1, aBit],
  [-0.6, 1.0],
  [ 0.1, aBit],
  [-0.8, 1.0],
  [-0.1, aBit],
  [-1.0, 1.0],
  [ 0.0, 1.0]
 ],
 //8
 [
  [ 0.0, aBit],
  [-0.6, 1.0],
  [-0.4, 1.0],
  [-0.2, 1.0],
  [-0.8, 1.0],
  [-1.0, 1.0],
  [ 1.0, 1.0],
  [ 0.8, 1.0],
  [ 0.2, 1.0],
  [ 0.4, 1.0],
  [ 0.6, 1.0],
  [ 0.0, aBit]
 ],
 //9
 [
  [ 0.0, 1.0],
  [-1.0, 1.0],
  [-0.8, 1.0],
  [ 1.0, 1.0],
  [ 0.6, 1.0],
  [-1.0, 1.0],
  [-0.4, 1.0],
  [ 1.0, 1.0],
  [ 0.2, 1.0],
  [-1.0, 1.0],
  [ 0.0, 1.0],
  [ 1.0, 1.0],
  [ 0.2, 1.0],
  [-1.0, 1.0],
  [-0.4, 1.0],
  [ 1.0, 1.0],
  [ 0.6, 1.0],
  [-1.0, 1.0],
  [-0.8, 1.0],
  [ 1.0, 1.0],
  [ 0.0, 1.0]
 ],
 //10
 [
  [ 0.0, 1.0],
  [-1.0, 1.0],
  [ 0.8, 1.0],
  [ 1.0, 1.0],
  [ 0.6, 1.0],
  [-1.0, 1.0],
  [ 0.4, 1.0],
  [ 1.0, 1.0],
  [ 0.2, 1.0],
  [-1.0, 1.0],
  [ 0.0, 1.0],
  [ 1.0, 1.0],
  [-0.2, 1.0],
  [-1.0, 1.0],
  [-0.4, 1.0],
  [ 1.0, 1.0],
  [-0.6, 1.0],
  [-1.0, 1.0],
  [-0.8, 1.0],
  [ 1.0, 1.0],
  [ 0.0, 1.0]
 ],
 //11
 [
  [ 0.0, 1.0],
  [ 1.0, 1.0],
  [ 0.2, aLot],
  [ 1.0, aBit],
  [-1.0, aBit],
  [-0.2, aLot],
  [-1.0, 1.0],
  [ 0.0, 1.0]
 ],
 //12 This should deemphasize the 5th harmonic.
 [
  [ 0.0, 1.0],
  [ 1.0, 1.0],
  [ 0.0, 2.0],
  [-1.0, 1.0]
  //[-0.2, aLot],
  //[-1.0, 1.0],
  //[ 0.0, 1.0]
 ],
 //13 This should deemphasize the 5th harmonic.
 [
  [ 1.0, 1.0],
  [-1.0, 1.5]
 ],
 //14 From waveform[4]. Adds up to 9.
 [
  [-0.25, 1.0],
  [-0.5, 1.0],
  [-0.75, 1.0],
  [-1.0, 1.0],
  [ 1.0, 1.0],
  [ 0.75, 1.0],
  [ 0.5, 1.0],
  [ 0.25, 1.0],
  [ 0.0, 1.0]
 ],
 //15 From waveform[4]. Durations add up to 5, therefore it omits the 5th harmonic?
 [
  [-0.5, 1.0],
  [-1.0, 1.0],
  [ 1.0, 1.0],
  [ 0.5, 1.0],
  [ 0.0, 1.0]
 ],
 //16 From above. An experiment. Resulted in a tinnier sound which omits all 10s.
 [
  [-0.75, 1.0],
  [-1.0, 1.0],
  [-0.0, 1.0],
  [-0.25, 1.0],
  [-0.5, 1.0],
  [ 0.25, 1.0],
  [ 0.0, 1.0],
  [ 1.0, 1.0],
  [ 0.75, 1.0],
  [ 0.5, 1.0]
 ],
 //17 another from waveform[15]. Completely different. Wipes out most harmonics, aside from 1, 3, 7, 9, 11, 13, 17, 19, 21, 23, 27, 29, 31, 33...
 // in short, omits even harmonics and multiples of 5. It's like a square wave that omits 5s as well.
 [
  [-0.75, 1.0],
  [-1.0, 1.0],
  [-0.0, 1.0],
  [-0.25, 1.0],
  [-0.5, 1.0],
  [ 0.75, 1.0],
  [ 1.0, 1.0],
  [ 0.0, 1.0],
  [ 0.25, 1.0],
  [ 0.5, 1.0]
 ],
 //18 I took the above and essentially smoothed out all the edges. This is the same as the above, but with much more muted upper harmonics.
 [
  [-0.75, halfofbase],
  [-0.8, fourthofbase],
  [-0.85, fourthofbase],
  [-0.9, fourthofbase],
  [-0.95, fourthofbase],
  [-1.0, halfofbase],
  [-0.8, fourthofbase],
  [-0.6, fourthofbase],
  [-0.4, fourthofbase],
  [-0.2, fourthofbase],
  [-0.0, halfofbase],
  [-0.05, fourthofbase],
  [-0.1, fourthofbase],
  [-0.15, fourthofbase],
  [-0.2, fourthofbase],
  [-0.25, halfofbase],
  [-0.3, fourthofbase],
  [-0.35, fourthofbase],
  [-0.4, fourthofbase],
  [-0.45, fourthofbase],
  [-0.5, halfofbase],
  [-0.25, fourthofbase],
  [ 0.0, fourthofbase],
  [ 0.25, fourthofbase],
  [ 0.5, fourthofbase],
  [ 0.75, halfofbase],
  [ 0.8, fourthofbase],
  [ 0.85, fourthofbase],
  [ 0.9, fourthofbase],
  [ 0.95, fourthofbase],
  [ 1.0, halfofbase],
  [ 0.8, fourthofbase],
  [ 0.6, fourthofbase],
  [ 0.4, fourthofbase],
  [ 0.2, fourthofbase],
  [ 0.0, halfofbase],
  [ 0.05, fourthofbase],
  [ 0.1, fourthofbase],
  [ 0.15, fourthofbase],
  [ 0.2, fourthofbase],
  [ 0.25, halfofbase],
  [ 0.3, fourthofbase],
  [ 0.35, fourthofbase],
  [ 0.4, fourthofbase],
  [ 0.45, fourthofbase],
  [ 0.5, halfofbase],
  [ 0.25, fourthofbase],
  [ 0.0, fourthofbase],
  [-0.25, fourthofbase],
  [-0.5, fourthofbase]
 ]
]
@=> float waveform[][][];

mmtoDur(110) => dur beatDur;
1 => int tonic;

Envelope moreEnvelopes[10];
for(0 => int envCount; envCount < moreEnvelopes.size(); envCount++)
{
    moreEnvelopes[envCount].value(1);
    moreEnvelopes[envCount] => safeG;
}
JCRev r => safeG;
r.mix(0.01);


2::second => dur t1;

Event baby;

now + t1 => time start;
start + 25::t1 => time done;
[ 105, 110, 105,  110,   95,  95, 95, 95, 97,100,120, 150, 75, 75, 75, 75, 85, 85, 95, 95, 100, 120, 150 ] @=> int rubato[];
[ 0.2, 0.2, 0.21, 0.21,0.22,0.22,0.23,0.23,0.25,0.26,0.25,0.24,0.25,0.25,0.25,0.24, 0.24,0.23,0.23,0.22,0.22,0.21, 0.2 ] @=> float dynamics[];

microGen(fractionGen(rubato), start, done) @=> time beats[];



[ beats[0], beats[2], beats[4], beats[6], beats[8] ] @=> time cues[];
[ 0, 17, 34, 51, 68 ] @=> int transpositions[];
[ 2, 2, 2, 1, 1 ] @=> int somanyvariables[];

//[ 0, 5, 10, 15, 20, 25, 30, 35, 30, 25, 20, 15, 10, 5, 0 ] // A neutral thirds all the way up. (A Cd E Gd B Dd...) Interesting effect of perfect fifths.
//[ 0, 4, 8, 12, 16, 20, 24, 28, 24, 20, 16, 12, 8, 4, 0 ] // A diminished seventh chord (A C Eb Gb Bbb..) No corrections for 17TET.
//[ 0, 3, 6, 10, 13, 17, 20, 23, 20, 17, 13, 10, 6, 3, 0 ] // A Major anhemitonic pentatonic scale.
//[ 0, 4, 7, 10, 14, 17, 21, 24, 21, 17, 14, 10, 7, 4, 0 ] // A minor anhemitonic pentatonic scale. (A C D E G A). Sounds pretty cool.
//[ 0, 3, 4, 10,11, 17, 20, 21, 20, 17, 11, 10, 4, 3, 0 ] // A minor hemitonic pentatonic scale. (A B C E F A). Sounds so cool.
//[ 0, 3, 6, 9, 12, 15, 18, 21, 18, 15, 12, 9, 6, 3, 0 ] // A whole-tone scale ( 3 + 3...) No corrections for 17TET. 
//[ 0, 2, 4, 6, 8, 10, 12, 14, 12, 10, 8, 6, 4, 2, 0 ] // A 17TET chromatic half-steps scale (A, A#, Ax, Ax#...) It's interesting.
//[ 0, 1, 2, 3, 4, 5, 6, 7, 6, 5, 4, 3, 2, 1, 0 ] // A 17TET diatonic half-steps scale (A, Bb, Cb, Dbb, Ebbb...) It's ghastly.
//[ 0, 1, 4, 5, 8, 9, 12, 13, 12, 9, 8, 5, 4, 1, 0 ]  // A octatonic (1 + 3 + 1 + 3...) No corrections for 17TET. 
//[ 0, 3, 4, 7, 8, 11, 12, 15, 12, 11, 8, 7, 4, 3, 0] // A octatonic (3 + 1 + 3 + 1...) No corrections for 17TET. 
//[ 0, 3, 4, 7, 10, 13, 14, 17, 14, 13, 10, 7, 4, 3, 0 ] // A Dorian.
//[ 0, 2, 5, 7, 10, 12, 15, 17, 15, 12, 10, 7, 5, 2, 0 ] // my beloved invented 'A neutral' scale, with half-lowered second.
//[ 0, 3, 5, 7, 10, 12, 15, 17, 15, 12, 10, 7, 5, 3, 0 ] // my beloved invented 'A neutral' scale.
//[ 0, 3, 5, 8, 10, 13, 15, 18, 20, 23, 25, 28, 30, 33, 35 ] // ???
[ 0, 3, 6, 7, 10, 13, 16, 17, 16, 13, 10, 7, 6, 3, 0 ] // A Major. 
@=> int mel[];

0 => int final;
while(true)
{
    for(0 => int cueCount; cueCount < cues.size(); cueCount++)
    {
        if(cueCount == cues.size()-1)
            1 => final;
        cues[cueCount] => now;
        currentBeat(beats) => int currentbeat;
        
        repeat( 3 )
        {
            spork ~ round(r, transpositions[cueCount], final, dynamics, beats, currentbeat, somanyvariables[cueCount]);
        }
    }
    
    baby => now;
    
    2::t1 => now;
}
        


fun void round(UGen chuckee, int transpose, int endorno, float dynamics[], time beats[], int currentbeat, int yesanothervariable)
{
    
    SinOsc thing;
    Envelope killMe;
    spork ~ lifeCycle(killMe, 0.1::t1, chuckee, baby);
    spork ~ sineVibrato(baby, thing, Math.random2f(4,7), Math.random2f(0.00018, 0.0003), 2::t1);
    12 => int whichWaveform; // 12, 13, 15, 17 all sound good in 17tet. 18 is just too complicated for the CPU.
    spork ~ stepWithCrescendoBeats(thing, killMe, waveform[whichWaveform], dynamics, beats);
    
    // 30 47 64 81 98 115
    30 + transpose => int start;
    
    Math.random2f(0.995,1.005) => float detune;
    
    thing.freq(detune*gamut[start+mel[0]]);
    killMe.value(1);
    
    
    
    for(1 => int melCount; melCount < mel.size(); melCount++)
    {
        beats[currentbeat+1] - now => dur toNextBeat;
        
        if(yesanothervariable)
        {
            if(yesanothervariable-1)
            {
                spork ~ sineGlissBeforeNextBeat(toNextBeat, thing, detune*gamut[start+mel[melCount]], Math.random2f(0.025*division(transpose+17,TET[0]),0.05*division(transpose+17,TET[0]))::second);
                beats[currentbeat+1] => now;
            }
            else
            {
                beats[currentbeat+1] => now;
                spork ~ sineGliss(thing, detune*gamut[start+mel[melCount]], Math.random2f(0.05*division(transpose+17,TET[0]),0.1*division(transpose+17,TET[0]))::t1);
            }
        }
        else    
        {
            beats[currentbeat+1] => now;
            thing.freq(detune*gamut[start+mel[melCount]]);
        }
        
        currentbeat++;
    }
    
    if(endorno)
    {
        2::t1 => now;
        baby.broadcast();
        0.25::t1 => now;
    }
    else
    {
        baby => now;
        0.25::t1 => now;
    }
    
    
    
}


fun void stepWithCrescendoBeats(SinOsc base, UGen chuckee, float myWaveform[][], float dynamics[], time beats[])
{
    Step voice => chuckee;
    voice.gain(dynamics[currentBeat(beats)]);
    
    spork ~ stepCrescendoBeats(voice, dynamics, beats);
    
    while(true)
    {
        second / base.freq() => dur period;
        for(0 => int waveCount; waveCount < myWaveform.size(); waveCount++)
        {
            voice.next(myWaveform[waveCount][0]);
            arrayPercentf(twoDimensionaltoOnef(myWaveform, 1), waveCount)::period => now;
        }
    }
}

fun void stepCrescendoBeats(Step myR, float dynamics[], time beats[])
{
    while(nextBeat(beats) < beats.size() && dynamics.size()+1==beats.size())
    {
        nextBeatTime(beats) => time nextbeat;
        nextbeat - now => dur howLong;
        
        myR.gain() => float start;
        
        start - dynamics[nextBeat(beats)] => float difference;
        
        division(difference,100) => float gainIncrements;
        
        totalDurtoMeter(howLong, 100) @=> time incrementTime[];
        
        until(now >= incrementTime[incrementTime.size()-1])
        {
            myR.gain() - gainIncrements => myR.gain;
            nextBeatTime(incrementTime) => now;
        }
    }
}

fun void sineVibrato(Event killer, SinOsc thing, float freq, float gain, dur fade)
{
    spork ~ sineVibratoA(thing, freq, gain);
    
    killer => now;
    
    fade => now;
}
fun void sineVibratoA(SinOsc thing, float freq, float gain)
{
    SinOsc lfo => blackhole;
    lfo.freq(freq);
    lfo.gain(gain);
    
    while(true)
    {
        thing.freq() => float baseFreq;
        while(thing.freq() >= baseFreq - lfo.gain() && thing.freq() <= baseFreq + lfo.gain())
        {
            lfo.last() + 1 => float modifier;
            modifier * baseFreq => thing.freq;
            
            ms => now;
        }
    }
}

// format for use:
// Declare your SinOsc base and either chuck it to blackhole or do nothing with it. (Don't chuck to dac or something else.)
// Then spork step. 
// It will run indefinitely (until its parent shred dies). It can fade out if UGen chuckee is an envelope.
// If all your waveform[]s begin and end in 0.0, you can alter SinOsc's frequency whenever you want and it won't cause a pop. Probably.
// But you can't alter the waveform[].
fun void step(SinOsc base, UGen chuckee, float myWaveform[][], float gain)
{
    Step voice => chuckee;
    voice.gain(gain);
    
    while(true)
    {
        second / base.freq() => dur period;
        for(0 => int waveCount; waveCount < myWaveform.size(); waveCount++)
        {
            voice.next(myWaveform[waveCount][0]);
            arrayPercentf(twoDimensionaltoOnef(myWaveform, 1), waveCount)::period => now;
        }
    }
}

// You spork this and it runs concurrently with the main spork. (A grandchild of the main shred.)
fun void mortality(Envelope kill, dur fade, UGen chuckee, Event theReaper)
{
    theReaper => now;
    
    kill.duration(fade);
    kill.keyOff(1);
    
    kill.duration() => now;
    
    kill =< chuckee;
    ms => now;
    me.exit();
}
fun void lifeCycle(Envelope kill, dur fade, UGen chuckee, Event theReaper)
{
    kill => chuckee;
    
    theReaper => now;
    
    kill.duration(fade);
    kill.keyOff(1);
    
    kill.duration() => now;
    
    kill =< chuckee;
    ms => now;
    me.exit();
}

fun void yesEvenLPFGliss(LPF p, float destination, dur howLong)
{
    p.freq() => float start;
    
    destination - start => float difference; 
    // if destination > start (it glissandos up), then difference is positive.
    // if destination < start (it glissandos down), difference is negative.
    
    division(difference,100) => float freqIncrements;
    
    totalDurtoMeter(howLong, 100) @=> time incrementTime[];
    
    until(now >= incrementTime[incrementTime.size()-1])
    {
        p.freq() + freqIncrements => p.freq;
        nextBeatTime(incrementTime) => now;
    }    
}
fun void sineGliss(SinOsc p, float destination, dur howLong)
{
    p.freq() => float start;
    
    destination - start => float difference; 
    // if destination > start (it glissandos up), then difference is positive.
    // if destination < start (it glissandos down), difference is negative.
    
    division(difference,100) => float freqIncrements;
    
    totalDurtoMeter(howLong, 100) @=> time incrementTime[];
    
    until(now >= incrementTime[incrementTime.size()-1])
    {
        p.freq() + freqIncrements => p.freq;
        nextBeatTime(incrementTime) => now;
    }    
}
fun void sineGliss(SinOsc p, float start, float destination, dur howLong)
{
    p.freq(start);
    
    destination - start => float difference; 
    // if destination > start (it glissandos up), then difference is positive.
    // if destination < start (it glissandos down), difference is negative.
    
    division(difference,100) => float freqIncrements;
    
    totalDurtoMeter(howLong, 100) @=> time incrementTime[];
    
    until(now >= incrementTime[incrementTime.size()-1])
    {
        p.freq() + freqIncrements => p.freq;
        nextBeatTime(incrementTime) => now;
    }    
}
fun void sineGlissBeforeNextBeat(dur toNextBeat, SinOsc p, float destination, dur howSoonBefore) // Spork this prior to every chucking to now.
{
    // Needs some provision in case howSoonBefore > toNextBeat.
    
    now + toNextBeat => time nextBeat;
    nextBeat - howSoonBefore => time glissStart;
    
    glissStart => now;
    
    p.freq() => float start;
    
    destination - start => float difference; 
    // if destination > start (it glissandos up), then difference is positive.
    // if destination < start (it glissandos down), difference is negative.
    
    division(difference,100) => float freqIncrements;
    
    totalDurtoMeter(howSoonBefore, 100) @=> time incrementTime[];
    
    until(now >= incrementTime[incrementTime.size()-1])
    {
        p.freq() + freqIncrements => p.freq;
        nextBeatTime(incrementTime) => now;
    }    
    
    if(now < nextBeat)
        nextBeat => now;
}
fun void sineGlissBeforeNextBeat(dur toNextBeat, SinOsc p, float start, float destination, dur howSoonBefore) // Spork this prior to every chucking to now.
{
    // Needs some provision in case howSoonBefore > toNextBeat.
    
    now + toNextBeat => time nextBeat;
    nextBeat - howSoonBefore => time glissStart;
    
    glissStart => now;
    
    p.freq(start);
    
    destination - start => float difference; 
    // if destination > start (it glissandos up), then difference is positive.
    // if destination < start (it glissandos down), difference is negative.
    
    division(difference,100) => float freqIncrements;
    
    totalDurtoMeter(howSoonBefore, 100) @=> time incrementTime[];
    
    until(now >= incrementTime[incrementTime.size()-1])
    {
        p.freq() + freqIncrements => p.freq;
        nextBeatTime(incrementTime) => now;
    }    
    
    if(now < nextBeat)
        nextBeat => now;
}

fun void bowedVolumeToDestination(Bowed myB, float destinationVol, float destinationPos, float destinationPres, dur howLong)
{
    myB.volume() => float startVol;
    myB.bowPosition() => float startPos;
    myB.bowPressure() => float startPres;
    
    startVol - destinationVol => float differenceVol;
    startPos - destinationPos => float differencePos;
    startPres - destinationPres => float differencePres;
    
    division(differenceVol,100) => float mixIncrementsVol;
    division(differencePos,100) => float mixIncrementsPos;
    division(differencePres,100) => float mixIncrementsPres;
    
    totalDurtoMeter(howLong, 100) @=> time incrementTime[];
    
    until(now >= incrementTime[incrementTime.size()-1])
    {
        myB.volume() - mixIncrementsVol => myB.volume;
        myB.bowPosition() - mixIncrementsPos => myB.bowPosition;
        myB.bowPressure() - mixIncrementsPres => myB.bowPressure;
        nextBeatTime(incrementTime) => now;
    }
}


fun void mandGliss(Mandolin p, float destination, dur howLong)
{
    p.freq() => float start;
    
    destination - start => float difference; 
    // if destination > start (it glissandos up), then difference is positive.
    // if destination < start (it glissandos down), difference is negative.
    
    division(difference,100) => float freqIncrements;
    
    totalDurtoMeter(howLong, 100) @=> time incrementTime[];
    
    until(now >= incrementTime[incrementTime.size()-1])
    {
        p.freq() + freqIncrements => p.freq;
        nextBeatTime(incrementTime) => now;
    }    
}
fun void mandGlissWithPluck(float pluck, Mandolin p, float destination, dur howLong)
{
    p.pluck(pluck);
    
    p.freq() => float start;
    
    destination - start => float difference; 
    // if destination > start (it glissandos up), then difference is positive.
    // if destination < start (it glissandos down), difference is negative.
    
    division(difference,100) => float freqIncrements;
    
    totalDurtoMeter(howLong, 100) @=> time incrementTime[];
    
    until(now >= incrementTime[incrementTime.size()-1])
    {
        p.freq() + freqIncrements => p.freq;
        nextBeatTime(incrementTime) => now;
    }    
}
fun void mandGlissBeforeNextBeat(dur toNextBeat, Mandolin p, float destination, dur howSoonBefore) // Spork this prior to every chucking to now.
{
    // Needs some provision in case howSoonBefore > toNextBeat.
    
    now + toNextBeat => time nextBeat;
    nextBeat - howSoonBefore => time glissStart;
    
    glissStart => now;
    
    p.freq() => float start;
    
    destination - start => float difference; 
    // if destination > start (it glissandos up), then difference is positive.
    // if destination < start (it glissandos down), difference is negative.
    
    division(difference,100) => float freqIncrements;
    
    totalDurtoMeter(howSoonBefore, 100) @=> time incrementTime[];
    
    until(now >= incrementTime[incrementTime.size()-1])
    {
        p.freq() + freqIncrements => p.freq;
        nextBeatTime(incrementTime) => now;
    }    
    
    if(now < nextBeat)
        nextBeat => now;
}
fun void mandGlissBeforeNextBeatWithPluck(float pluck, dur toNextBeat, Mandolin p, float destination, dur howSoonBefore) // Spork this prior to every chucking to now.
{
    // Needs some provision in case howSoonBefore > toNextBeat.
    
    p.pluck(pluck);
    
    now + toNextBeat => time nextBeat;
    nextBeat - howSoonBefore => time glissStart;
    
    glissStart => now;
    
    p.freq() => float start;
    
    destination - start => float difference; 
    // if destination > start (it glissandos up), then difference is positive.
    // if destination < start (it glissandos down), difference is negative.
    
    division(difference,100) => float freqIncrements;
    
    totalDurtoMeter(howSoonBefore, 100) @=> time incrementTime[];
    
    until(now >= incrementTime[incrementTime.size()-1])
    {
        p.freq() + freqIncrements => p.freq;
        nextBeatTime(incrementTime) => now;
    }    
    
    if(now < nextBeat)
        nextBeat => now;
}


fun void reverbToDestination(JCRev myR, float destination, dur howLong)
{
    myR.mix() => float start;
    
    start - destination => float difference;
    
    division(difference,100) => float mixIncrements;
    
    totalDurtoMeter(howLong, 100) @=> time incrementTime[];
    
    until(now >= incrementTime[incrementTime.size()-1])
    {
        myR.mix() - mixIncrements => myR.mix;
        nextBeatTime(incrementTime) => now;
    }
}
fun void reverbToZero(JCRev myR, dur howLong)
{
    division(myR.mix(),100) => float mixIncrements;
    
    totalDurtoMeter(howLong, 100) @=> time incrementTime[];
    
    until(now >= incrementTime[incrementTime.size()-1])
    {
        myR.mix() - mixIncrements => myR.mix;
        nextBeatTime(incrementTime) => now;
    }
}


//
// // // Pure mechanics functions:
// Generate an array of size n, of integers 0 through n-1, where each integer is unique.
fun int[] nonRepeatingIntegers(int size)
{
    int myArray[size];
    int random[0];
    
    random << Math.random2(0, size-1);
    random[0] => myArray[0];
    
    for(1 => int sizeCount; sizeCount < size; sizeCount++)
    {
        int tempRandom;
        while(true)
        {
            Math.random2(0, size-1) => tempRandom;
            
            0 => int randomCheck;
            for(0 => int randomCount; randomCount < random.size(); randomCount++)
            {
                if(tempRandom == random[randomCount])
                    true => int randomCheck;
            }
            if(randomCheck == false)
                break;
        }
        random << tempRandom;
        random[sizeCount] => myArray[sizeCount];
    }
    
    return myArray;
}

// This returns either 1 or -1.
fun int posOrNeg()
{
    return Std.ftoi(2*(maybe-.5));
}

// This is just division. / doesn't seem to work in many cases, except in /=>.
fun float division(float numerator, float denominator)
{
    denominator /=> numerator;
    return numerator;
}
fun dur divisionDur(dur numerator, float denominator)
{
    division(1, denominator) => float inverse;
    inverse::numerator => numerator;
    return numerator;
}
// This is even simpler.
fun float itof(int integer)
{
    integer => float floatValue;
    return floatValue;
}
// These must exist already, I imagine, but I can't find them.
fun int arrayIntSum(int array[])
{
    return arrayIntSum(array, array.size());
}
fun int arrayIntSum(int array[], int upTo)
{
    if(upTo > array.size())
    {
        <<< "Stop that at once." >>>;
        return arrayIntSum(array);
    }
    else
    {
        0 => int sum;
        for (0 => int myCount; myCount < upTo; myCount++)
        {
            array[myCount] +=> sum;
        }
        return sum;
    }
}
fun float arrayIntAverage(int array[])
{
    return arrayIntAverage(array, array.size());
}
fun float arrayIntAverage(int array[], int upTo)
{
    if(upTo > array.size())
    {
        <<< "Stop that at once." >>>;
        return arrayIntAverage(array);
    }
    else
    {
        0 => float average;
        for (0 => int myCount; myCount < upTo; myCount++)
        {
            array[myCount] +=> average;
        }
        upTo /=> average;
        return average;
    }
}
fun float arrayPercent(int array[], int whichOne)
{
    array[whichOne] => float percent;
    arrayIntSum(array) /=> percent;
    return percent;
}
fun float arrayPercentf(float array[], int whichOne)
{
    array[whichOne] => float percent;
    arrayfSum(array) /=> percent;
    return percent;
}
fun float arrayfSum(float array[])
{
    return arrayfSum(array, array.size());
}
fun float arrayfSum(float array[], int upTo)
{
    if(upTo > array.size())
    {
        <<< "Stop that at once." >>>;
        return arrayfSum(array);
    }
    else
    {
        0 => float sum;
        for (0 => int myCount; myCount < upTo; myCount++)
        {
            array[myCount] +=> sum;
        }
        return sum;
    }
}
fun float arrayfAverage(float array[])
{
    return arrayfAverage(array, array.size());
}
fun float arrayfAverage(float array[], int upTo)
{
    if(upTo > array.size())
    {
        <<< "Stop that at once." >>>;
        return arrayfAverage(array);
    }
    else
    {
        0 => float average;
        for (0 => int myCount; myCount < upTo; myCount++)
        {
            array[myCount] +=> average;
        }
        upTo /=> average;
        return average;
    }
}
// Arrange all of the values in an int array in order from least to greatest.
// Buggy. Careful.
fun int[] numericalOrder(int array[])
{
    int newArray[array.size()];
    array @=> int tempArray[];
    for (0 => int newArrayCount; newArrayCount < newArray.size(); newArrayCount++)
    {
        
        tempArray.size()-1 => int arrayTesterNum;
        tempArray[arrayTesterNum] => int arrayTester;
        for (tempArray.size()-2 => int arrayCount; arrayCount >= 0; arrayCount--)
        {
            if(tempArray[arrayCount] < arrayTester)
            {
                arrayCount => arrayTesterNum;
                tempArray[arrayCount] => arrayTester;
            }   
        }
        
        tempArray[tempArray.size()-1] => tempArray[arrayTesterNum];
        arrayTester => tempArray[tempArray.size()-1];
        
        tempArray.popBack();
        
        arrayTester => newArray[newArrayCount];
    }
    
    return newArray;
}
// The same, for a set of float values.
fun float[] numericalOrderf(float array[])
{
    float newArray[array.size()];
    array @=> float tempArray[];
    for (0 => int newArrayCount; newArrayCount < newArray.size(); newArrayCount++)
    {
        
        tempArray.size()-1 => int arrayTesterNum;
        tempArray[arrayTesterNum] => float arrayTester;
        for (tempArray.size()-2 => int arrayCount; arrayCount >= 0; arrayCount--)
        {
            if(tempArray[arrayCount] < arrayTester)
            {
                arrayCount => arrayTesterNum;
                tempArray[arrayCount] => arrayTester;
            }   
        }
        
        tempArray[tempArray.size()-1] => tempArray[arrayTesterNum];
        arrayTester => tempArray[tempArray.size()-1];
        
        tempArray.popBack();
        
        arrayTester => newArray[newArrayCount];
    }
    
    return newArray;
}
// Picks the highest member of an int array. (Note: no provisions for if there are multiple highest members.)
fun int maximumMember(int array[])
{
    -24390239 => int arrayTest;
    0 => int arrayTestMember;
    
    for(0 => int arrayCount; arrayCount < array.size(); arrayCount++)
    {
        if(array[arrayCount] >= arrayTest)
        {
            arrayCount => arrayTestMember;
            array[arrayCount] => arrayTest;
        }
    }
    return arrayTestMember;
}
// Picks the highest member of a float array.
fun int maximumMemberf(float array[])
{
    -24390239 => float arrayTest;
    0 => int arrayTestMember;
    
    for(0 => int arrayCount; arrayCount < array.size(); arrayCount++)
    {
        if(array[arrayCount] >= arrayTest)
        {
            arrayCount => arrayTestMember;
            array[arrayCount] => arrayTest;
        }
    }
    return arrayTestMember;
}
// Picks the highest value of an int array. (Note: no provisions for if there are multiple highest members.)
fun int maximumValue(int array[])
{
    -24390239 => int arrayTest;
    0 => int arrayTestMember;
    
    for(0 => int arrayCount; arrayCount < array.size(); arrayCount++)
    {
        if(array[arrayCount] >= arrayTest)
        {
            arrayCount => arrayTestMember;
            array[arrayCount] => arrayTest;
        }
    }
    return arrayTest;
}
// Picks the highest value of a float array.
fun float maximumValuef(float array[])
{
    -24390239 => float arrayTest;
    0 => int arrayTestMember;
    
    for(0 => int arrayCount; arrayCount < array.size(); arrayCount++)
    {
        if(array[arrayCount] >= arrayTest)
        {
            arrayCount => arrayTestMember;
            array[arrayCount] => arrayTest;
        }
    }
    return arrayTest;
}
// Adds a value to each member of an int array.
fun int[] transposeArray(int array[], int byHowMuch)
{
    for (0 => int arrayCount; arrayCount < array.size(); arrayCount++)
    {
        byHowMuch +=> array[arrayCount];
    }
    return array;
}
fun float[] transposeArrayf(float array[], float byHowMuch)
{
    for (0 => int arrayCount; arrayCount < array.size(); arrayCount++)
    {
        byHowMuch +=> array[arrayCount];
    }
    return array;
}
// The same as the above two, but instead of adding by a given amount, it adds by some amount to get to a given target amount for the lowest value.
fun int[] transposeArrayTo(int array[], int target)
{
    numericalOrder(array) @=> int tempArray[]; 
    target - tempArray[0] => int difference;   
    
    return transposeArray(array, difference);
}
fun int[] transposeArrayTo(int array[])
{
    return transposeArrayTo(array, 0);
}
fun float[] transposeArrayTof(float array[], float target)
{
    numericalOrderf(array) @=> float tempArray[]; 
    target - tempArray[0] => float difference;   
    
    return transposeArrayf(array, difference);
}
fun float[] transposeArrayTof(float array[])
{
    return transposeArrayTof(array, 0);
}
// A function that takes the values of myArray[#][X] (every #, the X specified by you) and returns a single array with all of X in a single array.
fun int[] twoDimensionaltoOne(int array[][], int whichOne)
{
    int newArray[array.size()];
    for(0 => int arrayCount; arrayCount<array.size(); arrayCount++)
    {
        array[arrayCount][whichOne] => newArray[arrayCount];
    }
    return newArray;
}
fun float[] twoDimensionaltoOnef(float array[][], int whichOne)
{
    float newArray[array.size()];
    for(0 => int arrayCount; arrayCount<array.size(); arrayCount++)
    {
        array[arrayCount][whichOne] => newArray[arrayCount];
    }
    return newArray;
}
// A function that converts an array like [ a, b, c, d ] into [ a, a+b, a+b+c, a+b+c+d ].
fun int[] arraySummation(int array[])
{
    int newArray[array.size()];
    for(0 => int arrayCount; arrayCount<array.size(); arrayCount++)
    {
        arrayIntSum(array, arrayCount+1) => newArray[arrayCount];
    }
    return newArray;
}
fun float[] arraySummationf(float array[])
{
    float newArray[array.size()];
    for(0 => int arrayCount; arrayCount<array.size(); arrayCount++)
    {
        arrayfSum(array, arrayCount+1) => newArray[arrayCount];
    }
    return newArray;
}



// The following is not (easily) used outside of this program. It needs two global arrays, int beats[][] and int bars[], to function.
//fun void addXTimetoEachPartOfArraysbeatsandbars(dur byHowLong)
//{
//    for(0 => int barCount; barCount < bars.size(); barCount++)
//    {
//        byHowLong +=> bars[barCount];
//    }
//    for(0 => int barCount; barCount < beats.size(); barCount++)
//    {
//        for(0 => int beatCount; beatCount < beats[barCount].size(); beatCount++)
//        {
//            byHowLong +=> beats[barCount][beatCount];
//        }
//    }
//}
// The following variant might have nice uses in rubato (not strict rubato)
//fun void addXTimetoEachPartOfArraysbeatsandbars(time Now, dur byHowLong)
//{
//    for(0 => int barCount; barCount < bars.size(); barCount++)
//    {
//        if(bars[barCount] > Now)
//        {
//            byHowLong +=> bars[barCount];
//        }
//    }
//    for(0 => int barCount; barCount < beats.size(); barCount++)
//    {
//        for(0 => int beatCount; beatCount < beats[barCount].size(); beatCount++)
//        {
//            if(beats[barCount][beatCount] > Now)
//            {
//                byHowLong +=> beats[barCount][beatCount];
//            }
//        }
//    }
//}
// Another variant, for stricter rubato.
//fun void addXTimetoEachPartOfArraysbeatsandbars(time Now, time Until, dur byHowLong)
//{
//    for(0 => int barCount; barCount < bars.size(); barCount++)
//    {
//        if(bars[barCount] > Now && bars[barCount] < Until)
//        {
//            byHowLong +=> bars[barCount];
//        }
//    }
//    for(0 => int barCount; barCount < beats.size(); barCount++)
//    {
//        for(0 => int beatCount; beatCount < beats[barCount].size(); beatCount++)
//        {
//            if(beats[barCount][beatCount] > Now && beats[barCount][beatCount] < Until)
//            {
//                byHowLong +=> beats[barCount][beatCount];
//            }
//        }
//    }
//}
//fun void addXTimetoEachPartOfArraysBeatsBarsSimpleBeatsandCues(dur byHowLong)
//{
//    for(0 => int barCount; barCount < bars.size(); barCount++)
//    {
//        byHowLong +=> bars[barCount];
//    }
//    for(0 => int barCount; barCount < beats.size(); barCount++)
//    {
//        for(0 => int beatCount; beatCount < beats[barCount].size(); beatCount++)
//        {
//            byHowLong +=> beats[barCount][beatCount];
//        }
//    }
//    for(0 => int beatCount; beatCount < simpleBeats.size(); beatCount++)
//    {
//        byHowLong +=> simpleBeats[beatCount];
//    }
//    for(0 => int cueCount; cueCount < cues.size(); cueCount++)
//    {
//        byHowLong +=> cues[cueCount];
//    }
//}



//
// // // Tuning set-up functions:

//
// // Intonation functions:

// This generates the basic information needed to set up equal temperament, within a mostly-handy array.
// TET[0] is the number of tones per octave, if you need that. (If you need it as an int, then Std.ftoi(TET[0]).)
// TET[1] is 1 / TET[0], if you need that.
// TET[2] is the thing you really need. This is the size of a semitone in this system.
// With all of this you ought to be able to set up a whole keyboard that you could use much like the Std.mtof(#).
// It can also be used on its own, e.g. tonic * Math.pow(TET[2], mel[melCount]) => voice.freq; or something.
fun float[] EDOsetup(int tonesPerOctave)
{
    1 => float toneInv; tonesPerOctave/=>toneInv; // toneInv is equal to 1 divided by tonesPerOctave. 
    Math.pow(2,toneInv) => float semitone; // a semitone is equal to 2 to the power of 1 over tonesPerOctave, or, the tonesPerOctaveth root of 2. 
    
    tonesPerOctave => float tonesPerOctavef;
    [ tonesPerOctavef, toneInv, semitone ] @=> float TET[];
    
    return TET; // 
}

// This is simply to make what's happening clearer. 
fun float semitones(int howMany, float myTET[])
{
    return Math.pow(myTET[2],howMany);
}
// This is if you have no TET.
fun float semitonesNoSetup(int howMany, int myTET)
{
    EDOsetup(myTET) @=> float tempTET[];
    return semitones(howMany, tempTET);
}
// This gives you the frequency, not just the frequency ratio.
fun float semitonesOver(int howMany, float myTET[], float tonic)
{
    return tonic * Math.pow(myTET[2],howMany);
}
// 
// // Timbre functions:

// Does a variety of things. Very proud of this one.
// Must be atchucked to another ADSR in order to lock it into existence.
// Oh shoot
// How do I change the fundamental of an existing note
// Argghhhh
fun ADSR additiveSynth1(float harmonic[][], float fundamental, float gain)
{
    if(harmonic.size() != 0)
    {
        // This segment calibrates all the listed gains (in each harmonic[x][1]) to the stated float 'gain'.
        0 => float harmonicGainSum; // The sum of all harmonic[x][1]. Starts at zero.
        float harmonicGainPercent[harmonic.size()]; // A percentage for each harmonic[x][1]. Unspecified at the start.
        // How much gain is there in harmonic?
        for (0 => int harmCount; harmCount < harmonic.size(); harmCount++)
        {
            harmonic[harmCount][1] +=> harmonicGainSum; // This adds every harmonic[harmCount][1] to harmonicGainSum. It's not zero anymore.
        }
        // What percentage of this total does each harmonic[#][1] constitute?
        for (0 => int harmCount; harmCount < harmonic.size(); harmCount++)
        {
            harmonic[harmCount][1] => harmonicGainPercent[harmCount]; // First we take each harmonic[harmCount][1].
            harmonicGainSum /=> harmonicGainPercent[harmCount]; // Then we divide that by the sum to get a percentage for each harmonic. (Strictly speaking, it's a decimal, not a percentage.)
        }
        
        // Now we create a SinOsc for each harmonic, and a single ADSR envelope.
        SinOsc voice[harmonic.size()];
        ADSR adsr;
        
        for (0 => int voiceCount; voiceCount < voice.size(); voiceCount++)
        {
            fundamental * harmonic[voiceCount][0] => voice[voiceCount].freq; // We multiply the fundamental by the harmonic (or non-harmonic) multiplier listed in harmonic[voiceCount][0], and give that to voice[voiceCount]'s frequency.
            
            harmonicGainPercent[voiceCount] * gain => voice[voiceCount].gain; // We multiply the total gain by the percentage we obtained previously for each voiceCount.
            
            voice[voiceCount] => adsr;
        }
        
        return adsr;
    }
    else
    {
        <<< "Harmonic array cannot be zero size." >>>;
        
        ADSR dummy;
        return dummy;
    }
}
// I'm proud of this one two, but maybe it's a bit much.
// Requires an adsr[][] in order to create an independent attack, decay, sustain and release for every single harmonic, Christ. I wonder if ADSR finalenv could be replaced by Gain g or something.
fun ADSR additiveSynth2(float harmonic[][], float fundamental, float gain, float adsr[][])
{
    if(harmonic.size() != 0)
    {
        // This segment calibrates all the listed gains (in each harmonic[x][1]) to the stated float 'gain'.
        0 => float harmonicGainSum; // The sum of all harmonic[x][1]. Starts at zero.
        float harmonicGainPercent[harmonic.size()]; // A percentage for each harmonic[x][1]. Unspecified at the start.
        // How much gain is there in harmonic?
        for (0 => int harmCount; harmCount < harmonic.size(); harmCount++)
        {
            harmonic[harmCount][1] +=> harmonicGainSum; // This adds every harmonic[harmCount][1] to harmonicGainSum. It's not zero anymore.
        }
        // What percentage of this total does each harmonic[#][1] constitute?
        for (0 => int harmCount; harmCount < harmonic.size(); harmCount++)
        {
            harmonic[harmCount][1] => harmonicGainPercent[harmCount]; // First we take each harmonic[harmCount][1].
            harmonicGainSum /=> harmonicGainPercent[harmCount]; // Then we divide that by the sum to get a percentage for each harmonic. (Strictly speaking, it's a decimal, not a percentage.)
        }
        
        // Now we create a SinOsc for each harmonic, and an ADSR envelope for each SinOsc, and another ADSR envelope for all of them to plug into in the end. 
        SinOsc voice[harmonic.size()];
        ADSR env[voice.size()];
        ADSR finalenv;
        
        for (0 => int voiceCount; voiceCount < voice.size(); voiceCount++)
        {
            fundamental * harmonic[voiceCount][0] => voice[voiceCount].freq; // We multiply the fundamental by the harmonic (or non-harmonic) multiplier listed in harmonic[voiceCount][0], and give that to voice[voiceCount]'s frequency.
            
            harmonicGainPercent[voiceCount] * gain => voice[voiceCount].gain; // We multiply the total gain by the percentage we obtained previously for each voiceCount.
            
            voice[voiceCount] => env[voiceCount];
        }
        
        // Here we modify the sound of each env[#] based on the float adsr[#] supplied.
        for (0 => int envCount; envCount < env.size(); envCount++)
        {
            if(envCount<adsr.size())
            {
                env[envCount].set(adsr[envCount][0]::second, adsr[envCount][1]::second, adsr[envCount][2], 0.1::second);
            }
            else
            {
                env[envCount].set(0.1::second, 0.1::second, 0.0, 0.1::second);
            }
            env[envCount].keyOn(1);
            env[envCount] => finalenv;
        }
        
        
        return finalenv;
    }
    else
    {
        <<< "Harmonic array cannot equal zero." >>>;
        ADSR dummy;
        return dummy;
    }
}
// This is the old version of the above two. As of yet, it's the only one capable of slurring pitches.
fun void newPitchSinOscArray(UGen chuckee, SinOsc voice[], float harmonic[][], float gain, float newFreq)
{
    if(voice.size() == harmonic.size() && harmonic.size() != 0)
    {
        0 => float harmonicGainSum;
        float harmonicGainPercent[harmonic.size()];
        for (0 => int harmCount; harmCount < harmonic.size(); harmCount++)
        {
            harmonic[harmCount][1] +=> harmonicGainSum;
        }
        for (0 => int harmCount; harmCount < harmonic.size(); harmCount++)
        {
            harmonic[harmCount][1] => harmonicGainPercent[harmCount];
            harmonicGainSum /=> harmonicGainPercent[harmCount];
        }
        
        for (0 => int voiceCount; voiceCount < voice.size(); voiceCount++)
        {
            newFreq * harmonic[voiceCount][0] => voice[voiceCount].freq;
            
            harmonicGainPercent[voiceCount] * gain => voice[voiceCount].gain;
            
            if(voice[voiceCount].isConnectedTo(chuckee))
            {}
            else
            {
                voice[voiceCount] => chuckee;
            }
        }
    }
    else
    {
        <<< "Voice array and harmonic array must be of equal size, and cannot equal zero." >>>;
    }
}

// This one should work for my purposes.
// Actually, never mind. Instead I'm splitting its functions into additiveSynth3a (assign to an ADSR) and additiveSynth3b (change pitch and gain).
fun ADSR additiveSynth3(float harmonic[][], SinOsc voice[], float fundamental, float gain)
{
    if(harmonic.size() != 0 && harmonic.size() == voice.size())
    {
        // This segment calibrates all the listed gains (in each harmonic[x][1]) to the stated float 'gain'.
        0 => float harmonicGainSum; // The sum of all harmonic[x][1]. Starts at zero.
        float harmonicGainPercent[harmonic.size()]; // A percentage for each harmonic[x][1]. Unspecified at the start.
        // How much gain is there in harmonic?
        for (0 => int harmCount; harmCount < harmonic.size(); harmCount++)
        {
            harmonic[harmCount][1] +=> harmonicGainSum; // This adds every harmonic[harmCount][1] to harmonicGainSum. It's not zero anymore.
        }
        // What percentage of this total does each harmonic[#][1] constitute?
        for (0 => int harmCount; harmCount < harmonic.size(); harmCount++)
        {
            harmonic[harmCount][1] => harmonicGainPercent[harmCount]; // First we take each harmonic[harmCount][1].
            harmonicGainSum /=> harmonicGainPercent[harmCount]; // Then we divide that by the sum to get a percentage for each harmonic. (Strictly speaking, it's a decimal, not a percentage.)
        }
        
        // Now we create a single ADSR envelope for all SinOscs.
        ADSR adsr;
        
        for (0 => int voiceCount; voiceCount < voice.size(); voiceCount++)
        {
            fundamental * harmonic[voiceCount][0] => voice[voiceCount].freq; // We multiply the fundamental by the harmonic (or non-harmonic) multiplier listed in harmonic[voiceCount][0], and give that to voice[voiceCount]'s frequency.
            
            harmonicGainPercent[voiceCount] * gain => voice[voiceCount].gain; // We multiply the total gain by the percentage we obtained previously for each voiceCount.
            
            voice[voiceCount] => adsr; // We connect each one to adsr.
        }
        
        return adsr; // In order to solidify this thing's existence, use @=> to explicitly assign it to an existing or new ADSR object.
    }
    else
    {
        <<< "Voice array and harmonic array must be of equal size, and cannot equal zero." >>>;
        
        ADSR dummy;
        return dummy;
    }
}
fun ADSR additiveSynth3a(float harmonic[][], SinOsc voice[])
{
    if(harmonic.size() != 0 && harmonic.size() == voice.size())
    {
        // We create a single ADSR envelope for all SinOscs.
        ADSR adsr;
        
        for (0 => int voiceCount; voiceCount < voice.size(); voiceCount++)
        {
            voice[0].freq() * harmonic[voiceCount][0] => voice[voiceCount].freq; // We multiply the fundamental by the harmonic (or non-harmonic) multiplier listed in harmonic[voiceCount][0], and give that to voice[voiceCount]'s frequency.
            
            voice[voiceCount] => adsr; // We connect each one to adsr.
        }
        
        return adsr; // In order to solidify this thing's existence, use @=> to explicitly assign it to an existing or new ADSR object.
    }
    else
    {
        <<< "Voice array and harmonic array must be of equal size, and cannot equal zero." >>>;
        
        ADSR dummy;
        return dummy;
    }
}
fun void additiveSynth3b(float harmonic[][], SinOsc voice[], float fundamental, float gain)
{
    if(harmonic.size() != 0 && harmonic.size() == voice.size())
    {
        // This segment calibrates all the listed gains (in each harmonic[x][1]) to the stated float 'gain'.
        0 => float harmonicGainSum; // The sum of all harmonic[x][1]. Starts at zero.
        float harmonicGainPercent[harmonic.size()]; // A percentage for each harmonic[x][1]. Unspecified at the start.
        // How much gain is there in harmonic?
        for (0 => int harmCount; harmCount < harmonic.size(); harmCount++)
        {
            harmonic[harmCount][1] +=> harmonicGainSum; // This adds every harmonic[harmCount][1] to harmonicGainSum. It's not zero anymore.
        }
        // What percentage of this total does each harmonic[#][1] constitute?
        for (0 => int harmCount; harmCount < harmonic.size(); harmCount++)
        {
            harmonic[harmCount][1] => harmonicGainPercent[harmCount]; // First we take each harmonic[harmCount][1].
            harmonicGainSum /=> harmonicGainPercent[harmCount]; // Then we divide that by the sum to get a percentage for each harmonic. (Strictly speaking, it's a decimal, not a percentage.)
        }
        
        for (0 => int voiceCount; voiceCount < voice.size(); voiceCount++)
        {
            fundamental * harmonic[voiceCount][0] => voice[voiceCount].freq; // We multiply the fundamental by the harmonic (or non-harmonic) multiplier listed in harmonic[voiceCount][0], and give that to voice[voiceCount]'s frequency.
            
            harmonicGainPercent[voiceCount] * gain => voice[voiceCount].gain; // We multiply the total gain by the percentage we obtained previously for each voiceCount.
        }
    }
    else
    {
        <<< "Voice array and harmonic array must be of equal size, and cannot equal zero." >>>;
        
    }
}


//
//
// // // Time and duration functions:


//
// // Time-setting functions (no modification of now)

// Converting metronome marking (for my convenience)
fun dur mmtoDur(float tempo)
{
    1 => float tempoInv; tempo /=> tempoInv;
    
    tempoInv::minute => dur tempoDur;
    
    return tempoDur;
}

// Sets up a simple beat, derived from a total duration. 
fun time[] totalDurtoMeter(time start, dur totalDur, int beatNum)
{
    1 => float beatNumInv; beatNum /=> beatNumInv;
    beatNumInv::totalDur => dur beatDur;
    
    time beat[beatNum+1]; // barNum+1 if you want the last barline to be the end.
    
    for (0 => int beatCount; beatCount < beat.size(); beatCount++)
    {
        start + beatCount::beatDur => beat[beatCount];
        
    }
    return beat;
}
fun time[] totalDurtoMeter(dur totalDur, int beatNum)
{
    return totalDurtoMeter(now, totalDur, beatNum);
}

fun time[] beatDurtoMeter(time start, dur beatDur, int beatNum)
{
    
    time beat[beatNum+1]; // barNum+1 if you want the last barline to equal end.
    
    for (0 => int beatCount; beatCount < beat.size(); beatCount++)
    {
        start + beatCount::beatDur => beat[beatCount];
        
    }
    return beat;
}
fun time[] beatDurtoMeter(dur beatDur, int beatNum)
{
    return beatDurtoMeter(now, beatDur, beatNum);
}
// Another one much like the above.
fun time[] timeIntervaltoMeter(time start, time end, int beatNum)
{
    end - start => dur totalDur;
    
    1 => float beatNumInv; beatNum /=> beatNumInv;
    beatNumInv::totalDur => dur beatDur;
    
    time beat[beatNum+1]; // barNum+1 if you want the last barline to be the end.
    
    for (0 => int beatCount; beatCount < beat.size(); beatCount++)
    {
        start + beatCount::beatDur => beat[beatCount];
        
    }
    return beat;
}
fun time[] microGen(int fractions[], time start, time end)  
{
    if(fractions.size() > 0)
    {
        0 => int equalFlag;
        for(1 => int dangerCount; dangerCount < fractions.size(); dangerCount++)
        {
            if(fractions[dangerCount-1] == fractions[dangerCount]) true => equalFlag;
        }
        // I have this flag set up, but at the moment, I'm skipping on actually having them do anything. 
        
        if(fractions[0] == 0)
        {
            time genBar[fractions.size()];
            end - start => dur barDur;
            1 => float inv; fractions[fractions.size()-1] /=> inv;
            
            for (0 => int beatCount; beatCount < fractions.size(); beatCount++)
            {
                start + (fractions[beatCount]*inv)::barDur => genBar[beatCount];
            }
            return genBar;
        }
        else
        {
            <<< "I'll assume you meant this:" >>>;
            int newFractions[fractions.size()+1]; 0 => newFractions[0];
            for(0 => int arrayCount; arrayCount < fractions.size(); arrayCount++)
            {
                fractions[arrayCount] => newFractions[arrayCount+1];
            }
            return microGen(newFractions, start, end);
        }
    }
    else
    {
        <<< "Get that shit outta here." >>>;
    }
}
fun time[] microGenf(float fractions[], time start, time end)  
{
    if(fractions.size() > 0)
    {
        0 => int equalFlag;
        for(1 => int dangerCount; dangerCount < fractions.size(); dangerCount++)
        {
            if(fractions[dangerCount-1] == fractions[dangerCount]) true => equalFlag;
        }
        // I have this flag set up, but at the moment, I'm skipping on actually having them do anything. 
        
        if(fractions[0] == 0.0)
        {
            time genBar[fractions.size()];
            end - start => dur barDur;
            1 => float inv; fractions[fractions.size()-1] /=> inv;
            
            for (0 => int beatCount; beatCount < fractions.size(); beatCount++)
            {
                start + (fractions[beatCount]*inv)::barDur => genBar[beatCount];
            }
            return genBar;
        }
        else
        {
            <<< "I'll assume you meant this:" >>>;
            float newFractions[fractions.size()+1]; 0.0 => newFractions[0];
            for(0 => int arrayCount; arrayCount < fractions.size(); arrayCount++)
            {
                fractions[arrayCount] => newFractions[arrayCount+1];
            }
            return microGenf(newFractions, start, end);
        }
    }
    else
    {
        <<< "Get that shit outta here." >>>;
    }
}
// For use with the above (just the int one).
fun int[] fractionGen()
{
    int fractions[1];
    0 => fractions[0];
    
    repeat(Math.random2(1,4)) // Yields a fractions[] array of sizes 2, 3, 4 or 5. Giving us a beat pattern of 1, 2, 3 or 4 beats long.
    {
        fractions << (fractions[fractions.size()-1]+Math.random2(1,4));
    }
    return fractions;
}
fun int[] fractionGen(int beats)
{
    int fractions[1];
    0 => fractions[0];
    
    repeat(beats) // Yields a fractions[] array of size beats+1. Giving us a beat pattern that's 'beats' beats long.
    {
        fractions << (fractions[fractions.size()-1]+Math.random2(1,4));
    }
    return fractions;
}
fun int[] fractionGen(int beatApproximates[])
{
    int fractions[1];
    0 => fractions[0];
    
    for(0 => int beatCount; beatCount < beatApproximates.size(); beatCount++)
    {
        fractions << (fractions[fractions.size()-1] + Math.random2(beatApproximates[beatCount]-1,beatApproximates[beatCount]+1));
    }
    
    return fractions;
}
fun int[] fractionGen(int floor0cap1, int beatApproximates[], int input1)
{
    int floor; int cap;
    if(floor0cap1)
    {
        0 => floor;
        
        if(input1 > 0 && input1 <= beatApproximates.size())
            input1 => cap;
        else
            beatApproximates.size() => cap;
    }
    else
    {
        if(input1 >= 0 && input1 < beatApproximates.size())
            input1 => floor;
        else
            0 => floor;
        
        beatApproximates.size() => cap;
    }
    
    int fractions[1];
    0 => fractions[0];
    
    for(0 => int beatCount; beatCount < beatApproximates.size(); beatCount++)
    {
        if(beatCount < floor || beatCount >= cap)
        {
            fractions << (fractions[fractions.size()-1] + beatApproximates[beatCount]);
        }
        else
            fractions << (fractions[fractions.size()-1] + Math.random2(beatApproximates[beatCount]-1,beatApproximates[beatCount]+1));
    }
    
    return fractions;
}
fun int[] fractionGen(int beatApproximates[], int input1, int input2)
{
    int floor; int cap;
    0 => floor;
    beatApproximates.size() => cap;
    
    if(input1 > input2)
    {
        if(input1 < cap && input1 > floor)
            input1 => cap;
        if(input2 < cap && input2 > floor)
            input2 => floor;
    }
    if(input1 < input2)
    {
        if(input1 < cap && input1 > floor)
            input2 => cap;
        if(input2 < cap && input2 > floor)
            input1 => floor;
    }
    if(input1 == input2)
    {
        if(input1 < cap && input1 > floor)
            input1 => cap;
        if(input2 < cap && input2 > floor)
            input2 => floor;
    }
    
    int fractions[1];
    0 => fractions[0];
    
    for(0 => int beatCount; beatCount < beatApproximates.size(); beatCount++)
    {
        if(beatCount < floor || beatCount >= cap)
        {
            fractions << (fractions[fractions.size()-1] + beatApproximates[beatCount]);
        }
        else
            fractions << (fractions[fractions.size()-1] + Math.random2(beatApproximates[beatCount]-1,beatApproximates[beatCount]+1));
    }
    
    return fractions;
}





// A timekeeping function. 
fun int currentBeat(time Now, time beat[])
{
    if(Now >= beat[0] && Now < beat[beat.size()-1])
    {
        0 => int beatCount;
        
        while (Now > beat[beatCount])
        {
            beatCount++;
        }
        if(Now == beat[beatCount])
        {
            return beatCount;
        }
        if(Now < beat[beatCount])
        {
            return (beatCount-1);
        }
        
    }
    else
    {
        <<< "You playing me for a fool?" >>>;
    }
}
fun time currentBeatTime(time Now, time beat[])
{
    if(Now >= beat[0] && Now < beat[beat.size()-1])
    {
        0 => int beatCount;
        
        while (Now > beat[beatCount])
        {
            beatCount++;
        }
        if(Now == beat[beatCount])
        {
            return beat[beatCount];
        }
        if(Now < beat[beatCount])
        {
            return beat[beatCount-1];
        }
    }
    else
    {
        <<< "You playing me for a fool?" >>>;
    }
}
fun int currentBeat(time beat[])
{
    return currentBeat(now, beat);
}
fun time currentBeatTime(time beat[])
{
    return currentBeatTime(now, beat);
}

// A timekeeping function.
// format: nextBeat(now, beat) => int theNextBeat;
fun int nextBeat(time Now, time beat[])
{
    if(Now >= beat[0] && Now < beat[beat.size()-1])
    {
        0 => int beatCount;
        
        while (Now >= beat[beatCount])
        {
            beatCount++;
        }
        return beatCount;
    }
    else
    {
        <<< "You playing me for a fool?" >>>;
    }
}
fun time nextBeatTime(time Now, time beat[])
{
    if(Now >= beat[0] && Now < beat[beat.size()-1])
    {
        0 => int beatCount;
        
        while (Now >= beat[beatCount])
        {
            beatCount++;
        }
        return beat[beatCount];
    }
    else
    {
        <<< "You playing me for a fool?" >>>;
    }
}
fun int nextBeat(time beat[])
{
    return nextBeat(now, beat);
}
fun time nextBeatTime(time beat[])
{
    return nextBeatTime(now, beat);
}
//fun int beatsFromCurrentBeat(time Now, time beat[], int count)
//{
//    
//    
//    
//fun int beatsFromCurrentBeat(time beat[], int count)
//{
//    return beatsFromCurrentBeat(n, beat, count);
//}




//
// // Now-affecting functions

fun void adsrArticulation(ADSR adsr, dur note, dur artic, dur release)  // artic: how long it sustains the note. release: how long it takes for the note to fade to nothing.
{
    if(note > artic)
    {
        adsr.releaseTime(release);
        
        now + note => time later;
        
        adsr.keyOn(1);
        
        artic => now;
        
        adsr.releaseTime(release);
        
        adsr.keyOff(1);
        
        later => now;
    }
    else
    {
        if(note == artic)
        {
            adsr.releaseTime(release);
            
            adsr.keyOn(1);
            note => now;
            adsr.keyOff(1);
        }
        else
        {
            <<< "Cannot travel to the past!" >>>;
            adsr.keyOn(1);
            note => now;
        }
    }
}
fun void adsrArticulation(ADSR adsr, time later, dur artic, dur release)
{
    if(now + artic < later)
    {
        adsr.releaseTime(release);
        
        adsr.keyOn(1);
        
        artic => now;
        
        adsr.keyOff(1);
        
        later => now;
    }
    else
    {
        adsr.releaseTime(release);
        
        adsr.keyOn(1);
        later => now;
        adsr.keyOff(1);
    }
}

// For StkInstrument. Can support as many as three control number and value pairs (more can be added).
fun void StkArticulation(StkInstrument stk, float velocity, dur note, dur artic) 
{
    if(note > artic)
    {
        now + note => time later;
        
        stk.noteOn(velocity);
        
        artic => now;
        
        stk.noteOff(velocity);
        
        later => now;
    }
    else
    {
        if(note < artic)
        {
            <<< "Cannot travel to the past!" >>>;
        }
        
        stk.noteOn(velocity);
        note => now;
    }
}
fun void StkArticulation(StkInstrument stk, float velocity, time later, dur artic)
{
    if(now + artic < later)
    {
        stk.noteOn(velocity);
        
        artic => now;
        
        stk.noteOff(velocity);
        
        later => now;
    }
    else
    {
        stk.noteOn(velocity);
        later => now;
    }
}
fun void StkArticulation(StkInstrument stk, float velocity, dur note, dur artic, int ctrlNum, float ctrlValue) 
{
    stk.controlChange(ctrlNum, ctrlValue);
    
    StkArticulation(stk, velocity, note, artic);
}
fun void StkArticulation(StkInstrument stk, float velocity, time later, dur artic, int ctrlNum, float ctrlValue)
{
    stk.controlChange(ctrlNum, ctrlValue);
    
    StkArticulation(stk, velocity, later, artic);
}
fun void StkArticulation(StkInstrument stk, float velocity, dur note, dur artic, int ctrlNum, float ctrlValue, int ctrlNum2, float ctrlValue2) 
{
    stk.controlChange(ctrlNum2, ctrlValue2);
    StkArticulation(stk, velocity, note, artic, ctrlNum, ctrlValue);
}
fun void StkArticulation(StkInstrument stk, float velocity, time later, dur artic, int ctrlNum, float ctrlValue, int ctrlNum2, float ctrlValue2)
{
    stk.controlChange(ctrlNum, ctrlValue);
    StkArticulation(stk, velocity, later, artic, ctrlNum, ctrlValue);
}
fun void StkArticulation(StkInstrument stk, float velocity, dur note, dur artic, int ctrlNum, float ctrlValue, int ctrlNum2, float ctrlValue2, int ctrlNum3, float ctrlValue3) 
{
    stk.controlChange(ctrlNum3, ctrlValue3);
    StkArticulation(stk, velocity, note, artic, ctrlNum, ctrlValue, ctrlNum2, ctrlValue2);
}
fun void StkArticulation(StkInstrument stk, float velocity, time later, dur artic, int ctrlNum, float ctrlValue, int ctrlNum2, float ctrlValue2, int ctrlNum3, float ctrlValue3)
{
    stk.controlChange(ctrlNum3, ctrlValue3);
    StkArticulation(stk, velocity, later, artic, ctrlNum, ctrlValue, ctrlNum2, ctrlValue2);
}
fun void StkPitchandArticulation(float frequency, StkInstrument stk, float velocity, dur note, dur artic)
{
    stk.freq(frequency);
    StkArticulation(stk, velocity, note, artic);
}    
fun void StkPitchandArticulation(float frequency, StkInstrument stk, float velocity, time later, dur artic)
{
    stk.freq(frequency);
    StkArticulation(stk, velocity, later, artic);
}
fun void StkPitchandArticulation(float frequency, StkInstrument stk, float velocity, dur note, dur artic, int ctrlNum, float ctrlValue)
{
    stk.freq(frequency);
    StkArticulation(stk, velocity, note, artic, ctrlNum, ctrlValue);
}
fun void StkPitchandArticulation(float frequency, StkInstrument stk, float velocity, time later, dur artic, int ctrlNum, float ctrlValue)
{
    stk.freq(frequency);
    StkArticulation(stk, velocity, later, artic, ctrlNum, ctrlValue);
}
fun void StkPitchandArticulation(float frequency, StkInstrument stk, float velocity, dur note, dur artic, int ctrlNum, float ctrlValue, int ctrlNum2, float ctrlValue2)
{
    stk.freq(frequency);
    StkArticulation(stk, velocity, note, artic, ctrlNum, ctrlValue, ctrlNum2, ctrlValue2);
}
fun void StkPitchandArticulation(float frequency, StkInstrument stk, float velocity, time later, dur artic, int ctrlNum, float ctrlValue, int ctrlNum2, float ctrlValue2)
{
    stk.freq(frequency);
    StkArticulation(stk, velocity, later, artic, ctrlNum, ctrlValue, ctrlNum2, ctrlValue2);
}
fun void StkPitchandArticulation(float frequency, StkInstrument stk, float velocity, dur note, dur artic, int ctrlNum, float ctrlValue, int ctrlNum2, float ctrlValue2, int ctrlNum3, float ctrlValue3)
{
    stk.freq(frequency);
    StkArticulation(stk, velocity, note, artic, ctrlNum, ctrlValue, ctrlNum2, ctrlValue2, ctrlNum3, ctrlValue3);
}
fun void StkPitchandArticulation(float frequency, StkInstrument stk, float velocity, time later, dur artic, int ctrlNum, float ctrlValue, int ctrlNum2, float ctrlValue2, int ctrlNum3, float ctrlValue3)
{
    stk.freq(frequency);
    StkArticulation(stk, velocity, later, artic, ctrlNum, ctrlValue, ctrlNum2, ctrlValue2, ctrlNum3, ctrlValue3);
}

// // // Addendum.

// // Cheat sheet for making any sense of the code:

// currentBeat(beats[currentBeat(bars)])
// Integer ID of the current beat, among the beats of the current bar/measure.

// nextBeatTime(beats[currentBeat(bars)])
// Timestamp of the next beat, among the beats of the current bar/measure.

// beats[0][0]
// Timestamp of the first bar's first beat.

// bars[0]
// Timestamp of the first barline. In sheet music, "1" would be written above this point.

// beats[0][beats[0].size()-1]
// The final timestamp within the array representing the first bar, equivalent to the first beat of the following measure, or the next barline (all equivalents, as far as timestamps go).

// beats[1][0]
// The first timestamp within the array representing the second bar. Equivalent to the above.

// bars[1]
// Timestamp of the second barline. In sheet music, "2" would be written above this point. Equivalent to both of the above.

// beats.size()-1
// Integer ID of the last measure. That is, the measure that starts at bars[bars.size()-2] and ends at bars[bars.size()-1]. 
// In other words, the last array within array-of-arrays 'beats'.

// bars.size()-1
// Integer ID of the last barline. That is, the double barline. The moment that music ceases. Should be equal to the integer ID of the last timestamp within the last array of 'beats'.

// bars.size()-2
// Integer ID of the beginning of the final measure. Note that, in terms of time variables, the barline beginning a measure == the first note of that measure (or, the point in time that the first note begins).

// beats[beats.size()-1].size()-1
// Integer ID of the last timestamp within the last bar represented by array-of-arrays 'beats'.

// if(beats[beats.size()-1][beats[beats.size()-1].size()-1] == bars[bars.size()-1] && beats[0][0] == bars[0] && beats[0][beats[0].size()-1] == bars[1] && beats[0][beats[0].size()-1] == beats[1][0]) {    2::second => now;     }
// Is it all true that...
// -- the last timestamp of the last bar in array-of-arrays 'beats' is equal to the last timestamp in array 'bars'?
// -- the first timestamp of the first bar in array-of-arrays 'beats' is equal to the first timestamp in array 'bars'?
// -- the last timestamp of the first bar in array-of-arrays 'beats' is equal to the second timestamp in array 'bars'?
// -- the last timestamp of the first bar in array-of-arrays 'beats' is equal to the first timestamp of the second bar in array-of-arrays 'beats'?
// If so, tell me by waiting two seconds.

// This thing ought to make code easier to read. That's its sole function.
//fun time[] beatsOfTheCurrentBar() {return beats[currentBeat(bars)];}

// beats[nextBeat(bars)][currentBeat(beats[currentBeat(bars)])]
//fun int nextBar() {return nextBeat(bars);}
//fun int currentBar() {return currentBeat(bars);}
//fun int nextBeatbeat() {return nextBeat(beatsOfTheCurrentBar());}
//fun int currentBeatbeat() {return currentBeat(beatsOfTheCurrentBar());}



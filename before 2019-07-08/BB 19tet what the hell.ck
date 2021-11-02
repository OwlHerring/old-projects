



//
//
// times:
dur t[17];
8::second => t[0];
t[0]/2 => t[1];
for (2 => int tCount; tCount<t.cap(); tCount++)
{
    t[1]/tCount=>t[tCount];
}

//
//
// tuning system:
19 => int tone; // How many notes are there in an octave?
1 => float toneInv; tone/=>toneInv; // over19 is equal to 1 divided by 19. (I can't figure out how to do the following line without making 1/19 a variable first.)
Math.pow(2,toneInv) => float semitone; // a semitone is equal to 2 to the power of 1 over 19, or, the 19th root of 2. (You'd need semitone multiplied by itself 19 times to get 2 again.)

16 => int pitchstandard; // our C0 is 16 Hz (inaudible). A4 in 12TET is 430.54 Hz. In 19TET, A0 is 26.664 Hz, so A4 is 426.630 Hz (only 3 cents shy of a quarter tone away from 440 Hz).
11 => int numberofoctaves; // There are 11 Cs within our gamut, only 10 of which are audible.

float gamut[numberofoctaves*tone];
for (0 => int gamutCount; gamutCount < gamut.size(); gamutCount++) // This for loop will occur once for every octave from 0 to 11.
{
    pitchstandard * Math.pow(semitone,gamutCount) => gamut[gamutCount];
}

// 
// 
// diatonic notes (format: gamut[dia[#][#]];)

//0  1. 2. 3. 4.  5.  6
//C. D. E. F. G.  A.  B
[ 0, 3, 6, 8, 11, 14, 17 ] @=> int seedDia[];
1 => float diaSizeInv; seedDia.size()/=>diaSizeInv; //diaSizeInv is 1/7th.

int dia[seedDia.size()*numberofoctaves][5]; // Returns the chromatic value of scale degrees 0 (C) through 6 (B), with applied accidental 0 (bb) through 4 (x). 2 is natural.
for(0=>int diaCount; diaCount<dia.size(); diaCount++)
{
    Std.ftoi(diaCount*diaSizeInv) => int oct;
    for(0 => int chromCount; chromCount<dia[diaCount].size(); chromCount++)
    {
        seedDia[diaCount % seedDia.size()] + tone * oct + (chromCount - 2) => dia[diaCount][chromCount];
    }
}
// dia[0][0 through 4]: -2 (Cbb), -1 (Cb), 0 (C), 1 (C#), 2 (Cx)
// 0 is C, 1 is D, 2 is E, 3 is F, 4 is G, 5 is A, 6 is B, 7 is c.
// diatonic Cs: 0, 7, 14, 21, 28, 35, 42, 49, 56, 63, 70, 77
// diatonic As: 5, 12, 19, 26, 33, 40, 47, 54, 61, 68, 75, 82
// seconds are +1, thirds are +2, fourths are +3, fifths are +4, sixths are +5, sevenths are +6, octaves are +7.
// refer to the excel chart I made.

//
//
// scales
[ 0, 3, 6, 8, 11, 14, 17, 19, 22, 25, 27, 30 ] @=> int Maj1Oct[];

[ 0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40] @=> int halfFourths[];

//
//
// score:

50 => int tonic;
0.2 => float onGain; 0 => float offGain;

oneNote(
oneNote(gamut[dia[30][2]])




fun void BB(dur repDur, dur totalDur, int repNum, float pitch, dur release, UGen ug) // arguments: time in which repetitions occur, time before code resumes/ends, number of repetitions (initial note included), frequency, time for last note to fade, UGen to connect sound to.
{
    SawOsc voice => ADSR env => ug;
    pitch => voice.freq; 0.5 => voice.gain;
    env.set(0.01::second, 0.01::second, 1, 0.1::second);
    
    1 => float repNumInv; repNum /=> repNumInv;
    
    now => time earlier;
    
    for(0 => int repCount; repCount < repNum; repCount++)
    {
        if(repCount==repNum-1){release => env.releaseTime;}
        1 => env.keyOn;
        .5*repNumInv::repDur => now;
        1 => env.keyOff;
        .5*repNumInv::repDur => now;
    }
    
    now - earlier => dur elapsed; // If totalDur / repDur < repNum/repNum (i.e. 1), then exceptions occur.
    totalDur - elapsed => now;
} 

fun void BBB(dur repDur, dur totalDur, int repNum, float pitch, dur release, UGen ug) // arguments: time in which repetitions occur, time before code resumes/ends, number of repetitions (final note excluded), frequency, time for last note to fade, UGen to connect sound to.
{
    SawOsc voice => ADSR env => ug;
    pitch => voice.freq; 0.5 => voice.gain;
    env.set(0.01::second, 0.01::second, 1, 0.1::second);
    
    1 => float repNumInv; repNum /=> repNumInv;
    
    now => time earlier;
    
    for(0 => int repCount; repCount <= repNum; repCount++)
    {
        if(repCount==repNum){release => env.releaseTime;}
        1 => env.keyOn;
        .5*repNumInv::repDur => now;
        1 => env.keyOff;
        .5*repNumInv::repDur => now;
    }
    
    now - earlier => dur elapsed; // If totalDur / repDur <= (repNum+1)/repNum, then exceptions occur.
    totalDur - elapsed => now;
    
}

fun void oneNote(float pitch, dur tillRelease, dur release, dur tillNextNote, UGen ug)
{
    SawOsc voice => ADSR env => ug;
    pitch => voice.freq; 0.25 => voice.gain;
    env.set(0.01::second, 0.01::second, 1, release);
    
    
    now + tillNextNote => time nextNote;
    
    1 => env.keyOn;
    
    if (tillRelease <= env.attackTime() + env.decayTime()) {env.attackTime()+env.decayTime() => now;}
    else {tillRelease => now;}
    
    1 => env.keyOff;
    
    nextNote => now;
    
}
fun void oneNoteInf(int tonic, int scale[], dur tillRelease, dur release, dur tillNextNote, UGen ug)
{
    SawOsc voice => ADSR env => ug;
    gamut[tonic] => voice.freq; 0.25 => voice.gain;
    env.set(0.01::second, 0.01::second, 1, release);
    
    while(true)
    {        
        now + tillNextNote => time nextNote;
        
        1 => env.keyOn;
        
        if (tillRelease <= env.attackTime() + env.decayTime()) {env.attackTime()+env.decayTime() => now;}
        else {tillRelease => now;}
        
        1 => env.keyOff;
        
        nextNote => now;
        
        gamut[tonic + scale[Math.random2(0,scale.size()-1)]] => voice.freq;
    }
}


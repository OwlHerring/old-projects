// Past the Eastern Mountains
// by Mark Fretheim



// // // Events. 
// Experimental. From what I know about them, they seem like the perfect solution to my problem (how do I get all these discrete shreds to stop for a bit?).
Event e;
Event e2a;
Event e2b;
Event e2c;

Event theeventthatwouldnevercome;

//
//
// // Timbre.
2 => float powersof; // (used in some timbres.)
// Each timbre within a giant float[][][] array. Format: [which timbre] [which harmonic] [0: this times the fundamental equal the harmonic's frequency; 1: this divided by the sum of all 1s gives you the percent of gain allocated to this harmonic]
[
// 0: At 100hz, sounds like an SNES guitar? reminds me of Chrono Trigger.
[ [1.0,4.0], [2.0,2.0], [3.0,1.0], [4.0,0.5] ],

// 1: Organ ish? If you listen closely, the fifth is very audible.
[ [1.0,10.0], [4.0,2.0], [6.0,2.0], [8.0,2.0] ],

// 2: Even more so.
[ [1.0,10.0], [4.0,4.0], [6.0,8.0], [8.0,2.0] ],

// 3: Clarinetish.
[ [1.0,4.0], [3.0,2.0], [5.0,1.0], [7.0,0.5] ],

// 4: Organ-ish, with a toyish flair. 50hz is too low. At 500hz it sounds toyboxish.
[ [1.0,16.0], [4.0,2.0], [20.0,1.0], [30.0,0.5] ],

// 5: Organ ish. Very strong fundamental. Somehow the fifth is very clear.
[ [1.0,8.0], [8.0,3.0], [6.0,1.0], [16.0,1.0] ],

// 6: Much less organish. Has a bit of a vibraphone feeling? Slight wobble. (So long as all overtones have the same envelope, they'll probably be pretty organish.)
[ [1.0,8.0], [0.5,1.0], [2.5,1.0], [4.0,0.5], [5.01,0.5], [5.00,0.5] ],

// 7: Not organish. Approaching metallic. Minor sixth comes through pretty clear. Ghostly!
[ [1.0,8.0], [1.6,1.0], [4.0,0.5], [4.1,0.1], [5.01,0.5], [5.00,0.1] ],

// 8: Stronger fundamental pitch. Cold? I dunno what that means.
[ [1.0,8.0], [1.6,1.0], [4.0,4.5], [4.1,Math.random2f(0.1,0.5)], [5.01,0.5], [5.00,0.1] ],

// 9: Metal. Bell-ish. Whistle-ish. High-pitched.
[ [1.0,8.0], [1.3,1.0], [3.9,1.0], [5.2,1.0], [8.1,8.0], [8.00,0.5] ],

// 10: Metal. Lower. Ghostly. 
[ [1.0,8.25], [2.5,1.0], [2.56,1.0], [3.333,0.5], [5.00,0.25] ],

// 11: Metalish. Whistle-ish. The flat fourth is pretty audible. Vibrato.
[ [1.0,32.0], [1.3,1.0], [2.005,8.0], [3.9,1.0], [5.2,1.0], [8.00,0.5] ] ,

// 12: from the cello sample:
[ [1.0, 30.0],[2.0,22.0],[3.0,18.0],[4.0,6.0],[5.0,14.0],[6.0,18.0],[7.0,6.0],[8.0,10.0],[9.0,1.0],[10.0,2.0],[11.0,0.8],[12.0,0.7],[13.0,0.8],[14.0,0.7],[15.0,0.7],[16.0,0.6],[17.0,0.6],[18.0,0.6],[19.0,0.5],[20.0,0.6],[21.0,0.6],[22.0,0.5],[23.0,0.5],[24.0,0.5],[25.0,0.4],[26.0,0.4],[27.0,0.4],[28.0,0.4],[29.0,0.3],[30.0,0.4],[31.0,0.4],[32.0,0.3],[33.0,0.3],[34.0,0.2],[35.0,0.2],[36.0,0.2],[37.0,0.1],[38.0,0.1],[39.0,0.1],[49.0,0.1]],

// 13: not sure how to describe, but it's neat. Derived from above.
[ [1.0,64.0], [2.0,32.0], [3.0,16.0], [4.0,8.0], [5.0,4.0], [8.0,2.8],[9.0,2.7],[10.0,2.8],[11.0,2.7],[16.0,1.7],[17.0,1.6],[18.0,1.6],[19.0,1.6],[24.0,1.5],[25.0,1.6],[26.0,1.6],[27.0,1.5],[32.0,0.5],[33.0,0.5],[34.0,0.4],[35.0,0.4],[40.0,0.4],[41.0,0.4],[42.0,0.3],[43.0,0.4],[48.0,0.4],[49.0,0.3],[50.0,0.3],[51.0,0.2],[56.0,0.2],[57.0,0.2],[58.0,0.1],[59.0,0.1],[64.0,0.1],[65.0,0.1]],

// 14: gain is powers of 2 in reverse order. It would have been easier to let the computer handle this one, probably. 
[ [1.0,Math.pow(powersof,32)],[2.0,Math.pow(powersof,31)],[3.0,Math.pow(powersof,30)],[4.0,Math.pow(powersof,29)],[5.0,Math.pow(powersof,28)],[6.0,Math.pow(powersof,27)],[7.0,Math.pow(powersof,26)],[8.0,Math.pow(powersof,25)],[9.0,Math.pow(powersof,24)],[10.0,Math.pow(powersof,23)],[11.0,Math.pow(powersof,22)],[12.0,Math.pow(powersof,21)],[13.0,Math.pow(powersof,20)],[14.0,Math.pow(powersof,19)],[15.0,Math.pow(powersof,18)],[16.0,Math.pow(powersof,17)],[17.0,Math.pow(powersof,16)],[18.0,Math.pow(powersof,15)],[19.0,Math.pow(powersof,14)],[20.0,Math.pow(powersof,13)],[21.0,Math.pow(powersof,12)],[22.0,Math.pow(powersof,11)],[23.0,Math.pow(powersof,10)],[24.0,Math.pow(powersof,9)],[25.0,Math.pow(powersof,8)],[26.0,Math.pow(powersof,7)],[27.0,Math.pow(powersof,6)],[28.0,Math.pow(powersof,5)],[29.0,Math.pow(powersof,4)],[30.0,Math.pow(powersof,3)],[31.0,Math.pow(powersof,2)],[32.0,Math.pow(powersof,1)],[33.0,Math.pow(powersof,0)]],

// 15: same as above, but only odd harmonics.
[ [1.0,Math.pow(powersof,32)],[3.0,Math.pow(powersof,31)],[5.0,Math.pow(powersof,30)],[7.0,Math.pow(powersof,29)],[9.0,Math.pow(powersof,28)],[11.0,Math.pow(powersof,27)],[13.0,Math.pow(powersof,26)],[15.0,Math.pow(powersof,25)],[17.0,Math.pow(powersof,24)],[19.0,Math.pow(powersof,23)],[21.0,Math.pow(powersof,22)],[23.0,Math.pow(powersof,21)],[25.0,Math.pow(powersof,20)],[27.0,Math.pow(powersof,19)],[29.0,Math.pow(powersof,18)],[31.0,Math.pow(powersof,17)],[33.0,Math.pow(powersof,16)],[35.0,Math.pow(powersof,15)],[37.0,Math.pow(powersof,14)],[39.0,Math.pow(powersof,13)],[41.0,Math.pow(powersof,12)],[43.0,Math.pow(powersof,11)],[45.0,Math.pow(powersof,10)],[47.0,Math.pow(powersof,9)],[49.0,Math.pow(powersof,8)],[51.0,Math.pow(powersof,7)],[53.0,Math.pow(powersof,6)],[55.0,Math.pow(powersof,5)],[57.0,Math.pow(powersof,4)],[59.0,Math.pow(powersof,3)],[61.0,Math.pow(powersof,2)],[63.0,Math.pow(powersof,1)],[65.0,Math.pow(powersof,0)]],

// 16: same as above, but only prime number harmonics (and 1 for some reason).
[ [1.0,Math.pow(powersof,32)],[2.0,Math.pow(powersof,31)],[3.0,Math.pow(powersof,30)],[5.0,Math.pow(powersof,29)],[7.0,Math.pow(powersof,28)],[11.0,Math.pow(powersof,27)],[13.0,Math.pow(powersof,26)],[17.0,Math.pow(powersof,25)],[19.0,Math.pow(powersof,24)],[23.0,Math.pow(powersof,23)],[29.0,Math.pow(powersof,22)],[31.0,Math.pow(powersof,21)],[37.0,Math.pow(powersof,20)],[41.0,Math.pow(powersof,19)],[43.0,Math.pow(powersof,18)],[47.0,Math.pow(powersof,17)],[53.0,Math.pow(powersof,16)],[59.0,Math.pow(powersof,15)],[61.0,Math.pow(powersof,14)],[67.0,Math.pow(powersof,13)],[71.0,Math.pow(powersof,12)],[73.0,Math.pow(powersof,11)],[79.0,Math.pow(powersof,10)],[83.0,Math.pow(powersof,9)],[89.0,Math.pow(powersof,8)],[97.0,Math.pow(powersof,7)],[101.0,Math.pow(powersof,6)],[103.0,Math.pow(powersof,5)],[107.0,Math.pow(powersof,4)],[109.0,Math.pow(powersof,3)],[113.0,Math.pow(powersof,2)],[127.0,Math.pow(powersof,1)],[131.0,Math.pow(powersof,0)]],

// 17: I honestly didn't notice a difference between the above and this next one (omitting harmonics above 67). Actually, you might omit harmonics up to 43, but that might change its sound in the low register.
[ [1.0,Math.pow(powersof,32)],[2.0,Math.pow(powersof,31)],[3.0,Math.pow(powersof,30)],[5.0,Math.pow(powersof,29)],[7.0,Math.pow(powersof,28)],[11.0,Math.pow(powersof,27)],[13.0,Math.pow(powersof,26)],[17.0,Math.pow(powersof,25)],[19.0,Math.pow(powersof,24)],[23.0,Math.pow(powersof,23)],[29.0,Math.pow(powersof,22)],[31.0,Math.pow(powersof,21)],[37.0,Math.pow(powersof,20)],[41.0,Math.pow(powersof,19)],[43.0,Math.pow(powersof,18)],[47.0,Math.pow(powersof,17)],[53.0,Math.pow(powersof,16)],[59.0,Math.pow(powersof,15)],[61.0,Math.pow(powersof,14)],[67.0,Math.pow(powersof,13)]],

// 18: derived from the prime number one. Use this with very low baseFreq, like 6 to 24.
[ [23.0,Math.pow(powersof,23)],[29.0,Math.pow(powersof,22)],[31.0,Math.pow(powersof,21)],[37.0,Math.pow(powersof,20)],[41.0,Math.pow(powersof,19)],[43.0,Math.pow(powersof,18)],[47.0,Math.pow(powersof,17)],[53.0,Math.pow(powersof,16)],[59.0,Math.pow(powersof,15)],[61.0,Math.pow(powersof,14)],[67.0,Math.pow(powersof,13)],[71.0,Math.pow(powersof,12)],[73.0,Math.pow(powersof,11)],[79.0,Math.pow(powersof,10)],[83.0,Math.pow(powersof,9)],[89.0,Math.pow(powersof,8)],[97.0,Math.pow(powersof,7)],[101.0,Math.pow(powersof,6)],[103.0,Math.pow(powersof,5)],[107.0,Math.pow(powersof,4)],[109.0,Math.pow(powersof,3)],[113.0,Math.pow(powersof,2)],[127.0,Math.pow(powersof,1)],[131.0,Math.pow(powersof,0)]],

// 19: tried the same thing with the cello sample. Makes me uncomfortable. A bit like a cat's purring at 25 baseFreq. At 100 baseFreq it sounds like it's through a telephone.
[ [4.0,6.0],[5.0,14.0],[6.0,18.0],[7.0,6.0],[8.0,10.0],[9.0,1.0],[10.0,2.0],[11.0,0.8],[12.0,0.7],[13.0,0.8],[14.0,0.7],[15.0,0.7],[16.0,0.6],[17.0,0.6],[18.0,0.6],[19.0,0.5],[20.0,0.6],[21.0,0.6],[22.0,0.5],[23.0,0.5],[24.0,0.5],[25.0,0.4],[26.0,0.4],[27.0,0.4],[28.0,0.4],[29.0,0.3],[30.0,0.4],[31.0,0.4],[32.0,0.3],[33.0,0.3],[34.0,0.2],[35.0,0.2],[36.0,0.2],[37.0,0.1],[38.0,0.1],[39.0,0.1],[49.0,0.1]],

// 20: derived from the cello one above. Sounds slightly less silly.
[ [1.0, 30.0],[2.0,22.0],[3.0,18.0],[4.0,6.0],[5.0,14.0],[6.0,18.0],[7.0,6.0],[8.0,10.0],[9.0,1.0],[10.0,2.0],[11.0,0.8],[12.0,0.7],[13.0,0.8],[14.0,0.7],[15.0,0.7],[16.0,0.5],[17.0,0.4],[18.0,0.3],[19.0,0.2],[20.0,0.2],[21.0,0.1]],

// 21: The Ky in Kyrie attempt 1: 
[ [1.0,10.0], [2.0,10.0], [3.0,7.0], [4.0,4.0], [5.0,4.0], [6.0,4.0], [7.0,5.0], [8.0,6.0], [9.0,8.0], [10.0,5.0], [11.0,9.0], [12.0,10.0], [13.0,10.0], [14.0,10.0], [15.0,10.0], [16.0,5.0], [17.0,3.0], [18.0,3.0], [19.0,3.0], [20.0,3.0], [21.0,3.0], [22.0,3.0],[23.0,4.0], [24.0,5.0], [25.0,2.0], [26.0,2.0], [27.0,2.0], [28.0,2.0], [29.0,4.0], [30.0,3.0], [31.0,3.0], [32.0,4.0], [33.0,2.0], [34.0,2.0], [35.0,2.0], [36.0,2.0], [37.0,2.0]] ,

// 22: The Ky in Kyrie attempt 2: 
[ [1.0,30.0], [2.0,30.0], [3.0,21.0], [4.0,4.0], [5.0,4.0], [6.0,4.0], [7.0,5.0], [8.0,18.0], [9.0,24.0], [10.0,5.0], [11.0,24.0], [12.0,30.0], [13.0,30.0], [14.0,30.0], [15.0,30.0], [16.0,5.0], [17.0,3.0], [18.0,3.0], [19.0,3.0], [20.0,3.0], [21.0,3.0], [22.0,3.0],[23.0,4.0], [24.0,5.0], [25.0,2.0], [26.0,2.0], [27.0,2.0], [28.0,2.0], [29.0,4.0], [30.0,3.0], [31.0,3.0], [32.0,4.0], [33.0,2.0], [34.0,2.0], [35.0,2.0], [36.0,2.0], [37.0,2.0]] ,

// 23: The on in eleison attempt 1 (after ky attempt 2):
[ [1.0,21.0], [2.0,21.0], [3.0,24.0], [4.0,15.0], [5.0,15.0], [6.0,5.0], [7.0,2.0], [8.0,2.0], [9.0,0.0], [10.0,1.0], [11.0,1.0], [12.0,0.0], [13.0,0.0], [14.0,3.0], [15.0,4.0], [16.0,4.0], [17.0,3.0], [18.0,4.0], [19.0,4.0], [20.0,1.0], [21.0,1.0]],

// 24: custom:
[ [1.0,64.0], [2.0,16.0], [3.0,1.0], [4.0,0.5], [8.0, 8.0], [16.0, 1.0], [32.0, 1.0], [64.0, 1.0], [128.0, 1.0] ],

// 25: custom:
[ [1.0,128.0], [3.0,4.0], [9.0,4.0], [27.0,4.0], [81.0, 2.0], [243.0, 1.0], [729.0, 1.0] ],

// 26: custom:
[ [1.0,128.0], [5.0,32.0], [25.0,8.0], [125.0,2.0] ],

// 27: custom:
[ [0.99,16.25], [2.1,1.0], [3.01,1.0], [4.2,2.5], [7.00,0.25], [11.0, 1.0], [12.0, 0.5], [13.0, 1.0] ]

]
@=> float harmonic[][][];


//
//
// // Tuning. 
// (I am using 19TET.)
TETsetup(19) @=> float TET[]; // TET[0]: 19; TET[1]: 1/19; TET[2]: 19th root of 2.
16 * semitones(0, TET) => float tonic; // C0. Major 6th lower than the lowest note on a piano. Sine waves inaudible.

float gamut[Std.ftoi(TET[0]*9)];
0 => gamut[0]; // This is our rest. (What other use will I have for c1?)
for (1 => int gamutCount; gamutCount < gamut.size(); gamutCount++) // This for loop will occur once for every octave from 0 to 11.
{
    semitonesOver(gamutCount, TET, tonic) => gamut[gamutCount];
}
// Cs: C0 C1 C2 C3 C4 C5 C6  C7  C8
// - - 0. 19 38 57 76 95 114 133 152


// // // beatDurtoMeter(x, n) @=> time bars[];
// With this function, we create n bars of music, each x duration long. 
// More technically, we create an array of timestamps with size n+1.
// bars[0] is the start of the first bar.
// bars[1] is the end of the first bar and the start of the second.
// ...
// bars[n-1] is the end of the second-last bar and the start of the last.
// bars[n] is the end of the last bar (the closing double-barline).
beatDurtoMeter(1.6::second, 144) @=> time bars[]; 
nextBeatTime(bars) - now => dur t1; // This finds the timestamp within the time[] array specified that comes immediately after now. We subtract that from now to get us the length of a single bar, which we'll call a whole note.


// Should I have individual parts responsible for their individual beats?
// I wonder.


// We use currentBeat(bars) instead of 0, so that individual sporks can create their own beats[][] with the same bars[] framework.

time beats[currentBeat(bars)][0]; // This array-of-arrays will hold the beats within each bar, organized in the same way as bars are. beats[which bar][which beat (or the end of the bar/first beat of the next bar)].

time simpleBeats[1]; // This array will hold every beat in beats[][]. simpleBeats[] should serve my purposes on most occasions. I'll only need beats[][] when I need to refer to certain beats in relation to the bar (e.g. the downbeat)
now => simpleBeats[0]; // We define the first timestamp in simpleBeats as now. 

for(currentBeat(bars) => int barCount; barCount < bars.size()-1; barCount++) // Because we handle two adjacent bars[#] in the for loop, bars[barCount] and bars[barCount+1], we have to stop the loop before barCount == bars.size()-1. Otherwise, when barCount reaches bars.size()-1, it will ask for bars[bars.size()-1] and bars[bars.size()], the latter of which will yield an error.
{
    timeIntervaltoMeter(bars[barCount], bars[barCount+1], 4) @=> time tempMeter[]; // timeIntervaltoMeter(start, end, barNum) takes a start and end time, divides it into barNum, and returns an array of size [barNum+1]. We assign this array to time tempMeter[].
    
    beats << tempMeter; //  We add each tempMeter to the time[][] array-of-arrays 'beats'.=
     
    for(1 => int tempCount; tempCount < tempMeter.size(); tempCount++) 
    {
        simpleBeats << tempMeter[tempCount]; // Additionally, we add each member of tempMeter to the time[] array 'simpleBeats', except for tempMeter[0]. If we included tempMeter[0], then because one loop's tempMeter[tempMeter.size()-1] equals the next loop's tempMeter[0], we'd end up with more timestamps than necessary.
        // So apparently, the above is possible in ChucK on the Macs in CAD, but not on my Windows 7 desktop. Earlier version?
    }
    
    tempMeter.clear(); // After that, I reset tempMeter to size 0. I don't know whether failing to do so would cause issues with each loop, but it might.
}
nextBeatTime(simpleBeats) - now => dur tBeat; // This creates a beat from simpleBeats. 

// myBar[n] is tuned to gamut[n+38]. I'm doing this because I fear for the CPU.
ModalBar myBar[gamut.size()-38]; // A modal bar for every note of the gamut C2 and up. Like a handbell choir.
for(0 => int modalCount; modalCount < myBar.size(); modalCount++)
{
    gamut[modalCount+38] => myBar[modalCount].freq;
    1 => myBar[modalCount].preset;
}

0.05 => float pianissimo;
0.2 => float piano;
0.4 => float mezzo;
0.6 => float forte;

[ 1.0, 1.1, 1.2, 1.0, 1.1, 1.21, 1.32, 1.1, 1.21] @=> float myPhrasing[];

// Fadeout.
Envelope fadeout => dac;
Envelope fadeout2 => dac;
fadeout.value(1);
0.33 => float fadeout2Volume;
fadeout2.value(fadeout2Volume);

// Global cues.

//              modalbar        stillmb           wind instr.         
//     0        1        2         3         4         5         6         7 (pointless) 8 (pointless)
[ bars[0], bars[2], bars[18], bars[20], bars[40], bars[42], bars[78], bars[80], bars[96] ] @=> time cues[];

now + 2::week => time fadeoutTime; // (an arbitrary point in time in the future.)
false => int allTheWayUpHere; // reacts to something within the interlude.

while(fadeout.value() > 0.00001)
{
    if(now == cues[0]) spork ~ barChoir1(0.7, -0.9);
    
    if(now == cues[1]) 
    {
        spork ~ barChoir2(0.7, -0.5);
        spork ~ strings(0.25);
    }
    
    if(now == cues[3]) // or whereever, as long as it's not at the same time as the above two.
        spork ~ otherInstrument(0.185, 0.9);
    
    if(now == cues[6])
    {
        spork ~ interludeMaster();
        
        // Turns out this isn't necessary.
        //now => time timer;
        
        e => now;
        
        // This following line would be ideal if I wanted the end of e to be followed by cues[6], then cues[7]. But actually I want it to go back to the beginning.
        //now - timer => dur eDur; addXTimetoEachPartOfArraysBeatsBarsSimpleBeatsandCues(eDur);
        now - cues[0] => dur sinceTheStart;
        addXTimetoEachPartOfArraysBeatsBarsSimpleBeatsandCues(sinceTheStart);
        
        now + 4::t1 => fadeoutTime;
        
        continue;
    }
    
    if(now == fadeoutTime) // if two weeks have passed then it'd better fade out.
    {
        fadeout.duration(5.4::t1);
        fadeout.keyOff(1);
    }
    
    samp => now;
}


// // // // Sporkables.

//[ 74, 82, 85 ] @=> int whichBars1[];
//[ .7, .4, .3 ] @=> float velo[];
//[ [0, 0, 

// // Modal bars ensembles. (Handbells-ish.)

//fun void barChoir(ModalBar bar[], int whichBars[])
fun void barChoir1(float gain, float myPan)
{
    
    Gain g => JCRev r => Pan2 pan => Envelope myFadeout => fadeout;
    
    myFadeout.value(1);
    r.mix(0.01);
    g.gain(gain); 
    
    pan.pan(myPan);
    
    [ myBar[74], myBar[82], myBar[85], myBar[88] ] @=> ModalBar localBar[];
    
    for(0 => int localCount; localCount < localBar.size(); localCount++)
    {
        localBar[localCount].preset(1);
        localBar[localCount] => g;
        localBar[localCount].stickHardness(0);
    }
    
    [[.7, .45],[.5, .45],[.6, .45],[.4, .45]] @=> float myBarInfo[][];
    [ 0,       1,       2,        1 ] @=> int myMel[];
    
    myBarInfo @=> float resetBarInfo[][];
    
    
    while(true)
    {
        
        for(currentBeat(cues) => int cueCount; cueCount < cues.size(); currentBeat(cues) => cueCount)
        {    
            for(0 => int count; count < myBarInfo.size(); count++)
            {
                //if(currentBeat(cues) == 4) 3 => myMel[3];
                
                myBarInfo[count][0] => localBar[myMel[count]].strike; myBarInfo[count][1] => localBar[myMel[count]].strikePosition;
                2::tBeat => now;
            }
            //if(myMel[3] == 3) 1 => myMel[3];
            
            // // // // cues[1].
            
            (currentBeat(cues) % 6) => cueCount;
            currentBeat(cues) => int cueCount2;
            
            while(now<cues[cueCount2 + 1])
            {
                for(0 => int count; count < myBarInfo.size(); count++)
                {
                    myBarInfo[count][0] => localBar[myMel[count]].strike; myBarInfo[count][1] => localBar[myMel[count]].strikePosition;
                    nextBeatTime(simpleBeats) => now;
                }
            }
            
            if(currentBeat(cues) >= 6)
            {
                myFadeout.duration(4::t1);
                myFadeout.keyOff;
                theeventthatwouldnevercome => now;
                
                me.exit();
            }
        }
    }
}
    

fun void barChoir2(float gain, float myPan)
{
    
    Gain g => JCRev r => Pan2 pan => Envelope myFadeout => fadeout;
    
    myFadeout.value(1);
    r.mix(0.1);
    g.gain(gain); 
    pan.pan(myPan);
    
    ModalBar separateBar;
    gamut[112] => separateBar.freq;
    
    [ myBar[55], myBar[63], myBar[66], myBar[69], separateBar ] @=> ModalBar localBar[];
    
    for(0 => int localCount; localCount < localBar.size(); localCount++)
    {
        localBar[localCount].preset(1);
        localBar[localCount].stickHardness(0.25);
        
        localBar[localCount] => g;
    }
    
    [[.8, .45],[.5, .45],[.7, .45],[.5, .45]] @=> float myBarInfo[][];
    
    [
     [ 
      [0, 4],[1, 4],[2, 4],[1, 6], //               bars[2] to 2 beats after bars[6]  (bars 3 to 6)
      [0, 4],[1, 2],[2, 4],[3, 4], // 2 beats after bars[6] to               bars[10] (bars 7 to 10)
      [4, 6],[3, 2],[2, 4],[3, 6], //               bars[10]to 2 beats after bars[14] (bars 11 to 14)
      [4, 4],[3, 2],[2, 4],[1, 4]  // 2 beats after bars[14]to               bars[18] (bars 15 to 18)
     ],
     [
      [0, 6],[1, 2],[2, 4],[3, 4], // bars[20] to bars[24]
      [4, 6],[3, 2],[2, 4],[1, 4], // bars[24] to bars[28]
      [0, 6],[1, 2],[2, 4],[3, 6], // bars[28] to bars[32]
      [4, 4],[3, 2],[2, 4],[1, 4], // bars[32] to bars[36]
      [0, 6],[1, 2],[2, 4],[3, 4]  // bars[36] to bars[40]
     ],
     [ 
      [4, 6],[3, 2],[2, 4],[3, 4], // bars[42] to bars[46]
      [4, 6],[3, 2],[2, 4],[1, 6], // bars[46] to bars[50]
      [4, 4],[3, 2],[2, 4],[3, 8], // bars[50] to bars[54]
      [2, 6],[1, 6],               // bars[54] to bars[58]
      [0, 6],[1, 2],[2, 4],[3, 4], // bars[58] to bars[62]
      [4, 6],[3, 2],[2, 4],[1, 4], // bars[62] to bars[66]
      [0, 6],[1, 2],[2, 4],[3, 6], // bars[66] to bars[70]
      [4, 4],[3, 2],[2, 4],[1, 4], // bars[70] to bars[74]
      [0, 6],[1, 2],[2, 4],[3, 4]  // bars[74] to bars[78]
     ]
    ]
    @=> int myMel[][][];
    
    while(true)
    {
        // on cues 1, 3, 5, 7 etc I want it to play
        // myMel   0, 1, 2, 3 etc
        // So, on cue n I want it to play myMel Std.ftoi(.5(n-1)). 
        for(currentBeat(cues) => int cueCount; cueCount < cues.size(); currentBeat(cues) => cueCount)
        {
            
            for(0 => int count; count < myMel[Std.ftoi(.5*(cueCount-1))].size(); count++)
            {
                myBarInfo[count%myBarInfo.size()][0] => localBar[myMel[Std.ftoi(.5*(cueCount-1))][count][0]].strike;
                myBarInfo[count%myBarInfo.size()][1] => localBar[myMel[Std.ftoi(.5*(cueCount-1))][count][0]].strikePosition;
                myMel[Std.ftoi(.5*(cueCount-1))][count][1]::tBeat => now;
            }
            
            nextBeatTime(cues) => now;
            
            if(currentBeat(cues) >= 6)
            {
                myFadeout.duration(4::t1);
                myFadeout.keyOff;
                theeventthatwouldnevercome => now;
                
                me.exit();
            }
            
        }
        
        if(fadeout.value() < 0.0001) me.exit();
        
    }
}

// // Strings.

fun void strings(float gain)
{
    [
     [
     gamut[63],gamut[63], // E E
     gamut[63],gamut[66], // E F#
     gamut[69],gamut[74], // G#B
     gamut[66],gamut[63]  // F#E
     ],
     [
     gamut[77],gamut[82], // C#E
     gamut[82],gamut[77], // E C#
     gamut[82],gamut[85], // E F#
     gamut[82],gamut[85], // E F#
     gamut[88],gamut[93]  // G#B
     ], 
     [
     gamut[63],gamut[69], // E G#
     gamut[63],gamut[74], // E B
     gamut[69],gamut[74], // G#B
     gamut[74],gamut[74], // B B
     gamut[77],gamut[82], // C#E
     gamut[82],gamut[77], // E C#
     gamut[82],gamut[85], // E F#
     gamut[82],gamut[85], // E F#
     gamut[88],gamut[93]  // G#B
     ]
    ]
    @=> float violins[][];

    [
     [
     gamut[63],gamut[58], // E C#
     gamut[63],gamut[66], // E F#
     gamut[69],gamut[74], // G#B
     gamut[66],gamut[63]  // F#E
     ],
     [
     gamut[71],gamut[69], // A G#
     gamut[69],gamut[74], // G#B
     gamut[77],gamut[80], // C#D#
     gamut[82],gamut[82], // E E
     gamut[82],gamut[77]  // E C#
     ],
     [
     gamut[63],gamut[58], // E C#
     gamut[63],gamut[66], // E F#
     gamut[69],gamut[74], // G#B
     gamut[66],gamut[63],  // F#E
     gamut[71],gamut[69], // A G#
     gamut[69],gamut[74], // G#B
     gamut[77],gamut[80], // C#D#
     gamut[82],gamut[82], // E E
     gamut[88],gamut[93]  // G#B
     ]
    ]
    @=> float violas[][]; 
    [
     [
     gamut[55],gamut[58], // B C#
     gamut[55],gamut[58], // B C#
     gamut[61],gamut[58], // D#C#
     gamut[61],gamut[58]  // D#C#
     ], 
     [
     gamut[63],gamut[63], // E E
     gamut[63],gamut[63], // E E
     gamut[66],gamut[69], // F#G#
     gamut[69],gamut[74], // G#B
     gamut[71],gamut[71]  // A A
     ],
     [
     gamut[63],gamut[66],
     gamut[69],gamut[66],
     gamut[69],gamut[66],
     gamut[61],gamut[58],
     gamut[63],gamut[63], // E E
     gamut[63],gamut[63], // E E
     gamut[66],gamut[69], // F#G#
     gamut[69],gamut[74], // G#B
     gamut[71],gamut[71]  // A A
     ]
    ]
    @=> float celloTop[][]; 
    [
     [
     gamut[55],gamut[58], // B C#
     gamut[55],gamut[58], // B C#
     gamut[61],gamut[58], // D#C#
     gamut[55],gamut[52]  // B A
     ], 
     [
     gamut[63],gamut[63], // E E
     gamut[63],gamut[63], // E E
     gamut[66],gamut[69], // F#G#
     gamut[69],gamut[74], // G#B
     gamut[71],gamut[71]  // A A
     ],
     [
     gamut[55],gamut[58],
     gamut[55],gamut[58],
     gamut[61],gamut[58],
     gamut[55],gamut[52],
     gamut[63],gamut[63], // E E
     gamut[63],gamut[63], // E E
     gamut[66],gamut[69], // F#G#
     gamut[69],gamut[74], // G#B
     gamut[71],gamut[71]  // A A
     ]
    ]
    @=> float celloMid[][]; 
    [
     [
     gamut[44],gamut[44],
     gamut[44],gamut[44],
     gamut[44],gamut[44],
     gamut[44],gamut[52]
     ], 
     [
     gamut[52],gamut[58], // A C#
     gamut[50],gamut[52], // G#A
     gamut[52],gamut[55], // A B
     gamut[58],gamut[58], // C#C#
     gamut[58],gamut[61]  // C#D#
     ],
     [
     gamut[44],gamut[44],
     gamut[44],gamut[44],
     gamut[44],gamut[44],
     gamut[44],gamut[52],
     gamut[52],gamut[58], // A C#
     gamut[50],gamut[52], // G#A
     gamut[52],gamut[55], // A B
     gamut[58],gamut[58], // C#C#
     gamut[58],gamut[61]  // C#D#
     ]
    ]
    @=> float celloLow[][]; 
    [
     [
     gamut[44],gamut[44],
     gamut[44],gamut[44],
     gamut[44],gamut[44],
     gamut[25],gamut[33]
     ], 
     [
     gamut[52],gamut[58], // A C#
     gamut[50],gamut[52], // G#A
     gamut[33],gamut[36], // A B
     gamut[39],gamut[39], // C#C#
     gamut[39],gamut[42]  // C#D#
     ], 
     [
     gamut[44],gamut[44],
     gamut[44],gamut[44],
     gamut[44],gamut[44],
     gamut[25],gamut[33],
     gamut[52],gamut[58], // A C#
     gamut[50],gamut[52], // G#A
     gamut[33],gamut[36], // A B
     gamut[39],gamut[39], // C#C#
     gamut[39],gamut[42]  // C#D#
     ]
    ]
    @=> float bassLow[][]; 
    [
     [
     gamut[44],gamut[44],
     gamut[44],gamut[44],
     gamut[44],gamut[44],
     gamut[25],gamut[33]
     ], 
     [
     gamut[52],gamut[58], // A C#
     gamut[50],gamut[52], // G#A
     gamut[33],gamut[36], // A B
     gamut[39],gamut[39], // C#C#
     gamut[39],gamut[42]  // C#D#
     ], 
     [
     gamut[44],gamut[44],
     gamut[44],gamut[44],
     gamut[44],gamut[44],
     gamut[25],gamut[33],
     gamut[52],gamut[58], // A C#
     gamut[50],gamut[52], // G#A
     gamut[33],gamut[36], // A B
     gamut[39],gamut[39], // C#C#
     gamut[39],gamut[42]  // C#D#
     ]
    ]
    @=> float bassPart[][];
    
    
    JCRev r => Envelope myFadeout => fadeout;
    
    myFadeout.value(1);
    r.mix(0.15);
    
    
    Bowed violin[6];
    Bowed viola[6];
    Bowed cello[6];
    Bowed bass[6];
    Pan2 pan[4]; // number of the above sections.
    Gain g[4];
    
    0 => int partCount;
    
    for(0 => int violCount; violCount < violin.size(); violCount++)
    {
        violin[violCount] => g[0] => pan[0] => r;
        pan[0].pan(-0.8);
        g[0].gain(division(gain,4*violin.size()));
    }
    for(0 => int violCount; violCount < viola.size(); violCount++)
    {
        viola[violCount] => g[1] => pan[1] => r;
        pan[1].pan(-0.4);
        g[1].gain(division(gain,4*viola.size()));
    }
    for(0 => int celloCount; celloCount < cello.size(); celloCount++)
    {
        cello[celloCount] => g[2] => pan[2] => r;
        pan[2].pan(0.4);
        g[2].gain(division(gain,4*cello.size()));
    }
    
    for(0 => int bassCount; bassCount < bass.size(); bassCount++)
    {
        bass[bassCount] => g[3] => pan[3] => r;
        pan[3].pan(0.8);
        g[3].gain(division(gain,4*bass.size()));
    }
    
    while(true)
    {
        for(0 => int violCount; violCount < violin.size(); violCount++)
        {
            0.85 + Math.random2f(-0.05, 0.05) => violin[violCount].bowPressure;
            0.1 + Math.random2f(-0.05, 0.05) => violin[violCount].bowPosition;
            7.6 + Math.random2f(-0.6, 0.6) => violin[violCount].vibratoFreq;
            0.004 + Math.random2f(-0.002, 0.002) => violin[violCount].vibratoGain;
            0 => violin[violCount].volume;
        }
        for(0 => int violCount; violCount < viola.size(); violCount++)
        {
            0.85 + Math.random2f(-0.05, 0.05) => viola[violCount].bowPressure;
            0.2 + Math.random2f(-0.05, 0.05) => viola[violCount].bowPosition;
            7.5 + Math.random2f(-0.6, 0.6) => viola[violCount].vibratoFreq;
            0.003 + Math.random2f(-0.002, 0.002) => viola[violCount].vibratoGain;
            0 => viola[violCount].volume;
        }
        for(0 => int celloCount; celloCount < cello.size(); celloCount++)
        {
            0.85 + Math.random2f(-0.05, 0.05) => cello[celloCount].bowPressure;
            0.2 + Math.random2f(-0.05, 0.05) => cello[celloCount].bowPosition;
            7.4 + Math.random2f(-0.6, 0.6) => cello[celloCount].vibratoFreq;
            0.002 + Math.random2f(-0.002, 0.002) => cello[celloCount].vibratoGain;
            0 => cello[celloCount].volume;
        }
        
        for(0 => int bassCount; bassCount < bass.size(); bassCount++)
        {
            0.6 + Math.random2f(-0.05, 0.05) => bass[bassCount].bowPressure;
            0.3 + Math.random2f(-0.05, 0.05) => bass[bassCount].bowPosition;
            7.3 + Math.random2f(-0.6, 0.6) => bass[bassCount].vibratoFreq;
            0.001 + Math.random2f(-0.005, 0.005) => bass[bassCount].vibratoGain;
            0 => bass[bassCount].volume;
        }
        
        for(currentBeat(cues) => int cueCount; cueCount < cues.size(); currentBeat(cues) => cueCount)
        {
            false => int violinsPlay;
            if(cueCount == 3 || cueCount == 5)
            {
                true => violinsPlay;
            }
            // Violins only play at certain points.
            if(violinsPlay)
            {
                for(0 => int violCount; violCount < violin.size(); violCount++)
                {
                    violin[violCount].startBowing(0.25);
                    violin[violCount].volume(pianissimo+0.15);
                    
                    g[0].gain(division(gain,4*violin.size()));
                }
            }
            // Everyone else in the strings will play whenever the machine reader thingy arrives here.
            for(0 => int violCount; violCount < viola.size(); violCount++)
            {
                viola[violCount].startBowing(0.25);
                if(violinsPlay)
                {
                    viola[violCount].volume(pianissimo+0.15);
                    g[1].gain(division(gain,4*viola.size()));
                }
                    
                else
                {    
                    viola[violCount].volume(pianissimo);
                    g[1].gain(division(gain,3*viola.size()));
                }
            }
            for(0 => int celloCount; celloCount < cello.size(); celloCount++)
            {
                cello[celloCount].startBowing(0.25);
                if(violinsPlay)
                {
                    cello[celloCount].volume(pianissimo+0.15);
                    g[2].gain(division(gain,4*cello.size()));
                }
                else
                {
                    cello[celloCount].volume(pianissimo+0.05);
                    g[2].gain(division(gain,3*cello.size()));
                }
            } 
            for(0 => int bassCount; bassCount < bass.size(); bassCount++)
            {
                bass[bassCount].startBowing(0.25);
                if(violinsPlay)
                {
                    bass[bassCount].volume(pianissimo+0.20);
                    g[3].gain(division(gain,4*bass.size()));
                }
                else
                {
                    bass[bassCount].volume(pianissimo+0.10);
                    g[3].gain(division(gain,3*bass.size()));
                }
            }
            
            // Splits each chunk into phrases, 4 bars each.
            for(0 => int phraseCount; phraseCount < celloTop[partCount%celloTop.size()].size(); phraseCount++)
            {
                // Frequencies are set for each section, even the violins who don't always play.
                for(0 => int violCount; violCount < violin.size(); violCount++)
                {
                    violin[violCount].freq(violins[partCount%violins.size()][phraseCount] + Math.random2f(-0.05, 0.05));
                }
                
                for(0 => int violCount; violCount < viola.size(); violCount++)
                {
                    viola[violCount].freq(violas[partCount%violas.size()][phraseCount] + Math.random2f(-0.05, 0.05));
                }
                for(0 => int celloCount; celloCount < cello.size(); celloCount++)
                {
                    if(celloCount < .667*cello.size() )
                    {
                        if(celloCount < .333*cello.size() )
                        {
                            cello[celloCount].freq(celloTop[partCount%celloTop.size()][phraseCount] + Math.random2f(-0.05, 0.05));
                        }
                        else
                        {
                            cello[celloCount].freq(celloMid[partCount%celloMid.size()][phraseCount] + Math.random2f(-0.05, 0.05));
                        }
                    }
                    else 
                    {
                        cello[celloCount].freq(celloLow[partCount%celloLow.size()][phraseCount] + Math.random2f(-0.05, 0.05));
                    }
                }
                for(0 => int bassCount; bassCount < bass.size(); bassCount++)
                {
                    if(bassCount< .5*bass.size() )
                    {
                        bass[bassCount].freq(bassPart[partCount%bassPart.size()][phraseCount] + Math.random2f(-0.05, 0.05));
                    }
                    else 
                    {
                        bass[bassCount].freq(bassLow[partCount%bassLow.size()][phraseCount] + Math.random2f(-0.05, 0.05));
                    }
                }
                
                // In order to swell in volume to a certain point two bars from now, we keep track of when two bars from now is, and scale in exact divisions from that point.
                bars[currentBeat(bars)+2] => time tempNext;
                tempNext - now => dur tempDur;
                10 => int incrementDenom;
                piano => float target;
                
                if(cueCount == 1)
                    (mezzo-0.1)*myPhrasing[Std.ftoi(.5*phraseCount)] => target;
                if(cueCount == 3)
                    mezzo*myPhrasing[Std.ftoi(.5*phraseCount)] => target;
                if(cueCount == 5)
                {
                    if(phraseCount < 8)
                        (mezzo-0.1)*myPhrasing[Std.ftoi(.5*phraseCount)] => target;
                    else
                        mezzo*myPhrasing[Std.ftoi(.5*phraseCount)] => target;
                }     
                if(cueCount == 7)
                    (mezzo-0.1)*myPhrasing[Std.ftoi(.5*phraseCount)] => target;
                viola[0].volume() => float startVolume;
                while(now < tempNext)
                {
                    if(cueCount == 3 || cueCount == 5)
                    {
                        for(0 => int violCount; violCount < violin.size(); violCount++)
                        {
                            violin[violCount].volume() + (target-startVolume)*division(1,incrementDenom) => violin[violCount].volume;
                        }
                    }
                    for(0 => int violCount; violCount < viola.size(); violCount++)
                    {
                        viola[violCount].volume() + (target-startVolume)*division(1,incrementDenom) => viola[violCount].volume;
                    }
                    
                    for(0 => int celloCount; celloCount < cello.size(); celloCount++)
                    {
                        cello[celloCount].volume() + (target-startVolume)*division(1,incrementDenom) => cello[celloCount].volume;
                    }
                    
                    for(0 => int bassCount; bassCount < bass.size(); bassCount++)
                    {
                        bass[bassCount].volume() + (target-startVolume)*division(1,incrementDenom) => bass[bassCount].volume;
                    }
                    division(1,incrementDenom)::tempDur => now;
                }
                
                // phraseCount ticks up so that we play the next note in each section's part.
                phraseCount++;
                
                // Each frequency is set again.
                for(0 => int violCount; violCount < violin.size(); violCount++)
                {
                    violin[violCount].freq(violins[partCount%violins.size()][phraseCount] + Math.random2f(-0.05, 0.05));
                }
                
                for(0 => int violCount; violCount < viola.size(); violCount++)
                {
                    if(violCount< viola.size()*.5)
                    {
                        viola[violCount].freq(violas[partCount%violas.size()][phraseCount] + Math.random2f(-0.05, 0.05));
                    }
                    else
                    {
                        viola[violCount].freq(celloTop[partCount%celloTop.size()][phraseCount] + Math.random2f(-0.05, 0.05));
                    }
                }
                
                for(0 => int celloCount; celloCount < cello.size(); celloCount++)
                {
                    if(celloCount < cello.size() * .5) 
                    {
                        if(celloCount < cello.size() * .25)
                        {
                            cello[celloCount].freq(celloTop[partCount%celloTop.size()][phraseCount] + Math.random2f(-0.05, 0.05));
                        }
                        else
                        {
                            cello[celloCount].freq(celloMid[partCount%celloMid.size()][phraseCount] + Math.random2f(-0.05, 0.05));
                        }
                    }
                    else 
                    {
                        cello[celloCount].freq(celloLow[partCount%celloLow.size()][phraseCount] + Math.random2f(-0.05, 0.05));
                    }
                }
                
                for(0 => int bassCount; bassCount < bass.size() ; bassCount++)
                {
                    if(bassCount<bass.size()*.5) 
                    {
                        bass[bassCount].freq(bassPart[partCount%bassPart.size()][phraseCount] + Math.random2f(-0.05, 0.05));
                    }
                    else 
                    {
                        bass[bassCount].freq(bassLow[partCount%bassLow.size()][phraseCount] + Math.random2f(-0.05, 0.05));
                    }
                }
                
                bars[currentBeat(bars)+2]=> tempNext;
                tempNext - now => tempDur;
                viola[0].volume() => startVolume;
                if(cueCount == 5 && phraseCount == 7)
                    piano => target;
                else
                    pianissimo => target;
                while(now < tempNext)
                {
                    for(0 => int violCount; violCount < violin.size(); violCount++)
                    {
                        violin[violCount].volume() - (startVolume-target)*division(1,incrementDenom) => violin[violCount].volume;
                    }
                    for(0 => int violCount; violCount < viola.size(); violCount++)
                    {
                        viola[violCount].volume() - (startVolume-target)*division(1,incrementDenom) => viola[violCount].volume;
                    }
                    
                    for(0 => int celloCount; celloCount < cello.size(); celloCount++)
                    {
                        cello[celloCount].volume() - (startVolume-target)*division(1,incrementDenom) => cello[celloCount].volume;
                    }
                    
                    for(0 => int bassCount; bassCount < bass.size(); bassCount++)
                    {
                        bass[bassCount].volume() - (startVolume-target)*division(1,incrementDenom) => bass[bassCount].volume;
                    }
                    division(1,incrementDenom)::tempDur => now;
                }
                
                // Everyone is told to stop bowing here, including the violins (even if they weren't bowing in the first place). Except for one moment.
                if(false == (cueCount == 5 && phraseCount == 7))
                {
                    for(0 => int violCount; violCount < violin.size(); violCount++)
                    {
                        violin[violCount].stopBowing(0.9);
                        violin[violCount].volume(0);
                    }
                    for(0 => int violCount; violCount < viola.size(); violCount++)
                    {
                        viola[violCount].stopBowing(0.9);
                        viola[violCount].volume(0);
                    }
                    for(0 => int celloCount; celloCount < cello.size(); celloCount++)
                    {
                        cello[celloCount].stopBowing(0.9);
                        cello[celloCount].volume(0);
                    } 
                    for(0 => int bassCount; bassCount < bass.size(); bassCount++)
                    {
                        bass[bassCount].stopBowing(0.9);
                        bass[bassCount].volume(0);
                    }
                }
            }
            
            (currentBeat(cues) % 6) => cueCount;
            
            partCount++; // partCount determines which set of frequencies within a part to draw from. format: celloTop[partCount][phraseCount];
            
            
            if(currentBeat(cues) == 6)
            {
                3::second => now;
                
                e2b => now;
                
                for(0 => int violCount; violCount < violin.size(); violCount++)
                {
                    violin[violCount].startBowing(0.25);
                    violin[violCount].volume(pianissimo);
                    
                    g[0].gain(division(gain,4*violin.size()));
                }
                for(0 => int violCount; violCount < viola.size(); violCount++)
                {
                    viola[violCount].startBowing(0.25);
                    viola[violCount].volume(pianissimo);
                    g[1].gain(division(gain,4*viola.size()));
                }
                for(0 => int celloCount; celloCount < cello.size(); celloCount++)
                {
                    cello[celloCount].startBowing(0.25);
                    cello[celloCount].volume(pianissimo);
                    g[2].gain(division(gain,4*cello.size()));
                } 
                for(0 => int bassCount; bassCount < bass.size(); bassCount++)
                {
                    bass[bassCount].startBowing(0.25);
                    bass[bassCount].volume(pianissimo);
                    g[3].gain(division(gain,4*bass.size()));
                }
                
                1 => int partCount;
                
                // Splits each chunk into phrases, 4 bars each.
                for(0 => int phraseCount; phraseCount < 6; phraseCount++)
                {
                    // Frequencies are set for each section, even the violins who don't always play.
                    for(0 => int violCount; violCount < violin.size(); violCount++)
                    {
                        violin[violCount].freq(violins[partCount%violins.size()][phraseCount] + Math.random2f(-0.05, 0.05));
                    }
                    
                    for(0 => int violCount; violCount < viola.size(); violCount++)
                    {
                        viola[violCount].freq(violas[partCount%violas.size()][phraseCount] + Math.random2f(-0.05, 0.05));
                    }
                    for(0 => int celloCount; celloCount < cello.size(); celloCount++)
                    {
                        if(celloCount < .667*cello.size() )
                        {
                            if(celloCount < .333*cello.size() )
                            {
                                cello[celloCount].freq(celloTop[partCount%celloTop.size()][phraseCount] + Math.random2f(-0.05, 0.05));
                            }
                            else
                            {
                                cello[celloCount].freq(celloMid[partCount%celloMid.size()][phraseCount] + Math.random2f(-0.05, 0.05));
                            }
                        }
                        else 
                        {
                            cello[celloCount].freq(celloLow[partCount%celloLow.size()][phraseCount] + Math.random2f(-0.05, 0.05));
                        }
                    }
                    for(0 => int bassCount; bassCount < bass.size(); bassCount++)
                    {
                        if(bassCount< .5*bass.size() )
                        {
                            bass[bassCount].freq(bassPart[partCount%bassPart.size()][phraseCount] + Math.random2f(-0.05, 0.05));
                        }
                        else 
                        {
                            bass[bassCount].freq(bassLow[partCount%bassLow.size()][phraseCount] + Math.random2f(-0.05, 0.05));
                        }
                    }
                    
                    // In order to swell in volume to a certain point two bars from now, we keep track of when two bars from now is, and scale in exact divisions from that point.
                    2::t1 => dur tempDur;
                    now + tempDur => time tempNext;
                    10 => int incrementDenom;
                    
                    piano+0.05 => float target;
                    
                    viola[0].volume() => float startVolume;
                    while(now < tempNext)
                    {
                        for(0 => int violCount; violCount < violin.size(); violCount++)
                        {
                            violin[violCount].volume() + (target-startVolume)*division(1,incrementDenom) => violin[violCount].volume;
                        }
                        for(0 => int violCount; violCount < viola.size(); violCount++)
                        {
                            viola[violCount].volume() + (target-startVolume)*division(1,incrementDenom) => viola[violCount].volume;
                        }
                        
                        for(0 => int celloCount; celloCount < cello.size(); celloCount++)
                        {
                            cello[celloCount].volume() + (target-startVolume)*division(1,incrementDenom) => cello[celloCount].volume;
                        }
                        
                        for(0 => int bassCount; bassCount < bass.size(); bassCount++)
                        {
                            bass[bassCount].volume() + (target-startVolume)*division(1,incrementDenom) => bass[bassCount].volume;
                        }
                        division(1,incrementDenom)::tempDur => now;
                    }                    
                    // phraseCount ticks up so that we play the next note in each section's part.
                    phraseCount++;
                    
                    // Each frequency is set again.
                    for(0 => int violCount; violCount < violin.size(); violCount++)
                    {
                        violin[violCount].freq(violins[partCount%violins.size()][phraseCount] + Math.random2f(-0.05, 0.05));
                    }
                    
                    for(0 => int violCount; violCount < viola.size(); violCount++)
                    {
                        if(violCount< viola.size()*.5)
                        {
                            viola[violCount].freq(violas[partCount%violas.size()][phraseCount] + Math.random2f(-0.05, 0.05));
                        }
                        else
                        {
                            viola[violCount].freq(celloTop[partCount%celloTop.size()][phraseCount] + Math.random2f(-0.05, 0.05));
                        }
                    }
                    
                    for(0 => int celloCount; celloCount < cello.size(); celloCount++)
                    {
                        if(celloCount < cello.size() * .5) 
                        {
                            if(celloCount < cello.size() * .25)
                            {
                                cello[celloCount].freq(celloTop[partCount%celloTop.size()][phraseCount] + Math.random2f(-0.05, 0.05));
                            }
                            else
                            {
                                cello[celloCount].freq(celloMid[partCount%celloMid.size()][phraseCount] + Math.random2f(-0.05, 0.05));
                            }
                        }
                        else 
                        {
                            cello[celloCount].freq(celloLow[partCount%celloLow.size()][phraseCount] + Math.random2f(-0.05, 0.05));
                        }
                    }
                    
                    for(0 => int bassCount; bassCount < bass.size() ; bassCount++)
                    {
                        if(bassCount<bass.size()*.5) 
                        {
                            bass[bassCount].freq(bassPart[partCount%bassPart.size()][phraseCount] + Math.random2f(-0.05, 0.05));
                        }
                        else 
                        {
                            bass[bassCount].freq(bassLow[partCount%bassLow.size()][phraseCount] + Math.random2f(-0.05, 0.05));
                        }
                    }
                    
                    now + tempDur => tempNext;
                    
                    viola[0].volume() => startVolume;
                    pianissimo => target;
                    while(now < tempNext)
                    {
                        for(0 => int violCount; violCount < violin.size(); violCount++)
                        {
                            violin[violCount].volume() - (startVolume-target)*division(1,incrementDenom) => violin[violCount].volume;
                        }
                        for(0 => int violCount; violCount < viola.size(); violCount++)
                        {
                            viola[violCount].volume() - (startVolume-target)*division(1,incrementDenom) => viola[violCount].volume;
                        }
                        
                        for(0 => int celloCount; celloCount < cello.size(); celloCount++)
                        {
                            cello[celloCount].volume() - (startVolume-target)*division(1,incrementDenom) => cello[celloCount].volume;
                        }
                        
                        for(0 => int bassCount; bassCount < bass.size(); bassCount++)
                        {
                            bass[bassCount].volume() - (startVolume-target)*division(1,incrementDenom) => bass[bassCount].volume;
                        }
                        division(1,incrementDenom)::tempDur => now;
                    }
                    
                    // Everyone is told to stop bowing here, including the violins (even if they weren't bowing in the first place). Except for one moment.
                    if(false == (cueCount == 5 && phraseCount == 7))
                    {
                        for(0 => int violCount; violCount < violin.size(); violCount++)
                        {
                            violin[violCount].stopBowing(0.9);
                            violin[violCount].volume(0);
                        }
                        for(0 => int violCount; violCount < viola.size(); violCount++)
                        {
                            viola[violCount].stopBowing(0.9);
                            viola[violCount].volume(0);
                        }
                        for(0 => int celloCount; celloCount < cello.size(); celloCount++)
                        {
                            cello[celloCount].stopBowing(0.9);
                            cello[celloCount].volume(0);
                        } 
                        for(0 => int bassCount; bassCount < bass.size(); bassCount++)
                        {
                            bass[bassCount].stopBowing(0.9);
                            bass[bassCount].volume(0);
                        }
                    }
                }
                
                
                e2c.broadcast();
                
                myFadeout.duration(3::tBeat);
                myFadeout.keyOff;
                theeventthatwouldnevercome => now;
                
                me.exit();
            }
            
            cues[currentBeat(cues)+1] => now;
        }
        
        if(fadeout.value() < 0.0001) me.exit();
    }
}
    
fun void otherInstrument(float gain, float myPan)
{
    Chorus c => Gain g => Pan2 pan => JCRev r => Envelope myFadeout => fadeout;
    
    myFadeout.value(1);
    r.mix(0.1);
    g.gain(gain); 
    pan.pan(myPan);
    c.modFreq(0.12);
    c.modDepth(0.15);
    c.mix(0.15);
    
    // This instrument is organized much like the modal bar choirs above. Actually, partially copy-pasted from the above.
    // It was partially copy-pasted from the above, but combining as many as 64 harmonics into a single ADSR, and doing that for every single note on a 12-octave keyboard, 19 pitches per octave, is too taxing for the computer.
    // Never mind, apparently handling so many harmonics is the issue, not the number of pitches it's doing so for.
    // It's two ADSRs which play at the same time, in order to create a more interesting timbre.
    
    20 => int whichHarmonic;
    
    [ 55, 63, 66, 69, 74 ] @=> int gamut8va[];
    
    ADSR mySounds[gamut8va.size()];
    for(0 => int soundCount; soundCount < mySounds.size(); soundCount++)
    {
        additiveSynth1(harmonic[whichHarmonic], gamut[gamut8va[soundCount] + 38], 0.5) @=> mySounds[soundCount];
        mySounds[soundCount].set(0.2::second, 0.6::second, 0.25, 2::second);
        
        mySounds[soundCount] => c;
    }
    
    4 => int whichTah;
    ADSR myTahs[gamut8va.size()]; 
    for(0 => int tahCount; tahCount < myTahs.size(); tahCount++)
    {
        additiveSynth1(harmonic[whichTah], gamut[gamut8va[tahCount] + 38], 0.25) @=> myTahs[tahCount];
        myTahs[tahCount].set(0.15::second, 0.05::second, 0.125, 2::second);
        
        myTahs[tahCount] => g;
    }
    
    [ 
     [
      [0, 4],[1, 4],[2, 4],[1, 6], // bars[42] to bars[46]
      [0, 4],[1, 2],[2, 4],[3, 4], // bars[46] to bars[50]
      [4, 6],[3, 2],[2, 4],[3, 6], // bars[50] to bars[54]
      [4, 4],[3, 2],[2, 4],[1, 4], // bars[54] to bars[58]
      [0, 6],[1, 2],[2, 4],[3, 4], // bars[58] to bars[62]
      [4, 6],[3, 2],[2, 4],[1, 4], // bars[62] to bars[66]
      [0, 6],[1, 2],[2, 4],[3, 6], // bars[66] to bars[70]
      [4, 4],[3, 2],[2, 4],[1, 4], // bars[70] to bars[74]
      [0, 6],[1, 2],[2, 4],[3, 4]  // bars[74] to bars[78]
     ]
    ]
    @=> int myMel[][][];
    
    // renovations!! I think they're mostly done but
    
    1 => int firsttime;
    
    while(true)
    {
        if(currentBeat(cues) == 5)
        {
            
            for(currentBeat(cues) => int cueCount; cueCount < cues.size(); currentBeat(cues) => cueCount)
            {
                for(0 => int count; count < myMel[Std.ftoi(.5*cueCount)%myMel.size()].size(); count++)
                {
                    if(firsttime)
                    {
                        false => firsttime;
                        mySounds[0].gain(0.8);
                        myTahs[0].gain(0.8);
                    }
                    else
                    {
                        mySounds[0].gain(1.0);
                        myTahs[0].gain(1.0);
                    }
                    
                    spork ~ adsrArticulation(myTahs[myMel[Std.ftoi(.5*cueCount)%myMel.size()][count][0]], 4::tBeat, .15::second, 1.8::second);
                    adsrArticulation(mySounds[myMel[Std.ftoi(.5*cueCount)%myMel.size()][count][0]], myMel[Std.ftoi(.5*cueCount)%myMel.size()][count][1]::tBeat, .5*myMel[Std.ftoi(.5*cueCount)%myMel.size()][count][1]::tBeat, .7*myMel[Std.ftoi(.5*cueCount)%myMel.size()][count][1]::tBeat);
                }
                
                if(currentBeat(cues) >= 6)
                {
                    myFadeout.duration(1::t1);
                    myFadeout.keyOff;
                    3::t1 => now;
                    
                    me.exit();
                }
                                    
                nextBeatTime(cues) => now;
            }
        }
        
        else
        {
            nextBeatTime(cues) => now;
        }
        if(fadeout.value()<0.0001) me.exit();
    }
}


// // In this section are the bits within the interlude.
// This one is fake! Just a placeholder.
fun void interlude()
{
    5::second => now;
    e.broadcast();
}

fun void interludeMaster()
{
    beatDurtoMeter(t1, 144) @=> time interludeBars[]; 
    
    while(now <= interludeBars[6])
    {
        if(now == interludeBars[0])
            spork ~ interludeUpper(0.7, -0.9, interludeBars);
        if(now == interludeBars[1]-(.125*tBeat))
            spork ~ interludeMiddle(0.7, 0.9, interludeBars);
        if(now == interludeBars[6])
            spork ~ interludeLower(0.23, 0.0, interludeBars);
        
        samp => now;
    }
    
    e2a => now;
    
    fadeout2.duration(8::t1);
    fadeout2.keyOff(1);
    
    while(fadeout2.value() > 0.001)
    {
        samp => now;
    }
    
    e2b.broadcast();
    
    e2c => now;
    
    fadeout2.value(fadeout2Volume);
    
    e.broadcast();
}

fun void interludeUpper(float gain, float myPan, time meter[])
{
    Gain g => JCRev r => Pan2 pan => fadeout2;
    
    r.mix(0.01);
    g.gain(gain); 
    
    pan.pan(myPan);
    
    [ myBar[74], myBar[82], myBar[85], myBar[88], myBar[93] ] @=> ModalBar localBar[];
    
    for(0 => int localCount; localCount < localBar.size(); localCount++)
    {
        localBar[localCount].preset(1);
        localBar[localCount] => g;
        localBar[localCount].stickHardness(0.8);
    }
    
    [[.7, .45],[.5, .45],[.6, .45],[.4, .45]] @=> float myBarInfo[][];
    [ 0,       1,       2,        1,
      0, 1, 2, 3,
      4, 3, 2, 3,
      4, 3, 2, 1
     ] @=> int myMel[];
    
    0 => int infoCount;
    0 => int melCount;
    2 => int speed;
    
    while(true)
    {
        if(now == meter[9])
            1 => speed;
        if(now == meter[17])
            2 => speed;
        
        myBarInfo[infoCount%myBarInfo.size()][0] => localBar[myMel[melCount%myMel.size()]].strike; 
        myBarInfo[infoCount%myBarInfo.size()][1] => localBar[myMel[melCount%myMel.size()]].strikePosition;
        speed::tBeat => now;
        
        infoCount++;
        melCount++;
        
        if(fadeout2.value() < 0.001)
            me.exit();
    }
}
fun void interludeMiddle(float gain, float myPan, time meter[])
{
    Gain g => JCRev r => Pan2 pan => fadeout2;
    
    r.mix(0.1);
    g.gain(gain); 
    
    pan.pan(myPan);
    
    [ myBar[74], myBar[69], myBar[66], myBar[63], myBar[55] ] @=> ModalBar localBar[];
    
    for(0 => int localCount; localCount < localBar.size(); localCount++)
    {
        localBar[localCount].preset(1);
        localBar[localCount] => g;
        localBar[localCount].stickHardness(0.2);
    }
    
    [[.7, .45],[.5, .45],[.6, .45],[.4, .45]] @=> float myBarInfo[][];
    [ 0,       1,       2,        1,
    0, 1, 2, 3,
    4, 3, 2, 3,
    4, 3, 2, 1
    ] @=> int myMel[];
    
    0 => int infoCount;
    0 => int melCount;
    2 => int speed;
    
    while(true)
    {
        if(now == meter[13]-(.125*tBeat))
            1 => speed;
        if(now == meter[23]-(.125*tBeat))
        {
            2 => speed;
        }
        myBarInfo[infoCount%myBarInfo.size()][0] => localBar[myMel[melCount%myMel.size()]].strike; 
        myBarInfo[infoCount%myBarInfo.size()][1] => localBar[myMel[melCount%myMel.size()]].strikePosition;
        speed::tBeat => now;
        
        infoCount++;
        melCount++;
        
        if(fadeout2.value() < 0.001)
            me.exit();
        
    }
}
fun void interludeLower(float gain, float myPan, time meter[])
{
    Chorus c => Gain g => Pan2 pan => JCRev r => fadeout2;
    
    r.mix(0.1);
    g.gain(gain); 
    pan.pan(myPan);
    c.modFreq(0.12);
    c.modDepth(0.15);
    c.mix(0.15);
    
    // This instrument is organized much like the modal bar choirs above. Actually, partially copy-pasted from the above.
    // It was partially copy-pasted from the above, but combining as many as 64 harmonics into a single ADSR, and doing that for every single note on a 12-octave keyboard, 19 pitches per octave, is too taxing for the computer.
    // Never mind, apparently handling so many harmonics is the issue, not the number of pitches it's doing so for.
    // It's two ADSRs which play at the same time, in order to create a more interesting timbre.
    
    12 => int whichHarmonic;
    
    [ 55, 50, 47, 44, 36 ] @=> int gamut8va[];
    
    ADSR mySounds[gamut8va.size()];
    for(0 => int soundCount; soundCount < mySounds.size(); soundCount++)
    {
        additiveSynth1(harmonic[whichHarmonic], gamut[gamut8va[soundCount] + 38], 0.4) @=> mySounds[soundCount];
        mySounds[soundCount].set(0.2::second, 0.6::second, 0.25, 2::second);
        
        mySounds[soundCount] => c;
    }
    11 => int whichTah;
    ADSR myTahs[gamut8va.size()]; 
    for(0 => int tahCount; tahCount < myTahs.size(); tahCount++)
    {
        additiveSynth1(harmonic[whichTah], gamut[gamut8va[tahCount] + 38], 0.25) @=> myTahs[tahCount];
        myTahs[tahCount].set(0.15::second, 0.05::second, 0.125, 2::second);
        
        myTahs[tahCount] => g;
    }
    
    [ 0,       1,       2,        1,
    0, 1, 2, 3,
    4, 3, 2, 3,
    4, 3, 2, 1
    ] @=> int myMel[];
    
    0 => int infoCount;
    0 => int melCount;
    4 => int speed;
    
    while(now < meter[22])
    {
        
        spork ~ adsrArticulation(myTahs[myMel[melCount%myMel.size()]], speed::tBeat, .15::second, 4.8::tBeat);
                adsrArticulation(mySounds[myMel[melCount%myMel.size()]], speed::tBeat, 2::tBeat, 3::tBeat);
        
        infoCount++;
        melCount++;
        
    }
    
    spork ~ adsrArticulation(myTahs[myMel[melCount%myMel.size()]], speed::tBeat, .15::second, 4.8::tBeat);
            adsrArticulation(mySounds[myMel[melCount%myMel.size()]], 2*speed::tBeat, 2::tBeat, 3::tBeat);
            
    e2a.broadcast();
    
    2::second => now;
}









//
// // // Pure mechanics functions:
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
fun void addXTimetoEachPartOfArraysBeatsBarsSimpleBeatsandCues(dur byHowLong)
{
    for(0 => int barCount; barCount < bars.size(); barCount++)
    {
        byHowLong +=> bars[barCount];
    }
    for(0 => int barCount; barCount < beats.size(); barCount++)
    {
        for(0 => int beatCount; beatCount < beats[barCount].size(); beatCount++)
        {
            byHowLong +=> beats[barCount][beatCount];
        }
    }
    for(0 => int beatCount; beatCount < simpleBeats.size(); beatCount++)
    {
        byHowLong +=> simpleBeats[beatCount];
    }
    for(0 => int cueCount; cueCount < cues.size(); cueCount++)
    {
        byHowLong +=> cues[cueCount];
    }
}



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
fun float[] TETsetup(int tonesPerOctave)
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
    TETsetup(myTET) @=> float tempTET[];
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




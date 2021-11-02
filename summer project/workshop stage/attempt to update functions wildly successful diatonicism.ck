private class adsrPlus extends Chubgraph
{
    inlet => ADSR env => outlet;
    
    0 => int playing;
    
    fun void set(dur att, dur dec, float sus, dur rel){ env.set(att, dec, sus, rel); }
    
    fun void sporkPlay(dur noteLength)
    {
        1 => playing;
        this.env.keyOn(1);
        noteLength => now;
        this.env.keyOff(1);
        this.env.releaseTime()=>now;
        0 => playing;
    }
    
    fun void articulation(dur note, dur artic, dur release)
    {
        this.env.releaseTime(release);
        articulation(note, artic);
    }
    fun void articulation(dur note, dur artic) // these are intended not to be sporked, but to be used for time coordination in the main thing.
    {
        now + note => time later;
        if(note > artic)
        {
            this.env.keyOn(1);
            artic => now;
            this.env.keyOff(1);
            later => now;
        }
        else
        {
            //if(note < artic) <<< "Cannot travel to the past!" >>>;
            this.env.keyOn(1);
            later => now;
            this.env.keyOff(1);
        }
    }
    
    fun void articulation(time later, dur artic, dur release)
    {
        this.env.releaseTime(release);
        articulation(later, artic);
    }
    fun void articulation(time later, dur artic)
    {
        if(later > now + artic)
        {
            this.env.keyOn(1);
            artic => now;
            this.env.keyOff(1);
            later => now;
        }
        else
        {
            //if(later < now + artic) <<< "Cannot travel to the past!" >>>;
            this.env.keyOn(1);
            later => now;
            this.env.keyOff(1);
        }
    }
}

// intended to replace the old EDO setup.
private class EDO 
{
    // default is 12.
    12 => static int tone;
    fun int toneNum(){ return tone; }                                  // returns tones per octave.
    fun float toneInv(){ return Math.pow(tone,-1); }                   // returns inverse of above.
    fun float semi(){ return Math.pow(2, toneInv()); }                 // returns ratio of a single semitone.
    fun float semi(int count){ return Math.pow(this.semi(), count); }  // returns ratio of X semitones.
    
    16 => static float C0; // This is the pitch standard. (C3 is 256 Hz. A4 is (in 12tet) 432 Hz.)
    [
    0, //C
    2, //D
    4, //E
    5, //F
    7, //G
    9, //A
    11 //B
    ]
    @=> int letterSemitones[]; // Won't with fewer than 7.
    
    //  returns, in Hertz: (x octaves times EDO, plus distance between white keys, plus chromatic alteration) semitones above C0.
    fun float C(int oct, int acci){ return C0 * semi(tone*oct + letterSemitones[0] + acci); }
    fun float C(int oct)          { return C(oct, 0); }
    fun float D(int oct, int acci){ return C0 * semi(tone*oct + letterSemitones[1] + acci); }
    fun float D(int oct)          { return D(oct, 0); }
    fun float E(int oct, int acci){ return C0 * semi(tone*oct + letterSemitones[2] + acci); }
    fun float E(int oct)          { return E(oct, 0); }
    fun float F(int oct, int acci){ return C0 * semi(tone*oct + letterSemitones[3] + acci); }
    fun float F(int oct)          { return F(oct, 0); }
    fun float G(int oct, int acci){ return C0 * semi(tone*oct + letterSemitones[4] + acci); }
    fun float G(int oct)          { return G(oct, 0); }
    fun float A(int oct, int acci){ return C0 * semi(tone*oct + letterSemitones[5] + acci); }
    fun float A(int oct)          { return A(oct, 0); }
    fun float B(int oct, int acci){ return C0 * semi(tone*oct + letterSemitones[6] + acci); }
    fun float B(int oct)          { return B(oct, 0); }
    
    // because the above is less crazy-automatic-shit-friendly, the following puts a number to it.
    // let's do something nuts.
    // letter represents the position on the C diatonic scale. 0 is C, 6 is B.
    // if letter is 1...
        // acts just like D(oct, acci).
        // normal.
    // if letter is -6...
        // should act like D(oct-1, acci).
        // should act like dia(letter+7, oct-1, acci).
        //                          dia(letter+
    // if letter is 7...
        // should act like dia(letter-7, oct+1, acci);
    fun float dia(int letter, int oct, int acci)
    {
        //     C0 in Hz times the following semitones: [semitones per octave] times (the sum of [octaves above 0] and any extra octaves (from inputting 8 diatonic steps or something)), plus the semitone value of the inputted diatonic steps (mod diatonic scale size), plus any acccidental modifier.
        return C0       *     semi(                    tone                   *     (oct                          +   modPlus(letter,letterSemitones.size(),1))                          +    letterSemitones[      modPlus(letter, letterSemitones.size(),0)]             +    acci                   );
    }
    fun float dia(int letter, int oct)
    {
        return dia(letter, oct, 0);
    }
    
    fun float chrom(int semitoneCount) {return C(0, semitoneCount);} // same as using C(0, acci). Just for clarity.
    
    fun void setup(int newTone, int newLetters[])
    {
        newTone => tone;
        for(0 => int letterCount; letterCount < letterSemitones.size(); letterCount++)
        {
            newLetters[letterCount%newLetters.size()] => letterSemitones[letterCount]; 
        }
    }
}

EDO my; 
my.setup(// 17 semitones per octave; C, D, E, F, G,  A,  B
            17,                     [0, 3, 6, 7, 10, 13, 16]
         );

TriOsc s => adsrPlus env => dac;
s.gain(.5);

env.set(.1::second, .1::second, .5, .08::second);

mmtoDur(60) => dur bar;

[0, 4, 2, 1] @=> int diaTriad[];
[0.5, 0.6, 0.4, 0.3] @=> float lengths[];
-7 => int scaleCount;
2  => int scaleCap;

0 => int acci;
2 => int acciSize;

while(true)
{
    microGen([0, 2, 4, 6, 9], now, now + bar) @=> time localBar[];
    
    for(0 => int beatCount; now < localBar[localBar.size()-1]; beatCount++)
    {
        s.freq( my.dia(scaleCount+diaTriad[beatCount % diaTriad.size()],4,0) );
        env.articulation(nextBeatTime(localBar), lengths[beatCount % lengths.size()]::(nextBeatTime(localBar)-now));
    }
    
    scaleCount++;
    
}




























//
// // // Pure mechanics functions:

fun int booleanRatio(int num, int denom)
{
    return (Math.random2(1, denom) <= num);
}


// setting is 0: normal mod function, works negative too.
// setting is 1: instead, it says (negative) how many additions or subtractions of the mod were needed.
fun int modPlus(int moddee, int mod, int setting) 
{
    if( mod <= 0 ) { <<< "Get outta here. (modPlus negative mod error)" >>>; me.exit(); }
    
    moddee => int modToBe;
    
    0 => int outCount;
    
    if(modToBe >= mod)
    {
        while(modToBe >= mod)
        {
            mod -=> modToBe;
            outCount++;
        }
    }
    //else if(modToBe < mod && modToBe >= 0), nothing happens at all.
    else if(modToBe < 0)
    {
        while(modToBe < 0)
        {
            mod +=> modToBe;
            outCount--;
        }
    }
    
    if(setting) return outCount;
    else return modToBe;
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
// // // Timbre functions:

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



private class Meter
{
    now => time start;
    //Meter meter; // could I pull this off with null reference shenanigans? Check later.
    
    
}

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
            int newFractions[fractions.size()+1]; 
            0 => newFractions[0];
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










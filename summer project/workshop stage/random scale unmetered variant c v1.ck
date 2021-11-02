private class Stringish
{
    SinOsc LFO[2];
    9 => LFO[0].freq;
    LFO[0].freq()*.92=>LFO[1].freq;
    
    
    SawOsc s[4];
    220 => float base;
    
    ADSR env;
    .5 => float gain => env.gain;
    env.set(.01::second, .5::second, .6, 0.05::second);
    
    100 => int offsetNum;
    division(offsetNum,offsetNum-1) => float offset;
    
    0 => int playing;
    
    fun void setup()
    {
        LFO[0] => s[0] => env;
        s[0].sync(2);
        s[0].freq(offset*base);
        s[0].gain(division(1,s.size()));
        LFO[1] => s[1] => env;
        s[1].sync(2);
        s[1].freq(division(1,offset)*base);
        s[1].gain(division(1,s.size()));
        
        for(2 => int sCount; sCount < s.size(); sCount++)
        {
            LFO[maybe] => s[sCount] => env;
            s[sCount].sync(2);
            s[sCount].freq(Math.random2f(offset*base,division(1,offset)*base));
            s[sCount].gain(division(1,s.size()));
        }
    }
    fun void setFreq(float freq)
    {
        freq => base;
        s[0].freq(offset*base);
        s[1].freq(division(1,offset)*base);
        for(2 => int sCount; sCount < s.size(); sCount++)
        {
            s[sCount].freq(Math.random2f(offset*base,division(1,offset)*base));
        }
    }
    fun void setVibFreq(float freq)
    {
        freq => LFO[0].freq;
        LFO[0].freq()*.92=>LFO[1].freq;
    }
    
    fun void sporkPlay(dur noteLength)
    {
        1 => playing;
        this.env.keyOn(1);
        noteLength => now;
        this.env.keyOff(1);
        this.env.releaseTime()=>now;
        0 => playing;
    }
}

Stringish section[9];
Gain g => Envelope fadeout => dac;
fadeout.value(1);
g.gain(division(1,section.size()));

800 => float base;
[
division(8,8),
division(9,8),
division(10,8),
division(11,8),
division(12,8)
]
@=> float scale[];

for(0 => int secCount; secCount < section.size(); secCount++)
{
    section[secCount].env => g;
    section[secCount].setVibFreq(7);
    section[secCount].setup();
}

.125::second => dur beat;

int scaleCount[section.size()]; // each section has a corresponding scaleCount.
while(true)
{
    for(0 => int secCount; secCount < section.size(); secCount++)
    {
        section[secCount].setFreq(base*scale[modPlus(scaleCount[secCount],scale.size(),0)]);
        
        spork ~ section[secCount].sporkPlay(0.99::beat);
    }
    
    beat => now;
    
    if(maybe) scaleCount[Math.random2(0,section.size()-1)]++;
    else      scaleCount[Math.random2(0,section.size()-1)]--;
}















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

fun int maxInt(int A, int B)
{
    return Std.ftoi(Math.max(A,B));
}
fun int minInt(int A, int B)
{
    return Std.ftoi(Math.min(A,B));
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
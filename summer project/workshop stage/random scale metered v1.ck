private class adsrPlus extends Chubgraph
{
    inlet => ADSR env => outlet;
    
    0 => int playing;
    
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
            if(note < artic) <<< "Cannot travel to the past!" >>>;
            this.env.keyOn(1);
            later => now;
            this.env.keyOff(1);
        }
    }
    
    fun void articulation(time later, dur artic, dur release)
    {
        this.env.releaseTime(release);
        if(later > now + artic)
        {
            this.env.keyOn(1);
            artic => now;
            this.env.keyOff(1);
            later => now;
        }
        else
        {
            if(later < now + artic) <<< "Cannot travel to the past!" >>>;
            this.env.keyOn(1);
            later => now;
            this.env.keyOff(1);
        }
    }
}

Gain g => dac;
9 => int instrNum;
SawOsc s[instrNum];
adsrPlus e[instrNum];
Std.mtof(72) => float startFreq;
float offset[instrNum];

for(0 => int sCount; sCount < s.size(); sCount++)
{
    s[sCount] => e[sCount] => g;
    
    e[sCount].env.set(.1::second, .1::second, 0.2, .7::second);
    
    randomRange(1,division(60,59)) => offset[sCount];
}
g.gain(Math.pow(instrNum,-1));


// 7x/6 = 9/8
// x = 27 / 4*7
// x = 27/28

[
    [ division(8,8), division(9,8), division(6,5)],
    [ division(15,16), division(8,8), division(9,8), division(6,5)],
    [ division(8,8), division(9,8), division(6,5)],
    [ division(15,16), division(8,8), division(9,8), division(6,5)],
    [ division(8,8), division(9,8), division(6,5)],
    [ division(15,16), division(8,8), division(9,8), division(6,5)],
    [ division(4,5), division(15,16), division(9,8), division(6,5)],
    [ division(3,4), division(4,5), division(15,16), division(9,8), division(6,5)]
]
@=> float sets[][];
0 => int setCount;
0.8::second => dur barDur; 

float localStartFreq[instrNum];
for(0 => int lsfCount; lsfCount < instrNum; lsfCount++)
{
    startFreq * offset[lsfCount] => localStartFreq[lsfCount];
}

// barDur times Math.pow(instrNum*(sets[#].size()-1), -1) equals beatDur.

while(true)
{
    int noteCount[instrNum];
    
    Math.pow(instrNum*(sets[setCount%sets.size()].size()-1), -1)::barDur => dur beatDur;
    
    while(true)
    {
        for(0 => int instrCount; instrCount < e.size(); instrCount++)
        {
            s[instrCount].freq(localStartFreq[instrCount] * sets[setCount%sets.size()][noteCount[instrCount]]);
        }
        
        if(arrayIntAverage(noteCount) == sets[setCount%sets.size()].size()-1)
            break;
        
        for(0 => int instrCount; instrCount < e.size(); instrCount++)
        {
            spork ~ e[instrCount].sporkPlay(.3::beatDur);
        }
        
        int rand;
        while(true)
        {
            Math.random2(0,instrNum-1) => rand;
            if(noteCount[rand] != sets[setCount%sets.size()].size()-1)
                break;
        }
        noteCount[rand]++;
        
        
        beatDur => now;
    }
    setCount++;
}

















fun float randomRange(float center, float offset) // in offset, put something like division(50,49).
{
    return Math.random2f(center*offset,center*Math.pow(offset,-1));
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
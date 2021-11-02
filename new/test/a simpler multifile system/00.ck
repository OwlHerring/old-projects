// just add this shred before any others. EZ

public class Ini // keeping its name as Ini for legacy
{
    // // // A bunch of functions that are generically useful.
    
    
    fun static float division(float num, float denom)
    {
        return num * Math.pow(denom, -1);
    }
    fun static int forloopMaybe(int count)
    { 
        maybe => int Maybe; 
        if(count == 0) return Maybe;
        else if(count == 1) return !Maybe;
        else if(count > 1) return maybe;
    }
    fun static int forloopRandom2(int count, int floor, int cap)
    {
        maybe => int Maybe;
        cap - floor => int difference;
        if(count == 0) return floor + Maybe*difference;
        else if(count == 1) return floor + (!Maybe)*difference;
        else if(count > 1) return Math.random2(floor, cap);
    }
    fun static float forloopRandom2f(int count, float floor, float cap)
    {
        maybe => int Maybe;
        cap - floor => float difference;
        if(count == 0) return floor + ((Maybe==1)*difference);
        else if(count == 1) return floor + ((Maybe!=1)*difference);
        else if(count > 1) return Math.random2f(floor, cap);
    }
    fun static int booleanRatio(int num, int denom) // booleanRatio(3,7): something has a probability of 3/7.
    {
        return (Math.random2(1, denom) <= num);
    }
    
    // setting is 0: normal mod function, works negative too.
    // setting is 1: instead, it says (negative) how many additions or subtractions of the mod were needed.
    fun static int modPlus(int moddee, int mod, int setting) 
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
    
    fun static int arrayIntSum(int array[])
    {
        return arrayIntSum(array, array.size());
    }
    fun static int arrayIntSum(int array[], int upTo)
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
    fun static float arrayIntAverage(int array[])
    {
        return arrayIntAverage(array, array.size());
    }
    fun static float arrayIntAverage(int array[], int upTo)
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
    fun static float arrayPercent(int array[], int whichOne)
    {
        array[whichOne] => float percent;
        arrayIntSum(array) /=> percent;
        return percent;
    }
    fun static float arrayPercentf(float array[], int whichOne)
    {
        array[whichOne] => float percent;
        arrayfSum(array) /=> percent;
        return percent;
    }
    fun static float arrayfSum(float array[])
    {
        return arrayfSum(array, array.size());
    }
    fun static float arrayfSum(float array[], int upTo)
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
    fun static float arrayfAverage(float array[])
    {
        return arrayfAverage(array, array.size());
    }
    fun static float arrayfAverage(float array[], int upTo)
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
    fun static int[] numericalOrder(int array[])
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
    fun static float[] numericalOrderf(float array[])
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
    fun static int maximumMember(int array[])
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
    fun static int maximumMemberf(float array[])
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
    fun static int maximumValue(int array[])
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
    fun static float maximumValuef(float array[])
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
    fun static int[] transposeArray(int array[], int byHowMuch)
    {
        for (0 => int arrayCount; arrayCount < array.size(); arrayCount++)
        {
            byHowMuch +=> array[arrayCount];
        }
        return array;
    }
    fun static float[] transposeArrayf(float array[], float byHowMuch)
    {
        for (0 => int arrayCount; arrayCount < array.size(); arrayCount++)
        {
            byHowMuch +=> array[arrayCount];
        }
        return array;
    }
    // The same as the above two, but instead of adding by a given amount, it adds by some amount to get to a given target amount for the lowest value.
    fun static int[] transposeArrayTo(int array[], int target)
    {
        numericalOrder(array) @=> int tempArray[]; 
        target - tempArray[0] => int difference;   
        
        return transposeArray(array, difference);
    }
    fun static int[] transposeArrayTo(int array[])
    {
        return transposeArrayTo(array, 0);
    }
    fun static float[] transposeArrayTof(float array[], float target)
    {
        numericalOrderf(array) @=> float tempArray[]; 
        target - tempArray[0] => float difference;   
        
        return transposeArrayf(array, difference);
    }
    fun static float[] transposeArrayTof(float array[])
    {
        return transposeArrayTof(array, 0);
    }
    // A function that takes the values of myArray[#][X] (every #, the X specified by you) and returns a single array with all of X in a single array.
    fun static int[] twoDimensionaltoOne(int array[][], int whichOne)
    {
        int newArray[array.size()];
        for(0 => int arrayCount; arrayCount<array.size(); arrayCount++)
        {
            array[arrayCount][whichOne] => newArray[arrayCount];
        }
        return newArray;
    }
    fun static float[] twoDimensionaltoOnef(float array[][], int whichOne)
    {
        float newArray[array.size()];
        for(0 => int arrayCount; arrayCount<array.size(); arrayCount++)
        {
            array[arrayCount][whichOne] => newArray[arrayCount];
        }
        return newArray;
    }
    // A function that converts an array like [ a, b, c, d ] into [ a, a+b, a+b+c, a+b+c+d ].
    fun static int[] arraySummation(int array[])
    {
        int newArray[array.size()];
        for(0 => int arrayCount; arrayCount<array.size(); arrayCount++)
        {
            arrayIntSum(array, arrayCount+1) => newArray[arrayCount];
        }
        return newArray;
    }
    fun static float[] arraySummationf(float array[])
    {
        float newArray[array.size()];
        for(0 => int arrayCount; arrayCount<array.size(); arrayCount++)
        {
            arrayfSum(array, arrayCount+1) => newArray[arrayCount];
        }
        return newArray;
    }
    
    //
    // // Time-setting functions (still unmodified)
    
    // Converting metronome marking (for my convenience)
    fun static dur mmtoDur(float tempo)
    {
        1 => float tempoInv; tempo /=> tempoInv;
        
        tempoInv::minute => dur tempoDur;
        
        return tempoDur;
    }
    
    // Sets up a simple beat, derived from a total duration. 
    fun static time[] totalDurtoMeter(time start, dur totalDur, int beatNum)
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
    fun static time[] totalDurtoMeter(dur totalDur, int beatNum)
    {
        return totalDurtoMeter(now, totalDur, beatNum);
    }
    
    fun static time[] beatDurtoMeter(time start, dur beatDur, int beatNum)
    {
        
        time beat[beatNum+1]; // barNum+1 if you want the last barline to equal end.
        
        for (0 => int beatCount; beatCount < beat.size(); beatCount++)
        {
            start + beatCount::beatDur => beat[beatCount];
            
        }
        return beat;
    }
    fun static time[] beatDurtoMeter(dur beatDur, int beatNum)
    {
        return beatDurtoMeter(now, beatDur, beatNum);
    }
    // Another one much like the above.
    fun static time[] timeIntervaltoMeter(time start, time end, int beatNum)
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
    fun static time[] microGen(int fractions[], time start, time end)  
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
    fun static time[] microGenf(float fractions[], time start, time end)  
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
    
    // original function: clips off the start of a time[] file if = to now.
    fun static time[] noStart(time old[])
    {
        if(old.size() == 0) { } // nothing happens, dumbass. Next time don't give it an empty time array
        else
        {
            if(old[0] != now) { } // nothing happens in this case either. The time array's gotta be piping hot
            {
                time New[0];
                for(1 => int oldCount; oldCount < old.size(); oldCount++)
                {
                    New << old[oldCount];
                }
                return New;
            }
        }
    }
    // // // A bunch of functions that are generically useful.
    
    
    fun static float division(float num, float denom)
    {
        return num * Math.pow(denom, -1);
    }
    fun static int forloopMaybe(int count)
    { 
        maybe => int Maybe; 
        if(count == 0) return Maybe;
        else if(count == 1) return !Maybe;
        else if(count > 1) return maybe;
    }
    fun static int forloopRandom2(int count, int floor, int cap)
    {
        maybe => int Maybe;
        cap - floor => int difference;
        if(count == 0) return floor + Maybe*difference;
        else if(count == 1) return floor + (!Maybe)*difference;
        else if(count > 1) return Math.random2(floor, cap);
    }
    fun static float forloopRandom2f(int count, float floor, float cap)
    {
        maybe => int Maybe;
        cap - floor => float difference;
        if(count == 0) return floor + ((Maybe==1)*difference);
        else if(count == 1) return floor + ((Maybe!=1)*difference);
        else if(count > 1) return Math.random2f(floor, cap);
    }
    fun static int booleanRatio(int num, int denom) // booleanRatio(3,7): something has a probability of 3/7.
    {
        return (Math.random2(1, denom) <= num);
    }
    
    // setting is 0: normal mod function, works negative too.
    // setting is 1: instead, it says (negative) how many additions or subtractions of the mod were needed.
    fun static int modPlus(int moddee, int mod, int setting) 
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
    
    fun static int arrayIntSum(int array[])
    {
        return arrayIntSum(array, array.size());
    }
    fun static int arrayIntSum(int array[], int upTo)
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
    fun static float arrayIntAverage(int array[])
    {
        return arrayIntAverage(array, array.size());
    }
    fun static float arrayIntAverage(int array[], int upTo)
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
    fun static float arrayPercent(int array[], int whichOne)
    {
        array[whichOne] => float percent;
        arrayIntSum(array) /=> percent;
        return percent;
    }
    fun static float arrayPercentf(float array[], int whichOne)
    {
        array[whichOne] => float percent;
        arrayfSum(array) /=> percent;
        return percent;
    }
    fun static float arrayfSum(float array[])
    {
        return arrayfSum(array, array.size());
    }
    fun static float arrayfSum(float array[], int upTo)
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
    fun static float arrayfAverage(float array[])
    {
        return arrayfAverage(array, array.size());
    }
    fun static float arrayfAverage(float array[], int upTo)
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
    fun static int[] numericalOrder(int array[])
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
    fun static float[] numericalOrderf(float array[])
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
    fun static int maximumMember(int array[])
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
    fun static int maximumMemberf(float array[])
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
    fun static int maximumValue(int array[])
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
    fun static float maximumValuef(float array[])
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
    fun static int[] transposeArray(int array[], int byHowMuch)
    {
        for (0 => int arrayCount; arrayCount < array.size(); arrayCount++)
        {
            byHowMuch +=> array[arrayCount];
        }
        return array;
    }
    fun static float[] transposeArrayf(float array[], float byHowMuch)
    {
        for (0 => int arrayCount; arrayCount < array.size(); arrayCount++)
        {
            byHowMuch +=> array[arrayCount];
        }
        return array;
    }
    // The same as the above two, but instead of adding by a given amount, it adds by some amount to get to a given target amount for the lowest value.
    fun static int[] transposeArrayTo(int array[], int target)
    {
        numericalOrder(array) @=> int tempArray[]; 
        target - tempArray[0] => int difference;   
        
        return transposeArray(array, difference);
    }
    fun static int[] transposeArrayTo(int array[])
    {
        return transposeArrayTo(array, 0);
    }
    fun static float[] transposeArrayTof(float array[], float target)
    {
        numericalOrderf(array) @=> float tempArray[]; 
        target - tempArray[0] => float difference;   
        
        return transposeArrayf(array, difference);
    }
    fun static float[] transposeArrayTof(float array[])
    {
        return transposeArrayTof(array, 0);
    }
    // A function that takes the values of myArray[#][X] (every #, the X specified by you) and returns a single array with all of X in a single array.
    fun static int[] twoDimensionaltoOne(int array[][], int whichOne)
    {
        int newArray[array.size()];
        for(0 => int arrayCount; arrayCount<array.size(); arrayCount++)
        {
            array[arrayCount][whichOne] => newArray[arrayCount];
        }
        return newArray;
    }
    fun static float[] twoDimensionaltoOnef(float array[][], int whichOne)
    {
        float newArray[array.size()];
        for(0 => int arrayCount; arrayCount<array.size(); arrayCount++)
        {
            array[arrayCount][whichOne] => newArray[arrayCount];
        }
        return newArray;
    }
    // A function that converts an array like [ a, b, c, d ] into [ a, a+b, a+b+c, a+b+c+d ].
    fun static int[] arraySummation(int array[])
    {
        int newArray[array.size()];
        for(0 => int arrayCount; arrayCount<array.size(); arrayCount++)
        {
            arrayIntSum(array, arrayCount+1) => newArray[arrayCount];
        }
        return newArray;
    }
    fun static float[] arraySummationf(float array[])
    {
        float newArray[array.size()];
        for(0 => int arrayCount; arrayCount<array.size(); arrayCount++)
        {
            arrayfSum(array, arrayCount+1) => newArray[arrayCount];
        }
        return newArray;
    }
    
    //
    // // Time-setting functions (still unmodified)
    
    // Converting metronome marking (for my convenience)
    fun static dur mmtoDur(float tempo)
    {
        1 => float tempoInv; tempo /=> tempoInv;
        
        tempoInv::minute => dur tempoDur;
        
        return tempoDur;
    }
    
    // Sets up a simple beat, derived from a total duration. 
    fun static time[] totalDurtoMeter(time start, dur totalDur, int beatNum)
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
    fun static time[] totalDurtoMeter(dur totalDur, int beatNum)
    {
        return totalDurtoMeter(now, totalDur, beatNum);
    }
    
    fun static time[] beatDurtoMeter(time start, dur beatDur, int beatNum)
    {
        
        time beat[beatNum+1]; // barNum+1 if you want the last barline to equal end.
        
        for (0 => int beatCount; beatCount < beat.size(); beatCount++)
        {
            start + beatCount::beatDur => beat[beatCount];
            
        }
        return beat;
    }
    fun static time[] beatDurtoMeter(dur beatDur, int beatNum)
    {
        return beatDurtoMeter(now, beatDur, beatNum);
    }
    // Another one much like the above.
    fun static time[] timeIntervaltoMeter(time start, time end, int beatNum)
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
    fun static time[] microGen(int fractions[], time start, time end)  
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
    fun static time[] microGenf(float fractions[], time start, time end)  
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
    
    // original function: clips off the start of a time[] file if = to now.
    fun static time[] noStart(time old[])
    {
        if(old.size() == 0) { } // nothing happens, dumbass. Next time don't give it an empty time array
        else
        {
            if(old[0] != now) { } // nothing happens in this case either. The time array's gotta be piping hot
            {
                time New[0];
                for(1 => int oldCount; oldCount < old.size(); oldCount++)
                {
                    New << old[oldCount];
                }
                return New;
            }
        }
    }

}
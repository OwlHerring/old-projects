FileIO file;

if(!file.open( me.dir() + "text1file.txt", FileIO.READ )) { me.exit(); }

int lineBytes[0];


while(true)
{
    file.tell() => int where;
    lineBytes << where;
    
    file => int read;
    if(file.eof()) break;
}

randomArrayOrder(lineBytes.size()) @=> int order[];
int randPitches[0];
for(0 => int orderCount; orderCount < order.size(); orderCount++)
{
    file.seek(lineBytes[order[orderCount]]);
    
    file.tell() => int where;
    file => int what;
    
    randPitches << what;
    
    <<< what, where >>>;
}

SinOsc s => ADSR env => dac;
env.gain(.5); env.set(.1::second, .1::second, .1, .1::second);

for(0 => int pCount; pCount < randPitches.size(); pCount++)
{
    s.freq(Std.mtof(randPitches[pCount]));
    env.keyOn(1);
    
    .25::second => now;
}



fun int[] randomArrayOrder(int size) // don't put anything in int size other than someArrayorAnother.size(), got it?
{
    int output[0];
    
    while(output.size() < size)
    {
        Math.random2(0,size-1) => int rand;
        if(isAnyOfThese(rand, output)){ continue; }
        output << rand;
    }
    return output;
}
fun int isAnyOfThese(int it, int ofThese[])
{
    0 => int isItOrNot;
    for(0 => int itCount; itCount < ofThese.size(); itCount++)
    {
        if(it==ofThese[itCount]) 1 => isItOrNot;
    }
    return isItOrNot;
}
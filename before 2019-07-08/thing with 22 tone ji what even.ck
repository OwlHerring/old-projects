float scale[22];
1 => scale[0];                  // A
16 => scale[1]; 15/=>scale[1];  // Bb. 16 on the Bb harmonic series
10 => scale[2]; 9/=>scale[2];   // B. 10 on the G harmonic series
9 => scale[3]; 8/=>scale[3];    // B. 9 on the A harmonic series
8 => scale[4]; 7/=>scale[4];    // B seven#. 8 on the B seven# harmonic series.
7 => scale[5]; 6/=>scale[5];    // C sevenb. 7 on the D harmonic series.
6 => scale[6]; 5/=>scale[6];    // C. 6 on the F harmonic series (A is 5).
5 => scale[7]; 4/=>scale[7];    // C#. 5 on the A harmonic series.
9 => scale[8]; 7/=>scale[8];    // C seven#. 9 on the B seven# harmonic series.
4 => scale[9]; 3/=>scale[9];    // D. 4 on the D harmonic series.
7 => scale[10]; 5/=>scale[10];  // D seven#. 7 on the F harmonic series (A is 5).
10 => scale[11]; 7/=>scale[11]; // E sevenb. 10 on the B seven# harmonic series.
3 => scale[12]; 2/=>scale[12];  // E. 3 on the A harmonic series.
14 => scale[13]; 9/=>scale[13]; // F sevenb. 14 on the G harmonic series.
8 => scale[14]; 5/=>scale[14];  // F. 8 on the F harmonic series (A is 5).
5 => scale[15]; 3/=>scale[15];  // F#. 5 on the D harmonic series.
12 => scale[16]; 7/=>scale[16]; // F seven#. 12 on the B seven# harmonic series.
7 => scale[17]; 4/=>scale[17];  // G sevenb. 7 on the A harmonic series.
16 => scale[18]; 9/=>scale[18]; // G. 16 on the G harmonic series.
9 => scale[19]; 5/=>scale[19];  // G. 9 on the F harmonic series (A is 5).
15 => scale[20]; 8/=>scale[20]; // G#. 15 on the A harmonic series.
2 => scale[21];                 // A.


[[0,3,7,12,17,20,21],[0,6,10,14,19,21],[0,2,9,13,15,18,21],[0,4,8,11,16,21]] @=> int denomSets[][];
[[0,1,4,9,14,18,21],[0,5,10,13,17,21],[0,6,9,12,16,21],[0,2,7,11,15,21]] @=> int numSets[][];
[[0,1,6,10,14,19,21],[0,1,2,5,9,13,15,18,21],[0,3,5,7,12,17,20,21]] @=> int moreDenomSets[][];

[[0,3,7,12,17,20,21],[0,6,10,14,19,21],[0,2,9,13,15,18,21],[0,4,8,11,16,21],[0,1,4,9,14,18,21],[0,5,10,13,17,21],[0,6,9,12,16,21],[0,2,7,11,15,21],[0,1,6,10,14,19,21],[0,1,2,5,9,13,15,18,21],[0,3,5,7,12,17,20,21]] @=> int allSets[][];

if(denomSets[0].size() == denomSets[1].size()){<<<"True.">>>;}



110 => float tonic;
44000 => int samplesPerSecond;

SndBuf whateven => blackhole;
me.dir()+"/Lawiswis Kawayan.wav" => whateven.read;
0 => whateven.pos;

now + (whateven.samples()*whateven.rate())::samp => time end;

fun void bass(int scaledegree)
{
    SinOsc basso => dac;
    0.6 => basso.gain;
    tonic*scale[scaledegree] => basso.freq;
    
    while(true)
    {
        second => now;
    }
}

fun void uppervoice(int scaledegree)
{
    SndBuf upper => Envelope env => dac;
    0.1 => upper.gain;
    2*scale[scaledegree] => upper.rate;
    
    me.dir()+"/Lawiswis Kawayan.wav" => upper.read;
    whateven.pos() - samplesPerSecond => upper.pos;
    
    0 => env.value;
    0 => int pastitsprime;
    0 => int notdeadyet;
    1 => env.target; 4.5::second => env.duration; 
    
    while(true)
    {
        10::ms => now;
        if(env.value()==1)
        {
            0 => env.target;
            0.5::second => env.duration;
            true => pastitsprime;
        }
        //if(env.value()<=0.5 && pastitsprime && notdeadyet==false)
        //{
        //    env.rate()*0.1 => env.rate;
        //    true => notdeadyet;
        //}
        if(env.value()==0 && pastitsprime)
        {
            me.exit();
        }
    }
}

//spork ~ bass(0);

0 => int counter;
0 => int setCounter;

1 => int goingup;

1::second => dur t1;

while(now < end)
{
    t1 => now;
    
    //counter => float counterPercent;
    //allSets[setCounter][allSets[setCounter].size()-1] /=> counterPercent;
    spork ~ uppervoice(numSets[setCounter][counter]);
    
    if(goingup)
    {
        if(counter == numSets[setCounter].size()-1)
        {
            setCounter++;
            numSets.size() %=> setCounter;
            //Math.random2(0,numSets.size()-1) => setCounter;
            
            false => goingup;
            numSets[setCounter].size()-1 => counter;
            counter--;
        }
        else
        {
            counter++;
        }
    }
    else
    {
        if(counter == 0)
        {
            setCounter++;
            numSets.size() %=> setCounter;
            //Math.random2(0,numSets.size()-1) => setCounter;
            
            true => goingup;
            counter++;
        }
        else
        {
            counter--;
        }
    }    
}

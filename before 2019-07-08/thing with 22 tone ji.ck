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


220 => float tonic;

0 => int counter;
0 => int setCounter;
1 => int goingup;

1 => int bassAlive;
10::second => dur bassFade;

0.11::second => dur t1;

now+3::bassFade => time end;

fun void bass(int scaledegree)
{
    SawOsc basso => Envelope env => dac;
    0.05 => basso.gain;
    tonic*scale[scaledegree] => basso.freq;
    
    0 => env.value;
    1 => env.target; bassFade => env.duration;

    while(true)
    {
        10::ms => now;
        if(now>end)
        {
            0 => env.target;
            bassFade => env.duration;
            env.duration() => now;
            me.exit();
        }
    }
}

fun void uppervoice(int scaledegree, float target, float multiplier)
{
    SinOsc upper => Envelope env => dac;
    0.025 => upper.gain;
    multiplier*tonic*scale[scaledegree] => upper.freq;
    
    0 => env.value;
    0 => int pastitsprime;
    target => env.target; 0.25::second => env.duration; 
    
    while(true)
    {
        10::ms => now;
        if(env.value()==target)
        {
            0 => env.target;
            true => pastitsprime;
        }
        if(env.value()<=0.5 && pastitsprime)
        {
            env.rate()*0.1 => env.rate;
            bassFade => now;
            me.exit();
        }
    }
}

spork ~ bass(0);

1 => float target;

while(true)
{
    t1 => now;
    spork ~ uppervoice(allSets[setCounter][counter],target,4);
    
    if(goingup)
    {
        if(counter == allSets[setCounter].size()-1)
        {
            //setCounter++;
            //allSets.size() %=> setCounter;
            Math.random2(0,allSets.size()-1) => setCounter;
            
            false => goingup;
            allSets[setCounter].size()-1 => counter;
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
            //setCounter++;
            //allSets.size() %=> setCounter;
            Math.random2(0,allSets.size()-1) => setCounter;
            
            true => goingup;
            counter++;
        }
        else
        {
            counter--;
        }
    }    
    
    if(now>end)
    {
        0.8*=>target;
    }
    
    if(target<0.0001)
    {
        me.exit();
    }
}
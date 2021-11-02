// Assignment 6: create at least 3 instruments using additive synthesis (waves upon waves)

ADSR env => Gain g => JCRev r => dac;
0.6 => g.gain;
0.1 => r.mix;

//
// An organ-like instrument

0.5::second => dur beat;

env.releaseTime(beat);

// fourths: 200, 266.6667, 355.5556, 474.0741, 632.0988, 842.7984

200 => float baseFreq;

// [ [1.0,1.0], [2.0,1.0], [3.0,1.0], [4.0,1.0] ]
// [ [1.0,4.0], [2.0,2.0], [3.0,1.0], [4.0,0.5] ]
// [ [1.0,10.0], [4.0,2.0], [6.0,2.0], [8.0,2.0] ]
// [ [1.0,2.5], [4.0,1.0], [6.0,2.0], [8.0,0.5] ]
// [ [1.0,4.0], [3.0,2.0], [5.0,1.0], [7.0,0.5] ]
// [ [1.0,8.0], [4.0,2.0], [20.0,1.0], [30.0,0.5] ]
// [ [1.0,8.0], [8.0,3.0], [6.0,2.0], [16.0,1.0] ]
// [ [1.0,8.0], [0.5,1.0], [2.5,1.0], [4.0,0.5], [5.01,0.5], [5.00,0.5] ]
// [ [1.0,8.0], [1.6,1.0], [3.9,0.5], [4.1,0.5], [5.01,0.5], [5.00,0.5] ]
// [ [1.0,8.0], [1.3,1.0], [3.9,1.0], [5.2,1.0], [8.1,8.0], [8.00,0.5] ]
// [ [1.0,8.25], [2.5,1.0], [2.56,1.0], [3.333,0.5], [5.00,0.25] ]
// [ [1.0,8.25], [2.5,1.0], [2.56,1.0], [3.333,0.5], [5.00,0.25] ]
// [ [1.0,8.25], [2.5,1.0], [2.56,1.0], [3.333,0.5], [5.00,0.25] ]
// [ [1.0,8.25], [2.5,1.0], [2.56,1.0], [3.333,0.5], [5.00,0.25] ]
[ [1.0,16.0], [1.3,1.0], [3.9,1.0], [5.2,1.0], [8.1,4.0], [8.00,0.5] ] @=> float harmonic[][];
SinOsc voice[harmonic.size()];

0.5 => float articDecimal;

while(true)
{
    newPitchSinOscArray(env, voice, harmonic, 0.5, baseFreq);
    adsrArticulation(env, beat, articDecimal::beat);
    
    newPitchSinOscArray(env, voice, harmonic, 0.5, baseFreq*1.125);
    adsrArticulation(env, beat, articDecimal::beat);
    
    newPitchSinOscArray(env, voice, harmonic, 0.5, baseFreq*1.25);
    adsrArticulation(env, beat, articDecimal::beat);
    
    newPitchSinOscArray(env, voice, harmonic, 0.5, baseFreq*1.333);
    adsrArticulation(env, beat, articDecimal::beat);
    
    newPitchSinOscArray(env, voice, harmonic, 0.5, baseFreq*1.25);
    adsrArticulation(env, beat, articDecimal::beat);
    
    newPitchSinOscArray(env, voice, harmonic, 0.5, baseFreq*1.125);
    adsrArticulation(env, beat, articDecimal::beat);
    
    //freqOrGainChanger(harmonic, 0.05, 1, 1, 0);

}

//
// a clarinet-like instrument





//
// a weird, slow-evolving instrument





fun void newPitchSinOscArray(UGen chuckee, SinOsc voice[], float harmonic[][], float gain, float newFreq)
{
    if(voice.size() == harmonic.size() && harmonic.size() != 0)
    {
        // unnecessary: 1 => float voiceSizeInv; voice.size() /=> voiceSizeInv;
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

fun void adsrArticulation(ADSR adsr, dur note, dur artic)
{
    if(note > artic)
    {
        now + note => time later;
    
        adsr.keyOn(1);
    
        artic => now;
        
        adsr.keyOff(1);
        
        later => now;
    }
    else
    {
        if(note == artic)
        {
            adsr.keyOn(1);
            note => now;
        }
        else
        {
            <<< "Cannot travel to the past!" >>>;
        }
    }
}

fun void freqOrGainChanger(float harmonic[][], float increment, int startingAtWhichHarmonic, int randomOrNo, int freqIs0GainIs1)
{
    if(freqIs0GainIs1 == 0 || freqIs0GainIs1 == 1)
    {
        if(startingAtWhichHarmonic < harmonic.size())
        {
            for(startingAtWhichHarmonic => int harmCount; harmCount < harmonic.size(); harmCount++)
            {
                if(randomOrNo)
                {
                    Math.random2f(-1*increment,increment) +=> harmonic[harmCount][freqIs0GainIs1];
                }
                else
                {
                    increment +=> harmonic[harmCount][freqIs0GainIs1];
                }
                
                if(harmonic[harmCount][freqIs0GainIs1]<=0)
                {
                    0 => harmonic[harmCount][freqIs0GainIs1];
                }
            }
        }
        else
        {
            <<< "Get outta here with that nonsense." >>>;
        }
        
    }
    else
    {
        <<< "I told you, freq is 0 and gain is 1." >>>;
    }
}
            
            
            
            
            
            
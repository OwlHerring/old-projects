// EDO.
// updating this to be static.

public class EDO 
{
    // default is 12.
    12 => static int tone;
    fun static int toneNum(){ return tone; }                                  // returns tones per octave.
    fun static float toneInv(){ return Math.pow(tone,-1); }                   // returns inverse of above.
    fun static float semi(){ return Math.pow(2, toneInv()); }                 // returns ratio of a single semitone.
    fun static float semi(int count){ return Math.pow(semi(), count); }  // returns ratio of X semitones.
    1 => static int halfstepSize;
    fun static int accidental(int halfsteps){ return halfstepSize * halfsteps; }
    
    32 => static float C0; // This is the pitch standard. (C3 is 256 Hz. A4 is (in 12tet) 432 Hz.)
    [
    0, //C
    2, //D
    4, //E
    5, //F
    7, //G
    9, //A
    11 //B
    ]
    @=> static int letterSemitones[]; // Won't with fewer than 7.
    
    [
    // Cb, Dbb, Ebb, Fb, Gb, Abb, Bbb
    [-1, -2, -2, -1, -1, -2, -2],  // 0
    // Cb, Db, Ebb, Fb, Gb, Abb, Bbb
    [-1, -1, -2, -1, -1, -2, -2],  // 1
    // Cb, Db, Ebb, Fb, Gb, Ab, Bbb
    [-1, -1, -2, -1, -1, -1, -2],  // 2
    // Cb, Db, Eb, Fb, Gb, Ab, Bbb
    [-1, -1, -1, -1, -1, -1, -2],  // 3
    // Cb, Db, Eb, Fb, Gb, Ab, Bb
    [-1, -1, -1, -1, -1, -1, -1],  // 4
    // Cb, Db, Eb, F, Gb, Ab, Bb
    [-1, -1, -1, 0, -1, -1, -1],   // 5
    // C, Db, Eb, F, Gb, Ab, Bb
    [0, -1, -1, 0, -1, 0, -1],     // 6
    // C, Db, Eb, F, G, Ab, Bb
    [0, -1, -1, 0, 0, -1, -1],     // 7
    // C, D, Eb, F, G, Ab, Bb
    [0, 0, -1, 0, 0, -1, -1],      // 8
    // C, D, Eb, F, G, A, Bb
    [0, 0, -1, 0, 0, 0, -1],       // 9
    // C, D, E, F, G, A, Bb
    [0, 0, 0, 0, 0, 0,-1],         // 10
    // C, D, E, F, G, A, B
    [0, 0, 0, 0, 0, 0, 0],         // 11
    // C, D, E, F#,G, A, B
    [0, 0, 0, 1, 0, 0, 0],         // 12
    // C#,D, E, F#,G, A, B
    [1, 0, 0, 1, 0, 0, 0],         // 13
    // C#,D, E, F#,G#,A, B
    [1, 0, 0, 1, 1, 0, 0],         // 14
    // C#,D#,E, F#,G#,A, B
    [1, 1, 0, 1, 1, 0, 0],         // 15
    // C#,D#,E, F#,G#,A#,B
    [1, 1, 0, 1, 1, 1, 0],         // 16
    // C#,D#,E#,F#,G#,A#,B
    [1, 1, 1, 1, 1, 1, 0],         // 17
    // C#,D#,E#,F#,G#,A#,B#
    [1, 1, 1, 1, 1, 1, 1],         // 18
    // C#,D#,E#,Fx,G#,A#,B#
    [1, 1, 1, 2, 1, 1, 1],         // 19
    // Cx,D#,E#,Fx,G#,A#,B#
    [2, 1, 1, 2, 1, 1, 1],         // 20
    // Cx,D#,E#,Fx,Gx,A#,B#
    [2, 1, 1, 2, 2, 1, 1],         // 21
    // Cx,Dx,E#,Fx,Gx,A#,B#
    [2, 2, 1, 2, 2, 1, 1]          // 22
    ]
    @=> static int keySig[][]; // keySig[11] is the key of C. 
    11 => static int CMajor => static int key;
    fun static void setKey(int newKey){ if(newKey >= -11 && newKey <= 11){ newKey + CMajor => key; } else{ <<<"Wrong again.">>>; } } // this way, setKey(0) sets it at C Major. The only inputs acceptable are from -11 to 11. Anything less or more would yield an error, so it's off limits.
    fun static int readKey(){ return key - CMajor; } // returns positions on the circle of fifths away from C Major.
    
    [0, 0, 0, 0, 0, 0, 0] @=> static int chromAlt[]; // NOTE: chromAlt is in chromatic semitones and alters the major scale of each key, while keySig is in diatonic semitones and modifies CDEFGAB no matter what. 
    fun static int tonic() // this returns the pitch class tonic of the current major key. In order to synchronize with above.
    {
        //     pitch class of:           4 (that is, a fifth) times the number of fifths above or below C Major. (octave equivalence) (0 means it's the modulus function)
        return Ini.modPlus(    Std.ftoi( 4                    *readKey()),                                       letterSemitones.size(),0);
    }
    fun static int tonicMinor() { return tonic() - 2; } // this doesn't do modulus, be warned.
    fun static void setChromAlt(int newChromAlt[])
    {
        for(0 => int chromAltCount; chromAltCount < chromAlt.size() && chromAltCount < newChromAlt.size(); chromAltCount++)
        {
            newChromAlt[chromAltCount] => chromAlt[chromAltCount];
        }
    }
    
    
    //  returns, in Hertz: (x octaves times EDO, plus distance between white keys, plus chromatic alterations to the major scale, plus diatonic alterations to CDEFGAB) semitones above C0.
    fun static float C(int oct, int acci){ return C0 * semi(tone*oct + letterSemitones[0] + chromAlt[Ini.modPlus(tonic()-0,letterSemitones.size(),0)] + accidental(acci + keySig[key][0])); }
    fun static float C(int oct)          { return C(oct, 0); }
    fun static float D(int oct, int acci){ return C0 * semi(tone*oct + letterSemitones[1] + chromAlt[Ini.modPlus(tonic()-1,letterSemitones.size(),0)] + accidental(acci + keySig[key][1])); }
    fun static float D(int oct)          { return D(oct, 0); }
    fun static float E(int oct, int acci){ return C0 * semi(tone*oct + letterSemitones[2] + chromAlt[Ini.modPlus(tonic()-2,letterSemitones.size(),0)] + accidental(acci + keySig[key][2])); }
    fun static float E(int oct)          { return E(oct, 0); }
    fun static float F(int oct, int acci){ return C0 * semi(tone*oct + letterSemitones[3] + chromAlt[Ini.modPlus(tonic()-3,letterSemitones.size(),0)] + accidental(acci + keySig[key][3])); }
    fun static float F(int oct)          { return F(oct, 0); }
    fun static float G(int oct, int acci){ return C0 * semi(tone*oct + letterSemitones[4] + chromAlt[Ini.modPlus(tonic()-4,letterSemitones.size(),0)] + accidental(acci + keySig[key][4])); }
    fun static float G(int oct)          { return G(oct, 0); }
    fun static float A(int oct, int acci){ return C0 * semi(tone*oct + letterSemitones[5] + chromAlt[Ini.modPlus(tonic()-5,letterSemitones.size(),0)] + accidental(acci + keySig[key][5])); }
    fun static float A(int oct)          { return A(oct, 0); }
    fun static float B(int oct, int acci){ return C0 * semi(tone*oct + letterSemitones[6] + chromAlt[Ini.modPlus(tonic()-6,letterSemitones.size(),0)] + accidental(acci + keySig[key][6])); }
    fun static float B(int oct)          { return B(oct, 0); }
    
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
    fun static float dia(int letter, int oct, int acci) // if you want easy transposing, define the melody in terms of tonic() + x.
    {
        //     C0 in Hz times the following semitones: [semitones per octave] times (the sum of [octaves above 0] and any extra octaves (from inputting 8 diatonic steps or something)), plus the semitone value of the inputted diatonic steps (mod diatonic scale size),  plus designated chromatic alteration of any given step (same as previous),            plus accidental modifier based on key signature                                                       and any additional accidental beyond that.
        return C0       *     semi(                    tone                   *     (oct                          +   Ini.modPlus(letter,letterSemitones.size(),1))                      +    letterSemitones[    Ini.modPlus(letter, letterSemitones.size(),0)]            + chromAlt[                             Ini.modPlus(letter-tonic(), letterSemitones.size(),0)] +    accidental(                  keySig[key][Ini.modPlus(letter, letterSemitones.size(),0)] +  acci)                                );
    }
    fun static float dia(int letter, int oct)
    {
        return dia(letter, oct, 0);
    }
    
    fun static float chrom(int semitoneCount) {return C(0, semitoneCount);} // same as using C(0, acci). Just for clarity.
    
    fun static void setup(int newTone, int newHalfstepSize, int newLetters[])
    {
        newTone => tone;
        newHalfstepSize => halfstepSize;
        for(0 => int letterCount; letterCount < letterSemitones.size(); letterCount++)
        {
            newLetters[letterCount%newLetters.size()] => letterSemitones[letterCount]; 
        }
    }
}
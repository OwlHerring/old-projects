public class Initial // this'll be where any useful function goes.
{
    // update with other folders in the project.
    [
    me.dir(),                   // 0
    me.dir() + "/public/",      // 1
    me.dir() + "/public/instr/"// 2
    ]
    @=> static string S[];
    
    // adds the following: "[directory specified in array S]/[integer 'which', converted to a string of a certain number of digits].ck".
    fun int add(int folder, int which, int digits)
    {
        return Machine.add(S[folder] + itoaDigits(which, digits) + ".ck");
    }
    fun int add(int folder, int which)
    { 
        return add(folder, which, 2); // if unspecified, assumed to be 2 digits long
    }
    fun int add(int folder, string filenameNoCK)
    {
        return Machine.add(S[folder] + filenameNoCK + ".ck");
    }
    
    fun string itoaDigits(int Int, int digits) 
    {
        Std.itoa(Int) => string myS;
        if(myS.length() > digits)
        {
            myS.length() - digits => int newPos;
            return myS.substring(newPos);
        }
        else if(myS.length() == digits)
        {
            return myS;
        }
        else // if less
        {
            while(myS.length() < digits)
            {
                "0" + myS => myS;
            }
            return myS;
        }
    }
    
    // This event will be signaled at the end of each play.ck. Note that Initial objects must not be instantiated anywhere other than in initialize.ck. Or it'll mess up.
    static Event @ end;
    new Event @=> end;
    fun static void signal(){end.signal();} fun static void broadcast(){end.broadcast();}
    
}




Initial ini;

// The ability to read how many files are in a folder doesn't seem to be native to ChucK. So this continues until it can't.

// do Machine.add for files in "[dir]/public/...", starting from 00.ck to 01.ck to whatever ##.ck that doesn't exist. 
for(0 => int addCount; addCount < 100; addCount++) 
{
    if(!ini.add(1, addCount)) { break; }
}

// do Machine.add for files in "[dir]/public/instr/...", starting from 00.ck to 01.ck to whatever ##.ck that doesn't exist. 
for(0 => int addCount; addCount < 100; addCount++) 
{
    if(!ini.add(2, addCount)) { break; }
}

<<< "Initialization successful. Now playing music." >>>;





// This will be where files from given pieces are added.
// Each piece's folder name (within /pieces/):
[
"first",
"number two" // names to emphasize that the name doesn't matter unlike with the public/##.ck files.
]
@=> string names[];

// a little buffer between each piece.
second => dur buffer;

for(0 => int nameCount; nameCount<names.size(); nameCount++)
{
    buffer => now;
    
    <<< "Now playing '" + names[nameCount] + "'." >>>; 
    if(!ini.add(0, "pieces/" + names[nameCount] + "/play")) { <<< "wait shit lol nvm" >>>; me.exit(); };
    
    ini.end => now;
}

<<< "End of playback." >>>;
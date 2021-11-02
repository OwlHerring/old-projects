fun int forloopMaybe(int count)
{ 
    if(count == 0) return 0;
        else if(count == 1) return 1;
            else if(count > 1) return maybe;
}
fun int forloopRandom2(int count, int floor, int cap)
{
    if(count == 0) return floor;
        else if(count == 1) return cap;
            else if(count > 1) return Math.random2(floor, cap);
}
fun float forloopRandom2f(int count, float floor, float cap)
{
    if(count == 0) return floor;
        else if(count == 1) return cap;
            else if(count > 1) return Math.random2f(floor, cap);
}
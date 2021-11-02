// safeGFirst.
// note: to input something with multiple channels into safeGFirst (like Pan2 or a reverb),
//       [incomingUGen].chan(0) => safeGFirst l => dac.left;
//       [incomingUGen].chan(1) => safeGFirst r => dac.right;
public class safeGFirst extends Chubgraph
{
    inlet => Gain safeG => Dyno safeD => outlet; 
    .5 => float maxAmp;
    safeG.gain(maxAmp);
    safeD.thresh(maxAmp);
    safeD.slopeBelow(1.0);
    safeD.slopeAbove(0.0);
}
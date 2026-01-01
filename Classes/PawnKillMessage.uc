//=============================================================================
// PawnKillMessage.uc
//=============================================================================
class PawnKillMessage extends Mutator;

function PostBeginPlay()
{
    local PawnKillRules R;

    Super.PostBeginPlay();

    R = Spawn(class'PawnKillRules');
    if( Level.Game.GameRules==None )
        Level.Game.GameRules = R;
    else Level.Game.GameRules.AddRules(R);
}

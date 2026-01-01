//=============================================================================
// PawnKillRules
// Unreal 227 GameRules
//=============================================================================
class PawnKillRules extends GameRules config(PawnKillRules);

// --------------------
// Configurable flags
// --------------------
var() bool bLogKills;                   // default: false
var() bool bDebug;                      // default: false

function PostBeginPlay()
{
    Super.PostBeginPlay();

    if (bDebug)
    {
        Log("### " @ self @ ": loaded and active ###");
        Log("  bLogKills                  =" @ bLogKills);
    }
}

function NotifyKilled(Pawn Victim, Pawn Killer, name DamageType)
{
    local string BroadcastMsg;
    local string ClientMsg;
    local string WeaponUsed;
    local string VictimClassStr;

    if (Victim == None || !Victim.IsA('ScriptedPawn'))
        return;

    if (Killer != None
        && Killer.bIsPlayer
        && Killer.PlayerReplicationInfo != None)
    {
        // Weapon detection safety
        if (Killer.Weapon == None || Killer.Weapon.ItemName == "")
        {
            WeaponUsed = "";
        }
        else
        {
            WeaponUsed = " with "
                $ Killer.Weapon.ItemArticle
                $ " "
                $ Killer.Weapon.ItemName;
        }

        VictimClassStr = " (" $ Victim.Class $ ")";

        // --------------------
        // Broadcast message
        // --------------------
        BroadcastMsg =
            Killer.GetHumanName()
            $ " killed "
            $ Victim.NameArticle
            $ Victim.MenuName
            $ VictimClassStr
            $ WeaponUsed;

        Level.Game.BroadcastMessage(BroadcastMsg, false);

        // --------------------
        // Client-only message
        // --------------------
        ClientMsg =
            "You killed "
            $ Victim.NameArticle
            $ Victim.MenuName;

        Killer.ClientMessage(ClientMsg, 'CriticalEvent');

        // --------------------
        // Optional logging
        // --------------------
        if (bDebug && bLogKills)
        {
            Log(
                "KillRules:"
                @ Killer.GetHumanName()
                @ "killed"
                @ Victim.Class
            );
        }
    }
}


defaultproperties
{
bLogKills=false
bDebug=false
bNotifyLogin=true
bNotifySpawnPoint=true
bNotifyRules=true
bNotifyMessages=true
bModifyDamage=true
bHandleDeaths=true
}
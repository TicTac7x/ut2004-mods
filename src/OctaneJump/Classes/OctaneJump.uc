class OctaneJump extends Mutator;

function preBeginPlay() {
	super.preBeginPlay();
	level.game.playerControllerClassName="OctaneJump.OctaneJumpPlayer";
}

defaultproperties {
	groupName="Jumping"
	friendlyName="OctaneJump"
	description="Double jump whenever you want."
}
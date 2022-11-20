class SpawnManagerGameRules extends GameRules;

var SpawnManager spawnManager;

event postBeginPlay() {
	super.postBeginPlay();
	spawnManager = SpawnManager(owner);
}

function bool preventDeath(Pawn killed, Controller killer, class<DamageType> damageType, vector hitLocation) {
	// Prevent death should have its original checks.
	if (
		killed == NONE ||
		killer == NONE ||
		killed.controller != killer ||
		killed.isA('Monster') ||
		PlayerController(killed.controller).player == NONE
	) {
		return super.preventDeath(killed, killer, damageType, hitLocation);
	}

	// Prevent death and teleport to checkpoint if one exists.
	if (spawnManager.getPlayerCheckpointsCount(killed.controller) > 0) {
		spawnManager.teleportToCheckpoint(killed.controller);
		killed.health = killed.default.health;
		return true;
	}

	// Player had no checkpoints.
	return super.preventDeath(killed, killer, damageType, hitLocation);;
}

/**
 * Prevent server of player pawns, so they dont have amputated body parts when teleporting to checkpoint.
 */
function bool preventSever(Pawn killed, Name boneName, int damage, class<DamageType> damageType) {
	if (
		killed == NONE ||
		killed.isA('Monster') ||
		PlayerController(killed.controller).player == NONE
	) {
		return super.preventSever(killed, boneName, damage, damageType);
	}

	return true;
}
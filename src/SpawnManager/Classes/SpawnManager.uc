class SpawnManager extends Mutator;

struct Checkpoint {
	var int playerId;
	var Vector location;
	var Rotator rotation;
	var bool behindView;
};

var bool interactions;
var array<Checkpoint> checkpoints;
var SpawnManagerGameRules gameRules;

event postBeginPlay() {
	super.postBeginPlay();

	gameRules = spawn(Class'SpawnManager.SpawnManagerGameRules', self);
    level.game.addGameModifier(gameRules);
}
 
simulated function tick(float deltaTime) {
	local PlayerController playerController;

	if (!interactions) {
		playerController = level.getLocalPlayerController();

		if (playerController != none) {
			playerController.player.interactionMaster.addInteraction("SpawnManager.SpawnManagerInteraction", playerController.player);
			interactions = true;
		}
	}
}

function mutate(string command, PlayerController playerController) {
	if (command == "SpawnManager.AddCheckpoint") {
		addCheckpoint(playerController);
	} else if (command == "SpawnManager.RemoveCheckpoint") {
		removeCheckpoint(playerController);
	} else if (command == "SpawnManager.TeleportCheckpoint") {
		teleportToCheckpoint(playerController);
	}
}

function addCheckpoint(PlayerController playerController) {
	local int j;

	if (playerController == NONE || playerController.pawn == NONE || playerController.playerReplicationInfo.bIsSpectator) {
		return;
	}

	j = checkpoints.length;
	checkpoints.Insert(j, 1);

	checkpoints[j].playerId = playerController.playerReplicationInfo.playerId;
	checkpoints[j].location = playerController.pawn.location;
	checkpoints[j].rotation = playerController.rotation;
	checkpoints[j].behindView = playerController.bBehindView;

	sendMessage(playerController, "Add Checkpoint" @ getPlayerCheckpointsCount(playerController));
}

function removeCheckpoint(Controller controller) {
	local int i;

	if (controller == NONE || controller.pawn == NONE || controller.playerReplicationInfo.bIsSpectator) {
		return;
	}

	for (i = checkpoints.length - 1; i >= 0; i--) {
		if (checkpoints[i].playerId == controller.playerReplicationInfo.playerId) {
			checkpoints.remove(i, 1);
			sendMessage(controller, "Remove Checkpoint" @ getPlayerCheckpointsCount(controller) + 1);
			return;
		}
	}

	sendMessage(controller, "No Checkpoints.");
}

function bool teleportToCheckpoint(Controller controller) {
	local PlayerController playerController;
	local int i;

	if (controller == NONE || controller.pawn == NONE || controller.playerReplicationInfo.bIsSpectator) {
		return false;
	}

	for (i = checkpoints.length - 1; i >= 0; i--) {
		if (checkpoints[i].playerId == controller.playerReplicationInfo.playerId) {
			playerController = PlayerController(controller);
			playerController.pawn.velocity = vect(0,0,0);
			PlayerController.pawn.setLocation(checkpoints[i].location);
			playerController.pawn.playTeleportEffect(false, true);
			playerController.clientSetRotation(checkpoints[i].rotation);
			playerController.behindView(checkpoints[i].behindView);

			sendMessage(playerController, "Checkpoint" @ getPlayerCheckpointsCount(playerController));
			return true;
		}
	}

	sendMessage(controller, "No Checkpoints.");
	return false;
}

function int getPlayerCheckpointsCount(Controller controller) {
	local int count, i;
	count = 0;

	for (i = 0; i < checkpoints.length; i++) {
		if (checkpoints[i].playerId == controller.playerReplicationInfo.playerId) {
			count++;
		}
	}

	return count;
}

function sendMessage(Controller controller, string message) {
	local PlayerController playerController;
	
	playerController = PlayerController(controller);
	playerController.clientMessage(message);
}
 
defaultproperties {
	remoteRole = ROLE_SimulatedProxy
	bAlwaysRelevant = true
}
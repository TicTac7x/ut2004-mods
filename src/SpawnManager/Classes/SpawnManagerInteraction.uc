class SpawnManagerInteraction extends Interaction;

var private float Delay;

function bool keyEvent(EInputKey key, EInputAction action, FLOAT delta ) {
	local string keyalias;

	keyalias = viewportOwner.actor.consoleCommand("KEYNAME"@key);
	keyalias = viewportOwner.actor.consoleCommand("KEYBINDING"@keyalias);

	if (action == IST_Press && (
		keyalias == "SpawnManager.AddCheckpoint" ||
		keyalias == "SpawnManager.RemoveCheckpoint" ||
		keyalias == "SpawnManager.TeleportCheckpoint"
	)) {
		return serverCommand(keyalias);
	}

	if (key == IK_Insert) {
		return serverCommand("SpawnManager.AddCheckpoint");
	} else if (key == IK_Delete) {
		return serverCommand("SpawnManager.RemoveCheckpoint");
	} else if (key == IK_Home) {
		return serverCommand("SpawnManager.TeleportCheckpoint");
	}
 
	return false;
}

function bool serverCommand(string command) {
	if (delay > viewportOwner.actor.level.timeSeconds) {
		return false;
	}

	delay = viewportOwner.actor.level.timeSeconds + 0.1;
	viewportOwner.actor.serverMutate(command);
	return true;
}

defaultproperties {
	bActive = true
}
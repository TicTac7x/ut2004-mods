class OctanePawn extends xPawn;

function bool dodge(eDoubleClickDir doubleClickMove) {
	return octaneDodge(doubleClickMove);
}

function bool octaneDodge(eDoubleClickDir doubleClickMove) {
	if (multiJumpRemaining == 1) {
		multiJumpRemaining--;
	}
	
	return super.dodge(doubleClickMove);
}

function bool doJump(bool bUpdating) {
	if (multiJumpRemaining == 1) {
		multiJumpRemaining--;
		return super.doJump(bUpdating);
	} else {
		return OctaneJump(bUpdating);
	}
}

function bool octaneJump(bool bUpdating) {
	// Jump disabled check.
	if (
		bIsCrouched ||
		bWantsToCrouch ||
		(physics != PHYS_Walking && physics != PHYS_Falling) ||
		multiJumpRemaining < 0
	) {
		return false;
	}

	if (role == ROLE_Authority) {
		// Original noise code.
		if (level.game != NONE && level.game.gameDifficulty > 2) {
			makeNoise(0.1 * level.game.gameDifficulty);
		}

		// Original inventory event.
		if (bCountJumps && inventory != None) {
			inventory.ownerEvent('Jumped');
		}
	}

	// Actual jump physics.
	if (physics == PHYS_Spider) {
		velocity = jumpZ * floor;
	} else if (physics == PHYS_Ladder) {
		velocity.z = 0;
	} else if (bIsWalking) {
		velocity.z = default.jumpZ;
	// Default jump.
	} else {
		velocity.z = jumpZ;
	}

	// Add Z velocity from Base.
	if (base != None && !base.bWorldGeometry) {
		velocity.Z += base.velocity.Z;
	}

	// Set player a falling after every jump to start reducing velocity.
	setPhysics(PHYS_Falling);

	// Grunt sound.
	if (!bUpdating) {
		playOwnedSound(GetSound(EST_Jump), SLOT_Pain, GruntVolume,,80);
	}

	// Reduce jumps remaining.
	multiJumpRemaining--;
}
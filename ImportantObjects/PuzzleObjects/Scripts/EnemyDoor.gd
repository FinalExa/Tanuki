class_name EnemyDoor
extends PuzzleObject

var activatedBy: Array[EnemyController]

func AddActivator(activator: EnemyController):
	if (!activatedBy.has(activator)):
		activatedBy.push_back(activator)
		if (self.activated): call_deferred("Deactivation")

func RemoveActivator(activator: EnemyController):
	if (activatedBy.has(activator)):
		activatedBy.erase(activator)
		if (activatedBy.size() == 0): call_deferred("Activation")

func GuardIn(ref):
	if (ref is GuardController):
		AddActivator(ref)

func GuardOut(ref):
	if (ref is GuardController):
		RemoveActivator(ref)

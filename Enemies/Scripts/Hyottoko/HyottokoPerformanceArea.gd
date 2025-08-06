class_name HyottokoPerformanceArea
extends Area2D

@export var doorToActivate: EnemyDoor
var currentHyottoko: HyottokoController

func HyottokoEnter(ref):
	if (currentHyottoko == null && ref is HyottokoController):
		ref.hyottokoEntranced.SetEntranced(self)
		if (ref.isEntranced):
			currentHyottoko = ref
			doorToActivate.AddActivator(currentHyottoko)

func HyottokoExit(ref):
	if (ref is HyottokoController && currentHyottoko == ref):
		currentHyottoko.hyottokoEntranced.UnsetEntranced()
		doorToActivate.RemoveActivator(currentHyottoko)
		currentHyottoko = null

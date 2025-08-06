class_name HyottokoPerformanceArea
extends Area2D

var currentHyottoko: HyottokoController
var doorToActivate

func HyottokoEnter(ref):
	if (currentHyottoko != null && ref is HyottokoController):
		currentHyottoko = ref
		currentHyottoko.hyottokoEntranced.SetEntranced()

func HyottokoExit(ref):
	if (ref is HyottokoController && currentHyottoko == ref):
		currentHyottoko.hyottokoEntranced.UnsetEntranced()
		currentHyottoko = null

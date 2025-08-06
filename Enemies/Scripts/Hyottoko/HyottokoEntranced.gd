class_name HyottokoEntranced
extends Node

@export var hyottokoController: HyottokoController
var performanceAreas: Array[HyottokoPerformanceArea]

func SetEntranced():
	hyottokoController.isEntranced = true

func UnsetEntranced():
	hyottokoController.isEntranced = false

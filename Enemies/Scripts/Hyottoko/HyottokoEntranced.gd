class_name HyottokoEntranced
extends Node

@export var hyottokoController: HyottokoController
@export var entrancedText: String
var performanceArea: HyottokoPerformanceArea

func SetEntranced(receivedArea: HyottokoPerformanceArea):
	if (hyottokoController.isReachingPoint && !hyottokoController.isEntranced):
		hyottokoController.isEntranced = true
		performanceArea = receivedArea
		hyottokoController.InterruptAttacks()
		hyottokoController.hyottokoReachPoint.StopReachingPoint()
		hyottokoController.enemyPatrol.stop_patrol()
		hyottokoController.enemyMovement.set_location_target(performanceArea.global_position)
		hyottokoController.enemyStatus.text = entrancedText

func UnsetEntranced():
	if (hyottokoController.isEntranced):
		hyottokoController.isEntranced = false
		performanceArea = null
		hyottokoController.enemyPatrol.resume_patrol()
		hyottokoController.enemyStatus.text = ""

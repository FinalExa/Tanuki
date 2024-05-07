class_name KeyAttack
extends TransformObjectAttack

func ExtraReadyOperations():
	SetAttackTagBasedOffName()
	SetAttackTag()

func SetAttackTagBasedOffName():
	attackTag = self.get_parent().currentTransformationName

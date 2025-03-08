class_name Blade
extends Area2D

const FORCE = 100.0


func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body is not Octopus: return

	var body_shape_owner_id = body.shape_find_owner(body_shape_index)
	var body_shape_owner = body.shape_owner_get_owner(body_shape_owner_id)
	var body_shape_2d = body.shape_owner_get_shape(body_shape_owner_id, 0)
	var body_global_transform = body_shape_owner.global_transform
	
	var area_shape_owner_id = shape_find_owner(local_shape_index)
	var area_shape_owner = shape_owner_get_owner(area_shape_owner_id)
	var area_shape_2d = shape_owner_get_shape(area_shape_owner_id, 0)
	var area_global_transform = area_shape_owner.global_transform
	
	var collision_points = area_shape_2d.collide_and_get_contacts(area_global_transform,
									body_shape_2d,
									body_global_transform)
	print(collision_points)
	if len(collision_points) == 2:
		var direction = collision_points[1] - collision_points[0]
		var force = direction.normalized() * FORCE
		body.velocity = force
		

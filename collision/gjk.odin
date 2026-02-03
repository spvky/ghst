package collision

import "core:math"
import l "core:math/linalg"

Vec3 :: [3]f32

Collider :: union {
	Collision_Sphere,
	Collision_Poly,
}


Collision_Poly :: struct {
	points: [8]f32,
}

Collision_Sphere :: struct {
	center: Vec3,
	radius: f32,
}

support :: proc(c1, c2: Collider, d: Vec3) -> (point: Vec3) {
	a := max_in_direction(c1, d)
	b := max_in_direction(c2, d)
	point = a - b
	return
}

max_in_direction :: proc(collider: Collider, d: Vec3) -> (point: Vec3) {
	switch s in collider {
	case Collision_Sphere:
		point = s.center + (s.radius * d)
	case Collision_Poly:
		max_dot := -math.F32_MAX
		for i in 0 ..< 8 {
			dot := l.dot(s.points[i], d)
			if dot > max_dot {
				point = s.points[i]
			}
		}
	}
	return
}

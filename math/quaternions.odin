package ghst_math

import m "core:math"
import l "core:math/linalg"

Vec2 :: [2]f32

Vec3 :: [3]f32

VEC_0: Vec3 : {0, 0, 0}
VEC_1: Vec3 : {1, 1, 1}
VEC_X: Vec3 : {1, 0, 0}
VEC_Y: Vec3 : {0, 1, 0}
VEC_Z: Vec3 : {0, 0, 1}

Quat :: l.Quaternionf32

Sphere :: struct {
	center: Vec3,
	radius: Vec2,
}

// Returns a quaternion from `origin` looking at `target`, only rotating on the y-axis
look_at_point_raw :: proc(origin, target: Vec3) -> Quat {
	forward := l.normalize0(target - origin)
	half_angle := m.acos(l.dot(VEC_Z, forward)) * 0.5
	axis := l.normalize0(l.cross(VEC_Z, forward))
	qi := axis * m.sin(half_angle)
	return transmute(Quat)[4]f32{qi.x, qi.y, qi.z, m.cos(half_angle)}
}

// Returns a quaternion from `origin` looking at `target` with an up vector of `up_vector`
look_at_point :: proc(origin, target: Vec3, up_vector: Vec3 = VEC_Y) -> Quat {
	forward := l.normalize0(target - origin)
	up := l.normalize0(forward - up_vector * forward.y)

	pitch, yaw := l.QUATERNIONF32_IDENTITY, l.QUATERNIONF32_IDENTITY
	// yaw
	if up.x != 0 {
		half_angle_yaw := m.acos(l.dot(VEC_Z, up)) * 0.5
		rot_axis := forward.x > 0 ? VEC_Y : -VEC_Y
		//Quat axes
		qa := rot_axis * m.sin(half_angle_yaw)
		yaw = transmute(Quat)[4]f32{qa.x, qa.y, qa.z, m.cos_f32(half_angle_yaw)}
	} else if up.z < 0 {
		yaw = transmute(Quat)[4]f32{0, m.sin_f32(m.PI * 0.5), 0, m.cos_f32(m.PI * 0.5)}
	}
	// pitch
	if forward.y != 0 {
		if l.length2(up) != 0 {
			half_angle_pitch := m.acos(l.dot(forward, up)) * 0.5
			rot_axis := forward.y < 0 ? VEC_X : -VEC_X
			//Quat axes
			qa := rot_axis * m.sin(half_angle_pitch)
			pitch = transmute(Quat)[4]f32{qa.x, qa.y, qa.z, m.cos_f32(half_angle_pitch)}
		} else {
			pitch = transmute(Quat)[4]f32{m.sin_f32(m.PI * 0.25), 0, 0, m.cos_f32(m.PI * 0.25)}
		}
	}
	return yaw * pitch
}

// Returns a lateral (x,0,z) vector given `quaternion` and `input_vector`
interpolate_lateral_vector :: proc(quaternion: Quat, input_vector: Vec2) -> Vec3 {
	vec := l.normalize0(Vec3{input_vector.x, 0, input_vector.y})
	right, forward: Vec3
	right = l.normalize0(l.quaternion_mul_vector3(quaternion, VEC_X))
	forward = l.normalize0(l.quaternion_mul_vector3(quaternion, VEC_Z))
	interpolated_vec: Vec3 = (forward * vec.z) + (right * vec.x)
	interpolated_vec.y = 0
	return l.normalize0(interpolated_vec)
}

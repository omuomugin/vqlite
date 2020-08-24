module util

pub fn s_to_u32(str string) ?u32 {
	if str == '0' {
		return 0
	}
	parsed_int := str.u32()
	// when failed parse, `str.u32()` will return 0
	if parsed_int == 0 {
		return error("string parsing to u32 failed \'$str\'")
	}
	return parsed_int
}

package day5

import "core:fmt"
import "core:os/os2"
import "core:strconv"
import "core:strings"
import "core:time"

TEST :: 
"1-4\r\n" + 
"2-3\r\n" + 
"\r\n"

main :: proc() {
	data, _ := os2.read_entire_file("./input.txt", context.allocator)

	text := string(data)
	// text := TEST

	now := time.tick_now()
	p1 := part1(text)
	fmt.println(time.tick_since(now), p1)
	now = time.tick_now()
	p2 := part2(text)
	fmt.println(time.tick_since(now), p2)
}

Range :: struct {
	min, max: int,
}

part1 :: proc(text: string) -> int {
	goals := text
	ranges_str, _ := strings.split_iterator(&goals, "\r\n\r\n")

	ranges: [dynamic]Range
	for line in strings.split_lines_iterator(&ranges_str) {
		length: int
		min, _ := strconv.parse_int(line, 10, &length)
		max, _ := strconv.parse_int(line[length + 1:], 10)
		append(&ranges, Range{min, max})
	}

	good_total := 0

	for line in strings.split_lines_iterator(&goals) {
		num := strconv.parse_int(line, 10) or_continue
		good := false
		for range in ranges {
			if num >= range.min && num <= range.max {
				good = true
				break
			}
		}

		if good {
			good_total += 1
		}
	}
	return good_total
}

part2 :: proc(text: string) -> int {
	ranges_str := text[:strings.index(text, "\r\n\r\n")]

	ranges: [dynamic]Range
	for line in strings.split_lines_iterator(&ranges_str) {
		length: int
		min, _ := strconv.parse_int(line, 10, &length)
		max, _ := strconv.parse_int(line[length + 1:], 10)
		assert(min != 0 && max != 0) // 0-value is still useful
		append(&ranges, Range{min, max})
	}

	for &my in ranges {
		for &your in ranges {
			assert(my.min != 0 && my.max != 0)
			if &my == &your {
				continue
			}

			if my == your {
				my = {}
				break
			}

			if my.min >= your.min && my.max <= your.max {
				my = {}
				break
			} else if my.min < your.min && my.max > your.max {
			    continue
			}else if my.max >= your.min && my.min < your.min {
				my.max = your.min - 1
			} else if my.min <= your.max && my.max > your.max {
				my.min = your.max + 1
			}
		}
	}

	good := 0

	for range in ranges do if range != {} {
		assert(range.max != 0 && range.min != 0)
		good += range.max - range.min + 1
	}

	return good
}


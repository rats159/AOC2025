package day1

import "core:fmt"
import "core:os/os2"
import "core:strconv"
import "core:strings"

main :: proc() {
	data, _ := os2.read_entire_file("./input.txt", context.allocator)
	text := string(data)

	fmt.println(part1(text))
	fmt.println(part2(text))
}

part1 :: proc(text: string) -> int {
	text := text

	current := 50
	passcode := 0

	for line in strings.split_lines_iterator(&text) {
		value, _ := strconv.parse_int(line[1:])
		direction := 1 if line[0] == 'R' else -1

		current += value * direction
		current %%= 100

		if current == 0 {
			passcode += 1
		}
	}

	return passcode
}

part2 :: proc(text: string) -> int {
	text := text

	current := 50
	passcode := 0

	for line in strings.split_lines_iterator(&text) {
		value, _ := strconv.parse_int(line[1:])
		direction := 1 if line[0] == 'R' else -1

		starting := current
		current += value * direction

		for i := starting; i != current; i += direction {
			if i % 100 == 0 {
				passcode += 1
			}
		}

		current %%= 100
	}

	return passcode
}

package day3

import "core:time"
import "core:fmt"
import "core:os/os2"
import "core:strings"

TEST :: `987654321111111
811111111111119
234234234234278
818181911112111`


main :: proc() {
	data, _ := os2.read_entire_file("input.txt", context.allocator)
	text := string(data)
	
	now := time.tick_now()
	p1 := part1(text)
	fmt.println(time.tick_since(now), p1)
	now = time.tick_now()
	p2 := part2(text)
	fmt.println(time.tick_since(now), p2)
}

part1 :: proc(text: string) -> int {
	text := text
	total := 0

	for line in strings.split_lines_iterator(&text) {
		total += find(line, 2)
	}

	return total
}

part2 :: proc(text: string) -> int {
	text := text
	total := 0

	for line in strings.split_lines_iterator(&text) {
		total += find(line, 12)
	}

	return total
}

find :: proc(line: string, size: int) -> int {
	joltage: int
	start := 0
	for i in 0 ..< size {
		max: rune
		max_idx := 0
		for outer, n in line[start:len(line) - size + i + 1] {
			if outer > max {
				max = outer
				max_idx = n + start
			}
		}
		start = max_idx + 1
		joltage *= 10
		joltage += int(max - '0')
	}
	return joltage
}


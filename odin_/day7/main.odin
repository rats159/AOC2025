package day7

import "core:fmt"
import "core:os/os2"
import "core:slice"
import "core:strings"
import "core:time"

TEST :: `.......S.......
...............
.......^.......
...............
......^.^......
...............
.....^.^.^.....
...............
....^.^...^....
...............
...^.^...^.^...
...............
..^...^.....^..
...............
.^.^.^.^.^...^.
...............`


main :: proc() {
	data, _ := os2.read_entire_file("input.txt", context.allocator)
	text := string(data)
	// text := TEST

	now := time.tick_now()
	p1 := part1(strings.clone(text))
	fmt.println(time.tick_since(now), p1)
	now = time.tick_now()
	p2 := part2(strings.clone(text))
	fmt.println(time.tick_since(now), p2)
}

part1 :: proc(text: string) -> int {
	lines := transmute([][]u8)(strings.split_lines(text))
	s, _ := slice.linear_search(lines[0], 'S')
	lines[1][s] = '|'
	total := 0
	for line := 2; line < len(lines); line += 1 {
		for row in 0 ..< len(lines[0]) {
			if lines[line - 1][row] == '|' {
				if lines[line][row] == '.' {
					lines[line][row] = '|'
				} else if lines[line][row] == '^' {
					lines[line][row + 1] = '|'
					lines[line][row - 1] = '|'
					total += 1
				}
			}

		}
	}
	return total
}

part2 :: proc(text: string) -> int {
	lines := transmute([][]u8)(strings.split_lines(text))
	s, _ := slice.linear_search(lines[0], 'S')
	lines[1][s] = '|'
	places: map[[2]int]int
	places[{s, 1}] = 1
	for line := 2; line < len(lines); line += 1 {
		for row in 0 ..< len(lines[0]) {
			if lines[line][row] == '^' {
				places[{row - 1, line}] += places[{row, line - 1}]
				places[{row + 1, line}] += places[{row, line - 1}]
			} else {
				places[{row, line}] += places[{row, line - 1}]
			}
		}
	}


	total := 0
	for row in 0 ..< len(lines[0]) {
		total += places[{row, len(lines) - 1}]
	}

	return total
}


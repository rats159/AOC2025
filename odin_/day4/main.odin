package day4

import "core:time"
import "core:fmt"
import "core:os/os2"
import "core:strings"

main :: proc() {
	data, _ := os2.read_entire_file("./input.txt", context.allocator)

	text := string(data)
	now := time.tick_now()
	p1 := part1(text)
	fmt.println(time.tick_since(now), p1)
	now = time.tick_now()
	p2 := part2(text)
	fmt.println(time.tick_since(now), p2)
}

NEIGHBORS :: [8][2]int{{1, 1}, {1, 0}, {1, -1}, {0, 1}, {0, -1}, {-1, 1}, {-1, 0}, {-1, -1}}

// Expects CRLF, picky about trailing newlines
part1 :: proc(text: string) -> int {
	height := strings.count(text, "\n") + 1
	width := len(text[:strings.index(text, "\n")]) - 1

	good := 0

	for y in 0 ..< height {
		for x in 0 ..< width {
			c := 0

			if text[x + y * (width + 2)] == '.' {
				continue
			}
			for p in NEIGHBORS {
				if p[0] + y < 0 || p[0] + y >= height || p[1] + x < 0 || p[1] + x >= width {
					continue
				}
				if text[(x + p[1]) + (y + p[0]) * (width + 2)] != '.' {
					c += 1
				}
			}

			if c < 4 {
				good += 1
			}
		}
	}

	return good
}

// Expects CRLF, picky about trailing newlines
part2 :: proc(text: string) -> int {
	text := text
	buffer := strings.clone(text, context.temp_allocator)
	
	height := strings.count(text, "\n") + 1
	width := len(text[:strings.index(text, "\n")]) - 1
	total_good := 0

	for {
		good := 0
		for y in 0 ..< height {
			for x in 0 ..< width {
				c := 0

				if text[x + y * (width + 2)] == '.' {
					continue
				}
				for p in NEIGHBORS {
					if p[1] + y < 0 || p[1] + y >= height || p[0] + x < 0 || p[0] + x >= width {
						continue
					}
					if text[(x + p[0]) + (y + p[1]) * (width + 2)] == '@' {
						c += 1
					}
				}

				if c < 4 {
					good += 1
					(transmute([]u8)buffer)[x + y * (width + 2)] = '.'
				}
			}
		}

		total_good += good

		copy(transmute([]u8)text, buffer)
		if good == 0 do break
	}

	return total_good
}


package day2

import "core:time"
import "core:fmt"
import "core:os/os2"
import "core:strconv"
import "core:strings"

main :: proc() {
	data :=
		os2.read_entire_file("input.txt", context.allocator) or_else panic("Failed to read file")
	defer delete(data)

	text := string(data)

	start := time.tick_now()
	fmt.println(part1(text))
	fmt.printfln("Part 1: %v", time.tick_since(start))
	start = time.tick_now()
	fmt.println(part2(text))
	fmt.printfln("Part 2: %v", time.tick_since(start))
}

part1 :: proc(text: string) -> i64 {
	text := text
	total: i64 = 0
	for range in strings.split_iterator(&text, ",") {
		min_max := strings.split(range, "-", context.temp_allocator)
		min_s, max_s := min_max[0], min_max[1]
		min, _ := strconv.parse_i64(min_s, base = 10)
		max, _ := strconv.parse_i64(max_s, base = 10)

		for n in min ..= max {
			str := fmt.tprint(n)
			if len(str) % 2 != 0 {
				continue
			}

			start := str[:len(str) / 2]
			end := str[len(str) / 2:]
			if start == end {
				total += n
			}
		}
	}

	free_all(context.temp_allocator)
	return total
}

part2 :: proc(text: string) -> i64 {
	text := text
	total: i64 = 0
	for range in strings.split_iterator(&text, ",") {
		min_max := strings.split(range, "-", context.temp_allocator)
		min_s, max_s := min_max[0], min_max[1]
		min, _ := strconv.parse_i64(min_s, base = 10)
		max, _ := strconv.parse_i64(max_s, base = 10)

		for n in min ..= max {
			str := fmt.tprint(n)
			
			ok := false
			for step in 1 ..= len(str) / 2 {
				if len(str) % step != 0 {
					continue
				}
				base := str[:step]
				all_matched := true
				for idx := step; idx < len(str); idx += step {
				    substr := str[idx:][:step]
					if substr != base {
						all_matched = false
					    break
					}
				}
				
				if all_matched {
				    ok = true
				    break
				}
			}
			
			if ok {
			    total += n
			}
		}
	}

	free_all(context.temp_allocator)
	return total
}


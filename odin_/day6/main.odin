package day6

import "core:fmt"
import "core:os/os2"
import "core:strconv"
import "core:strings"
import "core:time"
TEST :: `1  333
11 333
+  +  `


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

part1 :: proc(data: string) -> int {
	data := data
	operators_index := strings.index_any(data, "+*")

	numbers_str := data[:operators_index]
	nums: [dynamic]int
	for num in strings.split_multi_iterate(&numbers_str, {"\r\n", " ", "\n"}) {
		if num == "" {
			continue
		}
		parsed := strconv.parse_int(num, 10) or_else fmt.panicf("Bad number '%v'", num)
		append(&nums, parsed)
	}

	operators_str := data[operators_index:]
	operators: [dynamic]byte

	for op in strings.split_iterator(&operators_str, " ") {
		if op == "" do continue
		append(&operators, op[0])
	}

	lines := len(nums) / len(operators)
	problems := len(operators)

	grand_total := 0

	for problem in 0 ..< len(operators) {
		operator := operators[problem]

		total := 0 if operator == '+' else 1

		for n in 0 ..< lines {
			num := nums[problem + n * problems]
			switch operator {
			case '+':
				total += num
			case '*':
				total *= num
			}
		}


		grand_total += total
	}

	return grand_total
}

part2 :: proc(data: string) -> int {
	lines := strings.split_lines(data)

	grand_total := 0

	current_op: byte
	total: int
	for column in 0 ..< len(lines[0]) {
		if lines[len(lines) - 1][column] != ' ' {
			current_op = lines[len(lines) - 1][column]
			grand_total += total
			total = 0 if current_op == '+' else 1
		}
		num := 0
		for row in 0 ..< len(lines) - 1 {
			c := lines[row][column]
			if c == ' ' do continue
			num *= 10
			num += int(c - '0')
		}
		if num != 0 {
			switch current_op {
			case '+':
				total += num
			case '*':
				total *= num
			}
		}
	}

	grand_total += total
	return grand_total
}


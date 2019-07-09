require "./spec_helper"

it "matches integer literals" do
	match(3, {
		0 => "fail @ 0",
		1 => "fail @ 1",
		2 => "fail @ 2",
		3 => "success",
		4 => "fail @ 4",
		5 => "fail @ 5",
	}).should eq("success")
end

it "matches string literals" do
	match("test", {
		"this" => "fail @ this",
		"is"   => "fail @ is",
		"a"    => "fail @ a",
		"test" => "success",
	}).should eq("success")
end

struct TestStruct
	property a : Int32
	property b : String
	property c : Bool
	def initialize(@a, @b, @c)
	end
end
it "matches structs" do
	test_0 = TestStruct.new(3, "foo", false)
	test_1 = TestStruct.new(1, "foo", false)
	test_2 = TestStruct.new(2, "bar", true)
	test_3 = TestStruct.new(3, "foo", true)
	test_4 = TestStruct.new(3, "foo", false)
	match(test_0, {
		test_1 => "fail @ test_1",
		test_2 => "fail @ test_2",
		test_3 => "fail @ test_3",
		test_4 => "success",
	}).should eq("success")
end

def test_lhs(x, y)
	x ** y
end
it "evaluates left-hand functions" do
	x = 2
	y = x + 1
	z = x * y
	match(9, {
		test_lhs(x, y) => "fail @ test_lhs(x, y)",
		test_lhs(x, z) => "fail @ test_lhs(x, z",
		test_lhs(y, x) => "success",
		test_lhs(y, z) => "fail @ test_lhs(y, z)",
	}).should eq("success")
end

def test_rhs(x)
	return "success" if x == 3
	return "fail @ #{x}"
end
it "evaluates right-hand functions" do
	match(3, {
		0 => test_rhs(0),
		1 => test_rhs(1),
		2 => test_rhs(2),
		3 => test_rhs(3),
		4 => test_rhs(4),
	}).should eq("success")
end

it "supports procs" do
	test = ""
	match 2, {
		0 => ->{ test = "fail @ 0" },
		1 => ->{ test = "fail @ 1" },
		2 => ->{
			foo = "sse"
			bar = "ccus"
			baz = (foo + bar).chars.reverse
			baz.each do |c|
				test += c
			end
		},
		3 => ->{ test = "fail @ 3" },
	}
	test.should eq("success")
end

it "matches runtime integer values" do
	test_array      = [false] * 4
	expected_result = [true, true, true, false]
	(0..2).each do |x|
		match x, {
			0 => ->{ test_array[0] = true },
			1 => ->{ test_array[1] = true },
			2 => ->{ test_array[2] = true },
			3 => ->{ test_array[3] = true },
		}
	end
	test_array.should eq(expected_result)
end

it "supports catch-all match" do
	match(5, {
		0 => "fail @ 0",
		1 => "fail @ 1",
		_ => "success",
		5 => "fail @ 5",
	}).should eq("success")
end

it "matches multiple cases" do
	hit_count  = 0
	miss_count = 0
	(0...10).each do |x|
		match x, {
			2 || 5 || 6 => ->{ hit_count += 1 },
			_ => ->{ miss_count += 1 },
		}
	end
	hit_count.should eq(3)
	miss_count.should eq(7)
end

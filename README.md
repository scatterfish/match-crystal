# match-crystal

A macro to add Rust-like pattern matching to Crystal.

Almost certainly riddled with frustrating edge cases.

Please don't use this for anything serious.

## Installation

1. Add the dependency to your `shard.yml`:
	```yaml
	dependencies:
	  match-crystal:
	    github: fuzzineer/match-crystal
	```
2. Run `shards install`

## Usage

This macro aims to be as similar as possible to Rust's `match` keyword, but there are a few differences due to limitations with implementing the macro.

```crystal
require "match-crystal"

# basic matching works nearly identically to Rust
foo = match 3, {
	1 => "one",
	2 => "two",
	3 => "three",
	_ => "anything else!"
}
typeof(foo) # String

# the resulting type is a union of all of the possible options
# if no catch-all provided, the resulting type is also a union of Nil
bar = match "whammy", {
	0 => true,
	false => "slam",
	3.14 => :pow
}
typeof(bar) # (Bool | String | Symbol | Nil)

# blocks are supported using Proc syntax
match 3, {
	1 => ->{ puts "one" },
	2 => ->{ puts "two" },
	3 => ->{
		cipher = "ehtre"
		key = [3, 2, 4, 1, 5]
		puts key.map { |k| cipher[k - 1] }
		        .join
	},
	_ => ->{ puts "anything else!" }
}

# multiple cases can be matched using || (instead of | like in Rust)
match 3, {
	1 => "one",
	2 || 3 || 4 => "two or three or four",
	5 => "five"
}

# TODO: decomposition
```

This guide is only a few examples of what the macro can handle.  
If it works with Crystal's `case` statement, chances are it works with this too.

## Contributing

1. Fork it (<https://github.com/fuzzineer/match-crystal/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

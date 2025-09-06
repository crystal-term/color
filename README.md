<div align="center">
  <img src="./assets/term-logo.png" alt="term logo">
</div>

# Term::Color

![spec status](https://github.com/crystal-term/color/workflows/specs/badge.svg)

> Powerful color utilities, truecolor strings, and terminal color capability detection for Crystal.

Term::Color combines two pieces:
- A rich color API (based on the former cor library) for creating, composing, and formatting colors (hex/rgb, math operations, string helpers).
- Terminal capability detection (from the original term-color) to determine supported color modes (8/16/52/64/256/24-bit) and general color support in the active terminal.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  term-color:
    github: crystal-term/color
```

Then run:

```bash
shards install
```

## Usage

### 1. Creating Colors

```crystal
require "term-color"

# Basic RGB
red = Term::Color.new(255, 0, 0)

# From hex
red = Term::Color.new("FF0000")

# Named color
red = Term::Color.color(:red)

# With alpha
mid_red = Term::Color.new(255, 0, 0, 128)
```

### 2. Formatting

```crystal
blue = Term::Color.color(:blue)

# Hex
puts blue.hex_string            # => 0000ff
puts blue.hex_string(prefix: true)   # => #0000ff
puts blue.hex_string(alpha: true)    # => 0000ffff
puts blue.hex_string(upcase: true)   # => 0000FF

# RGB
magenta = Term::Color.color(:magenta)
puts magenta.rgb_string                 # => rgb(255, 0, 255)
puts magenta.rgb_string(alpha: true)    # => rgb(255, 0, 255, 1)
```

### 3. Math with Colors

```crystal
puts Term::Color.color(:magenta) - Term::Color.color(:blue)
# => #<Term::Color ...>
```

### 4. Truecolor Strings (24-bit)

Most modern terminals support 24-bit color. Term::Color adds chainable String helpers.

```crystal
require "term-color"
require "color/string"

puts "This is awesome!".fore(:blue).back(:white)
puts "Bold me!".bold
puts "Italic me!".italic
puts "Strike me!".strike
puts "Blink me like it's 1999!".blink
puts "Faint me!".faint
puts "Underline me!".underline
puts "Overline me!".overline
```

### 5. Terminal Color Capability Detection

Use the merged capabilities from the original term-color to determine mode and support.

```crystal
require "term-color"

env = ENV.to_h

# Mode returns a color depth: 0, 8, 16, 52, 64, 256, or 2**24 (24-bit)
mode = Term::Color::Mode.new(env).mode
puts "Color mode: #{mode}"

# Support checks whether colors are supported in general
support = Term::Color::Support.new(env)
if support.disabled?
  puts "NO_COLOR set; colors disabled"
elsif support.support?
  puts "Terminal supports colors"
else
  puts "No color support detected"
end
```

## Contributing

1. Fork it (<https://github.com/crystal-term/color/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

MIT © [Chris Watson](https://github.com/watzon)

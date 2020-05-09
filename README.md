<div align="center">
  <img src="./assets/term-logo.png" alt="term logo">
</div>

# Term::Color

![spec status](https://github.com/crystal-term/color/workflows/specs/badge.svg)

> Terminal color capabilities detection.

**Term::Color** provides an independent color support detection component for crystal-term.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     color:
       github: crystal-term/color
   ```

2. Run `shards install`

## Usage

```crystal
require "term-color"
```

**Term::Screen** allows you to check if your terminal supports color:

```crystal
Term::Color.support?  # => true
```

You can also get the number of colors supported by the terminal:

```crystal
Term::Color.mode      # => 64
```

`Term::Color` is just a module so you can easily include it into your own scripts:

```crystal
require "term-color"

include Term::Color

puts support?
```

## Contributing

1. Fork it (<https://github.com/crystal-term/color/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Chris Watson](https://github.com/watzon) - creator and maintainer

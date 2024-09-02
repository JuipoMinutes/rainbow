# rainbow

A Crystal module for linux to print colorful text into the terminal and other simple objects.
Only requirements is to use a terminal that accepts ANSI codes and the tty command installed in your distro(Comes pre-installed with the most popular distros)

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     rainbow:
       github: JuipoMinutes/rainbow
   ```

2. Run `shards install`

## Usage

```crystal
require "rainbow"
```

Rainbow works with it's own "rainbow codes" this is just a way to tell Rainbow what color or background to use on differente ways
For example:
- #|orange| => Makes the text to the right orange
- #|bg_cyan| => Makes the background of the text on the right cyan
- #|rgb0,0,0| => Makes the text on the right black, passed as 255 rgb code
- #|bg_rgb,255,255,255| => Makes the background white to the text on the right trough rgb
- #|default| and #|bg_default| reset colors to the original of the terminal

#### Printing colorful text

```crystal
require "rainbow"

Rainbow.print "#|orange|Hello, #|rgb54,78,34|World!, #|bg_blue|How are #|bg_rgb 45, 76, 90|you?"
```
- You can use a wrapper function to shorten the print call

#### Printing a box
```crystal
require "rainbow"

box = Rainbow::Box.new(text : "This time #|red|for me!")

Rainbow.print(box)
```
A box can be customized on diferent ways, you can read on this on the "src/box.cr" file

#### Other renderables
There is also a padding renderable, an align renderable and a Rule function within the shard/module

## Development

I have many ideas on what to do with this but I do develop this shard on my free time so expect mostly updates so that it can always function and sometimes big updates with new renderables and options.

## Contributing

If possible try to contact me to what you'll like so that I can try to add it to the shard.
If not possible fork this repository and do as you wish.

## Contributors

- [JuipoMinutes](https://github.com/JuipoMinutes) - creator and maintainer

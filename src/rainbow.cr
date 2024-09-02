require "./align"
require "./ansi_converter"
require "./con_conf"
require "./console"
require "./padding"
require "./renderable"
require "./tty"
require "./box"

# "Rainbow" a module to print colored text in the console, including boxes, padding, and alignment
# Functions by communicating with the console trough the "tty" linux command and using ANSI escape codes
# # Includes:
# * Rainbow::Align : A class to align text depending on the console width
# * Rainbow::Box : A class to create boxes with text inside
# * Rainbow::Console : An abstract console to communicate with the terminal
# * Rainbow::Padding : A class to add padding to text
# * Rainbow::Renderable : An abstract class to render text
# * Rainbow::Ansi_converter : A class to convert rgb and "rainbow codes" to ANSI codes
# * Rainbow::Con_conf : A class to get the terminal specifications
# 
# - It also includes a method to print text in the console without defining a console object
# - And a method to print a "rule"(horizontal line) in the terminal
module Rainbow
  VERSION = "0.1.0"

  DEFAULT_CONSOLE = Console.new

  def self.print(object : String | Rainbow::Renderable, ending : String = "\n")
    DEFAULT_CONSOLE.print(object, ending)
  end

  def self.rule(fg_color : String = "white", bg_color : String | Nil = nil)
    DEFAULT_CONSOLE.rule(fg_color, bg_color)
  end
  
end

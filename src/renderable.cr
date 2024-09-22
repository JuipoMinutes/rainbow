require "./con_conf"

# An abstract class to render text
# The base "template" for the renderable classes so Rainbow can print them
abstract class Rainbow::Renderable
    abstract def render(console : Rainbow::Console) : String
            
end
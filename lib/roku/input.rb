require 'io/console'

module Roku
  class Input
    BINDINGS = {
      ' ' => :Play,
      "\r" => :Select,
      "\e[A" => :Up,
      "\e[B" => :Down,
      "\e[C" => :Right,
      "\e[D" => :Left,
      "\e[1;5A" => :VolumeUp,
      "\e[1;5B" => :VolumeDown,
      "\u007F" => :Back
    }.freeze

    def run
      while (input = read_char)
        case input
        when 'a'
          launch_app(prompt('Launch: '))
        when 'q', "\u0003", "\e"
          break
        when *BINDINGS.keys
          Roku::Client.keypress(BINDINGS[input])
        else
          puts input.inspect
        end
      end
    end

    private

    def read_char
      $stdin.raw do |stdin|
        input = stdin.getc.chr
        if input == "\e"
          input << stdin.read_nonblock(3) rescue nil
          input << stdin.read_nonblock(2) rescue nil
        end
        return input
      end
    end

    def prompt(label)
      print label
      $stdin.gets.chomp
    end

    def launch_app(query)
      app = Roku::Client.apps.find { |a| a.name.casecmp(query).zero? }
      if app.nil?
        print "\rNo app found."
      else
        print "\rLaunching #{app.name}."
        app.launch!
      end
    end
  end
end

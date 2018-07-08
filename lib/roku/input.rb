require 'io/console'

module Roku
  class Input
    def run
      while (input = read_char)
        case input
        when ' '
          Roku::Client.keypress(:Play)
        when "\r"
          Roku::Client.keypress(:Select)
        when "\e[A"
          Roku::Client.keypress(:Up)
        when "\e[B"
          Roku::Client.keypress(:Down)
        when "\e[C"
          Roku::Client.keypress(:Right)
        when "\e[D"
          Roku::Client.keypress(:Left)
        when "\u007F"
          Roku::Client.keypress(:Back)
        when "\e[1;5A"
          Roku::Client.keypress(:VolumeUp)
        when "\e[1;5B"
          Roku::Client.keypress(:VolumeDown)
        when 'a'
          query = prompt('Launch: ')
          app = Roku::Client.apps.find { |a| a.name.casecmp(query) }
          if app.nil?
            print "\rNo app found."
          else
            print "\rLaunching #{app.name}."
            app.launch!
          end
        when 'q', "\u0003"
          break
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
  end
end

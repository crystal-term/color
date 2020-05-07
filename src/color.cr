require "./color/support"
require "./color/mode"
require "./color/version"

module Term
  module Color
    extend self

    class_property output : IO::FileDescriptor = STDOUT

    # Check if this terminal supports colors
    def support?
      Support.new(ENV.to_h).support?
    end

    def mode
      Mode.new(ENV.to_h).mode
    end

    # Check if output is linked to a terminal
    def tty?
      output.responds_to?(:tty?) ? output.tty? : false
    end

    # Check if command can be run
    def command?(cmd, args = nil)
      Process.run(cmd, args, output: File.open(File::NULL), error: File.open(File::NULL))
      true
    rescue
      false
    end

    # Check if running on windows. Just false for now.
    def windows?
      false
    end
  end
end

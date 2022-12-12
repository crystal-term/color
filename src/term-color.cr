require "./color/support"
require "./color/mode"
require "./color/version"

module Term
  module Color
    extend self

    class_property output : IO::FileDescriptor = STDOUT
    class_property verbose : Bool = false

    # Check if this terminal supports colors
    def support?
      Support.new(ENV.to_h).support?
    end

    def disabled?
      Support.new(ENV.to_h, verbose: @@verbose).disabled?
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
      {% if flag?(:windows) %}
        true
      {% else %}
        false
      {% end %}
    end
  end
end

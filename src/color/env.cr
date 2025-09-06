module Term
  class Color
    # True if STDOUT is a TTY
    def self.tty?
      STDOUT.tty?
    end

    # True if running on Windows
    def self.windows?
      {% if flag?(:windows) %}
        true
      {% else %}
        false
      {% end %}
    end

    # Check if a command exists and can run with given args
    def self.command?(cmd : String, args : Array(String) = [] of String)
      status = Process.run(cmd, args: args, output: Process::Redirect::Close, error: Process::Redirect::Close)
      status.success?
    rescue
      false
    end
  end
end

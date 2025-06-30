module Term
  module Color
    struct Support
      ENV_VARS   = %w[COLORTERM ANSICON]
      TERM_REGEX = /
        color|  # explicitly claims color support in the name
        direct| # explicitly claims "direct color" (24 bit) support
        #{Mode::TERM_256}|
        #{Mode::TERM_64}|
        #{Mode::TERM_52}|
        #{Mode::TERM_16}|
        #{Mode::TERM_8}|
        ^ansi(\.sys.*)?$|
        ^cygwin|
        ^linux|
        ^putty|
        ^rxvt|
        ^screen|
        ^tmux|
        ^xterm|
        ^ms\-terminal/xi

      def initialize(@env : Hash(String, String), @verbose = false)
      end

      # Detect if terminal supports color
      def support?
        return false unless Color.tty?

        {% for source in %w(from_term from_windows_term from_tput from_env) %}
          if value = {{ source.id }}
            return true unless value.nil?
          end
        {% end %}

        false
      end

      # Detect if color support has been disabled with NO_COLOR ENV var.
      def disabled?
        no_color = ENV["NO_COLOR"]?
        !(no_color.nil? || no_color.empty?)
      end

      # Inspect environment $TERM variable for color support
      def from_term
        case @env["TERM"]?
        when "dumb"     then false
        when TERM_REGEX then true
        else                 nil
        end
      end

      def from_windows_term
        ENV.has_key?("WT_SESSION") ? true : nil
      end

      # Shell out to tput to check color support
      def from_tput
        return nil unless Color.command?("tput", ["colors"])

        cmd = `tput colors 2>/dev/null`
        cmd.to_i > 2
      rescue ArgumentError
        nil
      end

      # Check if environment specifies color variables
      def from_env
        ENV_VARS.any? { |k| @env.has_key?(k) } || nil
      end

      # Attempt to load curses to check color support
      # TODO: Implement from_curses
      def from_curses(curses_class = Curses)
      end
    end
  end
end

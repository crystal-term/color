module Term
  module Color
    struct Support
      ENV_VARS = %w[COLORTERM ANSICON]

      def initialize(@env : Hash(String, String))
      end

      def support?
        return false unless Color.tty?

        {% for source in %w(from_term from_tput from_env) %}
          if value = {{ source.id }}
            return true unless value.nil?
          end
        {% end %}

        false
      end

      def from_term
        case @env["TERM"]?
        when "dumb" then false
        when /^screen|^xterm|^vt100|color|ansi|cygwin|linux|kitty/i then true
        else nil
        end
      end

      def from_tput
        return nil unless Color.command?("tput", ["colors"])

        cmd = `tput colors 2>/dev/null`
        cmd.to_i > 2
      rescue _e : ArgumentError
        nil
      end

      def from_env
        ENV_VARS.any? { |k| @env.has_key?(k) } || nil
      end
    end
  end
end

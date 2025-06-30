module Term
  module Color
    class Mode
      TERM_24BIT = /[+-]direct/
      TRUECOLORS = 2**24 # 8 bits per RGB channel; 24 bit color

      TERM_256 = /^(alacritty|iTerm\s?\d*\.app|kitty|mintty|ms-terminal|
                    nsterm|nsterm-build\d+|terminator|terminology(-[0-9.]+)?|
                    termite|vscode)$/x

      TERM_64 = /^(hpterm-color|wy370|wy370-105k|wy370-EPC|wy370-nk|
                   wy370-rv|wy370-tek|wy370-vb|wy370-w|wy370-wvb)$/x

      TERM_52 = /^(dg+ccc|dgunix+ccc|d430.*?[-+](dg|unix).*?[-+]ccc)$/x

      TERM_16 = /^(amiga-vnc|d430-dg|d430-unix|d430-unix-25|d430-unix-s|
                 d430-unix-sr|d430-unix-w|d430c-dg|d430c-unix|d430c-unix-25|
                 d430c-unix-s|d430c-unix-sr|d430c-unix-w|d470|d470-7b|d470-dg|
                 d470c|d470c-7b|d470c-dg|dg+color|dg\+fixed|dgunix\+fixed|
                 dgmode\+color|hp\+color|ncr260wy325pp|ncr260wy325wpp|
                 ncr260wy350pp|ncr260wy350wpp|nsterm-c|nsterm-c-acs|
                 nsterm-c-s|nsterm-c-s-7|nsterm-c-s-acs|nsterm\+c|
                 nsterm-7-c|nsterm-bce)$/x

      TERM_8 = /vt100|xnuppc|wy350/x

      def initialize(@env : Hash(String, String))
      end

      # Detect supported colors
      def mode
        return 0 unless Color.tty?

        {% for source in %w(from_term from_windows_term from_tput) %}
          if value = {{ source.id }}
            return value unless value.nil?
          end
        {% end %}

        8
      end

      def from_term
        case @env["TERM"]?
        when TERM_24BIT       then TRUECOLORS
        when /[-+](\d+)color/ then $1.to_i
        when /[-+](\d+)bit/   then 2**$1.to_i
        when TERM_256         then 256
        when TERM_64          then 64
        when TERM_52          then 52
        when TERM_16          then 16
        when TERM_8           then 8
        when /dummy/          then 0
        else                       nil
        end
      end

      def from_windows_term
        Color.windows? && ENV.has_key?("WT_SESSION") ? TRUECOLORS : nil
      end

      def from_tput
        return nil unless Color.command?("tput", ["colors"])

        colors = `tput colors 2>/dev/null`.to_i
        colors >= 8 ? colors : nil
      rescue ArgumentError
        nil
      end
    end
  end
end

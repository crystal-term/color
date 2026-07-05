# Color capability mode detection (merged from original term-color)
# Kept for future depth degradation; enabled? currently gates output on/off only.
class Term::Color::Mode
  TERM_24BIT = /[+-]direct/
  TRUECOLORS = 2**24 # 24-bit color

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

  # Detect supported colors (0, 8, 16, 52, 64, 256, or 24-bit)
  def mode : Int32
    return 0 unless Term::Color.tty?

    if value = from_term
      return value unless value.nil?
    end

    if value = from_windows_term
      return value unless value.nil?
    end

    if value = from_tput
      return value unless value.nil?
    end

    8
  end

  def from_term : Int32?
    term = @env["TERM"]?
    return nil unless term

    if term =~ TERM_24BIT
      return TRUECOLORS
    end

    if md = term.match(/[-+](\d+)color/)
      return md[1].to_i
    end

    if md = term.match(/[-+](\d+)bit/)
      return 2**md[1].to_i
    end

    return 256 if term =~ TERM_256
    return 64  if term =~ TERM_64
    return 52  if term =~ TERM_52
    return 16  if term =~ TERM_16
    return 8   if term =~ TERM_8
    return 0   if term =~ /dummy/

    nil
  end

  def from_windows_term : Int32?
    Term::Color.windows? && ENV.has_key?("WT_SESSION") ? TRUECOLORS : nil
  end

  def from_tput : Int32?
    return nil unless Term::Color.command?("tput", ["colors"])
    begin
      colors = `tput colors 2>/dev/null`.to_i
      colors >= 8 ? colors : nil
    rescue ArgumentError
      nil
    end
  end
end

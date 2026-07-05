# Terminal color support detection (merged from original term-color)
struct Term::Color::Support
  ENV_VARS = %w[COLORTERM ANSICON]

  TERM_REGEX = /
    color|                 # claims color support in the name
    direct|                # claims 24-bit direct color support
    #{Term::Color::Mode::TERM_256}|
    #{Term::Color::Mode::TERM_64}|
    #{Term::Color::Mode::TERM_52}|
    #{Term::Color::Mode::TERM_16}|
    #{Term::Color::Mode::TERM_8}|
    ^ansi(\.sys.*)?$|
    ^cygwin|
    ^linux|
    ^putty|
    ^rxvt|
    ^screen|
    ^tmux|
    ^xterm|
    ^ms\-terminal
  /xi

  def initialize(@env : Hash(String, String), @verbose = false, @tty : Bool = Term::Color.tty?)
  end

  # Detect if terminal supports color
  def support? : Bool
    return false unless @tty

    value = from_term
    return value unless value.nil?

    value = from_windows_term
    return value unless value.nil?

    value = from_tput
    return value unless value.nil?

    value = from_env
    return value unless value.nil?

    false
  end

  # Detect if color support has been disabled with NO_COLOR
  def disabled? : Bool
    no_color = @env["NO_COLOR"]?
    !(no_color.nil? || no_color.empty?)
  end

  # Inspect TERM for color support
  def from_term : Bool?
    case @env["TERM"]?
    when "dumb" then false
    when TERM_REGEX then true
    else nil
    end
  end

  def from_windows_term : Bool?
    @env.has_key?("WT_SESSION") ? true : nil
  end

  # Check via tput
  def from_tput : Bool?
    return nil unless Term::Color.command?("tput", ["colors"])
    begin
      cmd = `tput colors 2>/dev/null`
      cmd.to_i > 2 ? true : nil
    rescue
      nil
    end
  end

  # Check color-related env vars
  def from_env : Bool?
    ENV_VARS.any? { |k| @env.has_key?(k) } || nil
  end

  # TODO: from_curses (not implemented)
end

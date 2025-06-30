require "./spec_helper"

describe Term::Color do
  describe ".tty?" do
    it "returns boolean based on output tty status" do
      # Since we can't easily mock IO::FileDescriptor, we'll just test the current state
      result = Term::Color.tty?
      result.should be_a(Bool)
    end
  end

  describe ".command?" do
    it "returns true for existing commands" do
      Term::Color.command?("echo").should be_true
    end

    it "returns false for non-existing commands" do
      Term::Color.command?("nonexistentcommand12345").should be_false
    end
  end

  describe ".windows?" do
    it "returns correct platform" do
      {% if flag?(:windows) %}
        Term::Color.windows?.should be_true
      {% else %}
        Term::Color.windows?.should be_false
      {% end %}
    end
  end

  describe Term::Color::Support do
    describe "#disabled?" do
      it "returns true when NO_COLOR is set" do
        with_env("NO_COLOR", "1") do
          support = Term::Color::Support.new({"NO_COLOR" => "1"})
          support.disabled?.should be_true
        end
      end

      it "returns false when NO_COLOR is not set" do
        support = Term::Color::Support.new({} of String => String)
        support.disabled?.should be_false
      end

      it "returns false when NO_COLOR is empty" do
        support = Term::Color::Support.new({"NO_COLOR" => ""})
        support.disabled?.should be_false
      end
    end

    describe "#from_term" do
      it "returns false for dumb terminal" do
        support = Term::Color::Support.new({"TERM" => "dumb"})
        support.from_term.should be_false
      end

      it "returns true for xterm" do
        support = Term::Color::Support.new({"TERM" => "xterm"})
        support.from_term.should be_true
      end

      it "returns true for screen" do
        support = Term::Color::Support.new({"TERM" => "screen"})
        support.from_term.should be_true
      end

      it "returns nil for unknown terminal" do
        support = Term::Color::Support.new({"TERM" => "unknown"})
        support.from_term.should be_nil
      end
    end

    describe "#from_env" do
      it "returns true when COLORTERM is set" do
        support = Term::Color::Support.new({"COLORTERM" => "truecolor"})
        support.from_env.should be_true
      end

      it "returns true when ANSICON is set" do
        support = Term::Color::Support.new({"ANSICON" => "1"})
        support.from_env.should be_true
      end

      it "returns nil when no color env vars are set" do
        support = Term::Color::Support.new({} of String => String)
        support.from_env.should be_nil
      end
    end
  end

  describe Term::Color::Mode do
    describe "#from_term" do
      it "returns TRUECOLORS for direct color support" do
        mode = Term::Color::Mode.new({"TERM" => "xterm-direct"})
        mode.from_term.should eq(Term::Color::Mode::TRUECOLORS)
      end

      it "returns 256 for 256 color terminals" do
        mode = Term::Color::Mode.new({"TERM" => "xterm-256color"})
        mode.from_term.should eq(256)
      end

      it "returns 8 for basic color terminals" do
        mode = Term::Color::Mode.new({"TERM" => "vt100"})
        mode.from_term.should eq(8)
      end

      it "returns 0 for dumb terminals" do
        mode = Term::Color::Mode.new({"TERM" => "dummy"})
        mode.from_term.should eq(0)
      end
    end
  end
end

private def with_env(key, value, &)
  old_value = ENV[key]?
  ENV[key] = value
  yield
ensure
  if old_value
    ENV[key] = old_value
  else
    ENV.delete(key)
  end
end

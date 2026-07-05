require "./spec_helper"

describe Term::Color::Support do
  it "treats NO_COLOR as disabled" do
    support = Term::Color::Support.new({"NO_COLOR" => "1"}, tty: true)

    support.disabled?.should be_true
  end

  it "allows empty NO_COLOR" do
    support = Term::Color::Support.new({"NO_COLOR" => ""}, tty: true)

    support.disabled?.should be_false
  end

  it "does not support TERM=dumb" do
    support = Term::Color::Support.new({"TERM" => "dumb", "COLORTERM" => "truecolor"}, tty: true)

    support.support?.should be_false
  end

  it "supports COLORTERM=truecolor" do
    support = Term::Color::Support.new({"COLORTERM" => "truecolor"}, tty: true)

    support.support?.should be_true
  end

  it "does not support color for non-tty output" do
    support = Term::Color::Support.new({"COLORTERM" => "truecolor"}, tty: false)

    support.support?.should be_false
  end
end

require "./spec_helper"

describe Term::Color do
  after_each do
    Term::Color.enabled = nil
  end

  describe ".enabled?" do
    it "can be forced off" do
      Term::Color.enabled = false

      Term::Color.enabled?.should be_false
    end

    it "can be forced on" do
      Term::Color.enabled = true

      Term::Color.enabled?.should be_true
    end
  end

  describe ".truecolor_string" do
    it "returns plain text when color is disabled" do
      Term::Color.enabled = false

      Term::Color.truecolor_string("x", fore: :red).should eq("x")
    end

    it "emits truecolor escapes when color is enabled" do
      Term::Color.enabled = true

      Term::Color.truecolor_string("x", fore: :red).should contain("\e[38;2;")
    end
  end
end

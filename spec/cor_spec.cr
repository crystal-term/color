require "./spec_helper"

describe Term::Color do
  it "constructs from hex" do
    c = Term::Color.new("FF0000")
    c.hex_string.should eq("ff0000")
  end

  it "pretty prints RGB colors" do
    Term::Color.new(255, 0, 0).pretty_inspect.should_not be_empty
  end
end

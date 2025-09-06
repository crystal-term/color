require "./spec_helper"

describe Term::Color do
  it "constructs from hex" do
    c = Term::Color.new("FF0000")
    c.hex_string.should eq("ff0000")
  end
end

require "./spec_helper"

describe Term::Color do
  describe "setters" do
    it "updates red only" do
      color = Term::Color.new(10, 20, 30, 40)

      color.red = 90

      color.red.should eq(90)
      color.green.should eq(20)
      color.blue.should eq(30)
      color.alpha.should eq(40)
    end

    it "updates green only" do
      color = Term::Color.new(10, 20, 30, 40)

      color.green = 90

      color.red.should eq(10)
      color.green.should eq(90)
      color.blue.should eq(30)
      color.alpha.should eq(40)
    end

    it "updates blue only" do
      color = Term::Color.new(10, 20, 30, 40)

      color.blue = 90

      color.red.should eq(10)
      color.green.should eq(20)
      color.blue.should eq(90)
      color.alpha.should eq(40)
    end

    it "updates alpha only" do
      color = Term::Color.new(10, 20, 30, 40)

      color.alpha = 90

      color.red.should eq(10)
      color.green.should eq(20)
      color.blue.should eq(30)
      color.alpha.should eq(90)
    end
  end
end

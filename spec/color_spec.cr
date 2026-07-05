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

  describe "operators" do
    it "adds channels and clamps at 255" do
      result = Term::Color.new(100, 100, 100, 255) + Term::Color.new(200, 200, 200, 0)

      result.to_tuple.should eq({255, 255, 255, 255})
    end

    it "subtracts channels and floors at 0" do
      result = Term::Color.new(20, 30, 40, 50) - Term::Color.new(30, 20, 50, 10)

      result.to_tuple.should eq({0, 10, 0, 40})
    end

    it "multiplies channels and clamps at 255" do
      result = Term::Color.new(2, 20, 4, 10) * Term::Color.new(100, 20, 3, 30)

      result.to_tuple.should eq({200, 255, 12, 255})
    end

    it "divides channels and treats division by zero as 0" do
      result = Term::Color.new(100, 1, 9, 255) / Term::Color.new(2, 0, 2, 255)

      result.to_tuple.should eq({50, 0, 4, 1})
    end
  end
end

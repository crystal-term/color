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

  describe "#hex_string" do
    it "formats prefix, alpha, and uppercase variants" do
      color = Term::Color.new(255, 136, 0, 255)

      color.hex_string.should eq("ff8800")
      color.hex_string(prefix: true).should eq("#ff8800")
      color.hex_string(alpha: true).should eq("ff8800ff")
      color.hex_string(prefix: true, alpha: true, upcase: true).should eq("#FF8800FF")
      color.hex_string(alpha: true).size.should eq(8)
    end
  end

  describe "#rgb_string" do
    it "formats rgb and rgba strings" do
      color = Term::Color.new(10, 20, 30, 128)

      color.rgb_string.should eq("rgb(10, 20, 30)")
      color.rgb_string(alpha: true).should eq("rgba(10, 20, 30, 0.5)")
    end
  end

  describe "#inverse" do
    it "inverts rgb channels and preserves alpha" do
      color = Term::Color.new(255, 136, 0, 127)

      color.inverse.to_tuple.should eq({0, 119, 255, 127})
    end
  end

  describe "#pretty_inspect" do
    it "pretty prints repeatedly without indexing past the color table" do
      color = Term::Color.new(255, 136, 0, 127)

      50.times do
        color.pretty_inspect.should_not be_empty
      end
    end
  end

  describe "#to_s" do
    it "uses the Term::Color name" do
      Term::Color.new(1, 2, 3, 4).to_s.should eq("Term::Color{1, 2, 3, 4}")
    end
  end

  describe ".color" do
    it "mentions the color table when a color is unknown" do
      expect_raises(Exception, "the color missing has not been defined in `Term::Color::Colors::COLORS`") do
        Term::Color.color(:missing)
      end
    end
  end
end

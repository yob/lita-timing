RSpec.describe Lita::Timing::TimeParser do
  describe ".day_string_to_int" do

    let(:result) { Lita::Timing::TimeParser.day_string_to_int(input)}

    context "with sunday" do
      let(:input) { "Sunday" }

      it "returns 0" do
        expect(result).to eq(0)
      end
    end
    context "with saturday" do
      let(:input) { "Saturday" }

      it "returns 6" do
        expect(result).to eq(6)
      end
    end

    context "with invalid string" do
      let(:input) { "Foo" }

      it "raise an exception" do
        expect {
          result
        }.to raise_error(ArgumentError, "Expected one of: monday, tuesday, wednesday, thursday, friday, saturday or sunday")
      end
    end
  end
  describe ".day_strings_to_ints" do

    let(:result) { Lita::Timing::TimeParser.day_strings_to_ints(input)}

    context "with valid days" do
      let(:input) { %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday] }

      it "returns an array" do
        expect(result).to eq([0,1,2,3,4,5,6])
      end
    end
    context "with invalid string" do
      let(:input) { ["Foo"] }

      it "raise an exception" do
        expect {
          result
        }.to raise_error(ArgumentError, "Expected one of: monday, tuesday, wednesday, thursday, friday, saturday or sunday")
      end
    end
  end
  describe ".extract_hours_and_minutes" do

    let(:result) { Lita::Timing::TimeParser.extract_hours_and_minutes(input)}

    context "with midnight" do
      let(:input) { "00:00" }

      it "returns correct values" do
        expect(result).to eq([0,0])
      end
    end
    context "with 23:59" do
      let(:input) { "23:59" }

      it "returns correct values" do
        expect(result).to eq([23,59])
      end
    end
    context "with H:MM format" do
      let(:input) { "1:23" }

      it "returns correct values" do
        expect(result).to eq([1,23])
      end
    end
    context "with invalid string" do
      let(:input) { "Foo" }

      it "raises an exception" do
        expect {
          result
        }.to raise_error(ArgumentError, "time should be HH:MM")
      end
    end
    context "with invalid string" do
      let(:input) { "24:00" }

      it "raises an exception" do
        expect {
          result
        }.to raise_error(ArgumentError, "time should be HH:MM")
      end
    end
  end
end

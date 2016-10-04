require "oyster_card"

describe OysterCard do
  subject(:oystercard) {described_class.new}

  it "has a default balance of 0" do
    expect(oystercard.balance).to eq(0)
  end

  context "#top_up" do
    it "responds to top_up" do
      expect(oystercard).to respond_to(:top_up).with(1).argument
    end

    it "tops up card" do
      oystercard.top_up(10)
      expect(oystercard.balance).to eq(10)
    end

    it "prevents top up above 90" do
      expect{oystercard.top_up(described_class::MAX_LIMIT+1)}.to raise_error("The maximum amount allowed on the card is £90")
    end
  end

  context "#deduct" do
    it "Touching out should deduct correct amount from card" do
      oystercard.top_up(described_class::MINIMUM_BALANCE+1)
      expect{oystercard.touch_out}.to change{oystercard.balance}.by(-described_class::MINIMUM_FARE)
    end

  end

  context "#in_journey?" do
    it "Initialized not in a journey" do
      expect(oystercard.in_journey?).to eq false
    end
  end

  context "#touch_in" do
    it "Touching in changes in_journey variable to true" do
      oystercard.top_up(described_class::MINIMUM_BALANCE)
      oystercard.touch_in
      expect(oystercard.in_journey?).to eq true
    end

    it "Cannot touch_in if balance less than minimum balance", :focus do
      expect{oystercard.touch_in}.to raise_error "You don't have enough money"
    end
  end

  context "#touch_out"
    it "Touching out changes in_journey variable to false" do
      oystercard.top_up(described_class::MINIMUM_BALANCE)
      oystercard.touch_in
      oystercard.touch_out
      expect(oystercard.in_journey?).to eq false
    end


end

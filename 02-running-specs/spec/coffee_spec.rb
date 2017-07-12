class Coffee
  def ingredients
    @ingredients ||= []
  end

  def add(ingredient)
    ingredients << ingredient
  end

  def price
    if ingredients.empty?
      1.00
    else
      1.25
    end
  end
end

RSpec.describe 'A cup of coffee' do
  let(:coffee) { Coffee.new }

  it 'costs $1' do
    expect(coffee.price).to eql(1.00)
  end

  # context is an alias for describe, but makes it clear when describing a subset of behaviors
  context 'with milk' do
    before { coffee.add :milk }
    it 'costs $1.25' do
      expect(coffee.price).to eql(1.25)
    end
  end
end
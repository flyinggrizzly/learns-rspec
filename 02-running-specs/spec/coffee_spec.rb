class Coffee
  def ingredients
    @ingredients ||= []
  end

  def add(ingredient)
    ingredients << ingredient
  end

  def price
    1.00
  end
end

# Enables --only-failures flag for RSpec CLI
RSpec.configure do |c|
  c.example_status_persistence_file_path = 'spec/examples.txt'
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
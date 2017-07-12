class Coffee
  def ingredients
    @ingredients ||= []
  end

  def add(ingredient)
    ingredients << ingredient
  end

  def price
    1.00 + ingredients.size * 0.25
  end
end

# Enables --only-failures flag for RSpec CLI
RSpec.configure do |c|
  c.filter_run_when_matching(focus: true)
  c.example_status_persistence_file_path = 'spec/examples.txt'
end

RSpec.describe 'A cup of coffee' do
  let(:coffee) { Coffee.new }

  # Tagged: run just this example with `rspec --tag milky:false`
  it 'costs $1', milky: false do
    expect(coffee.price).to eql(1.00)
  end

  # Pending example with expectation to be skipped
  it 'is cooler than 200F' do
    # Including the pending helper means that any code below it will be skipped
    # Any code above it is still expected to pass
    # You should include an explanation why the example is still pending
    pending 'temperature not implemented yet'
    expect(coffee.temp).to be < (200)
  end

  # context is an alias for describe, but makes it clear when describing a subset of behaviors
  # Tagged: run just this example with `rspec --tag milky:true`
  context 'with milk', milky: true do
    before { coffee.add :milk }
    it 'costs $1.25' do
      expect(coffee.price).to eql(1.25)
    end

    # Pending example with expectation to be skipped
    it 'is light in color' do
      # Including the pending helper means that any code below it will be skipped
      # Any code above it is still expected to pass
      # You should include an explanation why the example is still pending
      pending 'color not implemented yet'
      expect(coffee.color).to be(:light)
    end
  end
end
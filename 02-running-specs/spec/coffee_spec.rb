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

  # This causes the coffee color example to start passing
  # which means that the test suite will flag it by 'failing' the passing test
  # to bring it to our attention
  def color
    ingredients.include?(:milk) ? :light : :dark
  end

  # This causes the coffee temp example to start passing
  # which means that the test suite will flag it by 'failing' the passing test
  # to bring it to our attention
  def temp
    ingredients.include?(:milk) ? 190.0 : 205.0
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

    # Pending example with expectation to be skipped
    it 'is cooler than 200F' do
      # Including the pending helper means that any code below it will be skipped
      # Any code above it is still expected to pass
      # You should include an explanation why the example is still pending
      pending 'temperature not implemented yet'
      expect(coffee.temp).to be < (200)
    end
  end
end
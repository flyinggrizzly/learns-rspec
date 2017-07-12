# First example. Demonstrates three core RSpec APIs:
# - describe
# - it
# - expect

Sandwich = Struct.new(:taste, :toppings)

RSpec.describe 'An ideal sandwich' do
  # define a Ruby helper to instantiate sandwiches when necessary
  # avoids overhead of having instance variables every time
  def sandwich
    @sandwich ||= Sandwich.new('delicious', [])
  end

  it 'is delicious' do
    taste = sandwich.taste
    expect(taste).to eq('delicious')
  end

  it 'lets me add toppings' do
    sandwich.toppings << 'cheese'
    toppings = sandwich.toppings
    # check out this inverted expectation with .not_to
    expect(toppings).not_to be_empty 
  end
end
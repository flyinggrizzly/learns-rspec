class Tea
  def initialize(args = nil)
    if args[:flavor]
      flavor(args[:flavor])
    end
    if args[:temp]
      temp(args[:temp])
    end
  end

  def flavor(input = nil)
    @flavor ||= input
  end

  def temp(input = nil)
    @temp ||= input
  end
end

RSpec.configure do |c|
  c.example_status_persistence_file_path = 'spec/examples.txt'
end

RSpec.describe Tea do
  let(:tea) { Tea.new(flavor: :earl_grey, temp: 201.0) }

  it 'tastes like Earl Grey' do
    expect(tea.flavor).to be :earl_grey
  end

  it 'is hot' do
    expect(tea.temp).to be > 200.0
  end
end
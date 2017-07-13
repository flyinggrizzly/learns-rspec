require 'rack/test'
require 'json'
require_relative '../../app/api'

module ExpenseTracker
  RSpec.describe 'Expense Tracker API' do
    include Rack::Test::Methods

    def app
      ExpenseTracker::API.new
    end

    it 'records submitted expenses' do
      coffee = {
        'payee'  => 'Starbucks',
        'amount' => 5.75,
        'date'   => '2017-06-10'
      }

      post '/expenses', JSON.generate(coffee)
      # test that the post's response is OK
      expect(last_response.status).to eql(200)

      # make sure we get the transaction ID back
      parsed = JSON.parse(last_response.body)
      expect(parsed).to include('expense_id' => a_kind_of(Integer))
    end
  end
end

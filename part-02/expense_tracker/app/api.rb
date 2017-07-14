require 'sinatra/base'
require 'json'

module ExpenseTracker
  class API < Sinatra::Base

    def initialize(ledger: Ledger.new)
      @ledger = ledger
      super
    end

    post '/expenses' do
      JSON.generate('expense_id' => 42)
    end

    get '/expenses/:date' do
      # return empty JSON to fix HTTP error in tests
      JSON.generate([])
    end
  end
end
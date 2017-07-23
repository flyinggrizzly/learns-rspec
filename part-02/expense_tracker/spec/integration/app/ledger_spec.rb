require_relative '../../../app/ledger'
require_relative '../../../config/sequel'
require_relative '../../support/db'

module ExpenseTracker
  # The `:aggregate_failures` property tells rspec to continue running and reporting
  # failed expectations when there are more than one in the example.
  RSpec.describe Ledger, :aggregate_failures do
    let(:ledger) { Ledger.new }
    let(:expense) do
      {
        'payee'  => 'Starbucks',
        'amount' => 5.75,
        'date'   => '2017-06-10'
      }
    end

    describe '#record' do
      context 'with a valid expense' do
        # This example includes two expectations. This is not classically
        # allowed in TDD, but it's done for performance. We'd be repeating
        # both the code and the operations if we didn't include both
        # expectations here.
        it 'successfully saves the expense in the DB' do
          result = ledger.record(expense)
          expect(result).to be_success
          expect(DB[:expenses].all).to match [a_hash_including(
            id: result.expense_id,
            payee: 'Starbucks',
            amount: 5.75,
            date: Date.iso8601('2017-06-10')
          )]
        end
      end
    end
  end
end
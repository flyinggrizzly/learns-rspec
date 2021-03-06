require_relative '../../../app/ledger'

module ExpenseTracker
  # The `:aggregate_failures` property tells rspec to continue running and reporting
  # failed expectations when there are more than one in the example.
  RSpec.describe Ledger, :aggregate_failures, :db do
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
      end # context 'with a valid expense'

      context 'when the expense lacks a payee' do
        it 'rejects the expense as invalid' do
          expense.delete('payee')
          result = ledger.record(expense)

          expect(result).not_to be_success
          expect(result.expense_id).to eq(nil)
          expect(result.error_message).to include('`payee` is required')
          expect(DB[:expenses].count).to eq(0)
        end
      end # context 'when the expense lacks a payee'

      context 'when the expense lacks a date' do
        it 'rejects the expense as invalid' do
          expense.delete('date')
          result = ledger.record(expense)

          expect(result).not_to be_success
          expect(result.expense_id).to eq(nil)
          expect(result.error_message).to include('`date` is required')
        end
      end # context 'when the expense lacks a date'
    end # description of '#record'

    describe '#expenses_on' do
      it 'returns all expenses for the provided date' do
        result_1 = ledger.record(expense.merge('date' => '2017-06-10'))
        result_2 = ledger.record(expense.merge('date' => '2017-06-10'))
        result_3 = ledger.record(expense.merge('date' => '2017-06-11'))

        expect(ledger.expenses_on('2017-06-10')).to contain_exactly(
          a_hash_including(id: result_1.expense_id),
          a_hash_including(id: result_2.expense_id)
        )
      end

      it 'returns a blank array when there are no matching expenses' do
        expect(ledger.expenses_on('2017-06-10')).to eq([])
      end
    end # description of '#expenses_on'
  end # description of Ledger
end
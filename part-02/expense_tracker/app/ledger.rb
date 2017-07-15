module ExpenseTracker
  # Redefine the RecordResult struct in its permanent home
  RecordResult = Struct.new(:success?,
                            :expense_id,
                            :error_message)

  class Ledger
    def record(expense); end
  end
end
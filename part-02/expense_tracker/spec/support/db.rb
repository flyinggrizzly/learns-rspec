RSpec.configure do |c|
  # Prepare test database for test suite
  c.before(:suite) do
    Sequel.extension :migration
    Sequel::Migrator.run(DB, 'db/migrations')
    DB[:expenses].truncate
  end

  # Rollback database transactions in specs
  c.around(:example, :db) do |example|
    DB.transaction(rollback: :always) { example.run }
  end
end
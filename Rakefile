require "foodcritic"
require "rspec/core/rake_task"
require "rubocop/rake_task"

desc "Run RuboCop style and lint checks"
Rubocop::RakeTask.new(:rubocop) do |task|
  # don't abort rake on failure
  task.fail_on_error = false
end

desc "Run Foodcritic lint checks"
FoodCritic::Rake::LintTask.new(:foodcritic) do |t|
  t.options = { :fail_tags => ["any"] }
end

# desc "Run ChefSpec examples"
# RSpec::Core::RakeTask.new(:spec)

desc "Run all tests"
task :test => [:rubocop, :foodcritic]
task :default => :test

begin
  require "kitchen/rake_tasks"
  Kitchen::RakeTasks.new

  desc "Alias for kitchen:all"
  task :integration => "kitchen:all"

  task :test => :integration
rescue LoadError
  puts ">>>>> Kitchen gem not loaded, omitting tasks" unless ENV['CI']
end

require 'rake'
require 'rspec/core/rake_task'
require 'active_support'
require 'active_support/core_ext'

require_relative 'config'

namespace :db do
  desc "Drop, create, and migrate the database"
  task :reset => [:drop, :create, :migrate]

  desc "Create #{APP_NAME} databases"
  task "create" do
    puts "Creating #{APP_NAME} development and test databases if they don't exist..."
    system("createdb #{DB_NAME} --username #{DB_USERNAME} -w --no-password && createdb #{TEST_DB_NAME} --username #{DB_USERNAME} -w --no-password")
  end

  desc "Drop #{APP_NAME} databases"
  task "drop" do
    puts "Dropping #{APP_NAME} development and test databases..."
    system("dropdb #{DB_NAME} && dropdb #{TEST_DB_NAME}_test")
  end

  desc "Migrate the database"
  task "migrate" do
    ActiveRecord::Migrator.migrations_paths << File.dirname(__FILE__) + 'db/migrate'
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate(ActiveRecord::Migrator.migrations_paths, nil)
  end

  desc "Populate the database with sample data"
  task "seed" do
    require APP_ROOT.join('db', 'seeds.rb')
  end
end

namespace :generate do
  desc "Create a database migration\n rake generate:migration NAME=create_people"
  task :migration do
    unless ENV.has_key?('NAME')
      raise "Must specify NAME for migration, e.g. rake generate:migration NAME=create_people"
    end

    migration_name = ENV['NAME']
    class_name = migration_name.camelize
    timestamp = Time.now.strftime('%Y%m%d%H%M%S')
    filename = "#{timestamp}_#{migration_name}.rb"
    path = APP_ROOT.join('db', 'migrate', filename)

    if File.exist?(path)
      raise "ERROR! File '#{path}' already exists"
    end

    puts "Creating migration at #{path}"
    File.open(path, 'w+') do |f|
      f.write("class #{class_name} < ActiveRecord::Migration\n\tdef change\n\n\tend\nend")
    end
  end
end

desc 'Start IRB with application environment loaded'
task "console" do
  exec "irb -r./config"
end

desc "Run the specs"
RSpec::Core::RakeTask.new(:spec)
task :default  => :specs

# Will this not work?
#desc "Run the specs"
#task 'specs' do
#  exec "rspec spec"
#end

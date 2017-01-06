require 'pathname'
require 'pg'
require 'active_record'
require 'logger'

## Load all files and configure the db

APP_ROOT = Pathname.new(File.expand_path(File.dirname(__FILE__)))

APP_NAME = APP_ROOT.basename.to_s

DB_PATH  = APP_ROOT.join('db', APP_NAME + "_development.db").to_s

DB_NAME = APP_NAME + "_development.db"

TEST_DB_NAME = APP_NAME + "_test.db"

DB_USERNAME = 'postgres'

DB_PASSWORD = ''

if ENV['DEBUG']
  ActiveRecord::Base.logger = Logger.new(STDOUT)
end


Dir[APP_ROOT.join('models', '*.rb')].each do |model_file|
  filename = File.basename(model_file).gsub('.rb', '')
  autoload ActiveSupport::Inflector.camelize(filename), model_file
end

ActiveRecord::Base.establish_connection :adapter  => 'postgresql',
                                        :database => DB_NAME,
                                        :host => 'localhost',
                                        :username => DB_USERNAME,
                                        :password => DB_PASSWORD

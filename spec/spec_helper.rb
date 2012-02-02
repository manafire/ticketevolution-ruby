require "ap"
require File.join(File.dirname(File.expand_path(__FILE__)), '..', 'lib', 'ticket_evolution.rb')
require 'active_support/ordered_hash' unless RUBY_VERSION =~ /^1\.9/

@spec_path = Pathname.new(File.join(File.dirname(File.expand_path(__FILE__))))

Dir[File.join(@spec_path, 'support/*.rb')].each { |file| require(file) }

RSpec.configure do |config|
end

require @spec_path + 'fixtures' + 'fake.rb'
require @spec_path + 'shared_examples' + 'endpoints' + 'class.rb'
require @spec_path + 'shared_examples' + 'endpoints' + 'create.rb'
require @spec_path + 'shared_examples' + 'endpoints' + 'deleted.rb'
require @spec_path + 'shared_examples' + 'endpoints' + 'list.rb'
require @spec_path + 'shared_examples' + 'endpoints' + 'search.rb'
require @spec_path + 'shared_examples' + 'endpoints' + 'show.rb'
require @spec_path + 'shared_examples' + 'endpoints' + 'update.rb'
require @spec_path + 'shared_examples' + 'errors.rb'
require @spec_path + 'shared_examples' + 'models.rb'

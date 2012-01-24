require File.join(File.dirname(File.expand_path(__FILE__)), '..', 'lib', 'ticket_evolution.rb')

RSpec.configure do |config|
end

@spec_path = Pathname.new(File.join(File.dirname(File.expand_path(__FILE__))))

require @spec_path + 'shared_examples' + 'errors.rb'
require @spec_path + 'shared_examples' + 'endpoints' + 'class.rb'
require @spec_path + 'shared_examples' + 'endpoints' + 'create.rb'
require @spec_path + 'shared_examples' + 'endpoints' + 'deleted.rb'
require @spec_path + 'shared_examples' + 'endpoints' + 'list.rb'
require @spec_path + 'shared_examples' + 'endpoints' + 'search.rb'
require @spec_path + 'shared_examples' + 'endpoints' + 'show.rb'
require @spec_path + 'shared_examples' + 'endpoints' + 'update.rb'
require @spec_path + 'fixtures' + 'fake.rb'

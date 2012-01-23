require 'base64'
require 'digest/md5'
require 'openssl'
require File.join(File.dirname(File.expand_path(__FILE__)), '..', 'lib', 'ticket_evolution.rb')

RSpec.configure do |config|
end

@spec_path = Pathname.new(File.join(File.dirname(File.expand_path(__FILE__))))

require @spec_path + 'shared_examples.rb'
require @spec_path + 'fixtures' + 'fake.rb'

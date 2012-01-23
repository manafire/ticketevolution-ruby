require 'spec_helper'

describe TicketEvolution::ApiError do
  let(:klass) { TicketEvolution::ApiError }
  let(:response) { Fake.error_response }
  let(:instance) { klass.new(response) }

  subject { instance }

  its(:error) { should == response.body['error'] }
  its(:code) { should == response.response_code }
  its(:message) { should == response.server_message }
end

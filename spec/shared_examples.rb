require 'spec_helper'

shared_examples_for "a ticket_evolution error class" do
  its(:ancestors) { should include Exception }
end

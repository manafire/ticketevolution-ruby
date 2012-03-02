require 'spec_helper'

describe TicketEvolution::Company do
  let(:klass) { TicketEvolution::Company }
  subject { TicketEvolution::Company }

  it_behaves_like "a ticket_evolution model"

  context "#destroy" do
    let(:company) { connection.companies.create(:name => "foo 1234567890hyq334d578foq5y7f83ho47o5qyyyyyyyfh7w34odhq57y345q78do5yq378") }

    context "on success" do
      use_vcr_cassette "endpoints/company/destroy_success", :match_requests_on => [:method, :uri, :body]
      before { company }

      it "destroy the instance" do
        response = company.destroy
        response.should be_true

        same_company = connection.companies.find(company.id)
        same_company.should be_instance_of(TicketEvolution::ApiError)
        same_company.code.should == 404
      end
    end

    context "on error" do
      use_vcr_cassette "endpoints/company/destroy_error", :match_requests_on => [:method, :uri, :body]

      it "cannot destroy one that doesn't exist" do
        unknown_company = TicketEvolution::Company.new(:id => 123, :name => "bar", :connection => connection)
        response = unknown_company.destroy

        response.should be_instance_of(TicketEvolution::ApiError)
        response.code.should == 404
      end
    end
  end
end


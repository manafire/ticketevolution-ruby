require 'spec_helper'

describe TicketEvolution::Accounts do
  let(:klass) { TicketEvolution::Accounts }
  let(:single_klass) { TicketEvolution::Account }

  it_behaves_like 'a ticket_evolution endpoint class'
  it_behaves_like 'a list endpoint'
  it_behaves_like 'a show endpoint'

  context "integration tests" do
    use_vcr_cassette "endpoints/accounts", :record => :new_episodes

    it "returns an account" do
      id = 62
      account = connection.accounts.show(id)

      account.url.should == "/accounts/#{id}"
      account.currency.should == "USD"
      account.updated_at.should_not be_nil
      account.balance.should == "9922.71"
      account.id.should == id.to_s

      account.client.should == TicketEvolution::Client.new({
        :connection => connection,
        "url" => "/clients/3",
        "name" => "Main Office",
        "id" => "3"
      })
    end

    it "returns a list of accounts" do
      accounts = connection.accounts.list(:per_page => 4, :page => 5)

      accounts.per_page.should == 4
      accounts.current_page.should == 5
      accounts.total_entries.should == 88

      accounts.size.should == 4
      accounts.each do |account|
        account.should be_a TicketEvolution::Account
      end
    end
  end
end

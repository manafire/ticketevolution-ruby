require 'spec_helper'

describe TicketEvolution::Categories do
  let(:klass) { TicketEvolution::Categories }
  let(:single_klass) { TicketEvolution::Category }

  it_behaves_like 'a ticket_evolution endpoint class'
  it_behaves_like 'a deleted endpoint'
  it_behaves_like 'a list endpoint'
  it_behaves_like 'a show endpoint'

  describe "integrations" do
    use_vcr_cassette "endpoints/categories", :record => :new_episodes

    context "#deleted" do
      it "returns a list of deleted categories" do
        categories = connection.categories.deleted(:per_page => 2)

        categories.size.should == 1
        categories.each do |category|
          category.should be_instance_of TicketEvolution::Category
        end
        categories.first.name.should == "Insult Comedy"
      end
    end
  end
end

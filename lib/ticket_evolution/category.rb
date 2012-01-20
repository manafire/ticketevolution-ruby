module TicketEvolution
  class Category < TicketEvolution::Base
    attr_accessor :parent, :name, :updated_at, :id, :url


    def initialize(api_response)
      super(api_response)
      self.id         = @attrs_for_object["id"]
      self.parent     = @attrs_for_object["parent"]
      self.name       = @attrs_for_object["name"]
      self.updated_at = @attrs_for_object["updated_at"]
      self.url        = @attrs_for_object["url"]
    end
  end
end

module TicketEvolution
  class Collection
    attr_accessor :total_entries, :per_page, :current_page, :entries

    include Enumerable

    delegate :all, :each, :last, :size, :[], :to => :entries

    def initialize(options = {})
      options.each {|k,v| send("#{k}=", v)}
      @entries ||= []
    end

    def self.build_from_response(response, entries_key, singular_class)
      entries = response.body[entries_key] || []
      new(
        :total_entries => response.body['total_entries'],
        :per_page => response.body['per_page'],
        :current_page => response.body['current_page'],
        :entries => entries.collect do |entry|
          singular_class.new(entry.merge({:connection => response.body[:connection]}))
        end
      )
    end
  end
end

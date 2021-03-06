module TicketEvolution
  class Search < Endpoint
    def list(params = {})
      request(:GET, nil, params, &method(:build_for_search))
    end

    def build_for_search(response)
      collection = TicketEvolution::Collection.new(
        :total_entries => response.body['total_entries'],
        :per_page => response.body['per_page'],
        :current_page => response.body['current_page']
      )

      response.body['results'].each do |result|
        collection.entries << "TicketEvolution::#{result['_type']}".
        constantize.new(result.merge({:connection => connection}))
      end

      collection
    end
  end
end

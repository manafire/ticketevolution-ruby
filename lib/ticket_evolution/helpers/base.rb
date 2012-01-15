module TicketEvolution
  module Helpers
    module Base
      
      def api_base;           "#{http_base}.ticketevolution.com";                       end
      def http_base;          "https://#{environmental_base}";                          end
      # TO REMOVE
      def environmental_base; TicketEvolution.mode == :sandbox ? "api.sandbox" : "api"; end


      def build_params_for_get(params)
        get_params = params.keys.inject([]) do |memo,key|
          current_parameter =  key.to_s + "=" + params[key].to_s
          memo.push(current_parameter)
        end

        get_params = get_params.sort.join("&")
        get_params = get_params.encoded
        return get_params
      end

      def sanitize_parameters(klass,mtd,params_hash)
        if klass == TicketEvolution::Category
          if mtd == "deleted"
            allowed = %w(name parent_id updated_at deleted_at )
            params_hash = clean_and_remove(allowed,params_hash)
            return params_hash
          elsif mtd == "search"
          end
        elsif TicketEvolution::Performer
        elsif TicketEvolution::Venue
        elsif TicketEvolution::Event
        end        
      end
                
      def clean_and_remove(white_list,raw)
        allowed_keys = raw.keys.inject({}) do |parameters,key|
          parameters[key] = raw[key] if white_list.include?(key.to_s) ||  white_list.include?(key.to_sym)
          parameters
        end
        return allowed_keys
      end
      
    end
  end
end


module Ticketevolution
  module Helpers
    module Base
      
      def http_base;          "#{protocol}://#{environmental_base}";                    end    
      def protocol;           Ticketevolution.protocol == :https ? "https" : "http";    end
      def environmental_base; Ticketevolution.mode == :sandbox ? "api.sandbox" : "api"; end
    
    
      def build_params_for_get(params)
        get_params = params.keys.inject([]) do |memo,key|
          current_parameter =  key.to_s + "=" + params[key].to_s
          memo.push(current_parameter)
        end

        get_params = get_params.sort.join("&")
        return get_params
      end
    
    end
  end
end
  
module Faraday
  module Utils
    # Override Faraday's version so it sorts the params
    alias :faradays_build_nested_query :build_nested_query
    def build_nested_query(value, prefix = nil)
      if faradays_build_nested_query_method_accepts_prefix?
        return faradays_build_nested_query(value, prefix)
      end

      return faradays_build_nested_query(value) unless prefix

      if value.is_a? Hash
        value.to_ordered_hash.map { |k, v|
          build_nested_query(v, prefix ? "#{prefix}%5B#{escape(k)}%5D" : escape(k))
        }.join("&")
      elsif value.is_a? Array
        value.map { |v| build_nested_query(v, "#{prefix}%5B%5D") }.join("&")
      elsif value.nil?
        prefix
      else
        "#{prefix}=#{escape(value)}"
      end
    end

    def faradays_build_nested_query_method_accepts_prefix?
      method(:faradays_build_nested_query).arity != 1
    end

    class ParamsHash
      def to_query(_encoder = nil)
        Utils.build_nested_query(self)
      end
    end
  end
end

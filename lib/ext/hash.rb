class Hash
  def to_ordered_hash
    ActiveSupport::OrderedHash.new.tap do |hash|
      self.sort_by{|k,v| k.to_s}.each do |k, v|
        hash[k] = v
      end
    end
  end
end

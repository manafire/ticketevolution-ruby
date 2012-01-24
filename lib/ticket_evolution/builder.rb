module TicketEvolution
  class Builder < OpenStruct
    def initialize(*stuff)
      super
      @table.each do |k, v|
        send("#{k}=", process_datum(v))
      end
    end

    private

    def process_datum(v)
      v.is_a?(Hash) ? Datum.new(v) : Time.parse(v)
    end

    def method_missing(meth, *args, &block)
      args.size == 1 ? super(meth, process_datum(args.first), &block) : super(meth, process_datum(args), &block)
    end
  end
end

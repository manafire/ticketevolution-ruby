module ConnectionSupport
  def connection
    TicketEvolution::Connection.new(
      :token => "b2b5a7a33b1a78896ed1b53d81c5c9cc",
      :secret => "m2bAipNKfNnzz9z88+z2cgDy4Tb+QjIudmpJkJcr"
    )
  end

  RSpec.configure {|c| c.include self}
end

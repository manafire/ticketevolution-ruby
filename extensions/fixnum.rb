class Fixnum
  
  def encoded
    CGI.escape(self.to_s)
  end
  
end
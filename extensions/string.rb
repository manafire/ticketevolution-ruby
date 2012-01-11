require 'cgi'
class String

  def encoded
    CGI.escape(self)
  end

end

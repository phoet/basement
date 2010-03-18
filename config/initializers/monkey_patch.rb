# patch Array to have a random-sort method
class Array
  
  def sort_random()
    self.sort do |x,y| 
      Kernel.rand() <=> Kernel.rand()
    end
  end
  
end

# patch HTTParty to use a configurable timeout
module HTTParty
  class Request
    private
      def http
        http = Net::HTTP.new(uri.host, uri.port, options[:http_proxyaddr], options[:http_proxyport])
        http.use_ssl = (uri.port == 443)
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http.open_timeout = http.read_timeout = options[:timeout].to_i if options[:timeout].to_i > 0
        http
      end
  end
end

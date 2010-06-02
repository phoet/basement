# patch Array to have a random-sort method
class Array
  def sort_random()
    self.sort do |x,y| 
      Kernel.rand() <=> Kernel.rand()
    end
  end
end

# patch I18n to automatically make a DateTime from a String
module I18n
  class << self
    alias :localize_old :localize
    def localize(object, options = {})
      object = DateTime.parse(object) if object.is_a? String
      localize_old(object, options)
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


# patch ruby-aaws to use a local .amazonrc file
module Amazon
  class Config < Hash
    def initialize(config_str=nil)
      locale = nil

      if config_str
        config_files = [ config_str ]
        config_class = StringIO
      else
        config_files = [ File.join( '', 'etc', 'amazonrc' ) ]
        home = ENV['AMAZONRCDIR'] ||
        ENV['HOME'] || ENV['HOMEDRIVE'] + ENV['HOMEPATH'] ||
        ENV['USERPROFILE']
        user_rcfile = ENV['AMAZONRCFILE'] || '.amazonrc'

        if home
          config_files << File.expand_path( File.join( home, user_rcfile ) )
        end

        # MONKEY_PATCH add rails-file
        config_files << File.join(RAILS_ROOT, '.amazonrc') if defined?(RAILS_ROOT)
        config_class = File
      end

      config_files.each do |cf|

        if config_class == StringIO
          readable = true
        else
          readable = File.exists?( cf ) && File.readable?( cf )
        end

        if readable

          Amazon.dprintf( 'Opening %s ...', cf ) if config_class == File

          config_class.open( cf ) { |f| lines = f.readlines }.each do |line|
            line.chomp!
            next if line =~ /^(#|$)/

            Amazon.dprintf( 'Read: %s', line )

            if match = line.match( /^\[(\w+)\]$/ )
              locale = match[1]
              Amazon.dprintf( "Config locale is now '%s'.", locale )
              next
            end

            begin
              match = line.match( /^\s*(\S+)\s*=\s*(['"]?)([^'"]+)(['"]?)/ )
              key, begin_quote, val, end_quote = match[1, 4]
              raise ConfigError if begin_quote != end_quote

            rescue NoMethodError, ConfigError
              raise ConfigError, "bad config line: #{line}"
            end

            if locale && locale != 'global'
              self[locale] ||= {}
              self[locale][key] = val
            else
              self[key] = val
            end
          end
        end
      end
    end
  end
end

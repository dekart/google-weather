require 'hpricot'
module GoogleWeather
  
  class Connection
    attr_accessor :location
    
    def initialize(*args)
      return if args.empty?
      options = args.first
      self.location = options[:location]
    end
    
    def raw_data
      @response ||= Net::HTTP.get(URI.parse('http://www.google.com/ig/api?weather=' + URI.encode(location)))
    end
    
    def parsed_data
      Hpricot(raw_data)
    end
    
    def forecast_information(item)
      ((parsed_data/'forecast_information').first/item).first['data']
    end
    
    def info
      GoogleWeather::ForecastInformation.new(
        :city => forecast_information('city'),
        :postal_code => forecast_information('postal_code'),
        :latitude => forecast_information('latitude_e6'),
        :longitude => forecast_information('longitude_e6')
      )
    end
  end
  
  class ForecastInformation
    attr_accessor :city, :postal_code, :latitude, :longitude, :forecast_date, :connection_date, :unit_system
    
    def initialize(attrs = {})
      attrs.each do |k,v|
        self.send("#{k}=",v)
      end
    end
  end
end
require 'google_weather'
=begin 
<?xml version="1.0"?>
<xml_api_reply version="1">
<weather module_id="0" tab_id="0">
  <forecast_information>
    <city data="Drammen, Buskerud"/>
    <postal_code data="Drammen"/>
    <latitude_e6 data=""/>
    <longitude_e6 data=""/>
    <forecast_date data="2008-11-06"/>
    <current_date_time data="2008-11-06 18:30:22 +0000"/>
    <unit_system data="US"/>
  </forecast_information>
  <current_conditions>
    <condition data="Mostly Cloudy"/>
    <temp_f data="36"/>
    <temp_c data="2"/>
    <humidity data="Humidity: 88%"/>
    <icon data="/images/weather/mostly_cloudy.gif"/>
    <wind_condition data="Wind: N at 0 mph"/>
  </current_conditions>
  <forecast_conditions>
    <day_of_week data="Today"/>
    <low data="26"/>
    <high data="41"/>
    <icon data="/images/weather/mostly_sunny.gif"/>
    <condition data="Partly Sunny"/>
  </forecast_conditions>
  <forecast_conditions>
    <day_of_week data="Fri"/>
    <low data="28"/>
    <high data="41"/>
    <icon data="/images/weather/chance_of_rain.gif"/>
    <condition data="Chance of Rain"/>
  </forecast_conditions>
  ...
</weather>
</xml_api_reply>
=end

describe GoogleWeather, "without a location" do
  before(:each) do
    @weather = GoogleWeather::Connection.new
  end
  
  it("should raise a connection error") {pending; @weather.info.should_raise(GoogleWeather::LocationError)}

end

describe GoogleWeather do
  before(:each) do
    @response = %Q[<?xml version="1.0"?>
<xml_api_reply version="1">
<weather module_id="0" tab_id="0">
  <forecast_information>
    <city data="Drammen, Buskerud"/>
    <postal_code data="Drammen"/>
    <latitude_e6 data=""/>
    <longitude_e6 data=""/>
    <forecast_date data="2008-11-06"/>
    <current_date_time data="2008-11-06 18:30:22 +0000"/>
    <unit_system data="US"/>
  </forecast_information>
  <current_conditions>
    <condition data="Mostly Cloudy"/>
    <temp_f data="36"/>
    <temp_c data="2"/>
    <humidity data="Humidity: 88%"/>
    <icon data="/images/weather/mostly_cloudy.gif"/>
    <wind_condition data="Wind: N at 0 mph"/>
  </current_conditions>
  <forecast_conditions>
    <day_of_week data="Today"/>
    <low data="26"/>
    <high data="41"/>
    <icon data="/images/weather/mostly_sunny.gif"/>
    <condition data="Partly Sunny"/>
  </forecast_conditions>
  <forecast_conditions>
    <day_of_week data="Fri"/>
    <low data="28"/>
    <high data="41"/>
    <icon data="/images/weather/chance_of_rain.gif"/>
    <condition data="Chance of Rain"/>
  </forecast_conditions>
  ...
</weather>
</xml_api_reply>]
    @weather = GoogleWeather::Connection.new(:location => 'Drammen')
    Net::HTTP.stub!(:get).and_return(@response)
  end
  
  it("should have forecast information"){@weather.info.should be_a_kind_of(GoogleWeather::ForecastInformation)}  
  it("should get the city nicely") { @weather.forecast_information('city').should == 'Drammen, Buskerud'}
  it("should map the city") {@weather.info.city.should == "Drammen, Buskerud"}
  it("should map the postal code") {@weather.info.postal_code.should == "Drammen" }
  it("should map the latitude") { @weather.info.latitude.should == "" }
  it("should map the longitude") { @weather.info.longitude.should == "" }
  # it("should set the date") { @weather.info.forecast_date.should be_a_kind_of(Date) }
  # it("should set the lookup date") { @weather.info.connection_date.should be_a_kind_of(DateTime) }
  # it("should set the unit system") { @weather.info.unit_system.should == 'US' }
end

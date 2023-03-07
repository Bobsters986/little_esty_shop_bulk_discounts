# require './app/poros/holiday'
# require './app/services/holiday_service'

class HolidaySearch
  
  def holiday_information
    service.holidays.first(3).map do |data|
      Holiday.new(data)
    end
  end

  def service
    HolidayService.new
  end
end
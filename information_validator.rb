require 'pry'

class InformationValidator
  def initialize(data)
    @data = data
    @month_dictionary = {
                          "jan" => 1,
                          "feb" => 2,
                          "mar" => 3,
                          "apr" => 4,
                          "may" => 5,
                          "jun" => 6,
                          "jul" => 7,
                          "aug" => 8,
                          "sep" => 9,
                          "oct" => 10,
                          "nov" => 11,
                          "dec" => 12
                        }
  end

  def month_to_integer(month)
    @month_dictionary[month.gsub(/[^0-9a-z ]/i, '').downcase]
  end

  def clean_data
    @data.map do |flower|
      flower.each_with_index.inject([]) do |acc, (info, i)|
        if i == 5 && info.include?(" - ")
          new_info = info.split("(")[1].split(" - ")
          acc << month_to_integer(new_info[0])
          acc << month_to_integer(new_info[1])
        elsif i == 5
          2.times do
            acc << @month_dictionary[info.downcase.match(/#{@month_dictionary.keys.map(&Regexp.method(:escape)).join('|')}/).to_s]
          end
        else
          acc << info.tr("\n", "").lstrip
        end
        acc
      end
    end
  end
end

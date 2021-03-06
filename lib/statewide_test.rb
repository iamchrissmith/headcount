require_relative 'custom_errors'
require 'pry'

class StatewideTest
  attr_reader :name,
              :data

  def initialize(args)
    @name = args[:name]
    args.delete(:name)
    @data = args
  end

  def validate_args(args)
    races = [:asian, :black, :pacific_islander,
            :hispanic, :native_american, :two_or_more, :white]
    valid = {
      :grade => [3,8],
      :race => races,
      :subject => [:math, :reading, :writing],
      :year => valid_3_or_8_years,
      :csap_year => valid_ethnicity_years
    }
    args.each do |set, value|
      raise UnknownDataError unless valid[set].include?(value)
    end
  end

  def proficient_by_grade(grade)
    validate_args({grade:grade})
    return @data[:third_grade] if grade == 3
    return @data[:eighth_grade] if grade == 8
  end

  def find_by_category(grade, subject)
    if grade == 3
      return get_category_by_years_test(:third_grade, subject)
    elsif grade == 8
      return get_category_by_years_test(:eighth_grade, subject)
    end
  end

  def get_category_by_years_test(category, subject)
    formatted = {}
    @data[category].each do |year, test_result|
      if test_result[subject].to_f != 0.0
        formatted[year] =  test_result[subject]
      end
    end
    formatted
  end

  def growth_by_grade_over_years(grade, subject = nil)
    validate_args({grade:grade})
    validate_args({subject:subject}) if !subject.nil?
    scores = find_by_category(grade, subject)
    average_scores(scores)
  end

  def average_scores(scores)
    max_year = scores.keys.max
    min_year = scores.keys.min
    max_val = scores[max_year].to_f
    min_val = scores[min_year].to_f
    year_dif = max_year.to_i - min_year.to_i
    if year_dif != 0
      ((max_val - min_val) / (max_year - min_year)).round(3)
    else
      0.0
    end
  end

  def proficient_by_race_or_ethnicity(race)
    validate_args({race:race})
    years = get_years_data(race)
    format_to_year_data(years)
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    validate_args({grade:grade, subject:subject, year:year})
    return @data[:third_grade][year][subject] if grade == 3
    return @data[:eighth_grade][year][subject] if grade == 8
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    validate_args({subject:subject, race:race, csap_year:year})
    race_data = proficient_by_race_or_ethnicity(race)
    race_data[year][subject]
  end

  def get_years_data(filter)
    tests = [:math, :reading, :writing]
    tests.map do |subject|
      get_category_by_years(filter, subject)
    end
  end

  def format_to_year_data(years)
    years = years.reduce(&:+)
    groups_deepened = group_into_years(years)
    flatten_groups(groups_deepened)
  end

  def flatten_groups(groups)
    sets = groups.map do |key, value|
      {key => value.reduce({}) {|h,pairs| pairs.each {|k,v| h[k] = v }; h }}
    end
    reduce_sets(sets)
  end

  def reduce_sets(sets)
    sets.reduce({}) do |h, sets|
      h.merge(sets)
    end
  end

  def group_into_years(years)
    year_groups = years.group_by do |year_subject|
      year_subject.keys.first
    end
    remove_year_keys(year_groups)
  end

  def remove_year_keys(year_groups)
    year_groups.map { |key, v| [key, v.map(&:values).flatten] }.to_h
  end

  def get_category_by_years(criteria, category)
    @data[category].map do |year, breakdown|
      {year => {category => breakdown[criteria]}}
    end
  end

  def update_data(args, look_in = @data)
    args.delete(:name) if args.key?(:name)
    args.each do |category, value|
      if look_in[category].nil?
        look_in[category] = value
      else
        update_data(value, look_in[category])
      end
    end
  end

  private

  def valid_3_or_8_years
    third_years = @data[:third_grade].keys.flatten.sort
    eigth_years = @data[:eighth_grade].keys.flatten.sort
    years = third_years + eigth_years
    [*(years.first..years.last)]
  end

  def valid_ethnicity_years
    reading_years = @data[:reading].keys.flatten.sort
    math_years = @data[:math].keys.flatten.sort
    writing_years = @data[:writing].keys.flatten.sort
    years = reading_years + math_years + writing_years
    [*(years.first..years.last)]
  end
end

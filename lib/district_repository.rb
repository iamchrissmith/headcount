require_relative 'district'
require_relative 'enrollment_repository'
require_relative 'statewide_testing_repository'

class DistrictRepository
  attr_reader :enrollment_repo,
              :testing_repo,
              :economic_profile_repo,
              :data

  def initialize
    @data = []
    @enrollment_repo = EnrollmentRepository.new
    @testing_repo = StatewideTestRepository.new
    @economic_profile_repo = EconomicProfileRepository.new
  end

  def load_data(args)
    if args.key?(:enrollment)
      enrollment_data = {enrollment: args[:enrollment]}
      district_data = @enrollment_repo.load_data(enrollment_data)
      populate_data(district_data)
    end
    if args.key?(:statewide_testing)
      testing_data = {statewide_testing: args[:statewide_testing]}
      district_data = @testing_repo.load_data(testing_data)
      populate_data(district_data)
    end
    if args.key?(:economic_profile)
      economic_data = {economic_profile: args[:economic_profile]}
      district_data = @economic_profile_repo.load_data(economic_data)
      populate_data(district_data)
    end
  end

  def populate_data(districts)
    districts.each do |district|
      create_district(district) if !find_by_name(district)
    end
  end

  def find_by_name(name)
    data.find { |district| district.name == name }
  end

  def find_all_matching(text)
    found = data.select do |district|
      district.name.upcase.include? text.upcase
    end
    found
  end

  def create_district(name)
    data << District.new({name: name, repo: self})
  end
end

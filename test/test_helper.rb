require 'simplecov'
SimpleCov.start do
  add_filter '/test/'
end
require 'pry'
require 'minitest/autorun'
require 'minitest/pride'

require_relative '../lib/csv_parser'

require_relative '../lib/district_repository'
require_relative '../lib/district'

require_relative '../lib/enrollment_repository'
require_relative '../lib/builders/enrollment_builder'
require_relative '../lib/enrollment'

require_relative '../lib/economic_profile_repository'
require_relative '../lib/builders/economic_profile_builder'
require_relative '../lib/economic_profile'

require_relative '../lib/statewide_testing_repository'
require_relative '../lib/builders/statewide_test_builder'
require_relative '../lib/statewide_test'

require_relative '../lib/result_set'
require_relative '../lib/result_entry'

require_relative '../lib/headcount_analyst'

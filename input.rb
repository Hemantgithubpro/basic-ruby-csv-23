# frozen_string_literal: true

require_relative 'csv_reader'

# Input class
class Input
  attr_accessor :employees, :file_name

  def initialize(file_name)
    @file_name = file_name
  end

  def load_employees
    csv_reader = CsvReader.new
    csv_reader.read_in_csv_data(file_name)
    self.employees = csv_reader.employees
  end
end

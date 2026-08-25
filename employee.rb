# frozen_string_literal: true

require_relative 'csv_reader'

# Employee class
class Employee
  attr_accessor :name, :emp_id, :designation

  def initialize(name, emp_id, designation)
    @name = name
    @emp_id = emp_id
    @designation = designation
  end

  def to_s
    "#{name} (EmpId: #{emp_id})"
  end

  def self.from_row(row)
    new(row[:name], row[:emp_id], row[:designation])
  end
end

# ReadFile class
class ReadFile
  attr_accessor :file_name, :employees

  def initialize(file_name)
    @file_name = file_name
    @employees = []
  end

  def load_employees
    self.employees = CSV.read_csv_file(file_name).map { |row| Employee.from_row(row) }
  end
end

# WriteFile class
class WriteFile
  attr_accessor :employees, :file_name

  def initialize(employees, file_name)
    @employees = employees
    @file_name = file_name
  end

  def write_to_file # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    employees_by_designation = employees.group_by(&:designation)

    File.open(file_name, 'w') do |output_file|
      employees_by_designation.keys.sort.each_with_index do |designation, designation_index|
        designation_employees = employees_by_designation[designation].sort_by do |employee|
          employee.emp_id.to_i
        end
        label_designation = designation_employees.length > 1 ? "#{designation}s" : designation

        output_file.puts label_designation
        designation_employees.each { |employee| output_file.puts employee }

        output_file.puts if designation_index != employees_by_designation.keys.size - 1
      end
    end
  end
end

input_file = ARGV[0] || 'file.csv'
output_file = ARGV[1] || 'output.txt'

employee_data = ReadFile.new(input_file)
employee_data.load_employees

WriteFile.new(employee_data.employees, output_file).write_to_file

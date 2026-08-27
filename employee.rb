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

  def self.write_to_file(employees, file_name) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    employees_by_designation = employees.group_by(&:designation)
    # employees_by_designation is a hash where the keys are designations and the values are arrays of Employee objects.
    # { "Developer" => [emp_obj, ...]}

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

employees = CSV.read_csv_file(input_file).map { |row| Employee.from_row(row) }
# read_csv_file returns an array of Hashes, {:name, :emp_id, :designation}
# employees is an array of Employee objects, each with a name, emp_id, and designation, [Employee, Employee, ...]
Employee.write_to_file(employees, output_file)

# frozen_string_literal: true

require_relative 'input'

# Output class
class Output
  attr_accessor :employees, :file_name

  def initialize(employees, file_name)
    @employees = employees
    @file_name = file_name
  end

  def write # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    grouped_employees = employees.group_by(&:designation)

    File.open(@file_name, 'w') do |file|
      grouped_employees.keys.sort.each_with_index do |designation, index|
        employees = grouped_employees[designation].sort_by { |employee| employee.emp_id.to_i }
        label = employees.length > 1 ? "#{designation}s" : designation

        file.puts label
        employees.each do |employee|
          file.puts "#{employee.name} (EmpId: #{employee.emp_id})"
        end

        file.puts if index != grouped_employees.keys.size - 1
      end
    end
  end
end

input_file = ARGV[0] || 'file.csv'
output_file = ARGV[1] || 'output.txt'

input = Input.new(input_file)
input.load_employees

Output.new(input.employees, output_file).write

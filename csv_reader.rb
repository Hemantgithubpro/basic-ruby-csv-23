# frozen_string_literal: true

require 'csv'
require_relative 'employee'

# CsvReader class
class CsvReader
  attr_accessor :employees

  def initialize
    @employees = []
  end

  def read_csv_data(csv_file_name) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity
    # using CSV.parse
    file_data = File.read(csv_file_name)
    csv_data = CSV.parse(file_data, headers: true, skip_blanks: true)
    csv_data.each do |row|
      name = row['Name']&.strip
      emp_id = row['EmpId']&.strip
      designation = row['Designation']&.strip

      next if name.nil? || emp_id.nil? || designation.nil?

      employees << Employee.new(name, emp_id, designation)
    end

    # using CSV.foreach
    # CSV.foreach(csv_file_name, headers: true, skip_blanks: true) do |row|
    #   name = row['Name']&.strip
    #   emp_id = row['EmpId']&.strip
    #   designation = row['Designation']&.strip

    #   next if name.nil? || emp_id.nil? || designation.nil?

    #   employees << Employee.new(name, emp_id, designation)
    # end

    # using CSV.read
    # csv_data = CSV.read(csv_file_name, headers: true, skip_blanks: true)
    # csv_data.each do |row|
    #   name = row['Name']&.strip
    #   emp_id = row['EmpId']&.strip
    #   designation = row['Designation']&.strip

    #   next if name.nil? || emp_id.nil? || designation.nil?

    #   employees << Employee.new(name, emp_id, designation)
    # end
  end
end

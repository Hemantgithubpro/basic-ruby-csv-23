# frozen_string_literal: true

require 'csv'

# CSV class
class CSV
  def self.read_csv_file(file_name)
    rows = []

    parse(File.read(file_name), headers: true, skip_blanks: true) do |row|
      name = row['Name']&.strip
      emp_id = row['EmpId']&.strip
      designation = row['Designation']&.strip

      next if name.nil? || emp_id.nil? || designation.nil?

      # rows << { 'Name' => name, 'EmpId' => emp_id, 'Designation' => designation }
      rows << { name: name, emp_id: emp_id, designation: designation }
    end

    rows
  end
end

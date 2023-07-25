require_relative 'path_helpers.rb'
class BaseShowParser
  include PathHelpers

  attr_reader :firm
  def initialize(firm)
    @firm = firm.downcase
  end

  def index_parsed_json
    @index_parsed_json ||= JSON.parse(File.read(index_parsed_json_file_path))
  end

  def parse_show
    result = index_parsed_json.map do |result|
      puts "parse #{result['Auction URL']}"
      parsed_result = parse_show_page(result)
      if parsed_result.nil?
        nil
      else
        result.merge(parsed_result)
      end
    end.compact
    finish
    write_to_json_file(result)
    write_csv(result)
    # write_educations_to_csv
    # puts "Missing locations: #{missing_locations.uniq}"
    # missing_degree.flatten.uniq.each do |degree|
    #   puts "Missing degree: #{degree}"
    # end
  end

  def write_to_json_file(result)
    puts "Writing to #{show_parsed_json_file_path}"
    File.open(show_parsed_json_file_path, "w") do |f|
      f.write(JSON.pretty_generate(result))
    end
  end

  def write_educations_to_csv
    data = JSON.parse(File.read(show_parsed_json_file_path))
    puts "Writing to #{educations_path}"
    fields = %w(name university graduation_year degree raw_education)
    CSV.open(educations_path, "wb") do |csv|
      csv << fields
      data.each do |item|
        next unless item["educations"]

        item["educations"].each.with_index do |education, index|
          csv << [item["name"], education["university"], education["graduation_year"], education["degree"], item["raw_educations"][index]]
        end
      end
    end
  end

  def write_csv(result)
    fields = ['Full Auction title', 'Is Owned', "Is it 'no reserve'", 'Year', 'Make', 'Model Family', 'Model Identifier', 'Era', 'Origin', 'Category', 'Number Of Comments', 'Seller', 'Private Party Or Dealer', 'Ext. Color Group', 'Int. Color Group', 'Buyer', 'Odometer', 'Miles Of Kilometers', 'Location', 'Chassis/VIN', 'Status', 'Value', 'Auction End Day', 'Auction End Month', 'Auction End Day Number', 'Auction End Time', 'Number Of Bids', 'Auction URL', 'Number Of Views', 'Watchers', 'Color Description']

    CSV.open(show_parsed_csv_file_path, "wb") do |csv|
      csv << fields
      result.each do |hash|
        csv << hash.values_at(*fields)
      end
    end
    puts "Writing to #{show_parsed_csv_file_path}"
  end

  def handle_nil(&block)
    yield
  rescue
    nil
  end

  def analyze_parsed_show_json
    parsed_json = JSON.parse(File.read(show_parsed_json_file_path))
    educations_missing = parsed_json.select { |result| result["educations"].nil? }
    location           = parsed_json.select { |result| result["location"].nil? }
    puts "Educations missing: #{educations_missing.count}"
    puts educations_missing.map { |result| result["full_url"] }
    puts "Location missing: #{location.count}"
  end

  def get_all_missing_locations
    parsed_json = JSON.parse(File.read(show_parsed_json_file_path))
    parsed_json.select { |result| LocationParser.parse(result["office"]).nil? }.map { |result| result["office"] }.tally.sort_by { |k, v| v }.reverse.to_h.keys
  end

  def get_all_locations
    parsed_json = JSON.parse(File.read(show_parsed_json_file_path))
    parsed_json.map { |result| result["office"] }.tally.sort_by { |k, v| v }.reverse.to_h.keys
  end

  def get_all_law_levels
    parsed_json = JSON.parse(File.read(show_parsed_json_file_path))
    parsed_json.map { |result| result["law_level"] }.tally.sort_by { |k, v| v }.reverse.to_h.keys
  end

  def validate_firm
    parsed_json = JSON.parse(File.read(show_parsed_json_file_path))

    valid   = parsed_json.select { |line| FirmValidator.new(line).valid? }
    invalid = parsed_json.reject { |line| FirmValidator.new(line).valid? }
    us_only = parsed_json.select { |line| line.dig("location", "country").to_s == "United States" }

    print_data(parsed_json, valid, invalid, us_only)
  end

  def print_data(json, valid, invalid, us_only)
    invalid_reasons = Hash.new(0)

    us_only.each do |line|
      validator = FirmValidator.new(line)

      unless validator.valid?
        reasons = validator.errors.full_messages
        reasons.each do |reason|
          invalid_reasons[reason] += 1
        end
      end
    end
    puts "--------"
    puts "Invalid reasons:"
    invalid_reasons.sort_by { |_, v| v }.reverse.each do |reason, count|
      puts "#{reason}: #{count}"
    end
    puts "--------"

    puts "Total: #{json.count}"
    puts "Invalid: #{invalid.count}"
    puts "Total US: #{us_only.count}"
    puts "Valid: #{valid.count}"
  end

end

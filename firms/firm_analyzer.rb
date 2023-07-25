require 'hirb'
class FirmAnalyzer
  include PathHelpers

  def initialize(firm)
    @firm = firm.downcase
  end

  def firm
    @firm
  end

  def run
    data = json
    puts "Analyzing #{data.count} items"

    missing_fields = count_missing_fields(data)
    report_missing_fields(missing_fields)
    analyze_educations
  end

  def analyze_educations
    data = json
    total_educations = 0
    missing_degree_count = 0
    missing_university_count = 0
    missing_graduation_year_count = 0

    data.each do |item|
      next unless item["educations"]
      item["educations"].each do |education|
        total_educations += 1
        missing_degree_count += 1 if education["degree"].nil? or education["degree"] == ""
        missing_university_count += 1 if education["university"].nil?
        missing_graduation_year_count += 1 if education["graduation_year"].nil?
      end
    end

    puts "--------------- Educations -----------"
    puts "Total educations: #{total_educations}"
    puts "Missing degree: #{missing_degree_count}"
    puts "Missing university: #{missing_university_count}"
    puts "Missing graduation year: #{missing_graduation_year_count}"
  end

  def count_of_jd_universities
    # order the JD universitrys by the count
    data = json
    jd_universities = Hash.new(0)
    data.each do |item|
      next unless item["educations"]
      item["educations"].each do |education|
        next unless JD_DEGREES.include?(education["degree"])

        jd_universities[education["university"]] += 1
      end
    end

    jd_universities = jd_universities.sort_by { |university, count| count }.reverse
    puts "--------------- JD Universities -----------"

    jd_universities.each do |university, count|
      puts "#{university}: #{count}"
    end
    puts Hirb::Helpers::Table.render(jd_universities)
    nil
  end

  def count_missing_fields(data)
    missing_fields = Hash.new(0)
    required_fields.each do |field|
      missing_fields[field] = count_field_occurrences(data, field)
    end
    missing_fields
  end

  def count_field_occurrences(data, field)
    count = 0
    data.each do |item|
      count += 1 if item[field].nil?
    end
    count
  end

  def report_missing_fields(missing_fields)
    missing_fields.each do |field, count|
      puts "Missing #{count} occurrences of '#{field}' field."
    end
  end

  def required_fields
    [
      "name", "first_name", "last_name", "law_firm", "profile_url", "full_url",
      "office", "email", "law_level", "phone", "raw_educations", "educations",
       "description", "location", "bar_associations", "image_url", "practice_areas"
    ]
  end

  def json
    JSON.parse(File.read(file))
  end

  def file
    show_parsed_json_file_path
  end
end

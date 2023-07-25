require 'pry'
require 'csv'
require_relative './html_driver'

Dir[File.dirname(__FILE__) + '/firms/*rb'].each { |file| load file }
Dir[File.dirname(__FILE__) + '/firms/*/*rb'].each { |file| load file }

# FIRMS are in firms/contstants.rb

def main_menu
  puts "Select a firm:"
  FIRMS.each_with_index do |firm, index|
    puts "#{index + 1}. #{firm[:klass]}"
  end

  firm_option = gets.chomp.to_i

  selected_firm = FIRMS[firm_option - 1]
  klass         = selected_firm[:klass]

  puts "Select a method:"
  puts "1. Scrape Index"
  puts "2. Download HTML"
  puts "3. Parse HTML"
  puts "4. Missing Location"
  puts "5. All Locations"
  puts "6. Law Levels"
  puts "7. Validate Firm"

  method_option = gets.chomp.to_i

  case method_option
  when 1 #Scrape Index"
    firm_class = Object.const_get("#{klass}IndexScraper")
    if selected_firm[:sitemap] == true
      firm_class.new.scrape_sitemap
    else
      firm_class.new.scrape_html
    end
  when 2 # Download HTML
    firm_class = Object.const_get("#{klass}ShowScraper")
    firm_class.new.download_html
  when 3 # Parse HTML
    firm_class = Object.const_get("#{klass}ShowParser")
    firm_class.new.parse_show
  when 4 # Missing Location
    firm_class = Object.const_get("#{klass}ShowParser")
    res = firm_class.new.get_all_missing_locations
    puts res
  when 5 # All Locations
    firm_class = Object.const_get("#{klass}ShowParser")
    res = firm_class.new.get_all_locations
    puts res
  when 6 # Law Levels
    firm_class = Object.const_get("#{klass}ShowParser")
    res = firm_class.new.get_all_law_levels
    puts res
  when 7 # Validate Firm
    firm_class = Object.const_get("#{klass}ShowParser")
    res = firm_class.new.validate_firm
  else
    puts "Invalid option. Please try again."
    main_menu
  end
end

main_menu

require_relative '../base_index_scraper.rb'
class WilsonSonsiniIndexScraper < BaseIndexScraper

  BASE_URL = 'https://www.wsgr.com/en/people/index.html?l=:offset'
  FULL_URL = 'https://www.wsgr.com'
  LAW_FIRM = "Wilson Sonsini"
  CSS_SELECTOR = "[class*='card-list__card--']"
  NAV_SELECTOR = "[class*='styles__next--']"
  TIMEOUT = 5
  LETTERS = ('A'..'Z').to_a

  def initialize
    super("wilson_sonsini")
  end

  def page_url(letter)
    BASE_URL.gsub(':offset', letter)
  end

  def navigate_page(letter)
    driver.navigate.to page_url(letter)
    wait_for_elements(CSS_SELECTOR)
  end

  def wait_for_elements(css_selector)
    timeout = TIMEOUT
    while driver.find_elements(:css, css_selector).length == 0
      sleep 1
      timeout -= 1
      break if timeout < 1
    end
  end

  def delete_elements(css_selector)
    driver.find_elements(:css, css_selector).map {|element| driver.execute_script("arguments[0].remove()", element)}
  end

  def parse_page(html)
    doc = Nokogiri::HTML(html)
    rows = doc.css(CSS_SELECTOR)

    rows.map do |row|
      create_row_hash(row)
    rescue => e
      {}
    end
  end

  def create_row_hash(row)
    name        = row.css(".spotlight-card__name--bf830ce5").text.strip
    first_name  = name.split(' ')[0]
    last_name   = name.split(' ')[-1]
    full_url    = row.at_css(".spotlight-card__name--bf830ce5")["href"]
    office      = row.css(".spotlight-card__office--ec4802b5")[0].text.strip

    {
      "name": name,
      "first_name": first_name,
      "last_name": last_name,
      "law_firm": LAW_FIRM,
      "full_url": full_url,
      "office": office,
    }
  end

  def scrape_html
    clear_index_files
    LETTERS.each do |letter|
      navigate_and_parse(letter)
    end

    driver.quit
    write_parsed_file
  end

  def navigate_and_parse(letter)
    navigate_page(letter)
    return if driver.find_elements(:css, CSS_SELECTOR).length == 0

    puts "Parsing page #{letter}"
    json = []

    loop do
      puts "Looping through page #{letter}"
      json += parse_page(driver.page_source)
      
      delete_elements(CSS_SELECTOR)

      begin
        break if driver.find_element(:css, NAV_SELECTOR).attribute("aria-disabled") == "true"

        element = driver.find_element(:css, NAV_SELECTOR)
        driver.execute_script("arguments[0].click();", element)

        wait_for_elements(CSS_SELECTOR)
      rescue Exception => e
        break
      end
    end

    write_response_to_file(json, letter)
  end

end
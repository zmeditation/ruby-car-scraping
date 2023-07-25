module PathHelpers
  def create_export_directory
    FileUtils.mkdir_p("export/#{firm}") unless Dir.exist?("export/#{firm}")
  end

  def firm
    raise "You must implement this method in your subclass"
  end

  def index_scrape_json_file_path
    "export/#{firm}/index_scrape_#{firm}.json"
  end

  def index_parsed_json_file_path
    "export/#{firm}/index_parsed_#{firm}.json"
  end

  def show_parsed_json_file_path
    "export/#{firm}/show_parsed_#{firm}.json"
  end

  def show_parsed_csv_file_path
    "export/#{firm}/show_parsed_#{firm}.csv"
  end

  def educations_path
    "export/#{firm}/educations_#{firm}.csv"
  end

  def show_scrape_html_folder_path
    "export/#{firm}/show_scrape_html".tap do |path|
      FileUtils.mkdir_p(path) unless Dir.exist?(path)
    end
  end

  def file_name(result)
    result["full_url"].split("/").last.gsub(".html", "")
  end
end

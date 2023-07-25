class BaseResultParser
  def parse_location(location)
    LocationParser.parse(location, firm_location_dict)
  end

  def parse_education_degree(education)
    EducationDegreeParser.parse(education)
  end

  def parse_university(education)
    UniversityParser.parse(education)
  end

  def parse_color(detail)
    ColorParser.parse(detail)
  end

  def firm_location_dict
    # define custom firm dict in subclass
  end

  def handle_nil(&block)
    yield
  rescue
    nil
  end
end

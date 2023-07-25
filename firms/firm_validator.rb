# frozen_string_literal: true

require 'active_model'
class FirmValidator
  include ActiveModel::Validations

  ATTRIBUTES = %i[
    name first_name last_name law_firm profile_url full_url office
    law_level email phone raw_educations educations description location
    practice_areas bar_associations image_url
  ]

  attr_accessor(*ATTRIBUTES)

  validates :first_name, length: { minimum: 2 }
  validate :requires_jd
  validate :valid_jd_university?
  validate :last_name_validator
  validates :law_level, inclusion: { in: LAW_LEVELS }
  validates :name, :first_name, :last_name, :law_firm, :full_url, presence: true
  validate :educations_validator
  validate :location_validator
  validate :practice_areas_validator

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def practice_areas_validator
    return if practice_areas.blank?

    if Array(practice_areas).any? { |practice_area| LAW_LEVELS.include?(practice_area) }
      errors.add(:practice_areas, "should not include law level")
    end
  end

  def requires_jd
    if educations.blank? || !educations.any? { |education| JD_DEGREES.include?(education["degree"]) }
      errors.add(:educations, "must have a JD")
      false
    else
      true
    end
  end

  def valid_jd_university?
    return unless educations.present?

    educations.each do |education|
      next unless JD_DEGREES.include?(education["degree"])

      if INVALID_UNIVERSITY_LIST.any? { |uni| education["university"].include?(uni) }
        errors.add(:jd_degree, "must be a valid university")
      end
    end
  end

  def university_list
    Rails.cache.fetch("university_list", expires_in: 5.minutes) do
      University.with_over_twenty_jds.pluck(:name)
    end
  end

  def educations_validator
    return errors.add(:educations, "must have university, degree, and graduation_year") if educations.blank?

    educations.each do |education|
      if education["university"].blank?
        errors.add(:university, "must have university")
      end

      if education["degree"].blank?
        errors.add(:degree, "must have degree")
      end

      # if education["graduation_year"].blank?
      #   errors.add(:graduation_year, "must have graduation_year")
      # end
    end
  end

  def location_validator
    if location.blank? || location["city"].blank? || location["state"].blank? || location["country"].blank?
      errors.add(:location, "must have city, state, and country")
    end
  end

  def last_name_validator
    return unless last_name.present? && last_name.include?(".")

    errors.add(:last_name, "must not include a period")
  end
end

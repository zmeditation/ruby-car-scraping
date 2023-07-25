require 'pry'
require 'csv'
require_relative './html_driver'

Dir[File.dirname(__FILE__) + '/firms/*rb'].each { |file| load file }
Dir[File.dirname(__FILE__) + '/firms/*/*rb'].each { |file| load file }

Pry.start

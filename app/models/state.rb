# coding: utf-8
class State  < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  has_many :sites
  has_many :providers, through: :sites

  def proper_name
    name.split(StringConstants::SPACE).map(&:capitalize).join(StringConstants::SPACE)
  end

  def to_s
    proper_name
  end
end

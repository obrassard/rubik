class AcademicDegreeTermCourse < ActiveRecord::Base
  include SerializedRecord::FindOrInitializeFor

  belongs_to :academic_degree_term
  belongs_to :course

  validates :academic_degree_term, presence: true
  validates :course, presence: true

  serialize :groups, GroupsSerializer
  serialized_find_or_initialize_for :groups

  default_scope { includes(:course).order('courses.code') }
  delegate :code, to: :course
end

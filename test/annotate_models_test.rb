require 'test_helper'
gem 'annotate'
require 'annotate/annotate_models'

class Sample < ActiveRecord::Base
  self.table_name = 'sample'
end

class AnnotateModelsTest < Test::Unit::TestCase
  include TestHelper

  TEST_PREFIX = "== Schema Information"

  def test_annotate_includes_comments
    ActiveRecord::Schema.define do
      add_table_comment :sample, "a table comment"
      add_column_comment :sample, :field1, "a \"comment\" \\ that ' needs; escaping''"
      add_column :sample, :field3, :string, :null => false, :comment => "third column comment"
    end

    result = AnnotateModels.get_schema_info(Sample, TEST_PREFIX)
    expected = <<EOS
# #{TEST_PREFIX}
#
# Table name: sample # a table comment
#
#  id     :integer         not null, primary key
#  field1 :string(255)                           # a "comment" \\ that ' needs; escaping''
#  field2 :integer
#  field3 :string(255)     not null              # third column comment
#

EOS
    assert_equal expected, result
  end
end

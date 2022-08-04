# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../wc'

class TestWc < MiniTest::Test
  def test_specify_only_parent_directory
    ARGV << '..'
    assert_output ("wc: ..: read: Is a directory\n") { main }
  end

  def test_specify_not_exist_directory
    ARGV << './hogefugapiyo'
    assert_output ("wc: ./hogefugapiyo: open: No such file or directory\n") { main }
  end
end

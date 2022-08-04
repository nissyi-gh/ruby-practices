# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../wc'

class TestWc < MiniTest::Test
  def setup
    ARGV.clear
  end

  def test_specify_only_parent_directory
    ARGV << '..'
    assert_output ("wc: ..: read: Is a directory\n") { main }
  end

  def test_specify_not_exist_directory
    ARGV << './hogefugapiyo'
    assert_output ("wc: ./hogefugapiyo: open: No such file or directory\n") { main }
  end

  def test_specify_rubocop_yml
    ARGV << '../.rubocop.yml'
    assert_output ("       3       4      57 ../.rubocop.yml\n") { main }
  end

  def test_specify_rubocop_yml_with_l_option
    ARGV << '-l'
    ARGV << '../.rubocop.yml'
    assert_output("       3 ../.rubocop.yml\n") { main }
  end
end

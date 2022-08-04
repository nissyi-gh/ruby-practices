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

  def test_specify_rubocop_yml_with_w_option
    ARGV << '-w'
    ARGV << '../.rubocop.yml'
    assert_output("       4 ../.rubocop.yml\n") { main }
  end

  def test_specify_rubocop_yml_with_c_option
    ARGV << '-c'
    ARGV << '../.rubocop.yml'
    assert_output("      57 ../.rubocop.yml\n") { main }
  end

  def test_specify_rubocop_yml_with_lw_option
    ARGV << '-lw'
    ARGV << '../.rubocop.yml'
    assert_output("       3       4 ../.rubocop.yml\n") { main }
  end

  def test_specify_rubocop_yml_with_wc_option
    ARGV << '-wc'
    ARGV << '../.rubocop.yml'
    assert_output("       4      57 ../.rubocop.yml\n") { main }
  end

  def test_specify_rubocop_yml_with_lc_option
    ARGV << '-lc'
    ARGV << '../.rubocop.yml'
    assert_output("       3      57 ../.rubocop.yml\n") { main }
  end

  def test_specify_rubocop_yml_with_lwc_option
    ARGV << '-lwc'
    ARGV << '../.rubocop.yml'
    assert_output("       3       4      57 ../.rubocop.yml\n") { main }
  end

  def test_specify_any_files
    ARGV << '../.rubocop.yml'
    ARGV << '../.gitignore'
    assert_output(
      <<-RESULT
       3       4      57 ../.rubocop.yml
     120     255    2090 ../.gitignore
     123     259    2147 total
      RESULT
    ) { main }
  end
end

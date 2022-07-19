# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../ls'
require_relative './helpers'
require 'pathname'

class TestLs < MiniTest::Test
  include TestHelpers

  def setup
    ARGV.clear
    Ls.clear_options
    Ls.clear_path_names

    @a_option = { a: true }
    @l_option = { l: true }
    @r_option = { r: true }
    @al_options = @a_option.merge(@l_option)
    @ar_options = @a_option.merge(@r_option)
    @lr_options = @l_option.merge(@r_option)
    @alr_options = @al_options.merge(@r_option)

    @result_current_directory_without_option = 'ls.rb'
    @result_root_directory_without_option = <<~RESULT
      Applications  Library       Public
      Desktop       Movies        count.sh
      Documents     Music         test.txt
      Downloads     Pictures      works
    RESULT
    @result_parent_directory_without_option = <<~RESULT
      01.fizzbuzz        05.ls              09.wc_object
      02.calendar        06.wc              README.md
      03.rake            07.bowling_object
      04.bowling         08.ls_object
    RESULT
  end

  def test_a_option_is_set?
    set_a_option
    Ls.main
    assert_equal @a_option, sort_options_hash
  end

  def test_l_option_is_set?
    set_l_option
    Ls.main
    assert_equal @l_option, sort_options_hash
  end

  def test_r_option_is_set?
    set_r_option
    Ls.main
    assert_equal @r_option, sort_options_hash
  end

  def test_al_option_is_set?
    set_al_options
    Ls.main
    assert_equal @al_options, sort_options_hash
  end

  def test_ar_option_is_set?
    set_ar_options
    Ls.main
    assert_equal @ar_options, sort_options_hash
  end

  def test_la_option_is_set?
    set_la_options
    Ls.main
    assert_equal @al_options, sort_options_hash
  end

  def test_lr_option_is_set?
    set_lr_options
    Ls.main
    assert_equal @lr_options, sort_options_hash
  end

  def test_ra_option_is_set?
    set_ra_options
    Ls.main
    assert_equal @ar_options, sort_options_hash
  end

  def test_rl_option_is_set?
    set_rl_options
    Ls.main
    assert_equal @lr_options, sort_options_hash
  end

  def test_alr_option_is_set?
    set_alr_options
    Ls.main
    assert_equal @alr_options, sort_options_hash
  end

  def test_arl_option_is_set?
    set_arl_options
    Ls.main
    assert_equal @alr_options, sort_options_hash
  end

  def test_lar_option_is_set?
    set_lar_options
    Ls.main
    assert_equal @alr_options, sort_options_hash
  end

  def test_lra_option_is_set?
    set_lra_options
    Ls.main
    assert_equal @alr_options, sort_options_hash
  end

  def test_ral_option_is_set?
    set_ral_options
    Ls.main
    assert_equal @alr_options, sort_options_hash
  end

  def test_rla_option_is_set?
    set_rla_options
    Ls.main
    assert_equal @alr_options, sort_options_hash
  end

  def test_path_name_equal_current_directory
    set_path_current_directory
    Ls.main
    assert_equal [Pathname.new('.')], Ls.path_names
  end

  def test_path_names_equal_any_paths
    set_path_current_directory
    set_path_parent_directory
    Ls.main
    assert_equal [Pathname.new('.'), Pathname.new('..')], Ls.path_names
  end

  def test_ls_command_without_option_in_current_directory
    set_path_current_directory
    Ls.main
    assert_equal @result_current_directory_without_option, Ls.main
  end

  def test_invalid_direcoty_message
    ARGV << 'hoge'
    Ls.main
    assert_equal 'ls: hoge: No such file or directory', Ls.path_names
  end
end

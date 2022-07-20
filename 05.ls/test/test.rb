# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../ls'
require_relative './helpers'
require 'pathname'

class TestLs < MiniTest::Test
  include TestHelpers

  A_OPTION = { a: true }
  L_OPTION= { l: true }
  R_OPTION = { r: true }
  AL_OPTIONS = A_OPTION.merge(L_OPTION)
  AR_OPTIONS = A_OPTION.merge(R_OPTION)
  LR_OPTIONS = L_OPTION.merge(R_OPTION)
  ALR_OPTIONS = AL_OPTIONS.merge(R_OPTION)
  RESULT_CURRENT_DIRECTORY_WITHOUT_OPTION = "ls.rb  test   \n"
  RESULT_PARENT_DIRECTORY_WITHOUT_OPTION = <<~RESULT
    01.fizzbuzz        05.ls              09.wc_object       
    02.calendar        06.wc              README.md          
    03.rake            07.bowling_object  
    04.bowling         08.ls_object       
  RESULT
  RESULT_NOT_EXIST_MESSAGE = "ls: hoge: No such file or directory\n"
  RESULT_CURRENT_DIRECTORY_WITH_A_OPTION = <<~RESULT
    .         .gitkeep  test      
    ..        ls.rb     
  RESULT
  RESULT_PARENT_DIRECTORY_WITH_A_OPTION = <<~RESULT
    .                  01.fizzbuzz        07.bowling_object  
    ..                 02.calendar        08.ls_object       
    .DS_Store          03.rake            09.wc_object       
    .git               04.bowling         README.md          
    .gitignore         05.ls              
    .rubocop.yml       06.wc              
  RESULT

  RESULT_CURRENT_DIRECTORY_WITH_R_OPTION = "test   ls.rb  \n"
  RESULT_PARENT_DIRECTORY_WITH_R_OPTION = <<~RESULT
    README.md          06.wc              02.calendar        
    09.wc_object       05.ls              01.fizzbuzz        
    08.ls_object       04.bowling         
    07.bowling_object  03.rake            
  RESULT
  RESULT_CURRENT_DIRECTORY_WITH_AR_OPTIONS = <<~RESULT
    test      .gitkeep  .         
    ls.rb     ..        
  RESULT
  RESULT_PARENT_DIRECTORY_WITH_AR_OPTIONS = <<~RESULT
    README.md          04.bowling         .git               
    09.wc_object       03.rake            .DS_Store          
    08.ls_object       02.calendar        ..                 
    07.bowling_object  01.fizzbuzz        .                  
    06.wc              .rubocop.yml       
    05.ls              .gitignore         
  RESULT

  def setup
    ARGV.clear
    Ls.clear_options
    Ls.clear_path_names
  end

  def test_a_option_is_set?
    set_a_option
    Ls.main
    assert_equal A_OPTION, sort_options_hash
  end

  def test_l_option_is_set?
    set_l_option
    Ls.main
    assert_equal L_OPTION, sort_options_hash
  end

  def test_r_option_is_set?
    set_r_option
    Ls.main
    assert_equal R_OPTION, sort_options_hash
  end

  def test_al_option_is_set?
    set_al_options
    Ls.main
    assert_equal AL_OPTIONS, sort_options_hash
  end

  def test_ar_option_is_set?
    set_ar_options
    Ls.main
    assert_equal AR_OPTIONS, sort_options_hash
  end

  def test_la_option_is_set?
    set_la_options
    Ls.main
    assert_equal AL_OPTIONS, sort_options_hash
  end

  def test_lr_option_is_set?
    set_lr_options
    Ls.main
    assert_equal LR_OPTIONS, sort_options_hash
  end

  def test_ra_option_is_set?
    set_ra_options
    Ls.main
    assert_equal AR_OPTIONS, sort_options_hash
  end

  def test_rl_option_is_set?
    set_rl_options
    Ls.main
    assert_equal LR_OPTIONS, sort_options_hash
  end

  def test_alr_option_is_set?
    set_alr_options
    Ls.main
    assert_equal ALR_OPTIONS, sort_options_hash
  end

  def test_arl_option_is_set?
    set_arl_options
    Ls.main
    assert_equal ALR_OPTIONS, sort_options_hash
  end

  def test_lar_option_is_set?
    set_lar_options
    Ls.main
    assert_equal ALR_OPTIONS, sort_options_hash
  end

  def test_lra_option_is_set?
    set_lra_options
    Ls.main
    assert_equal ALR_OPTIONS, sort_options_hash
  end

  def test_ral_option_is_set?
    set_ral_options
    Ls.main
    assert_equal ALR_OPTIONS, sort_options_hash
  end

  def test_rla_option_is_set?
    set_rla_options
    Ls.main
    assert_equal ALR_OPTIONS, sort_options_hash
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
    assert_output(RESULT_CURRENT_DIRECTORY_WITHOUT_OPTION) { Ls.main }
  end

  def test_ls_command_without_option_in_parent_directory
    set_path_parent_directory
    assert_output(RESULT_PARENT_DIRECTORY_WITHOUT_OPTION) { Ls.main }
  end

  def test_ls_command_with_a_option_in_current_directory
    set_a_option
    set_path_current_directory
    assert_output(RESULT_CURRENT_DIRECTORY_WITH_A_OPTION) { Ls.main }
  end

  def test_ls_command_with_a_option_in_parent_directory
    set_a_option
    set_path_parent_directory
    assert_output(RESULT_PARENT_DIRECTORY_WITH_A_OPTION) { Ls.main }
  end

  def test_ls_command_with_ar_option_in_current_directory
    set_a_option
    set_r_option
    set_path_current_directory
    assert_output(RESULT_CURRENT_DIRECTORY_WITH_AR_OPTIONS) { Ls.main }
  end

  def test_ls_command_with_ar_option_in_parent_directory
    set_a_option
    set_r_option
    set_path_parent_directory
    assert_output(RESULT_PARENT_DIRECTORY_WITH_AR_OPTIONS) { Ls.main }
  end

  def test_not_exist_direcoty_message
    set_path_not_exist_directory
    assert_output(RESULT_NOT_EXIST_MESSAGE) { Ls.main }
  end

  def test_specify_exist_directory_and_not_exist_directory
    set_path_not_exist_directory
    set_path_current_directory
    Ls.main
    assert_equal ['ls: hoge: No such file or directory', Pathname.new('.')], Ls.path_names
  end
end

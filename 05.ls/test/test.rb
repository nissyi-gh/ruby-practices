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
  end

  def test_ls_command_without_option_in_current_directory
    set_path_current_directory
    assert_output("lib    ls.rb  test   \n") { Ls.main }
  end

  def test_ls_command_without_option_in_parent_directrory
    set_path_parent_directory
    assert_output(<<~RESULT
      01.fizzbuzz        05.ls              09.wc_object       
      02.calendar        06.wc              README.md          
      03.rake            07.bowling_object  
      04.bowling         08.ls_object       
    RESULT
    ) { Ls.main }
  end

  def test_ls_command_without_option_specify_file_name
    ARGV << 'ls.rb'
    assert_output('ls.rb') { Ls.main }
  end

  def test_ls_command_without_option_specify_empty_directory
    ARGV << 'test/empty'
    assert_output('') { Ls.main }
  end

  def test_ls_command_without_option_in_current_directory_and_parent_direcrory
    set_path_current_directory
    set_path_parent_directory
    assert_output(<<~RESULT
      .:
      lib    ls.rb  test   

      ..:
      01.fizzbuzz        05.ls              09.wc_object       
      02.calendar        06.wc              README.md          
      03.rake            07.bowling_object  
      04.bowling         08.ls_object       
    RESULT
    ) { Ls.main }
  end

  def test_not_exist_direcoty_message
    set_path_not_exist_directory
    assert_output("ls: hoge: No such file or directory\n") { Ls.main }
  end

  def test_ls_command_without_option_in_current_directory_and_not_exist_directory
    set_path_not_exist_directory
    set_path_current_directory
    assert_output(<<~RESULT
      ls: hoge: No such file or directory
      .:
      lib    ls.rb  test   
    RESULT
    ) { Ls.main }
  end

  def test_ls_command_with_a_option_in_current_directory
    set_a_option
    set_path_current_directory
    assert_output(<<~RESULT
      .             .rubocop.yml  test          
      ..            lib           
      .gitkeep      ls.rb         
    RESULT
    ) { Ls.main }
  end

  def test_ls_command_with_l_option_in_current_directory
    set_l_option
    set_path_current_directory
    assert_output(<<~RESULT
      total 8
      drwxr-xr-x  3 yuta.onishi  staff    96  7 20 15:15 lib
      -rw-r--r--  1 yuta.onishi  staff  2420  7 20 16:20 ls.rb
      drwxr-xr-x  5 yuta.onishi  staff   160  8  1 17:54 test
    RESULT
    ) { Ls.main }
  end

  def test_ls_command_with_r_option_in_current_directory
    set_r_option
    set_path_current_directory
    assert_output("test   ls.rb  lib    \n") { Ls.main }
  end

  def test_ls_command_with_ar_option_in_current_directory
    set_a_option
    set_r_option
    set_path_current_directory
    assert_output(<<~RESULT
      test          .rubocop.yml  .             
      ls.rb         .gitkeep      
      lib           ..            
    RESULT
  ) { Ls.main }
  end

  def test_ls_command_with_al_option_in_current_directory
    set_a_option
    set_l_option
    set_path_current_directory
    assert_output(<<~RESULT
      total 16
      drwxr-xr-x   7 yuta.onishi  staff   224  8  1 17:55 .
      drwxr-xr-x  16 yuta.onishi  staff   512  7 19 18:23 ..
      -rw-rw-r--   1 yuta.onishi  staff     0  6  6 18:27 .gitkeep
      -rw-r--r--   1 yuta.onishi  staff   168  7 20 15:34 .rubocop.yml
      drwxr-xr-x   3 yuta.onishi  staff    96  7 20 15:15 lib
      -rw-r--r--   1 yuta.onishi  staff  2420  7 20 16:20 ls.rb
      drwxr-xr-x   5 yuta.onishi  staff   160  8  1 17:54 test
    RESULT
    ) { Ls.main }
  end

  def test_ls_command_with_alr_option_in_current_directory
    set_a_option
    set_l_option
    set_r_option
    assert_output(<<~RESULT
      total 16
      drwxr-xr-x   5 yuta.onishi  staff   160  8  1 17:54 test
      -rw-r--r--   1 yuta.onishi  staff  2420  7 20 16:20 ls.rb
      drwxr-xr-x   3 yuta.onishi  staff    96  7 20 15:15 lib
      -rw-r--r--   1 yuta.onishi  staff   168  7 20 15:34 .rubocop.yml
      -rw-rw-r--   1 yuta.onishi  staff     0  6  6 18:27 .gitkeep
      drwxr-xr-x  16 yuta.onishi  staff   512  7 19 18:23 ..
      drwxr-xr-x   7 yuta.onishi  staff   224  8  1 17:55 .
    RESULT
    ) { Ls.main }
  end
end

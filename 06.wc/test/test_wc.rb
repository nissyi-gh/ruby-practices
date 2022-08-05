# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../wc'

class TestWc < MiniTest::Test
  def setup
    ARGV.clear
  end

  def test_specify_only_parent_directory
    ARGV << '..'
    assert_output("wc: ..: read: Is a directory\n") { main }
  end

  def test_specify_not_exist_directory
    ARGV << './hogefugapiyo'
    assert_output("wc: ./hogefugapiyo: open: No such file or directory\n") { main }
  end

  def test_specify_rubocop_yml
    ARGV << '../.rubocop.yml'
    assert_output("       3       4      57 ../.rubocop.yml\n") { main }
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

  def test_specify_exist_file_and_not_exist_file
    ARGV << '../.rubocop.yml'
    ARGV << './hoge'
    assert_output(
      <<~RESULT
               3       4      57 ../.rubocop.yml
        wc: ./hoge: open: No such file or directory
               3       4      57 total
      RESULT
    ) { main }
  end

  # 上のテストコードと似ているが、こちらはファイルを指定した順で表示できているかのテスト
  def test_output_files_in_order
    ARGV << './hoge'
    ARGV << '../.rubocop.yml'
    assert_output(
      <<~RESULT
        wc: ./hoge: open: No such file or directory
               3       4      57 ../.rubocop.yml
               3       4      57 total
      RESULT
    ) { main }
  end

  def test_accept_stdin_from_ls_command_as_pipe
    output, input = IO.pipe
    Thread.new do
      input.puts "test\nwc.rb\n"
      input.close
    end
    $stdin = output
    assert_output("       2       2      11\n") { main }
    $stdin = STDIN
  end
end

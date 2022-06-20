require 'minitest/autorun'
require_relative './ls'

class LsTest < Minitest::Test
  def test_without_option
    assert_equal "ls.rb ls_test.rb", `ruby ls.rb`
  end

  def test_without_option_and_one_folder_up
    expect = "01.fizzbuzz 02.calendar 03.rake 04.bowling 05.ls 06.wc 07.bowling_object 08.ls_object 09.wc_object README.md"
    assert_equal expect, `ruby ls.rb ..`
  end
end

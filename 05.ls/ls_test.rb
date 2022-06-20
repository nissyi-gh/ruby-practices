require 'minitest/autorun'
require_relative './ls'

class LsTest < Minitest::Test
  def test_without_option
    assert_equal "ls.rb ls_test.rb", `ruby ls.rb`
  end

  def test_without_option_and_one_folder_up
    expect = <<-TEXT
    01.fizzbuzz 05.ls             09.wc_object
    02.calendar 06.wc             README.md
    03.rake     07.bowling_object
    04.bowling  08.ls_object
    TEXT

    assert_equal expect, `ruby ls.rb ..`
  end
end

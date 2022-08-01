# frozen_string_literal: true

module TestHelpers
  def set_path_current_directory
    ARGV << '.'
  end

  def set_path_parent_directory
    ARGV << '..'
  end

  def set_path_not_exist_directory
    ARGV << 'hoge'
  end

  def set_a_option
    ARGV << '-a'
  end

  def set_l_option
    ARGV << '-l'
  end

  def set_r_option
    ARGV << '-r'
  end

  def sort_options_hash
    Ls.options.sort.to_h
  end
end

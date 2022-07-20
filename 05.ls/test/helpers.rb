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

  def set_al_options
    ARGV << '-al'
  end

  def set_ar_options
    ARGV << '-ar'
  end

  def set_la_options
    ARGV << '-la'
  end

  def set_lr_options
    ARGV << '-lr'
  end

  def set_ra_options
    ARGV << '-ra'
  end

  def set_rl_options
    ARGV << '-rl'
  end

  def set_alr_options
    ARGV << '-alr'
  end

  def set_arl_options
    ARGV << '-arl'
  end

  def set_lar_options
    ARGV << '-lar'
  end

  def set_lra_options
    ARGV << '-lra'
  end

  def set_ral_options
    ARGV << '-ral'
  end

  def set_rla_options
    ARGV << '-rla'
  end

  def sort_options_hash
    Ls.options.sort.to_h
  end
end

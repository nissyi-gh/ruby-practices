require 'minitest/autorun'
require_relative '../ls'
require_relative './helpers'

class TestLs < MiniTest::Test
  include TestHelpers

  def setup
    ARGV.clear
    Ls.clear_options

    @A_OPTION = { a: true }
    @L_OPTION = { l: true }
    @R_OPTION = { r: true }
    @AL_OPTIONS = @A_OPTION.merge(@L_OPTION)
    @AR_OPTIONS = @A_OPTION.merge(@R_OPTION)
    @LR_OPTIONS = @L_OPTION.merge(@R_OPTION)
    @ALR_OPTIONS = @AL_OPTIONS.merge(@R_OPTION)
  end

  def test_a_option_is_set?
    set_a_option
    Ls.main
    assert_equal @A_OPTION, sort_options_hash
  end

  def test_l_option_is_set?
    set_l_option
    Ls.main
    assert_equal @L_OPTION, sort_options_hash
  end

  def test_r_option_is_set?
    set_r_option
    Ls.main
    assert_equal @R_OPTION, sort_options_hash
  end

  def test_al_option_is_set?
    set_al_options
    Ls.main
    assert_equal @AL_OPTIONS, sort_options_hash
  end

  def test_ar_option_is_set?
    set_ar_options
    Ls.main
    assert_equal @AR_OPTIONS, sort_options_hash
  end

  def test_la_option_is_set?
    set_la_options
    Ls.main
    assert_equal @AL_OPTIONS, sort_options_hash
  end

  def test_lr_option_is_set?
    set_lr_options
    Ls.main
    assert_equal @LR_OPTIONS, sort_options_hash
  end

  def test_ra_option_is_set?
    set_ra_options
    Ls.main
    assert_equal @AR_OPTIONS, sort_options_hash
  end

  def test_rl_option_is_set?
    set_rl_options
    Ls.main
    assert_equal @LR_OPTIONS, sort_options_hash
  end

  def set_alr_option_is_set?
    set_alr_options
    Ls.main
    assert_equal @ALR_OPTIONS, sort_options_hash
  end

  def set_arl_option_is_set?
    set_arl_options
    Ls.main
    assert_equal @ALR_OPTIONS, sort_options_hash
  end

  def set_lar_option_is_set?
    set_lar_options
    Ls.main
    assert_equal @ALR_OPTIONS, sort_options_hash
  end

  def set_lra_option_is_set?
    set_lra_options
    Ls.main
    assert_equal @ALR_OPTIONS, sort_options_hash
  end

  def set_ral_option_is_set?
    set_ral_options
    Ls.main
    assert_equal @ALR_OPTIONS, sort_options_hash
  end

  def set_rla_option_is_set?
    set_rla_options
    Ls.main
    assert_equal @ALR_OPTIONS, sort_options_hash
  end
end

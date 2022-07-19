require 'minitest/autorun'
require_relative '../ls'
require_relative './helpers'

class TestLs < MiniTest::Test
  include TestHelpers

  def setup
    ARGV.clear
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
    assert_equal @A_OPTION, Ls.options
  end

  def test_l_option_is_set?
    set_l_option
    assert_equal @L_OPTION, Ls.options
  end

  def test_r_option_is_set?
    set_r_option
    assert_equal @R_OPTION, Ls.options
  end

  def test_al_option_is_set?
    set_al_options
    assert_equal @AL_OPTIONS, Ls.options
  end

  def test_ar_option_is_set?
    set_ar_options
    assert_equal @AR_OPTIONS, Ls.options
  end

  def test_la_option_is_set?
    set_la_options
    assert_equal @AL_OPTIONS, Ls.options
  end

  def test_lr_option_is_set?
    set_lr_options
    assert_equal @LR_OPTIONS, Ls.options
  end

  def test_ra_option_is_set?
    set_ra_options
    assert_equal @AR_OPTIONS, Ls.options
  end

  def test_rl_option_is_set?
    set_rl_options
    assert_equal @LR_OPTIONS, Ls.options
  end

  def set_alr_option_is_set?
    set_alr_options
    assert_equal @ALR_OPTIONS, Ls.options
  end

  def set_arl_option_is_set?
    set_arl_options
    assert_equal @ALR_OPTIONS, Ls.options
  end

  def set_lar_option_is_set?
    set_lar_options
    assert_equal @ALR_OPTIONS, Ls.options
  end

  def set_lra_option_is_set?
    set_lra_options
    assert_equal @ALR_OPTIONS, Ls.options
  end

  def set_ral_option_is_set?
    set_ral_options
    assert_equal @ALR_OPTIONS, Ls.options
  end

  def set_rla_option_is_set?
    set_rla_options
    assert_equal @ALR_OPTIONS, Ls.options
  end
end

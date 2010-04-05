require 'paramix'
require 'test/unit'

class TC_Paramix_Nested_Bottom < Test::Unit::TestCase

  # -- fixture ------------------------------

  module M
    include Paramix

    def f
      mixin_param(M,:p)
    end
  end

  module N
    include M

    def g
      mixin_param(N,:p)
    end
  end

  class I
    include N[:p => "mosh"]
  end

  class E
    extend N[:p => "many"]
  end

  # -- tests --------------------------------

  def test_include_f
    assert_equal( "mosh", I.new.f )
  end

  def test_include_g
    assert_equal( "mosh", I.new.g )
  end

  def test_extend_f
    assert_equal( "many", E.f )
  end

  def test_extend_g
    assert_equal( "many", E.g )
  end

end


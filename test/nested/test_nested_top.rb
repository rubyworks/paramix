require 'paramix'
require 'test/unit'

class TC_Paramix_Nested_Top < Test::Unit::TestCase

  # -- fixture ------------------------------

  module M
    include Paramix

    def f
      mixin_param(M,:p)
    end
  end

  module N
    include M[:p=>"mood"]

    def g
      mixin_param(N,:p)
    end
  end

  class I
    include N
  end

  class E
    extend N
  end

  # -- tests --------------------------------

  def test_include_f
    assert_equal( "mood", I.new.f )
  end

  def test_include_g
    assert_equal( nil, I.new.g ) # TODO: or error ?
  end

  #def test_extend
  #  assert_equal( "many", E.f )
  #end

end


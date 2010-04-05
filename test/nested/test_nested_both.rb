require 'paramix'
require 'test/unit'

class TC_Paramix_Nested_Both < Test::Unit::TestCase

  # -- fixture ------------------------------

  module M
    include Paramix

    def f
      mixin_param(M,:p)
    end
  end

  module N
    include Paramix
    include M[:p=>"mood"]

    def g
      mixin_params(N,:p)
    end
  end

  class I
    include N[:p => "mosh"]
  end

  class E
    extend N[:p => "many"]
  end

  # -- tests --------------------------------

  def test_include
    assert_equal( "mood", I.new.f )
  end

  #def test_extend
  #  assert_equal( "many", E.f )
  #end

end


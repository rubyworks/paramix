require 'paramix'
require 'test/unit'

class TC_Paramix_Inject < Test::Unit::TestCase

  # -- fixture ------------------------------

  module O
    def self.[](parameters)
      Paramix::Proxy.new(self, parameters) do
        attr_accessor mixin_parameters[O][:name] #mixin_params(O, :name)
      end
    end
  end

  class X
    include O[:name=>"x"]
  end

  # -- tests --------------------------------

  def test_attribute
    o = X.new
    assert_nothing_raised{ o.x = 10 }
    assert_equal(10, o.x)
  end

  def test_ancestors
    assert(X.ancestors.include?(X))
    assert(X.ancestors.include?(O))
    assert(X.ancestors.include?(Object))
    assert(X.ancestors.include?(Kernel))
  end

end


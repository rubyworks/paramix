class C < Module
  def initialize(&block)
    instance_eval(&block)
  end
end

M = C.new do
  private
  define_method(:x){ p "x" }
end

class X
  include M
end

X.new.x

exit


  class Module

    alias :publicize :public
    alias :privatize :private
    alias :protect   :protected

    #
    def public(name, &code)
      define_method(name, &code) if code
      publicize(name)
    end

    #
    def private(name, &code)
      define_method(name, &code) if code
      privatize(name)
    end

    #
    def protected(name, &code)
      define_method(name, &code) if code
      protect(name)
    end

  end


  class X

    public :x do |*a|
      p a
    end

    private :y do |*a|
      p a
    end

    protected :z do |*a|
      p a
    end

  end

  X.new.x("hello")


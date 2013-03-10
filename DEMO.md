= Basic Example

Require the library.

  require 'paramix'

Create a parametric mixin.

    module MyMixin
      include Paramix::Parametric

      parameterized do |params|

        public params[:name] do
          params[:value]
        end

      end
    end

Create a class that uses the mixin and set the parameter.

    class X
      include MyMixin[:name => 'f', :value=>1]
    end

Then the parameter is accessible.

    X.new.f.assert == 1


= Nested Parematric Mixins

If we create another parametric mixin which depends on the first.

    module AnotherMixin
      include Paramix::Parametric
      include MyMixin[:name => 'f', :value=>1]

      parameterized do |params|

        public params[:name] do
          params[:value]
        end

      end
    end

And a class for it.

    class Y
      include AnotherMixin[:name => 'g', :value=>2]
    end

We can see that the parameters stay with their respective mixins.

    Y.new.f.assert == 1
    Y.new.g.assert == 2

However if we do the same, but do not paramterize the first module then
the including module also become parametric.

    module ThirdMixin
      #include Paramix::Parametric
      include MyMixin

      parameterized do |params|

        public params[:name].succ do
          params[:value]
        end

      end
    end

And a class for it.

    class Z
      include ThirdMixin[:name => 'q', :value=>3]
    end

We can see that the value of the parameter has propogated up to its
ancestor parametric module.

    Z.new.q.assert == 3
    Z.new.r.assert == 3


= Parametric Include

Load the library.

  require 'paramix'

Given a parametric mixin.

  module M
    include Paramix::Parametric

    parameterized do |params|

      public :f do
        params[:p]
      end

    end
  end

We can inlcude the parameteric module in a some classes.

  class I1
    include M[:p => "mosh"]
  end

  class I2
    include M[:p => "many"]
  end

And the result will vary according to the parameter set.

  I1.new.f  #=> "mosh"
  I2.new.f  #=> "many"


= Parametric Extension

We can also extend classes witht the mixin.

  class E1
    extend M[:p => "mosh2"]
  end

  class E2
    extend M[:p => "many2"]
  end

And the results will likewise work as expected.

   E1.f  #=> "mosh2"
   E2.f  #=> "many2"


= Dynamically Defined Methods

Parametric mixins can be used to define dynamic code.

  module N
    include Paramix::Parametric

    parameterized do |params|
      attr_accessor params[:a]
    end
  end

Now if we include this module we will have new attributes based on
the parameter assigned.

  class D1
    include N[:a => "m1"]
  end

  class D2
    include N[:a => "m2"]
  end

  d1 = D1.new
  d1.m1 = :yes1

  d1.m1  #=> :yes1

  d2 = D2.new
  d2.m2 = :yes2

  d2.m2  #=> :yes2


= Works with Namespaces

Parametric mixins work regardless of the namespace depth.

  module R
    module M
      include Paramix::Parametric

      parameterized do |params|
        public :f do
          params[:p]
        end
      end
    end
  end

  module Q
    class I
      include R::M[:p => "mosh"]
    end
    class E
      extend R::M[:p => "many"]
    end
  end

  Q::I.new.f  #=> "mosh"

  Q::E.f #=> "many"


Given include with parametric mixins.

  module MI
    include Paramix::Parametric

    parameterized do |params|

      public :f do
        params[:p]
      end

    end
  end

  class I1
    include MI[:p => "mosh"]
  end

  class I2
    include MI[:p => "many"]
  end

Then it should vary the return value of the instance methods.

  I1.new.f.should == "mosh"
  I2.new.f.should == "many"


Given extend with parametric mixins.

  module ME
    include Paramix::Parametric

    parameterized do |params|

      public :f do
        params[:p]
      end

    end
  end

  class E1
    extend ME[:p => "mosh"]
  end

  class E2
    extend ME[:p => "many"]
  end

Then should vary the return value of the class methods.

  E1.f.should == "mosh"
  E2.f.should == "many"


Given namespace depth does not adversly effect parametric mixins.

  module N
    module M
      include Paramix::Parametric
      parameterized do |params|
        public :f do
          params[:p]
        end
      end
    end
  end

  module Q
    class I
      include N::M[:p => "mosh"]
    end
    class E
      extend N::M[:p => "many"]
    end
  end

Then

  Q::I.new.f == "mosh"

And

  Q::E.f.should == "many"


Given dynamic methods using paramtric mixins.

  module MD
    include Paramix::Parametric

    parameterized do |params|

      public :f do
        params[:p]
      end

      attr_accessor params[:p]
    end
  end

  class C1
    include MD[:p => "c1"]
  end

  class C2
    include MD[:p => "c2"]
  end

Then

  c = C1.new
  c.f.should == "c1"

And

  c = C2.new
  c.f.should == "c2"

And

  c = C1.new
  c.c1 = :yes1
  c.c1.should == :yes1

And

  c = C2.new
  c.c2 = :yes2
  c.c2.should == :yes2


Given nested modules where inner most module is parametric.

  m = Module.new do
    include Paramix::Parametric

    parameterized do |params|
      public :f do
        params[:p]
      end
    end
  end

  n = Module.new do
    include m[:p=>"NMp"]
  end

  i = Class.new do
    include n
  end

  e = Class.new do
    extend  n
  end

Then

    i.new.f.should == "NMp"

And

    e.f.should == "NMp"

Nested parametric mixins with parameters.

  m = Module.new do
    include Paramix::Parametric

    parameterized do |params|
      public :f do
        params[:p]
      end
    end
  end

  n = Module.new do
    include Paramix::Parametric
    include m[:p=>"NMp"]

    parameterized do |params|
      public :g do
        params[:p]
      end
    end
  end

  i = Class.new do
    include n[:p => "INp"]
  end

  e = Class.new do
    extend n[:p => "ENp"]
  end

Then

    i.new.f.should == "NMp"

And

    i.new.g.should == "INp"

And

    e.f.should == "NMp"

And
   
   e.g.should == "ENp"

Given nested parametric mixins without parameters.

  m = Module.new do
    include Paramix::Parametric

    parameterized do |params|
      public :f do
        params[:p]
      end
    end
  end

  n = Module.new do
    include m

    parameterized do |params|
      public :g do
        params[:p]
      end
    end
  end

  i = Class.new do
    include n[:p => "INp"]
  end

  e = Class.new do
    extend n[:p => "ENp"]
  end

Then

    i.new.f.should == "INp"

And

    i.new.g.should == "INp"

And

    e.f.should == "ENp"

And

    e.g.should == "ENp"

Given nested parametric mixins where the outer is not parameterized.

  m = Module.new do
    include Paramix::Parametric

    parameterized do |params|
      public :f do
        params[:p]
      end
    end
  end

  n = Module.new do
    include Paramix::Parametric
    include m[:p=>"NMp"]
  end

  i = Class.new do ; include n[] ; end
  e = Class.new do ; extend  n[] ; end

  ix = Class.new do ; include n[:p=>"IxNp"] ; end
  ex = Class.new do ; extend  n[:p=>"ExNp"] ; end

Then

    i.new.f.should == "NMp"


And

    e.f.should == "NMp"

And

    i.new.f.should == "NMp"

And

    e.f.should == "NMp"


Given nested parametric mixins both parameterized.

  m = Module.new do
    include Paramix::Parametric

    parameterized do |params|
      public :f do
        params[:p]
      end
    end
  end

  n = Module.new do
    include Paramix::Parametric
    include m[:p=>"mood"]

    parameterized do |params|
      public :g do
        params[:p]
      end
    end
  end

  i = Class.new do
    include n[]
  end

  e = Class.new do
    extend n[]
  end

Then

    i.new.f.should == "mood"

And

    i.new.g.should == nil  # TODO: or error ?

And

    e.f.should == "mood"

And

    e.g.should == nil



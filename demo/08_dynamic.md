# Dynamic Parametric Mixin

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


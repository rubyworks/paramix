# Namespaces

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


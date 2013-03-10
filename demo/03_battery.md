# Works with Namespaces

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


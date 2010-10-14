require 'paramix'

describe "extend with parametric mixins" do

  # -- fixture ------------------------------

  module M
    include Paramix::Parametric

    parameterized do |params|

      public :f do
        params[:p]
      end

    end
  end


end


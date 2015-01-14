require_relative '../phase4/controller_base'
require_relative './params'


module Phase5
  class ControllerBase < Phase4::ControllerBase
    attr_reader :params

    # setup the controller
    def initialize(req, res, route_params = {})
      super
      @route_params = route_params
      @params = Phase5::Params.new(req)
    end


  end
end
class FinancesController < ApplicationController
  def index
    authorize! :manage, Finance
  end

end

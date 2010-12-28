class StartController < ApplicationController

  def index
    if user_signed_in?
      load_payments_and_invoices_for_user
    end
  end

  def auth
    # you are now wepay authorized
    @auth_hash = request.env['omniauth.auth']
  end

end

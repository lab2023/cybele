# frozen_string_literal: true

module Hq
  class SessionsController < Devise::SessionsController
    layout 'hq/login'

    private

    # Overwriting the sign_out redirect path method
    def after_sign_in_path_for(_resource_or_scope)
      hq_root_path
    end

    # Overwriting the sign_out redirect path method
    def after_sign_out_path_for(_resource_or_scope)
      new_admin_session_path
    end
  end
end

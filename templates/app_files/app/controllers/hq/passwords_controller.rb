# frozen_string_literal: true

module Hq
  class PasswordsController < Devise::PasswordsController
    layout 'hq/login'

    private

    def after_resetting_password_path_for
      hq_root_path
    end
  end
end

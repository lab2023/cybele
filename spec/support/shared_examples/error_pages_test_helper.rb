# frozen_string_literal: true

shared_examples 'uses error_pages' do
  context do
    it do
      controller_file_test
      routes_file_test
    end

    def controller_file_test # rubocop:disable Metrics/AbcSize
      application_controller_file = content('app/controllers/application_controller.rb')
      expect(application_controller_file).to match('rescue_from Exception')
      expect(application_controller_file).to match('rescue_from ActiveRecord::RecordNotFound')
      expect(application_controller_file).to match('rescue_from ActionController::RoutingError')
      expect(application_controller_file).to match('server_error')
      expect(application_controller_file).to match('page_not_found')
    end

    def routes_file_test
      route_file = content('config/routes.rb')
      expect(route_file).to match('unmatched_route')
    end
  end
end

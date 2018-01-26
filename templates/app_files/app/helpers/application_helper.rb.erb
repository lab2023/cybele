# frozen_string_literal: true

module ApplicationHelper
  def devise_model_map(model_name)
    model_name.map { |obj| ["#{obj.email} - #{obj.full_name}", obj.id] }
  end

  def active_users
    devise_model_map(User.active)
  end

  def users
    devise_model_map(User.all)
  end

  def admins
    devise_model_map(Admin.all)
  end

  def audit_users
    [[t('activerecord.models.admin'), 'Admin'], [t('activerecord.models.user'), 'User']]
  end

  def blankable(contents, search)
    render partial: contents.size.zero? ? 'blank' : 'list', locals: { contents: contents, search: search }
  end

  def auditable_types_collection(auditable_types)
    auditable_types.map do |type|
      [t("activerecord.models.#{type.auditable_type.try(:underscore)}"), type.auditable_type]
    end
  end

  def query_present?(array)
    query = params[:q]
    return false unless query.present?
    query = query.permit!.to_h
    query.any? do |key, value|
      key.to_s.in?(array) && value.present?
    end
  end

  def actions_collection
    %w[create update destroy].map do |action|
      [t("actions.#{action}"), action]
    end
  end

  # :reek:TooManyStatements
  def css_class(paths, exist: '', not_exist: '')
    r_path = request.path
    if paths.is_a? Array
      paths.each do |path|
        return exist if r_path.include?(path)
      end
      return not_exist
    end
    return r_path == paths ? exist : not_exist if paths.is_a? String
    raise NotImplementedError
  end
end

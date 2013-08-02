# encoding: UTF-8
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
  before_action :<%= "set_#{singular_table_name}" %>, only: [:show, :edit, :update, :destroy]

<% unless options[:singleton] -%>
  def index
    @<%= table_name %> = <%= class_name %>.all.page(params[:page])
    respond_with(@<%= table_name %>)
  end
<% end -%>

  def show
    respond_with(@<%= file_name %>)
  end

  def new
    @<%= file_name %> = <%= orm_class.build(class_name) %>
    respond_with(@<%= file_name %>)
  end

  def edit
  end

  def create
    @<%= file_name %> = <%= orm_class.build(class_name, "#{singular_table_name}_params") %>
    @<%= orm_instance.save %>
    respond_with(@<%= file_name %>)
  end

  def update
    @<%= orm_instance.update_attributes("#{singular_table_name}_params") %>
    respond_with(@<%= file_name %>)
  end

  def destroy
    @<%= orm_instance.destroy %>
    respond_with(@<%= file_name %>)
  end

  private

  def <%= "set_#{singular_table_name}" %>
    @<%= file_name %> = <%= orm_class.find(class_name, "params[:id]") %>
  end

  def <%= "#{singular_table_name}_params" %>
    params.require(<%= ":#{singular_table_name}" %>).permit(<%= attributes.map {|a| ":#{a.name}" }.sort.join(', ') %>)
  end
end
<% end -%>
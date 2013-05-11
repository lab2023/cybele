# encoding: UTF-8
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
<% unless options[:singleton] -%>
  def index
    @<%= table_name %> = <%= class_name %>.all
    respond_with(@<%= table_name %>)
  end
<% end -%>

  def show
    @<%= file_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    respond_with(@<%= file_name %>)
  end

  def new
    @<%= file_name %> = <%= orm_class.build(class_name) %>
    respond_with(@<%= file_name %>)
  end

  def edit
    @<%= file_name %> = <%= orm_class.find(class_name, "params[:id]") %>
  end

  def create
    @<%= file_name %> = <%= orm_class.build(class_name, "params[:#{file_name}]") %>
    @<%= orm_instance.save %>
    respond_with(@<%= file_name %>)
  end

  def update
    @<%= file_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    @<%= orm_instance.update_attributes("params[:#{file_name}]") %>
    respond_with(@<%= file_name %>)
  end

  def destroy
    @<%= file_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    @<%= orm_instance.destroy %>
    respond_with(@<%= file_name %>)
  end

  private

  def <%= "#{singular_table_name}_params" %>
    params.require(<%= ":#{singular_table_name}" %>).permit(<%= attributes.map {|a| ":#{a.name}" }.sort.join(', ') %>)
  end
end
<% end -%>
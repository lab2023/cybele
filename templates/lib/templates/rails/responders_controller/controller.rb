# encoding: UTF-8
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
before_action :<%= "set_#{singular_table_name}" %>, only: [:show, :edit, :update, :destroy]
add_breadcrumb I18n.t('activerecord.models.<%= singular_table_name %>'), :<%= table_name %>_path
<% unless options[:singleton] -%>
def index
  @search = <%= class_name %>.order(id: :desc).search(params[:q])
     @<%= table_name %> = @search.result(distinct: true).paginate(page: params[:page])
  respond_with(@<%= table_name %>)
  end
<% end -%>

  def show
    add_breadcrumb @<%= file_name %>.<%= attributes.first.name %>, <%= singular_table_name %>_path(@<%= file_name %>)
    respond_with(@<%= file_name %>)
end

def new
  add_breadcrumb t('tooltips.new'), new_<%= singular_table_name %>_path
    @<%= file_name %> = <%= orm_class.build(class_name) %>
    respond_with(@<%= file_name %>)
end

def edit
  add_breadcrumb @<%= singular_table_name %>.id, <%= singular_table_name %>_path(@<%= singular_table_name %>)
    add_breadcrumb t('tooltips.edit'), edit_<%= singular_table_name %>_path
end

def create
  @<%= file_name %> = <%= orm_class.build(class_name, "#{singular_table_name}_params") %>
    @<%= orm_instance.save %>
    respond_with(@<%= file_name %>)
end

def update
  @<%= orm_instance.update("#{singular_table_name}_params") %>
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
# Hooks to attach to the Redmine Projects.  They are attached in init.rb by the
# +add_hook+ method
class BudgetProjectHook < Redmine::Plugin::Hook::Base

  # Renders an additional table header to the membership setting
  #
  # Context: none
  def self.member_list_header(context ={ })
    return "<th>#{GLoc.l(:label_member_rate) }</th>"
  end
  
  # Renders an AJAX from to update the member's billing rate
  #
  # Context:
  # * :member => Current Member record
  #
  def self.member_list_column_three(context = { })

    # Build a form_remote_tag by hand since this isn't in the scope of a controller 
    form = help.form_tag({:controller => 'members', :action => 'edit', :id => context[:member].id, :host => Setting.host_name},
                         :onsubmit => help.remote_function(:url => {
                                                             :controller => 'members',
                                                             :action => 'edit',
                                                             :id => context[:member].id,
                                                             :host => Setting.host_name
                                                           },
                                                           :host => Setting.host_name,
                                                           :form => true,
                                                           :method => 'post',
                                                           :return => 'false' )+ '; return false;') + 
      help.text_field_tag('member[rate]', help.number_with_precision(context[:member].rate, 0), :class => "small") + 
      help.submit_tag(GLoc.l(:button_change), :class => "small") + "</form>"
    
    return help.content_tag(:td, form, :align => 'center' )
    
  end
end

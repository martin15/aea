module ApplicationHelper

  def flash_type(type)
     return 'danger' if type == 'alert'
     return 'danger' if type == 'error'
     return 'success' if type == 'notice'
  end

  def welcome_text
    str = ""
    if current_user.nil?
      str = str + "#{link_to raw("<i class='icon fa fa-user user'></i> Login"), new_user_session_path}"
      str = str + "#{link_to raw("<i class='icon fa fa-pencil-square-o'></i> Sign up"),
                                        new_user_registration_path}"
    else
      str = str + "#{link_to raw("<i class='icon fa fa-sign-out'></i> Sign Out"),
                             destroy_user_session_path, :method => :Delete}"
      str = str + "#{link_to raw("<i class='icon fa fa-user user'></i>#{current_user.first_name.titleize}
                                  #{current_user.last_name[0].titleize}"), users_path}"
    end
  end

  def list_title
    [["Mr", "Mr"],["Mrs", "Mrs"],["Miss", "Miss"],["Pastor", "Pastor"],["Rev", "Rev"]]
  end

  def hide_roomate(user)
    return "" if @user.room_type_id.nil?
    return @user.room_type.name.downcase == "double" ? "" : "hidden_app"
  end

  def active_side_menu(obj)
    if obj.is_a?(Array)
      return 'active-menu' if obj.include?(action_name) && controller_name == "users"
    else
      return 'active-menu' if controller_name == obj
    end
  end
end

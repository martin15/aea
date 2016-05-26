module ApplicationHelper

  def flash_type(type)
     return 'danger' if type == 'alert'
     return 'danger' if type == 'error'
     return 'success' if type == 'notice'
  end

  def welcome_text
    str = ""
    if current_user.nil?
      str = str + "#{link_to raw("<i class='icon fa fa-user user' style='min-height:44px'></i> Login"),
                     new_user_session_path}"
      str = str + "#{link_to raw("<i class='icon fa fa-pencil-square-o'></i> Sign up"),
                                        new_user_registration_path}"
    else
      str = str + "#{link_to raw("<i class='icon fa fa-sign-out'></i> Sign Out"),
                             destroy_user_session_path, :method => :Delete}"
      str = str + "#{link_to raw("<i class='icon fa fa-user user'  style='min-height:44px'></i>
                                  #{current_user.first_name.titleize}
                                  #{current_user.last_name[0].titleize}"), users_path}"
    end
  end

  def list_title
    [["Mr", "Mr"],["Mrs", "Mrs"],["Miss", "Miss"],["Dr", "Dr"],["Pastor/Rev", "Pastor/Rev"]]
  end

  def airport_list
    [["Jakarta - Soekarno Hatta", "Jakarta - Soekarno Hatta"],["Bandung - Husein Sastranegara", "Bandung - Husein Sastranegara"]]
  end

  def must_fill_text
    str = "<div class='form-group'> <div class='col-sm-12'>
            <span class='must-fill'>* You must fill the field</span>
              </div>
            </div>"
  end

  def hide_roomate(user)
    return "hidden_app" if user.room_type_id.nil?
    return user.room_type.name.downcase != RoomType.single_room ? "" : "hidden_app"
  end

  def hide_pick_up_schedule(need_shuttle_bus)
    puts "------"
    puts need_shuttle_bus
    return need_shuttle_bus == true ? "" : "hidden_app"
  end

  def active_side_menu(obj)
    if obj.is_a?(Array)
      return 'active-menu' if obj.include?(action_name) && controller_name == "users"
    else
      return 'active-menu' if controller_name == obj
    end
  end

  def admin_active_menu(obj)
    return 'active' if controller_name == obj
  end

  def sortable(column, title=nil)
    title ||= column.titleize
    direction = (column == params[:sort] && params[:direction] == "asc") ? "desc" : "asc"
    link_to(title, :sort => column, :direction => direction)
  end

end

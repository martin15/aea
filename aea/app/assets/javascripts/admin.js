//= require jquery
//= require jquery_ujs
//= require bootstrap.min

function update_price() {
    user_type = $('input[name="user[user_type_id]"]:checked').val();
    room_type = $('input[name="user[room_type_id]"]:checked').val();
    $.ajax({
      type:'GET',
      url:'/user/update_price',
      data: { "user_type_id": user_type, "room_type_id": room_type}
    });
}

function update_price_by_country(select_box) {
    country_id = select_box.value;
    $.ajax({
      type:'GET',
      url:'/users/update_price_by_country',
      data: { "country_id": country_id}
    });
}

function display_roomate_field(){
    var selected = $("input[type='radio'][name='user[room_type_id]']:checked");
    roomtype = selected.parent().text();
    if (roomtype.toLowerCase().indexOf("double") >= 0){
      $("#roomate").show();
    }else{
      $("#roomate").hide();
    }
}


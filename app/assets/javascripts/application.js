// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs

// autoScroll
$(document).ready(function(){
    $('#scroller').simplyScroll({
        orientation:'vertical',
        customClass:'vert'
    });
});

function get_username(ht){
    $.ajax({
        url:"/students/username",
        data: {
            username: $(ht).val()
        },
        type: "PUT",
        success: function(data){
            if(data == "Error"){
                alert("Error. Please try again");
            }else{
        }
        }
    });
}

function profile_summary(user){
    $.ajax({
        url: '/profiles/'+user+'/profile_summary',
        success: function(data){
            $("#popup_body").html(data);
            $("#overlay").show();
            $("#popup_box").show();
        }
    });
}

function hide_popup(){

    if(jQuery('#popup_box')){
        jQuery('#popup_body').html("");
        jQuery('#popup_box').hide();
    }

    if(jQuery('#overlay')){
        jQuery('#overlay').hide();
    }
}

function readURL(input) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();

        reader.onload = function (e) {
            $('#img_show').attr('src', e.target.result);
            $('#realupload').hide();
        }

        reader.readAsDataURL(input.files[0]);
        $("#img_preview").show();
    }
    return true;
}

$(function() {
    $(".pagination a").live("click", function() {
        $.getScript(this.href);
        return false;
    });
});

jQuery(document).ajaxStart(function(settings){
    jQuery('#ajax_loader_big_div').show();
});
jQuery(document).ajaxStop(function(){
    jQuery('#ajax_loader_big_div').hide();
});

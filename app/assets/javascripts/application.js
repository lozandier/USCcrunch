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

function conversation(user){
    $.ajax({
        url: '/profiles/'+user+'/conversation',
        success: function(data){
            $("#popup_body").html(data);
            $("#overlay").show();
            $("#popup_box").show();
        }
    });
}

function new_compose(){
    $.ajax({
        url: '/profiles/new_compose',
        success: function(data){
            $("#popup_body1").html(data);
            $("#overlay").show();
            $("#popup_box1").show();
        }
    });
}

function hide_popup(){

    if(jQuery('#popup_box')){
        jQuery('#popup_body').html("");
        jQuery('#popup_box').hide();
    }

    if(jQuery('#popup_box1')){
        jQuery('#popup_body1').html("");
        jQuery('#popup_box1').hide();
    }

    if(jQuery('#overlay')){
        jQuery('#overlay').hide();
    }
}

function readURL(input) {
    if (input.files && input.files[0]) {//Check if input has files.
        var reader = new FileReader();//Initialize FileReader.

        reader.onload = function (e) {
            $('#PreviewImage').attr('src', e.target.result);
            $("#user_photo").hide();
        };
        reader.readAsDataURL(input.files[0]);
    }
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

function more_posts(page){
    jQuery('#more_posts_link').remove();
    jQuery.ajax({
        beforeSend: function() {
            $('#ajax_loader_big_div').hide();
            jQuery('#posts').append($("#ajax").show());
        },
        url: "/profiles?page="+page,
        success: function(data) {
            jQuery('#posts').append(data);
            jQuery($("#ajax"),this).remove();
        }
    });
}

function posts(user_id, page){
    jQuery('#more_posts_link').remove();
    jQuery.ajax({
        beforeSend: function() {
            $('#ajax_loader_big_div').hide();
            jQuery('#posts').append($("#ajax").show());
        },
        url: "/profiles/"+user_id+"?page="+page,
        success: function(data) {
            $("#ajax").show();
            jQuery('#posts').append(data);
            jQuery($("#ajax"),this).remove();
        }
    });
}


function notification_posts(page){
    jQuery('#more_posts_link').remove();
    jQuery.ajax({
        beforeSend: function() {
            $('#ajax_loader_big_div').hide();
            jQuery('#posts').append($("#ajax").show());
        },
        url: "/notifications/posts?page="+page,
        success: function(data) {
            $("#ajax").show();
            jQuery('#posts').append(data);
            jQuery($("#ajax"),this).remove();
        }
    });
}

function notification_replies(page){
    jQuery('#more_posts_link').remove();
    jQuery.ajax({
        beforeSend: function() {
            $('#ajax_loader_big_div').hide();
            jQuery('#posts').append($("#ajax").show());
        },
        url: "/notifications?page="+page,
        success: function(data) {
            $("#ajax").show();
            jQuery('#posts').append(data);
            jQuery($("#ajax"),this).remove();
        }
    });
}

function school_posts(user_id,student_id, page){
    jQuery('#more_posts_link').remove();
    jQuery.ajax({
        beforeSend: function() {
            $('#ajax_loader_big_div').hide();
            jQuery('#posts').append($("#ajax").show());
        },
        url: "/schools/"+user_id+"/students/"+student_id+"?page="+page,
        success: function(data) {
            jQuery('#posts').append(data);
            jQuery($("#ajax"),this).remove();
        }
    });
}


//change background image

var backImage = ["/assets/Amazing_Flowers_Wallpapers_55.jpg","/assets/scene3.jpg","/assets/rain1.jpg","/assets/moss.jpg","/assets/nature2.jpg"];
var count = 0;
function changeBGImage(whichImage) {
    count++;
    $(".cover_photo").css("background-image", "url("+backImage[(count-1)]+")");
    if(count == 4){
        count = 0;
    }
}



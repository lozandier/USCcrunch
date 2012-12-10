module ApplicationHelper

  def validation_error(message)
    if message.class.to_s == 'Array'
      message = message.join(",")
    end
    return !message.to_s.blank? ? ("<div class='form_error' style='color:red;'>"+message.to_s+"</div>").html_safe : " "
  end

  def profile_picture
    if @user.role == 'student'
      @user.avatar.present? ? image_tag(@user.avatar.url(:original) , :width => '180px;', :height => '180px;', :class => "profile_pic img-rounded for_cover_photo") : image_tag("/assets/profile_pic_student.png",:width => '180px;',:height => '180px;' , :class => "profile_pic img-rounded for_cover_photo")
    else
      @user.avatar.present? ? image_tag(@user.avatar.url(:original) , :width => '180px;', :height => '180px;', :class => "profile_pic img-rounded for_cover_photo") : image_tag("/assets/profile_pic_instructor.png",:width => '180px;',:height => '180px;' , :class => "profile_pic img-rounded for_cover_photo")
    end
  end


  def post_picture(post)
    if post.user.role == 'student'
      post.user.avatar.present? ? image_tag(post.user.avatar.url(:original), :width => "50px;", :height => "50px;", :class => "profile_pic img-rounded") : image_tag("/assets/profile_pic_student.png",:width => '50px;',:height => '50px;' , :class => "profile_pic img-rounded")
    else
      post.user.avatar.present? ? image_tag(post.user.avatar.url(:original), :width => "50px;", :height => "50px;", :class => "profile_pic img-rounded") : image_tag("/assets/profile_pic_instructor.png",:width => '50px;',:height => '50px;' , :class => "profile_pic img-rounded")
    end
  end

  def conversation_picture(post)
    if post.user.role == 'student'
      post.user.avatar.present? ? image_tag(post.user.avatar.url(:original), :width => "30px;", :height => "30px;", :class => "conversation_post_pic_small") : image_tag("/assets/profile_pic_student.png",:width => '30px;',:height => '30px;' , :class => "conversation_post_pic_small")
    else
      post.user.avatar.present? ? image_tag(post.user.avatar.url(:original), :width => "30px;", :height => "30px;", :class => "conversation_post_pic_small") : image_tag("/assets/profile_pic_instructor.png",:width => '30px;',:height => '30px;' , :class => "conversation_post_pic_small")
    end
  end
end

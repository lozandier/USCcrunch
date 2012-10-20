class SchoolPasswordsController < Devise::PasswordsController
  layout :get_school_layout

  def new
    build_resource({})
  end

  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)

    if successfully_sent?(resource)
      respond_with({}, :location => after_sending_reset_password_instructions_path_for(resource_name))
    else
      respond_with(resource)
    end
  end


  def edit
    self.resource = resource_class.new
    resource.reset_password_token = params[:reset_password_token]
  end
end

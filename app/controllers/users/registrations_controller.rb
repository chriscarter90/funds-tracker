class Users::RegistrationsController < Devise::RegistrationsController
  def update
    @user = User.find(current_user.id)

    successfully_updated = if needs_password?(@user, params)
      @user.update_with_password(devise_parameter_sanitizer.sanitize(:account_update))
    else
      params[:user].delete(:current_password)
      @user.update_without_password(devise_parameter_sanitizer.sanitize(:account_update))
    end

    if successfully_updated
      set_flash_message :success, :updated
      sign_in @user, bypass: true
      redirect_to after_update_path_for(@user)
    else
      render :edit
    end
  end

  protected

  def after_sign_up_path_for(resource)
    accounts_path
  end

  def after_update_path_for(resource)
    accounts_path
  end

  private

  def needs_password?(user, params)
    user.email != params[:user][:email] || params[:user][:password].present?
  end
end

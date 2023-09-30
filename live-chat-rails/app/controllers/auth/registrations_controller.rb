class Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController




  private
  
  # HTTPリクエストに付与されているパラメータのうちどれを許可するか指定
  # ストロングパラメータメソッド
  def sign_up_params
    params.require(:registration).permit(:name, :email, :password, :password_confirmation)
  end
end

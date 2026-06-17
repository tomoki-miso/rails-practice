class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  # ログイン必須（Devise のサインイン/サインアップ画面は除外される）
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # devise の新規登録・アカウント更新で name を許可する
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name ])
  end

  # current_user がメンバーの輪読会だけを取得する。
  # メンバーでない／存在しない場合は nil を返しホームへリダイレクトする。
  def find_member_group(id)
    group = current_user.groups.find_by(id: id)
    redirect_to root_path, alert: "この輪読会にはアクセスできません" unless group
    group
  end
end

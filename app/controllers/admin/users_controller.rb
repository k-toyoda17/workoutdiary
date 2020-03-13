class Admin::UsersController < ApplicationController
  before_action :login_required, except: [:new, :create]
  before_action :admin_login_required, only: [:index, :destroy]
  before_action :correct_user, only: [:edit, :update]

  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).page(params[:page]).per(15).recent

    respond_to do |format|
      format.html
      format.csv { send_data @users.generate_csv, filename: "users-#{Time.zone.now.strftime('%Y%m%d%S')}.csv"}
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)

    if @user.save
      if current_user&.admin? || current_user
        redirect_to admin_user_path(@user), notice: "ユーザー「#{@user.name}」を登録しました。"
      else
        log_in @user
        redirect_to root_path, notice: "ユーザー「#{@user.name}」を登録しました。"
      end
    else
      render :new
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: "ユーザー「#{@user.name}」を更新しました。"
    else
      render :new
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_url, notice: "ユーザー「#{@user.name}」を削除しました。"
  end

  def import
    User.import(params[:file])
    redirect_to admin_users_url, notice: "ユーザーを追加しました。"
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def admin_login_required
    redirect_to tasks_path, notice: '権限がありません。' unless current_user.admin?
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path, notice: '権限がありません。' unless @user == current_user
  end
end

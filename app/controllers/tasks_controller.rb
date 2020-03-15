class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :login_required, only: [:create, :edit, :update, :destroy]

  def index
    if current_user
      @q = current_user.tasks.ransack(params[:q])
      @tasks = @q.result(distinct: true).page(params[:page]).recent.per(10)
    else
      @q = Task.all.ransack(params[:q])
      @tasks = @q.result(distinct: true).page(params[:page]).recent.per(10)
    end
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def update
    @task.update(task_params)
    redirect_to tasks_url, notice: "トレーニング「#{@task.name}」を更新しました。"
  end

  def destroy
    @task.destroy
  end

  def create
    @task = current_user.tasks.new(task_params)

    if @task.save
      redirect_to @task, notice: "トレーニング 「#{@task.name}」を登録しました。"
    else
      render :new
    end
  end

  private

  def task_params
    params.require(:task).permit(:name, :activity_at, :weight, :lep, :set, :description, :image)
  end

  def set_task
    if current_user
      @task = current_user.tasks.find(params[:id])
    else
      @task = Task.find(params[:id])
    end
  end
end

class ActivitiesController < ApiController
  before_action :authenticate_user!
  before_action :require_user
  before_action :require_activity, only: [:show, :update, :destroy]
  before_action :authorize_user, only: [:show, :update, :destroy]

  def index
    render json: Activity.by_user(current_user).order(created_at: :desc)
  end

  def show
    render json: activity
  end

  def create
    new_activity = Activity.new(activity_attributes)

    if new_activity.save
      render json: { activity: new_activity }, status: :created
    else
      render json: { errors: new_activity.errors }, status: :unprocessable_entity
    end
  end

  def update
    activity.attributes = activity_attributes

    if activity.save
      render json: { activity: activity }, status: :ok
    else
      render json: { errors: activity.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if activity.destroy
      head :ok
    else
      render json: { errors: activity.errors }, status: :internal_server_error
    end
  end

  private

  def require_user
    unauthorized unless user_signed_in?
  end

  def require_activity
    activity.present?
  end

  def authorize_user
    unauthorized unless activity.user_id == current_user.id
  end

  def activity
    @_activity ||= Activity.find(activity_id)
  end

  def activity_id
    params.require(:id)
  end

  def activity_attributes
    params.permit(:description, :amount).merge({ user: current_user })
  end
end

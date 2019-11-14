require 'csv'

class Admins::UsersController < Admins::BaseController

  before_action :fetch_user, only: [:become, :import]

  def index
    @users = User.order(:id)
    @ink_counts = CollectedInk.group(:user_id).select("user_id, count(id)").reduce({}) {|acc, el| acc[el.user_id] = el.count; acc }
    @pen_counts = CollectedPen.group(:user_id).select("user_id, count(id)").reduce({}) {|acc, el| acc[el.user_id] = el.count; acc }
    @ci_counts = CurrentlyInked.group(:user_id).select("user_id, max(inked_on) as inked_on, count(id)").reduce({}) {|acc, el| acc[el.user_id] = el.count; acc }
  end

  def become
    sign_in(:user, @user, bypass: true)
    redirect_to root_url
  end

  def import
    count = 0
    content = params[:file].read.force_encoding('UTF-8')
    CSV.parse(content, headers: true) do |row|
      row = row.to_hash
      ImportCollectedInk.perform_async(@user.id, row)
      count +=1
    end
    flash[:notice] = "#{count} inks scheduled for imported for #{@user.email}"
    redirect_to admins_users_path
  end

  private

  def fetch_user
    @user = User.find(params[:id])
  end
end

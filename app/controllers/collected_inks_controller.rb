require 'csv'

class CollectedInksController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.collected_inks.empty?
      flash.now[:notice] = "Your ink collection is empty. Check out the <a href='/pages/documentation'>documentation</a> on how to add some.".html_safe
    end
    respond_to do |format|
      format.html
      format.json {
        render jsonapi: current_user.collected_inks.includes(:currently_inkeds)
      }
      format.csv do
        send_data current_user.collected_inks.order("brand_name, line_name, ink_name").to_csv, type: "text/csv", filename: "collected_inks.csv"
      end
    end
  end

  def create
    collected_ink = current_user.collected_inks.build
    if SaveCollectedInk.new(collected_ink, collected_ink_params).perform
      render jsonapi: collected_ink
    else
      render jsonapi_errors: collected_ink.errors
    end
  end

  def update
    collected_ink = current_user.collected_inks.find(params[:id])
    if SaveCollectedInk.new(collected_ink, collected_ink_params).perform
      render jsonapi: collected_ink
    else
      render jsonapi_errors: collected_ink.errors
    end
  end

  def destroy
    collected_ink = current_user.collected_inks.find(params[:id])
    collected_ink.destroy
    render jsonapi: collected_ink
  end

  private

  def collected_ink_params
    params.require(:collected_ink).permit(
      :ink_name,
      :line_name,
      :brand_name,
      :kind,
      :color,
      :swabbed,
      :used,
      :comment,
    )
  end

end

class CollectedInksController < ApplicationController
  before_action :authenticate_user!
  before_action :find_ink, only: [:edit, :update, :destroy, :archive, :unarchive]


  def index
    if current_user.collected_inks.empty?
      flash.now[:notice] = "Your ink collection is empty. Check out the <a href='/pages/guide'>documentation</a> on how to add some.".html_safe
    end
    inks = current_user.collected_inks.includes(:currently_inkeds, :usage_records).order(
      "brand_name, line_name, ink_name"
    )
    respond_to do |format|
      format.html
      format.jsonapi { render jsonapi: inks }
      format.json { render jsonapi: inks }
      format.csv do
        send_data inks.to_csv, type: "text/csv", filename: "collected_inks.csv"
      end
    end
  end

  def new
    self.ink = current_user.collected_inks.build
  end

  def import
  end

  def create
    self.ink = collected_ink = current_user.collected_inks.build
    if SaveCollectedInk.new(ink, collected_ink_params).perform
      flash[:notice] = 'Successfully created ink'
      if params[:redo]
        self.ink = collected_ink = current_user.collected_inks.build
        render :new
      else
        redirect_to collected_inks_path
      end
    else
      render :new
    end
  end

  def edit
  end

  def update
    if SaveCollectedInk.new(ink, collected_ink_params).perform
      flash[:notice] = 'Successfully updated ink'
      if archive?
        redirect_to collected_inks_path(search: { archive: true })
      else
        redirect_to collected_inks_path
      end
    else
      render :edit
    end
  end

  def destroy
    if ink
      if ink.deletable?
        ink.destroy
        flash[:notice] = "Ink successfully deleted"
      else
        flash[:alert] = "'#{ink.name}' has currently inked entries attached and can't be deleted."
      end
    end
    if archive?
      redirect_to collected_inks_path(search: { archive: true })
    else
      redirect_to collected_inks_path
    end
  end

  def archive
    flash[:notice] = "Successfully archived '#{ink.name}'" if ink
    ink&.archive!
    redirect_to collected_inks_path
  end

  def unarchive
    flash[:notice] = "Successfully unarchived '#{ink.name}'" if ink
    ink&.unarchive!
    redirect_to collected_inks_path(search: { archive: true })
  end

  private

  attr_accessor :ink

  def find_ink
    self.ink = current_user.collected_inks.find(params[:id])
  end

  helper_method :archive?
  def archive?
    params.dig(:search, :archive) == 'true' || params[:archive]
  end

  def collected_ink_params
    params.require(:collected_ink).permit(
      :brand_name,
      :line_name,
      :ink_name,
      :maker,
      :kind,
      :swabbed,
      :used,
      :comment,
      :private_comment,
      :color,
      :private,
    )
  end
end

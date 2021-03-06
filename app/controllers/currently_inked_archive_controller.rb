class CurrentlyInkedArchiveController < ApplicationController
  before_action :authenticate_user!
  before_action :retrieve_record, only: [:edit, :update, :destroy, :unarchive]
  before_action :set_used_pen_ids, only: [:index]

  def index
    @collection = current_user.currently_inkeds.archived.includes(
      :collected_pen, :collected_ink
    ).order('archived_on DESC, created_at DESC').page(params[:page]).per(50)
  end

  def edit
  end

  def unarchive
    @record.unarchive!
    redirect_to currently_inked_archive_index_path
  end

  def update
    if @record.update(currently_inked_params)
      flash[:notice] = "Successfully updated entry"
      redirect_to currently_inked_archive_index_path
    else
      render :edit
    end
  end

  def destroy
    @record.destroy
    redirect_to currently_inked_archive_index_path
  end

  private

  def currently_inked_params
    params.require(:currently_inked).permit(
      :collected_ink_id,
      :collected_pen_id,
      :inked_on,
      :archived_on,
      :comment
    )
  end

  def retrieve_record
    @record = current_user.currently_inkeds.find(params[:id])
  end

  def set_used_pen_ids
    @used_pen_ids = current_user.currently_inkeds.active.pluck(:collected_pen_id)
  end
end

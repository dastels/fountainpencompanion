class BrandsController < ApplicationController
  def index
    respond_to do |format|
      format.json {
        brands = Brand.search(params[:term])
        render json: brands
      }
      format.html {
        @brands = Brand.order(:popular_name).where.not(simplified_brand_name: "")
      }
    end
  end

  def show
    @inks = Ink.where(simplified_brand_name: params[:id]).order("simplified_line_name, popular_ink_name")
  end

end

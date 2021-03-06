class InksController < ApplicationController
  def index
    clusters = MacroCluster.autocomplete_search(params[:term], :ink_name)
    serializer = MacroClusterSerializer.new(
      clusters, fields: { macro_cluster: [:ink_name]}
    )
    render json: serializer.serializable_hash.to_json
end
end

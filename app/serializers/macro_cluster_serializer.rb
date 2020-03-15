class MacroClusterSerializer
  include FastJsonapi::ObjectSerializer

  has_many :micro_clusters

  attribute :brand_name
  attribute :line_name
  attribute :ink_name
  attribute :color
end

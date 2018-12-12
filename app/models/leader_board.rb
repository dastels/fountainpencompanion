class LeaderBoard
  def self.inks
    build
  end

  def self.bottles
    build.where(collected_inks: {kind: "bottle"})
  end

  def self.samples
    build.where(collected_inks: {kind: "sample"})
  end

  def self.brands
    build(
      "(select sum(1) OVER () from collected_inks where collected_inks.user_id = users.id group by collected_inks.brand_name limit 1) as counter"
    )
  end

  def self.build(select = "count(*) as counter")
    select_clause = "users.*, #{select}"
    base_relation.select(select_clause)
  end

  def self.base_relation
    User.joins(:collected_inks).where(collected_inks: {
      archived_on: nil, private: false
    }).group("users.id").order("counter DESC").limit(10)
  end
end

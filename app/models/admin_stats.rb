class AdminStats
  def user_count
    @user_count ||= User.count
  end

  def confirmed_user_count
    @confirmed_user_count ||= User.active.count
  end

  def confirmed_user_percentage
    confirmed_user_count*100.0/user_count
  end

  def active_user_count
    ink_user_ids = User.joins(:collected_inks).group('users.id').pluck(:id)
    pen_user_ids = User.joins(:collected_pens).group('users.id').pluck(:id)
    @active_user_count ||= (ink_user_ids | pen_user_ids).count
  end

  def active_user_percentage
    active_user_count*100.0/user_count
  end

  def users_using_collected_pens_count
    @users_using_collected_pens_count ||= User.joins(:collected_pens).group('users.id').count.count
  end

  def users_using_collected_pens_percentage
    users_using_collected_pens_count*100.0/active_user_count
  end

  def users_using_currently_inked_count
    @users_using_currently_inked_count ||= User.joins(:currently_inkeds).group('users.id').count.count
  end

  def users_using_currently_inked_percentage
    users_using_currently_inked_count*100.0/active_user_count
  end

  def users_using_collected_inks_count
    @users_using_collected_inks_count ||= User.joins(:collected_inks).group('users.id').count.count
  end

  def users_using_collected_inks_percentage
    users_using_collected_inks_count*100.0/active_user_count
  end

  def collected_inks_count
    @collected_inks_count ||= CollectedInk.count
  end

  def collected_inks_with_color_count
    @collected_inks_with_color_count ||= CollectedInk.with_color.count
  end

  def collected_inks_with_color_percentage
    collected_inks_with_color_count*100.0/collected_inks_count
  end

  def collected_inks_without_color_count
    @collected_inks_without_color_count ||= CollectedInk.without_color.count
  end

  def ink_count
    @ink_count ||= NewInkName.public_count
  end

  def inks_with_color_count
    @inks_with_color_count ||= NewInkName.with_color.public_count
  end

  def inks_with_color_percentage
    inks_with_color_count*100.0/ink_count
  end

  def inks_without_color_count
    @inks_without_color_count ||= NewInkName.without_color.public_count
  end

  def users_using_usage_records_count
    @users_using_usage_records_count ||= User.joins(currently_inkeds: :usage_records).group('users.id').count.count
  end

  def users_using_usage_records_percentage
    users_using_usage_records_count*100.0/active_user_count
  end
end
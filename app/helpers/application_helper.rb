module ApplicationHelper
  def premium_label(premium)
    if premium
      t("games.show.premium.#{premium.target}.#{premium.tuple}")
    end
  end
end

module ApplicationHelper
  # For check if asset is exists or not, prevent asset not found
  def asset_exists?(path)
    Rails.application.assets.find_asset(path).present?
  end
end

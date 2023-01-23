module ApplicationHelper
  # For check if asset is exists or not, prevent asset not found
  def asset_exists?(path)
    Rails.application.assets.find_asset(path).present?
  end

  def nominal_format(nominal)
    ActionController::Base.helpers.number_to_currency(
      nominal, unit: '', strip_insignificant_zeros: true
    )
  end
end

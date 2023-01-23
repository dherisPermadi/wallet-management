# frozen_string_literal: true

class StockItemsController < ApplicationController
  def index
    @search = if current_user.user_type.eql?('admin')
                StockItem.includes(:stock, :stockable).order(created_at: :desc).ransack(params[:q])
              else
                StockItem.where(stockable_type: 'User', stockable_id: current_user.id).includes(:stock, :stockable)
                         .order(created_at: :desc).ransack(params[:q])
              end
    @stock_items = @search.result(distinct: true).page(params[:page] || 1).per(10)
  end
end

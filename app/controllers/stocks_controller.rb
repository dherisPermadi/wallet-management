# frozen_string_literal: true

class StocksController < ApplicationController
  before_action :set_stock, only: %i[show edit update destroy]

  def index
    @search = Stock.order(name: :asc).ransack(params[:q])
    @stocks = @search.result(distinct: true).page(params[:page] || 1).per(10)
  end

  def show; end

  def new
    @stock = Stock.new
  end

  def edit; end

  def create
    @stock = Stock.new(stock_params)
    if @stock.save
      redirect_to @stock, notice: 'Stock created successfully!'
    else
      render :new
    end
  end

  def update
    if @stock.update(stock_params)
      redirect_to @stock, notice: 'Stock updated successfully!'
    else
      render :edit
    end
  end

  def destroy
    @stock.destroy
    redirect_to stocks_path, notice: 'Stock deleted successfully!'
  end

  private

  def set_stock
    @stock = Stock.find(params[:id])
  end

  def stock_params
    params.require(:stock).permit(:name, :status, :conversion_rate)
  end
end

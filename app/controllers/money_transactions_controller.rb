# frozen_string_literal: true

class MoneyTransactionsController < ApplicationController
  before_action :set_money_transaction, only: %i[show]

  def index
    @search = if current_user.user_type.eql?('admin')
                MoneyTransaction.includes(:transactionable).order(created_at: :desc).ransack(params[:q])
              else
                MoneyTransaction.where(transactionable_type: 'User', transactionable_id: current_user.id).includes(:transactionable)
                                .order(created_at: :desc).ransack(params[:q])
              end
    
    @money_transactions = @search.result(distinct: true).page(params[:page] || 1).per(10)
  end

  def show; end

  def new
    @money_transaction = MoneyTransaction.new
  end

  def create
    @money_transaction = MoneyTransaction.new(money_transaction_params)
    transaction_type   = @money_transaction.transaction_type
    if @money_transaction.save
      redirect_page = if ['deposit','transfer'].include?(transaction_type)
                        current_user.user_type.eql?('admin') ? money_transactions_path : wallet_path(id: current_user.wallet.id)
                      else
                        stock_items_path
                      end
      redirect_to redirect_page, notice: "Transaction #{@money_transaction.transaction_type} Success!"
    else
      render :new, locals: { params: {transaction_type: transaction_type} }
    end
  end

  private

  def set_money_transaction
    @money_transaction = MoneyTransaction.find(params[:id])
  end

  def money_transaction_params
    params.require(:money_transaction).permit(:transactionable_type, :transactionable_id, :transaction_type,
      :amount, :targetable_type, :targetable_id, :stock_id, :team_id, :user_id, :target_user_id, :target_team_id
    )
  end
end

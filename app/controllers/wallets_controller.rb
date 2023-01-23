# frozen_string_literal: true

class WalletsController < ApplicationController
  before_action :set_wallet, only: %i[show]

  def index
    @search = Wallet.select('wallets.*, SUM(wallet_transactions.amount) as total_balance')
                    .includes(:walletable).left_joins(:wallet_transactions).group('wallets.id')
                    .order(created_at: :desc).ransack(params[:q])
    @wallets = @search.result(distinct: true).page(params[:page] || 1).per(10)
  end

  def show; end

  private

  def set_wallet
    @wallet = Wallet.find(params[:id])
  end
end

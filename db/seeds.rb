# 1. USER GENERATE
# Admin Wallet
User.create_or_find_by(email: 'admin_wallet@mailinator.com', name: 'Admin wallet', user_type: 1, password: 'Wallet123!')

# User Customer
User.create_or_find_by(email: 'first_user@mailinator.com', name: 'Jessica', password: 'Wallet123!')
User.create_or_find_by(email: 'second_user@mailinator.com', name: 'Aaron', password: 'Wallet123!')
User.create_or_find_by(email: 'third_user@mailinator.com', name: 'James', password: 'Wallet123!')
User.create_or_find_by(email: 'fourth_user@mailinator.com', name: 'Kevin', password: 'Wallet123!')
User.create_or_find_by(email: 'fifth_user@mailinator.com', name: 'Sabrina', password: 'Wallet123!')

# 2. GENERATE TEAM
Team.create_or_find_by(name: 'Alpha Team')
Team.create_or_find_by(name: 'Dream Corps')

# 3. GENERATE STOCK
Stock.create_or_find_by(name: 'Gold', conversion_rate: 1.25)
Stock.create_or_find_by(name: 'US Dollar', conversion_rate: 0.80)
Stock.create_or_find_by(name: 'Mineral', conversion_rate: 0.50)

# 4. WALLET DEPOSIT
Wallet.all.each do |wallet|
  if wallet.walletable_type.eql?('User')
    if wallet.walletable.user_type.eql?('admin')
      wallet.walletable.money_transactions.create(transaction_type: 'deposit', amount: 1000000)
    else
      wallet.walletable.money_transactions.create(transaction_type: 'deposit', amount: 10000)
    end
  else
    wallet.walletable.money_transactions.create(transaction_type: 'deposit', amount: 5000)
  end
end

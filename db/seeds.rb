#doorkeeper
url = 'http://127.0.0.1/'
team_url = 'http://127.0.0.1/team'
admin_url = 'http://127.0.0.1/admin'

Doorkeeper::Application.create_or_find_by(name: "Customer Client", redirect_uri: url,
                                          uid: 'customer_client', scopes: 'customer')

Doorkeeper::Application.create_or_find_by(name: "Team Client", redirect_uri: team_url,
                                          uid: 'team_client', scopes: 'team')

Doorkeeper::Application.create_or_find_by(name: "Admin Client", redirect_uri: admin_url,
                                          uid: 'admin_client', scopes: 'admin')

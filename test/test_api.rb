require 'rspec'
require 'monexa'
require 'pp'

describe Monexa, '#ping' do
  it 'should pong' do
    Monexa.ping.success?.should === true
  end
end

describe Monexa, 'Account Methods' do
  before :all do
    @subscriber = nil
    @random_login = 'luser' + 5.times.map {rand(100)}.join('')
    @account_data = {
      :account_information => {
        :login_id => @random_login,
        :external_group_id => 'test',
        :provider_id => Monexa::config.provider_id,
        :password => '12345',
        :office_id => Monexa::config.office_id,
        :plan => {
          :plan_id => 'AudioAddict'
        }
      },
      :contact_information => {
        :first_name => 'Nick',
        :last_name => 'Wilson',
        :company => 'Nick Wilson',
        :timezone => 'America/New_York'
      }
    }
  end
  
  it 'should not find a user that does not exist' do
    response = Monexa::Subscriber.search :login_id => @random_login
    response.success?.should === true
    response.data.include?(:result_size).should === true
    response.data[:result_size].to_i.should === 0
  end

  it 'should successfully create a new account' do
    response = Monexa::Subscriber.create @account_data
    response.success?.should === true
  end

  it 'should find a user that does exist' do
    response = Monexa::Subscriber.search :login_id => @random_login
    response.success?.should === true
    response.data.include?(:result_size).should === true
    response.data[:result_size].to_i.should === 1
  end

  it 'should match the users password' do 
    request_data = {
      :account_information => {
        :login_id => @account_data[:account_information][:login_id],
        :external_group_id => @account_data[:account_information][:external_group_id],
        :provider_id => @account_data[:account_information][:provider_id],
        :password => @account_data[:account_information][:password]
      }
    }
    
    response = Monexa::Subscriber.check_password request_data
    response.success?.should === true
  end
  
  it 'should delete a user' do
    request_data = {
      :account_information => {
        :login_id => @account_data[:account_information][:login_id],
        :external_group_id => @account_data[:account_information][:external_group_id],
        :provider_id => @account_data[:account_information][:provider_id],
        :account_status => 'deleted'
      }
    }
      
    response = Monexa::Subscriber.update request_data
    response.success?.should === true
  end
end
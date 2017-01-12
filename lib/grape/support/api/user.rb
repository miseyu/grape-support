class Grape::Support::API::User
  include Her::Model
  use_api Grape::Support::API::DashboardAPI

  class UserEntity
    attr_accessor :id, :name, :company

    def initialize(id, name, company)
      self.id = id
      self.name = name
      self.company = Hashie::Mash.new(company)
    end

  end

  class << self

    def find_by_account_id(account_id)
      result = get("/users/account/#{account_id}")
      return if result.blank?
      UserEntity.new(result[:id], result[:name], result[:company])
    end
  end

end

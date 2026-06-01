class OrganizationMember < ApplicationRecord
  enum role: { member: 0, admin: 1, owner: 2 }
end

class Project < ApplicationRecord
    extend FriendlyId
    friendly_id :slug_candidates, use: :slugged

    has_many :project_contracts
    has_many :users, through: :project_contracts

    has_many :invoices

    validates :name, presence: true

    def slug_candidates
        [[:name, :slug_suffix]]
    end

    def slug_suffix
        SecureRandom.hex(3)
    end

    def from_owner(owner, props)
        owner_contract = owner.project_contracts.new(
            project: Project.new(props),
            activity: "Owner",
            project_rate: 0,
            user_rate: 0
        )
        owner_contract.project
    end
end
class UserSerializer < ResourceSerializer
  attributes :email

  attribute :images do |user, params|
    if params[:uploaded].present?
      if user.images.attached?
        url_for(user.images.last)
      end
    else
      if user.images.attached?
        user.images.map { |image| url_for(image) }
      end
    end
  end
end

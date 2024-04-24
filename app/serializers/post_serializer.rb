class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :text

  attributes :user

  def user
    UserSerializer.new(object.user, root: false)
  end
end

class CommentSerializer < ActiveModel::Serializer
  attributes :id, :name, :text, :post

  def post
    PostSerializer.new(object.post).as_json
  end
end

class TodoStore
  class << self
    def items
      @items ||= [
        { "id" => 1, "title" => "Ship SPA shell", "completed" => false }
      ]
    end

    def add!(title)
      next_id = items.map { |todo| todo["id"] }.max.to_i + 1
      todo = { "id" => next_id, "title" => title, "completed" => false }
      items << todo
      todo
    end

    def delete!(id)
      items.reject! { |todo| todo["id"] == id.to_i }
    end

    def reset!
      @items = [
        { "id" => 1, "title" => "Ship SPA shell", "completed" => false }
      ]
    end
  end
end

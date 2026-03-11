class HtmlTodoStore
  class << self
    def items
      @items ||= default_items
    end

    def add!(title)
      todo = {
        "id" => next_id,
        "title" => title,
      }
      items << todo
      todo
    end

    def delete!(id)
      items.reject! { |todo| todo["id"] == id.to_i }
    end

    def reset!
      @items = default_items
    end

    private

    def next_id
      items.map { |todo| todo["id"] }.max.to_i + 1
    end

    def default_items
      [
        { "id" => 1, "title" => "Ship HTML demo" },
        { "id" => 2, "title" => "Document recommended usage" }
      ]
    end
  end
end

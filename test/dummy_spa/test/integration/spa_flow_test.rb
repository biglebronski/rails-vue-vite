require "test_helper"

class SpaFlowTest < ActionDispatch::IntegrationTest
  setup do
    TodoStore.reset!
  end

  test "root route renders the spa shell" do
    get "/"

    assert_response :success
    assert_includes @response.body, 'id="app"'
    assert_includes @response.body, "http://localhost:5173/vite/@vite/client"
    assert_includes @response.body, "http://localhost:5173/vite/entrypoints/application.js"
  end

  test "about route resolves to the same spa shell" do
    get "/about"

    assert_response :success
    assert_includes @response.body, 'id="app"'
  end

  test "todo api lists and creates todos" do
    get "/api/todos"

    assert_response :success
    payload = JSON.parse(@response.body)
    assert_equal "Ship SPA shell", payload.fetch("todos").first.fetch("title")

    post "/api/todos", params: { title: "Add about route" }, as: :json

    assert_response :created
    payload = JSON.parse(@response.body)
    assert_equal "Add about route", payload.fetch("todo").fetch("title")

    get "/api/todos"

    payload = JSON.parse(@response.body)
    titles = payload.fetch("todos").map { |todo| todo.fetch("title") }
    assert_includes titles, "Add about route"
  end

  test "todo api deletes todos" do
    delete "/api/todos/1", as: :json

    assert_response :no_content

    get "/api/todos"

    payload = JSON.parse(@response.body)
    assert_empty payload.fetch("todos")
  end
end

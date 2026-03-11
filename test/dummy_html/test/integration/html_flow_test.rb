require "test_helper"

class HtmlFlowTest < ActionDispatch::IntegrationTest
  setup do
    HtmlTodoStore.reset!
  end

  test "home page is rails-rendered and includes the vue widget mount point" do
    get "/"

    assert_response :success
    assert_includes @response.body, "Rails rendered this page"
    assert_includes @response.body, "data-vue-widget"
    assert_includes @response.body, "Ship HTML demo"
    assert_includes @response.body, "http://localhost:5174/vite/entrypoints/application.js"
  end

  test "about page is rendered entirely by rails" do
    get "/about"

    assert_response :success
    assert_includes @response.body, "About the HTML-first mode"
    refute_includes @response.body, "data-vue-widget"
  end

  test "widget todo api persists create and delete" do
    get "/api/widget_todos"

    assert_response :success
    payload = JSON.parse(@response.body)
    assert_equal 2, payload.fetch("todos").length

    post "/api/widget_todos", params: { title: "Keep HTML mode realistic" }, as: :json

    assert_response :created
    created = JSON.parse(@response.body).fetch("todo")
    assert_equal "Keep HTML mode realistic", created.fetch("title")

    get "/"

    assert_includes @response.body, "Keep HTML mode realistic"

    delete "/api/widget_todos/#{created.fetch("id")}", as: :json

    assert_response :no_content

    get "/"

    refute_includes @response.body, "Keep HTML mode realistic"
  end
end

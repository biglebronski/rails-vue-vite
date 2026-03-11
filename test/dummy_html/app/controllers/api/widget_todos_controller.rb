class Api::WidgetTodosController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    render json: { todos: HtmlTodoStore.items }
  end

  def create
    todo = HtmlTodoStore.add!(params.require(:title))
    render json: { todo: todo }, status: :created
  end

  def destroy
    HtmlTodoStore.delete!(params[:id])
    head :no_content
  end
end

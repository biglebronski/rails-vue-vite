class Api::TodosController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    render json: { todos: TodoStore.items }
  end

  def create
    todo = TodoStore.add!(params.require(:title))
    render json: { todo: todo }, status: :created
  end

  def destroy
    TodoStore.delete!(params[:id])
    head :no_content
  end
end

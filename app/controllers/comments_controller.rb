class CommentsController < ApplicationController
  before_action :require_user
  before_action :set_comment, only: [:edit, :destroy, :update]
  before_action :check_user, only: [:edit, :destroy, :update]
  before_action :set_ticket, only: [:edit, :create, :destroy, :update]

  def edit
  end

  def update
    if @comment.update(comment_params)
      @ticket.update(ticket_params)
      flash[:notice] = "The comment was updated."
      redirect_to ticket_path(@ticket)
    else
      render :edit
    end
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    @comment.ticket = @ticket

    if @comment.save
      @ticket.update(ticket_params)
      flash[:notice] = 'Comment added.'
    else
      flash[:error] = 'Comment body cannot be blank.'
    end

    redirect_to ticket_path(@ticket)
  end

  def destroy
    @comment.destroy
    flash[:notice] = 'Comment deleted.'
    redirect_to ticket_path(@ticket)
  end

  private

  def set_ticket
    @ticket = Ticket.find(params[:ticket_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def ticket_params
    params.require(:ticket).permit(:status)
  end

  def check_user
    require_same_user(@comment.user)
  end
end

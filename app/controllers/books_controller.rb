class BooksController < ApplicationController
  before_action :authenticate_user!

  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @book_comment = BookComment.new
  end

  def index
    if params[:latest]
      @books = Book.latest
    elsif params[:old]
      @books = Book.old
    elsif params[:high_rate]
      @books = Book.high_rate
    else
      @books = Book.all
    end
    @tag_list = Tag.all
    @book = Book.new
  end

  def create
    @book = current_user.books.new(book_params)
    tag_list = params[:book][:name].split(',')
    if @book.save
      @book.save_tag(tag_list)
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
    @user = @book.user
    @tag_list = @book.tags.pluck(:name).join(',')
    unless @user == current_user
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    tag_list = params[:book][:name].split(',')
    if @book.update(book_params)
      @book.save_tag(tag_list)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end
  

  private

  def book_params
    params.require(:book).permit(:title, :body, :rate)
  end
end

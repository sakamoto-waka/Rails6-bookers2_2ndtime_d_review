class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]
    @search = params[:search]
    @word = params[:word]

    if @range == 'User'
      @records = User.looks(@search, @word)
    elsif @range == 'Book'
      @records = Book.looks(@search, @word)
    else
      @records = Tag.looks_books_for(@search, @word)
    end
  end
end

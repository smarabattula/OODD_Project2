class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update destroy ]

  # GET /books or /books.json
  def index
    @books = Book.all
  end

  #Filter books based on Author or Average Rating
  def filter
    @books = Book.all
  #Author is entered, filter it
    if params[:author].present?
      @books = @books.where(author: params[:author])
    end
  #Average Rating is entered, filter it
    if params[:rating].present?
      @books = @books.select do |book|
        if book.reviews.present?
          book.reviews.average(:Rating) >= params[:rating].to_f
        else
          false
        end
      end
    end
    # Display a message if no books were found
    if @books.empty?
      flash.now[:notice] = "No books found."
    end
    render :index, locals: { average_rating: "N/A" } # default value for average_rating
  end
  # GET /books/1 or /books/1.json
  def show
    @book = Book.find(params[:id])
    # Calculate the average rating of the book's reviews, or display "N/A" if there are no reviews
    @average_rating = @book.reviews.present? ? @book.reviews.average(:rating) : "N/A" # default value for average_rating
  end

  # GET /books/new
  def new
    # Only allow admins to create new books
    if current_user.is_admin?
      @book = Book.new
    else
      flash.now[:notice] = "You aren't authorized to create new books"
    end
  end

  # GET /books/1/edit
  def edit
    #only admin can edit books
    if current_user.is_admin?
      @book = Book.find(params[:id])
    else
      flash.now[:notice] = "You aren't authorized to edit books"
    end
  end

  # POST /books or /books.json
  def create
    @book = Book.new(book_params)
    # Save the book and redirect to its page if successful, or display an error message if not
    respond_to do |format|
      if @book.save
        format.html { redirect_to book_url(@book), notice: "Book was successfully created." }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1 or /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to book_url(@book), notice: "Book was successfully updated." }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    @book.destroy

    respond_to do |format|
      format.html { redirect_to books_url, notice: "Book was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:book_id,:Name, :Author, :Publisher, :Price, :Stock)
    end
end

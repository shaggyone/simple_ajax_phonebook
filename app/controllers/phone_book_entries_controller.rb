class PhoneBookEntriesController < ApplicationController
  respond_to :json
  respond_to :csv, only: :index

  # GET /phone_book_entries
  def index
    @phone_book_entries = PhoneBookEntry.all

    respond_to do |format|
      format.json { render json: @phone_book_entries }
    end
  end

  # POST /phone_book_entries
  def create
    @phone_book_entry = PhoneBookEntry.create params[:phone_book_entry]

    respond_to do |format|
      format.json { render json: @phone_book_entry }
    end
  end

  # PUT /phone_book_entries/:id
  def update
  end

  # DELETE /phone_book_entries/:id
  def destroy
  end

  # POST /phone_book_entries/upload
  def upload
  end
end

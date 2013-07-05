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
    @phone_book_entry = PhoneBookEntry.find(params[:id])
    @phone_book_entry.update_attributes params[:phone_book_entry]

    respond_to do |format|
      format.json { render json: @phone_book_entry }
    end
  end

  # DELETE /phone_book_entries/:id
  def destroy
    @phone_book_entry = PhoneBookEntry.find(params[:id])
    @phone_book_entry.destroy

    respond_to do |format|
      format.json { render json: @phone_book_entry }
    end
  end

  # POST /phone_book_entries/upload
  def upload
  end
end

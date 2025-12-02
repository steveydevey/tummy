class TrackableEntriesController < ApplicationController
  before_action :set_entry, only: [:edit, :update, :destroy]
  before_action :prepopulate_date, only: [:new]

  def index
    entries = model_class.recent
    instance_variable_set("@#{entry_variable_name.pluralize}", entries)
  end

  def new
    entry = model_class.new
    instance_variable_set("@#{entry_variable_name}", entry)
    prepopulate_date
    @return_to = sanitize_return_to(params[:return_to] || request.referer) || default_path
  end

  def create
    entry = model_class.new(entry_params)
    instance_variable_set("@#{entry_variable_name}", entry)
    return_to = sanitize_return_to(params[:return_to] || request.referer) || default_path

    if entry.save
      redirect_to return_to, notice: success_notice('created')
    else
      @return_to = return_to
      render :new, status: :unprocessable_content
    end
  end

  def edit
    @return_to = sanitize_return_to(params[:return_to] || request.referer) || default_path
  end

  def update
    return_to = sanitize_return_to(params[:return_to]) || default_path

    if @entry.update(entry_params)
      redirect_to return_to, notice: success_notice('updated')
    else
      @return_to = return_to
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    return_to = sanitize_return_to(params[:return_to]) || default_path
    @entry.destroy
    redirect_to return_to, notice: success_notice('deleted')
  end

  private

  def set_entry
    @entry = model_class.find(params[:id])
    instance_variable_set("@#{entry_variable_name}", @entry)
  end

  def prepopulate_date
    return unless params[:date].present?

    entry = instance_variable_get("@#{entry_variable_name}")
    return unless entry

    begin
      selected_date = Date.parse(params[:date])
      entry.public_send("#{timestamp_column}=", selected_date.beginning_of_day + 12.hours)
    rescue ArgumentError
      # Invalid date, ignore
    end
  end

  # Abstract methods - must be implemented in subclasses
  def model_class
    raise NotImplementedError, 'Subclass must implement model_class'
  end

  def entry_params
    raise NotImplementedError, 'Subclass must implement entry_params'
  end

  def default_path
    raise NotImplementedError, 'Subclass must implement default_path'
  end

  def entry_variable_name
    raise NotImplementedError, 'Subclass must implement entry_variable_name'
  end

  def timestamp_column
    raise NotImplementedError, 'Subclass must implement timestamp_column'
  end

  def model_name
    raise NotImplementedError, 'Subclass must implement model_name'
  end

  def success_notice(action)
    "#{model_name} was successfully #{action}."
  end
end


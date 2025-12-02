class AccidentsController < TrackableEntriesController
  private

  def model_class
    Accident
  end

  def entry_params
    params.require(:accident).permit(:occurred_at, :accident_type, :notes)
  end

  def default_path
    accidents_path
  end

  def entry_variable_name
    'accident'
  end

  def timestamp_column
    :occurred_at
  end

  def model_name
    'Accident'
  end
end


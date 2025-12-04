class MiralaxCapsController < TrackableEntriesController
  private

  def model_class
    MiralaxCap
  end

  def entry_params
    params.require(:miralax_cap).permit(:occurred_at, :amount, :notes)
  end

  def default_path
    miralax_caps_path
  end

  def entry_variable_name
    'miralax_cap'
  end

  def timestamp_column
    :occurred_at
  end

  def model_name
    'Miralax cap'
  end
end


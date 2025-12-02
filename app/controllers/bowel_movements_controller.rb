class BowelMovementsController < TrackableEntriesController
  private

  def model_class
    BowelMovement
  end

  def entry_params
    params.require(:bowel_movement).permit(:occurred_at, :severity, :notes)
  end

  def default_path
    bowel_movements_path
  end

  def entry_variable_name
    'bowel_movement'
  end

  def timestamp_column
    :occurred_at
  end

  def model_name
    'Bowel movement'
  end
end

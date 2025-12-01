class GiSymptomsController < ApplicationController
  def index
    @gi_symptoms = GiSymptom.recent
  end

  def new
    @gi_symptom = GiSymptom.new
  end

  def create
    @gi_symptom = GiSymptom.new(gi_symptom_params)

    if @gi_symptom.save
      redirect_to food_entries_path, notice: 'GI symptom was successfully created.'
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def gi_symptom_params
    params.require(:gi_symptom).permit(:symptom_type, :occurred_at, :severity, :notes)
  end
end

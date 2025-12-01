class BowelMovementsController < ApplicationController
  def index
    @bowel_movements = BowelMovement.recent
  end

  def new
    @bowel_movement = BowelMovement.new
  end

  def create
    @bowel_movement = BowelMovement.new(bowel_movement_params)

    if @bowel_movement.save
      redirect_to food_entries_path, notice: 'Bowel movement was successfully created.'
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
    @bowel_movement = BowelMovement.find(params[:id])
  end

  def update
    @bowel_movement = BowelMovement.find(params[:id])

    if @bowel_movement.update(bowel_movement_params)
      redirect_to bowel_movements_path, notice: 'Bowel movement was successfully updated.'
    else
      render :edit, status: :unprocessable_content
    end
  end

  private

  def bowel_movement_params
    params.require(:bowel_movement).permit(:occurred_at, :severity, :notes)
  end
end

# == Schema Information
#
# Table name: cats
#
#  id          :integer          not null, primary key
#  birthdate   :date             not null
#  color       :string           not null
#  name        :string           not null
#  sex         :string(1)        not null
#  description :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class CatsController < ApplicationController

  def index
    @cats = Cat.all.sort

    render :index
  end

  def show
    @cat = Cat.find(params[:id])

    render :show
  end

  def new
    render :new
  end

  def create
    cat = Cat.new(cat_params)
    if cat.save
      redirect_to cat_url(cat.id)
    end
    # else
    #   render html: cat.errors.full_messages, status: :unprocessable_entity
    # end
  end

  def edit
    @cat = Cat.find(params[:id])

    render :edit
  end

  def update
    @cat = Cat.find(params[:id])

    @cat.update!(params.require(:cat).permit(:id, :name, :birthdate, :sex, :color, :description))

    render :show
  end
end

private
def cat_params
  params.require(:cat).permit(:name, :birthdate, :sex, :color, :description)
end

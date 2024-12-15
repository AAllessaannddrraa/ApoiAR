class SupportsController < ApplicationController
  before_action :set_support, only: [:show, :edit, :update, :destroy, :calculate_score, :recalculate_matches, :assign_caregiver, :view_matches]
  before_action :set_collections, only: [:new, :edit, :create, :update]

  def index
    @supports = Support.includes(:skills, :equipments).paginate(page: params[:page], per_page: 10)
    @supports_without_caregivers = @supports.select { |support| support.caregiver.nil? }
    @caregivers = Caregiver.includes(:skills, :equipments)
  end

  def show
    @caregivers = Caregiver.all.map do |caregiver|
      match_data = caregiver.matches_support?(@support)
      {
        caregiver: caregiver,
        match: match_data[:match],
        missing_skills: match_data[:missing_skills],
        missing_equipments: match_data[:missing_equipments],
        score: caregiver.match_score(@support)
      }
    end.sort_by { |match| -match[:score] }
  end

  def new
    @support = Support.new
  end

  def edit
    @support = Support.find(params[:id])
    @skills = Skill.all
    @equipments = Equipment.all
    @caregivers = Caregiver.includes(:skills, :equipments).all
  end

  def create
    @support = Support.new(support_params)
    @support.user = current_user
    if @support.save
      redirect_to supports_path, notice: 'Support was successfully created.'
    else
      render :new
    end
  end

  def update
    if @support.update(support_params)
      redirect_to support_path(@support), notice: 'Support was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @support.destroy
    redirect_to supports_url, notice: 'Support was successfully destroyed.'
  end

  def calculate_score
    support = Support.find(params[:id])
    caregiver = Caregiver.find(params[:caregiver_id])
    selected_skills = Skill.where(id: params[:skill_ids] || [])
    selected_equipments = Equipment.where(id: params[:equipment_ids] || [])

    missing_skills = selected_skills - caregiver.skills
    missing_equipments = selected_equipments - caregiver.equipments
    score = caregiver.match_score(support)

    render json: {
      score: score,
      missing_skills: missing_skills.map(&:name),
      missing_equipments: missing_equipments.map(&:name)
    }
  end

  def recalculate_matches
    support = Support.find(params[:id])
    matches = Caregiver.all.map do |caregiver|
      match_data = caregiver.matches_support?(support)
      {
        name: caregiver.name,
        score: caregiver.match_score(support),
        missing_skills: match_data[:missing_skills].map(&:name),
        missing_equipments: match_data[:missing_equipments].map(&:name)
      }
    end.sort_by { |m| -m[:score] }

    render json: { matches: matches }
  end

  def assign_caregiver
    support = Support.find(params[:id])
    caregiver = Caregiver.find(params[:caregiver_id])
    support.update(caregiver: caregiver)

    render json: { message: "Caregiver assigned successfully!", caregiver_name: caregiver.name }
  end

  def view_matches
    @support = Support.find(params[:id])
    @matches = Caregiver.all.map do |caregiver|
      match_data = caregiver.matches_support?(@support)
      {
        caregiver: caregiver,
        match: match_data[:match],
        missing_skills: match_data[:missing_skills],
        missing_equipments: match_data[:missing_equipments],
        score: caregiver.match_score(@support)
      }
    end.sort_by { |match| -match[:score] }
  end

  def add_support_to_dashboard
    @support = Support.new(support_params)
    if @support.save
      render json: { success: true, support: @support }
    else
      render json: { success: false, errors: @support.errors.full_messages }
    end
  end

  private

  def set_support
    @support = Support.find(params[:id])
  end

  def set_collections
    @skills = Skill.all
    @equipments = Equipment.all
    @caregivers = Caregiver.all
  end

  def support_params
    params.require(:support).permit(:name, :description, :caregiver_id, skill_ids: [], equipment_ids: [])
  end
end

class RequestSupportsController < ApplicationController
  before_action :set_request_support, only: %i[show edit update destroy]

  def index
    @request_supports = RequestSupport.all
  end

  def show
    @caregivers = Caregiver.all
    @matches = @caregivers.map do |caregiver|
      match_data = caregiver.matches_support?(@request_support)
      {
        caregiver: caregiver,
        match: match_data[:match],
        missing_skills: match_data[:missing_skills],
        missing_equipments: match_data[:missing_equipments],
        score: caregiver.match_score(@request_support)
      }
    end.sort_by { |match| -match[:score] }
  end

  def new
    @request_support = RequestSupport.new
  end

  def edit
  end

  def create
    @request_support = RequestSupport.new(request_support_params)
    if @request_support.save
      redirect_to @request_support, notice: 'Request support was successfully created.'
    else
      render :new
    end
  end

  def update
    if @request_support.update(request_support_params)
      redirect_to @request_support, notice: 'Request support was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @request_support.destroy
    redirect_to request_supports_url, notice: 'Request support was successfully destroyed.'
  end

  private

  def set_request_support
    @request_support = RequestSupport.find(params[:id])
  end

  def request_support_params
    params.require(:request_support).permit(:requested_time, skill_ids: [], equipment_ids: [])
  end
end

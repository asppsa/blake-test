# This Rails controller manages CRUD operations for {Student}s, including
# serializing student data to JSON.
class StudentsController < ApplicationController
  before_action :set_student, only: %i[show edit update destroy]
  helper_method :lessons, :teachers

  # Index of {Student}s
  #
  # - GET /students
  # - GET /students.json
  def index
    @students = Student.includes(:teacher, lesson_part: :lesson).all
  end

  def_param_group :timestamps do
    property :created_at, String, desc: 'ISO 8601 representation of creation timestamp', validate: false
    property :updated_at, String, desc: 'ISO 8601 representation of creation timestamp', validate: false
  end

  api :GET, '/students/:id.json'
  param :id, :number, desc: 'ID of the student'
  returns code: 200, desc: 'JSON representation of the stuent and lesson progress' do
    property :id, Integer, desc: 'Student ID'
    property :name, String, desc: 'Student\'s (full) name'
    param_group :timestamps
    property :lesson, Hash, allow_nil: true, desc: "The student's current lesson" do
      property :id, Integer, desc: 'Lesson ID'
      property :number, Integer, desc: 'Lesson number'
      param_group :timestamps
    end
    property :lesson_part, Hash, allow_nil: true, desc: "The student's current lesson part" do
      property :id, Integer, desc: 'Lesson Part ID'
      property :number, Integer, desc: 'Lesson part number'
      param_group :timestamps
    end
  end
  returns code: 404, desc: 'There is no student with that ID'

  # Show a single {Student}
  #
  # - GET /students/1.json; or
  # - GET /students/1 with Accept: application/json
  def show
    respond_to do |format|
      format.html { redirect_to Student }
      format.json { render :show }
    end
  end

  # Show a "new student" form
  #
  # GET /students/new
  def new
    @student = Student.new
  end

  # Show an "edit student" form
  #
  # GET /students/1/edit
  def edit; end

  # Create a new {Student}
  #
  # - POST /students
  # - POST /students.json
  def create
    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save
        format.html { redirect_to Student, notice: 'Student was successfully created.' }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # Update an existing {Student}
  #
  # - PATCH/PUT /students/1
  # - PATCH/PUT /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to Student, notice: 'Student was successfully updated.' }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # Delete an existing {Student}
  #
  # - DELETE /students/1
  # - DELETE /students/1.json
  def destroy
    @student.destroy
    respond_to do |format|
      format.html { redirect_to students_url, notice: 'Student was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # This helper method returns a collection of all {Lesson}s in numbered order,
  # with {LessonPart}s preloaded.
  #
  # @return [<Lesson>]
  def lessons
    Lesson.includes(:parts).order(:number).all
  end

  # This helper method returns a collection of all {Teacher}s in
  # name-alphabetical order.
  #
  # @return [<Teacher>]
  def teachers
    Teacher.order(:name).all
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_student
    @student = Student.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def student_params
    params.require(:student).permit(:name, :lesson_part_id, :teacher_id)
  end
end

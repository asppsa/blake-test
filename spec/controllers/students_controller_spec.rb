require 'rails_helper'

RSpec.describe StudentsController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # Student. As you add validations to Student, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    { name: 'Jim Jones' }
  end

  let(:invalid_attributes) do
    { name: '90000' }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # StudentsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'returns a success response' do
      Student.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'redirects to the index' do
      student = Student.create! valid_attributes
      get :show, params: { id: student.to_param }, session: valid_session
      expect(response).to redirect_to(Student)
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      student = Student.create! valid_attributes
      get :edit, params: { id: student.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Student' do
        expect do
          post :create, params: { student: valid_attributes }, session: valid_session
        end.to change(Student, :count).by(1)
      end

      it 'redirects to the student index' do
        post :create, params: { student: valid_attributes }, session: valid_session
        expect(response).to redirect_to(Student)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { student: invalid_attributes }, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { name: 'Jimbo' }
      end

      it 'updates the requested student' do
        student = Student.create! valid_attributes
        put :update, params: { id: student.to_param, student: new_attributes }, session: valid_session
        student.reload
        expect(student.name).to eq 'Jimbo'
      end

      it 'redirects to the student index' do
        student = Student.create! valid_attributes
        put :update, params: { id: student.to_param, student: valid_attributes }, session: valid_session
        expect(response).to redirect_to(Student)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'edit' template)" do
        student = Student.create! valid_attributes
        put :update, params: { id: student.to_param, student: invalid_attributes }, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested student' do
      student = Student.create! valid_attributes
      expect do
        delete :destroy, params: { id: student.to_param }, session: valid_session
      end.to change(Student, :count).by(-1)
    end

    it 'redirects to the students list' do
      student = Student.create! valid_attributes
      delete :destroy, params: { id: student.to_param }, session: valid_session
      expect(response).to redirect_to(students_url)
    end
  end
end

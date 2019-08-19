require 'rails_helper'

RSpec.describe TeachersController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # Teacher. As you add validations to Teacher, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    { name: 'Robin Williams' }
  end

  let(:invalid_attributes) do
    { name: '999' }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # TeachersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'returns a success response' do
      Teacher.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'redirects to the index' do
      teacher = Teacher.create! valid_attributes
      get :show, params: { id: teacher.to_param }, session: valid_session
      expect(response).to redirect_to(teachers_path)
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
      teacher = Teacher.create! valid_attributes
      get :edit, params: { id: teacher.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Teacher' do
        expect do
          post :create, params: { teacher: valid_attributes }, session: valid_session
        end.to change(Teacher, :count).by(1)
      end

      it 'redirects to the teachers index' do
        post :create, params: { teacher: valid_attributes }, session: valid_session
        expect(response).to redirect_to(teachers_path)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { teacher: invalid_attributes }, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { name: 'My Name is Judge' }
      end

      it 'updates the requested teacher' do
        teacher = Teacher.create! valid_attributes
        put :update, params: { id: teacher.to_param, teacher: new_attributes }, session: valid_session
        teacher.reload
        expect(teacher.name).to eq new_attributes[:name]
      end

      it 'redirects to the index' do
        teacher = Teacher.create! valid_attributes
        put :update, params: { id: teacher.to_param, teacher: valid_attributes }, session: valid_session
        expect(response).to redirect_to(teachers_path)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'edit' template)" do
        teacher = Teacher.create! valid_attributes
        put :update, params: { id: teacher.to_param, teacher: invalid_attributes }, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested teacher' do
      teacher = Teacher.create! valid_attributes
      expect do
        delete :destroy, params: { id: teacher.to_param }, session: valid_session
      end.to change(Teacher, :count).by(-1)
    end

    it 'redirects to the teachers list' do
      teacher = Teacher.create! valid_attributes
      delete :destroy, params: { id: teacher.to_param }, session: valid_session
      expect(response).to redirect_to(teachers_url)
    end
  end
end

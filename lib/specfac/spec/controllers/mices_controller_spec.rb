
require 'rails_helper'
RSpec.describe MicesController, type: :controller do
describe 'GET #new' do
      it 'returns http success' do
        get :new
        expect(response).to have_http_status(:success)
      end
      it 'assigns @mice to a new Mice' do
        mice = create(:mice)
        get :new, params: {id: mice.to_param}
        expect(assigns(:mice)).to be_a_new(Mice)
      end
    end
describe 'GET #index' do
      it 'returns http success' do
        get :index
        expect(response).to have_http_status(:success)
      end
      it 'assigns @mices to Mice.all' do
        mice = create(:mice)
        get :index
        expect(assigns(:mices)).to eq([mice])
      end
    end
describe 'POST #update' do
      let(:mice) {create(:mice)}
      let(:valid_attributes) { attributes_for(:mice )}
      let(:new_attributes) { attributes_for(:updated_mice)}
      let(:invalid_attributes) { attributes_for(:invalid_mice)}
      it 'updates attributes for mice' do
        patch :update, params: {id: mice.to_param,mice: new_attributes}
        mice.reload
        # expect(mice.name).to eq('example')
        # expect(mice.points).to eq(800)
      end
      it 'redirects on update' do
        patch :update, params: {id: mice.to_param,mice: new_attributes}
        expect(response).to redirect_to(mices_path)
      end
      it 'renders a flash message on update' do
        patch :update, params: {id: mice.to_param,mice: new_attributes}
        expect(flash[:notice]).to be_present
      end
      it 'renders a flash message on failure to update' do
        patch :update, params: {id: mice.to_param,mice: invalid_attributes}
        expect(flash[:alert]).to be_present
      end
      it 'fails to update mice' do
        expect(build(:invalid_mice)).to be_invalid
      end
      it 'redirects to edit template on failure to update mice' do
        patch :update, params: {id: mice.to_param,mice: invalid_attributes}
        expect(response).to redirect_to(edit_mice_path(mice))
      end
    end
describe 'POST #create' do
      let(:mice) {create(:mice)}
      let(:valid_attributes) { attributes_for(:mice )}
      let(:invalid_attributes) { attributes_for(:invalid_mice)}
      it 'creates a new mice' do
        expect{
          post :create, params: {mice: valid_attributes}
        }.to change(Mice, :count).by(1)
      end
      it 'redirects on save' do
        post :create, params: {mice: valid_attributes}
        expect(response).to redirect_to(mices_path)
      end
      it 'renders a flash message on save' do
        post :create, params: {mice: valid_attributes}
        expect(flash[:notice]).to be_present
      end
      it 'fails to create a new mice' do
        expect(build(:invalid_mice)).to be_invalid
      end
      it 'redirects to new template on failure to save new mice' do
        post :create, params: {mice: invalid_attributes}
        expect(response).to redirect_to(new_mice_path)
      end
    end
describe 'GET #show' do
      it 'returns http success' do
        mice = create(:mice)
        get :show, params: {id: mice.to_param}
        expect(response).to have_http_status(:success)
      end
      it 'assigns @mice to a Mice' do
        mice = create(:mice)
        get :show, params: {id: mice.to_param}
        expect(assigns(:mice)).to eq(mice)
      end
    end
describe 'GET #edit' do
      it 'returns http success' do
        mice = create(:mice)
        get :edit, params: {id: mice.to_param}
        expect(response).to have_http_status(:success)
      end
      it 'assigns @mice to a Mice' do
        mice = create(:mice)
        get :edit, params: {id: mice.to_param}
        expect(assigns(:mice)).to eq(mice)
      end
    end
describe 'DELETE #destroy' do
      let(:mice) {build(:mice)}
      it 'destroys a mice' do
        mice.save
        expect {
          delete :destroy, params: {id: mice.to_param }
        }.to change(Mice, :count).by(-1)
      end
      it 'renders a flash message after delete' do
        mice.save
        delete :destroy, params: {id: mice.to_param }
        expect(flash[:notice]).to be_present
      end
      it 'redirects to mices_path after destroy' do
        mice.save
        delete :destroy, params: {id: mice.to_param }
        expect(response).to redirect_to(mices_path)
      end
    end
end

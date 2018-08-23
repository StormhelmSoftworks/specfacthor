require 'active_support'
require 'active_support/core_ext/string'

module Utils
  @@term = nil

  def self.define_utils_methods_params(term)
    @@term = term
  end

  def self.si
    Utils.singularize(@@term)
  end

  def self.si_ca
    Utils.singularize(@@term.capitalize)
  end

  def self.pl
    Utils.pluralize(@@term)
  end

  def self.pluralize(string)
    return ActiveSupport::Inflector.pluralize(string)
  end

  def self.singularize(string)
    return ActiveSupport::Inflector.singularize(string)
  end

end
module Utils
  include Utils



  def self.index
    "describe 'GET #index' do
      it 'returns http success' do
        get :index
        expect(response).to have_http_status(:success)
      end
      it 'assigns @#{Utils.pl} to #{Utils.si_ca}.all' do
        #{Utils.si} = create(:#{Utils.si})
        get :index
        expect(assigns(:#{Utils.pl})).to eq([#{Utils.si}])
      end
    end"
  end

  def self.show
    "describe 'GET #show' do
      it 'returns http success' do
        #{Utils.si} = create(:#{Utils.si})
        get :show, params: {id: #{Utils.si}.to_param}
        expect(response).to have_http_status(:success)
      end
      it 'assigns @#{Utils.si} to a #{Utils.si_ca}' do
        #{Utils.si} = create(:#{Utils.si})
        get :show, params: {id: #{Utils.si}.to_param}
        expect(assigns(:#{Utils.si})).to eq(#{Utils.si})
      end
    end"
  end

  def self.new
    "describe 'GET #new' do
      it 'returns http success' do
        get :new
        expect(response).to have_http_status(:success)
      end
      it 'assigns @#{Utils.si} to a new #{Utils.si_ca}' do
        #{Utils.si} = create(:#{Utils.si})
        get :new, params: {id: #{Utils.si}.to_param}
        expect(assigns(:#{Utils.si})).to be_a_new(#{Utils.si_ca})
      end
    end"
  end

  def self.create
    "describe 'POST #create' do
      let(:#{Utils.si}) {create(:#{Utils.si})}
      let(:valid_attributes) { attributes_for(:#{Utils.si} )}
      let(:invalid_attributes) { attributes_for(:invalid_#{Utils.si}_attrs)}
      it 'creates a new #{Utils.si}' do
        expect{
          post :create, params: {#{Utils.si}: valid_attributes}
        }.to change(#{Utils.si_ca}, :count).by(1)
      end
      it 'redirects on save' do
        post :create, params: {#{Utils.si}: valid_attributes}
        expect(response).to redirect_to(#{Utils.pl}_path)
      end
      it 'renders a flash message on save' do
        post :create, params: {#{Utils.si}: valid_attributes}
        expect(flash[:notice]).to be_present
      end
      it 'fails to create a new #{Utils.si}' do
        expect(build(:invalid_#{Utils.si}_attrs)).to be_invalid
      end
      it 'redirects to new template on failure to save new #{Utils.si}' do
        post :create, params: {#{Utils.si}: invalid_attributes}
        expect(response).to redirect_to(new_#{Utils.si}_path)
      end
    end"
  end

  def self.edit
    "describe 'GET #edit' do
      it 'returns http success' do
        #{Utils.si} = create(:#{Utils.si})
        get :edit, params: {id: #{Utils.si}.to_param}
        expect(response).to have_http_status(:success)
      end
      it 'assigns @#{Utils.si} to a #{Utils.si_ca}' do
        #{Utils.si} = create(:#{Utils.si})
        get :edit, params: {id: #{Utils.si}.to_param}
        expect(assigns(:#{Utils.si})).to eq(#{Utils.si})
      end
    end"
  end

  def self.update
    "describe 'POST #update' do
      let(:#{Utils.si}) {create(:#{Utils.si})}
      let(:valid_attributes) { attributes_for(:#{Utils.si} )}
      let(:new_attributes) { attributes_for(:updated_#{Utils.si})}
      let(:invalid_attributes) { attributes_for(:invalid_#{Utils.si}_attrs)}
      it 'updates attributes for #{Utils.si}' do
        patch :update, params: {id: #{Utils.si}.to_param,#{Utils.si}: new_attributes}
        #{Utils.si}.reload
        # expect(#{Utils.si}.name).to eq('test2')
        # expect(#{Utils.si}.points).to eq(800)
      end
      it 'redirects on update' do
        patch :update, params: {id: #{Utils.si}.to_param,#{Utils.si}: new_attributes}
        expect(response).to redirect_to(#{Utils.si}s_path)
      end
      it 'renders a flash message on update' do
        patch :update, params: {id: #{Utils.si}.to_param,#{Utils.si}: new_attributes}
        expect(flash[:notice]).to be_present
      end
      it 'renders a flash message on failure to update' do
        patch :update, params: {id: #{Utils.si}.to_param,#{Utils.si}: invalid_attributes}
        expect(flash[:alert]).to be_present
      end
      it 'fails to update #{Utils.si}' do
        expect(build(:invalid_#{Utils.si}_attrs)).to be_invalid
      end
      it 'redirects to edit template on failure to update #{Utils.si}' do
        patch :update, params: {id: #{Utils.si}.to_param,#{Utils.si}: invalid_attributes}
        expect(response).to redirect_to(edit_#{Utils.si}_path(#{Utils.si}))
      end
    end"
  end

  def self.destroy
    "describe 'DELETE #destroy' do
      let(:#{Utils.si}) {build(:#{Utils.si})}
      it 'destroys a #{Utils.si}' do
        #{Utils.si}.save
        expect {
          delete :destroy, params: {id: #{Utils.si}.to_param }
        }.to change(#{Utils.si_ca}, :count).by(-1)
      end
      it 'renders a flash message after delete' do
        #{Utils.si}.save
        delete :destroy, params: {id: #{Utils.si}.to_param }
        expect(flash[:notice]).to be_present
      end
      it 'redirects to #{Utils.si}s_path after destroy' do
        #{Utils.si}.save
        delete :destroy, params: {id: #{Utils.si}.to_param }
        expect(response).to redirect_to(#{Utils.si}s_path)
      end
    end"
  end


end

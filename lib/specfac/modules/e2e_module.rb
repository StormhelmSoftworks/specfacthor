require_relative './utils'

module E2eModule
  #end to end testing

  def self.index
    "describe 'index' do
    before do
      visit #{Utils.pl}_path
    end
    it 'can be reached successfully' do
      expect(page.status_code).to eq(200)
    end

    it 'has a title of #{Utils.si}s' do
      expect(page).to have_content('#{Utils.si}s')
    end

    it 'has a list of #{Utils.si}s' do
      create(:#{Utils.si})
      create(:second_#{Utils.si})
      visit #{Utils.si}s_path
      expect(page).to have_content(#{Utils.si_ca}) # change this
    end
  end"
  end

  def self.show
    "describe 'show' do
    before do
      @#{Utils.si} = create(:#{Utils.si})
      visit #{Utils.si}_path(@#{Utils.si})
    end
    it 'has a show page that can be reached' do
      expect(page.status_code).to eq(200)
    end
    it 'has content' do
      # expect(page).to have_content('Content')
    end
  end"
  end

  def self.new
    "describe 'new' do
      before do
        visit new_#{Utils.si}_path
      end
      it 'has a new page that can be reached' do
        expect(page.status_code).to eq(200)
      end

      it 'can be created from new form page' do
        # fill_in '#{Utils.si}[date]', with: '#{Date.today}'
        # fill_in '#{Utils.si}[rationale]', with: 'Some Rationale'
        #
        # click_on 'Submit'

        # expect(page).to have_content('Rationale')
      end
    end"
  end

  def self.create

  end

  def self.update

  end

  def self.destroy

  end


  def self.edit
    "describe 'edit' do
    before do
      @#{Utils.si} = create(:#{Utils.si})
      visit edit_#{Utils.si}_path(@#{Utils.si})
    end
    it 'has an edit page that can be reached' do
      expect(page.status_code).to eq(200)
    end
    it 'can be edited' do

      # fill_in '#{Utils.si}[date]', with: '#{Date.today}'
      # fill_in '#{Utils.si}[rationale]', with: 'Edited Content'
      #
      # click_on 'Submit'
      #
      # expect(page).to have_content('Edited Content')
    end
  end"
  end

end
require 'rails_helper'

RSpec.describe JobProfileSearch do
  describe '.search' do
    it 'does not return job profiles that are already stored on the session' do
      dog_trainer_job = create(:job_profile, name: 'Dog trainer')
      music_therapist_job = create(:job_profile, name: 'Music therapist')

      expect(described_class.new(term: 'Music therapist', profile_ids_to_exclude: [dog_trainer_job.id]).search).to contain_exactly(music_therapist_job)
    end

    it 'returns a job profile if a name has accidental spaces' do
      job_profile = create(:job_profile, name: 'Music therapist')

      expect(described_class.new(term: 'Music    therapist      ').search).to contain_exactly(job_profile)
    end

    it 'returns a job profile if a name matches exactly' do
      job_profile = create(:job_profile, name: 'Beverage Dissemination Officer')

      expect(described_class.new(term: 'Beverage Dissemination Officer').search).to contain_exactly(job_profile)
    end

    it 'returns a job profile if a name is like an existing job profile name' do
      job_profile = create(:job_profile, name: 'Beverage Dissemination Officer')

      expect(described_class.new(term: 'Dissemination').search).to contain_exactly(job_profile)
    end

    it 'returns a job profile if a name supplied is uppercase' do
      job_profile = create(:job_profile, name: 'Beverage Dissemination Officer')

      expect(described_class.new(term: 'DISSEMINATION').search).to contain_exactly(job_profile)
    end

    it 'returns a job profile if a name supplied is lowercase' do
      job_profile = create(:job_profile, name: 'BEVERAGE DISSEMINATION OFFICER')

      expect(described_class.new(term: 'beverage dissemination officer').search).to contain_exactly(job_profile)
    end

    it 'returns a job profile if a name supplied is mixed case' do
      job_profile = create(:job_profile, name: 'Beverage Dissemination Officer')

      expect(described_class.new(term: 'Beverage Dissemination OfFicer').search).to contain_exactly(job_profile)
    end

    it 'returns nothing if no job profile is matched' do
      create(:job_profile, name: 'Dream Alchemist')

      expect(described_class.new(term: 'Beverage Dissemination Officer').search).to be_empty
    end

    it 'returns no records if empty name is supplied' do
      create(:job_profile, name: 'Dream Alchemist')
      create(:job_profile, name: 'Beverage Dissemination Officer')

      expect(described_class.new(term: '').search).to be_empty
    end

    it 'returns no records if no name is supplied' do
      create(:job_profile, name: 'Dream Alchemist')

      expect(described_class.new(term: nil).search).to be_empty
    end

    it 'returns a record if value is in alternative titles only' do
      job_profile = create(:job_profile, name: 'Chef', alternative_titles: 'Cook, Kitchen manager')

      expect(described_class.new(term: 'cook').search).to contain_exactly(job_profile)
    end

    it 'returns a record if value is in specialism only' do
      job_profile = create(:job_profile, name: 'Chef', specialism: 'Cook,kitchen manager')

      expect(described_class.new(term: 'cook').search).to contain_exactly(job_profile)
    end

    it 'returns a record if value is in hidden titles only' do
      job_profile = create(:job_profile, name: 'Chef', hidden_titles: 'Cook, Kitchen manager')

      expect(described_class.new(term: 'cook').search).to contain_exactly(job_profile)
    end

    it 'returns a record if value is in the description only' do
      job_profile = create(:job_profile, name: 'Chef', alternative_titles: 'Cook', description: 'Kitchen manager')

      expect(described_class.new(term: 'Kitchen manager').search).to contain_exactly(job_profile)
    end

    it 'matches different records in query' do
      job_profiles = [
        create(:job_profile, name: 'Head Chef', description: 'some description'),
        create(:job_profile, name: 'name', alternative_titles: 'Cook', description: 'some description'),
        create(:job_profile, name: 'name', specialism: 'foody', description: 'some description'),
        create(:job_profile, name: 'name', hidden_titles: 'Pastry Chef', description: 'some description'),
        create(:job_profile, name: 'name', description: 'Street food traders')
      ]

      expect(described_class.new(term: 'food cook chef').search).to eq(job_profiles)
    end

    it 'matches query words as prefixes to records' do
      job_profile = create(:job_profile, name: 'Chief executive')

      expect(described_class.new(term: 'exec').search).to contain_exactly(job_profile)
    end

    it 'matches query words through stemming to records' do
      job_profile = create(:job_profile, name: 'Chief executive')

      expect(described_class.new(term: 'chiefs').search).to contain_exactly(job_profile)
    end

    it 'ignores unicode characters in query string' do
      job_profile = create(:job_profile, name: 'Chief executive')

      expect(described_class.new(term: "ṩ ® chief's àⅣ <>; /").search).to contain_exactly(job_profile)
    end

    it 'ignores irrelevant characters in query string' do
      job_profile = create(:job_profile, name: 'Script Writer')

      expect(described_class.new(term: '<script> alert("PWNED!") </script>').search).to contain_exactly(job_profile)
    end

    it 'guards against injection in string' do
      job_profile = create(:job_profile, name: 'Table Writer')

      expect(described_class.new(term: 'name; drop table job_profiles;').search).to contain_exactly(job_profile)
    end

    it 'orders records according to matched name' do
      cook = create(:job_profile, alternative_titles: 'Cook', name: 'name 1', description: nil)
      baker = create(:job_profile, hidden_titles: 'Pastry Chef', name: 'name 2', description: nil)
      head_chef = create(:job_profile, name: 'Head Chef', description: nil)
      foody = create(:job_profile, specialism: 'a foody', name: 'name 3', description: nil)
      food_trader = create(:job_profile, description: 'Street food traders', name: 'Trader')
      kitchen_chef = create(:job_profile, name: 'Kitchen Chef', description: nil)

      job_profiles_in_order = [
        head_chef,
        kitchen_chef,
        cook,
        baker,
        foody,
        food_trader
      ]

      expect(described_class.new(term: 'food cook chef').search).to eq(job_profiles_in_order)
    end

    it 'orders name, alternative title, hidden title then specialism, then description on exact match' do
      exact_alternative_title = create(:job_profile, alternative_titles: 'Head chef', name: 'name', description: nil)
      exact_hidden_title = create(:job_profile, hidden_titles: 'Head chef', name: 'name B', description: nil)
      exact_name = create(:job_profile, name: 'Head chef', description: nil)
      exact_specialism = create(:job_profile, specialism: 'Head chef', name: 'name A', description: nil)
      exact_desc = create(:job_profile, description: 'Head chef traders', name: 'Trader')

      job_profiles_in_order = [
        exact_name,
        exact_alternative_title,
        exact_specialism,
        exact_hidden_title,
        exact_desc
      ]

      expect(described_class.new(term: 'Head chef').search).to eq(job_profiles_in_order)
    end

    it 'orders name, alternative title, hidden title then specialism, then description on partial match' do
      partial_alternative_title = create(:job_profile, alternative_titles: 'development', name: 'name', description: nil)
      partial_hidden_title = create(:job_profile, hidden_titles: 'development', name: 'name B', description: nil)
      partial_name = create(:job_profile, name: 'development', description: nil)
      partial_specialism = create(:job_profile, specialism: 'development', name: 'name A', description: nil)
      partial_desc = create(:job_profile, description: 'development traders', name: 'Trader')

      job_profiles_in_order = [
        partial_name,
        partial_alternative_title,
        partial_specialism,
        partial_hidden_title,
        partial_desc
      ]

      expect(described_class.new(term: 'developer').search).to eq(job_profiles_in_order)
    end

    it 'orders name, alternative title, then description on partial match' do
      kitchen_assistant = create(
        :job_profile,
        name: 'Kitchen assistant',
        description: 'Kitchen assistants prepare food, make sure chefs have everything they need and keep the kitchen clean.'
      )
      chef = create(
        :job_profile,
        name: 'chef',
        alternative_titles: 'Cook',
        description: 'Chefs prepare, cook and present food in hotels, bars and restaurants'
      )
      head_chef = create(
        :job_profile,
        name: 'Head chef',
        alternative_titles: 'Kitchen manager, executive chef, chef de cuisine',
        description: 'Head chefs oversee restaurants’ staff, food and budgets.'
      )

      job_profiles_in_order = [
        chef,
        head_chef,
        kitchen_assistant
      ]

      expect(described_class.new(term: 'chef').search).to eq(job_profiles_in_order)
    end

    it 'orders exact match before partial match' do
      partial_alternative_title = create(:job_profile, alternative_titles: 'development', name: 'name 1', description: nil)
      exact_name = create(:job_profile, name: 'Web Developer', description: nil)
      partial_name = create(:job_profile, name: 'development', description: nil)
      exact_desc = create(:job_profile, description: 'A Developer', name: 'name 2')
      partial_specialism = create(:job_profile, specialism: 'development', name: 'name C', description: nil)
      partial_desc = create(:job_profile, description: 'development traders', name: 'Trader')
      exact_hidden_title = create(:job_profile, hidden_titles: 'App Developer', name: 'name B', description: nil)
      exact_specialism = create(:job_profile, specialism: 'App Developer', name: 'name A', description: nil)
      exact_alternative_title = create(:job_profile, alternative_titles: 'Software Developer', name: 'name 3', description: nil)
      partial_hidden_title = create(:job_profile, hidden_titles: 'development', name: 'name D', description: nil)

      job_profiles_in_order = [
        exact_name,
        exact_alternative_title,
        exact_specialism,
        exact_hidden_title,
        exact_desc,
        partial_name,
        partial_alternative_title,
        partial_specialism,
        partial_hidden_title,
        partial_desc

      ]

      expect(described_class.new(term: 'developer').search).to eq(job_profiles_in_order)
    end

    it 'orders alphabetically after matching' do
      job_profile1 = create(:job_profile, name: 'Web B', description: nil)
      job_profile2 = create(:job_profile, name: 'Web A', description: nil)

      job_profiles_in_order = [
        job_profile2,
        job_profile1
      ]

      expect(described_class.new(term: 'web').search).to eq(job_profiles_in_order)
    end

    it 'orders alphabetically after partial matching' do
      job_profile1 = create(:job_profile, name: 'development B', description: nil)
      job_profile2 = create(:job_profile, name: 'development A', description: nil)

      job_profiles_in_order = [
        job_profile2,
        job_profile1
      ]

      expect(described_class.new(term: 'developer').search).to eq(job_profiles_in_order)
    end

    it 'orders correctly even when values are nil' do
      job_profile1 = create(:job_profile, name: 'development C', alternative_titles: nil, description: nil)
      job_profile2 = create(:job_profile, name: 'development A', alternative_titles: nil, description: nil)

      job_profiles_in_order = [
        job_profile2,
        job_profile1
      ]

      expect(described_class.new(term: 'developer').search).to eq(job_profiles_in_order)
    end
  end

  describe 'validation' do
    it 'is invalid if term is not entered' do
      search = described_class.new(term: nil)

      expect(search).not_to be_valid
    end

    it 'is invalid if empty term entered' do
      search = described_class.new(term: '')

      expect(search).not_to be_valid
    end
  end
end

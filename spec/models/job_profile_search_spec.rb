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
        create(:job_profile, name: 'Head Chef', description: nil),
        create(:job_profile, name: 'name', alternative_titles: 'Cook', description: nil),
        create(:job_profile, name: 'name', specialism: 'foody', description: nil),
        create(:job_profile, name: 'name', hidden_titles: 'Pastry Chef', description: nil),
        create(:job_profile, name: 'name', description: 'Street food traders ')
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
      cook = create(:job_profile, alternative_titles: 'Cook', name: 'name', description: nil)
      baker = create(:job_profile, hidden_titles: 'Pastry Chef', name: 'name', description: nil)
      head_chef = create(:job_profile, name: 'Head Chef', description: nil)
      foody = create(:job_profile, specialism: 'foody', name: 'name', description: nil)
      food_trader = create(:job_profile, description: 'Street food traders ', name: 'Trader')
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

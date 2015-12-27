require 'rails_helper'

describe Term do
  it { is_expected.to have_many(:academic_degree_terms) }
  it { is_expected.to have_many(:academic_degrees).through(:academic_degree_terms) }

  it { is_expected.to validate_presence_of(:year) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:year, :tags) }

  describe '#ordered' do
    let(:ordered_terms) { [] }
    before do
      ordered_terms[0] = create(:term, year: 2015, name: 'A', tags: 'B')
      ordered_terms[1] = create(:term, year: 2015, name: 'A', tags: 'C')
      ordered_terms[3] = create(:term, year: 2014, name: 'A', tags: 'B')
      ordered_terms[2] = create(:term, year: 2015, name: 'B', tags: 'B')
    end

    it 'returns terms in "year: :desc, name: :asc, tags: :asc" order' do
      expect(Term.ordered).to eq(ordered_terms)
    end
  end
end

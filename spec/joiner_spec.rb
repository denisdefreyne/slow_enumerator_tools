# frozen_string_literal: true

describe SlowEnumeratorTools::Joiner do
  subject { described_class.join(enums).to_a }

  context 'no enums' do
    let(:enums) { [] }
    it { is_expected.to be_empty }
  end

  context 'one enum, empty' do
    let(:enums) { [[]] }
    it { is_expected.to be_empty }
  end

  context 'one enum, one element' do
    let(:enums) { [[1]] }
    it { is_expected.to eq([1]) }
  end

  context 'one enum, two elements' do
    let(:enums) { [[1, 2]] }
    it { is_expected.to eq([1, 2]) }
  end

  context 'two enums, empty + empty' do
    let(:enums) { [[], []] }
    it { is_expected.to be_empty }
  end

  context 'two enums, empty + one el' do
    let(:enums) { [[], [1]] }
    it { is_expected.to eq([1]) }
  end

  context 'two enums, empty + two el' do
    let(:enums) { [[], [1, 2]] }
    it { is_expected.to eq([1, 2]) }
  end

  context 'two enums, one el + empty' do
    let(:enums) { [[1], []] }
    it { is_expected.to match_array([1]) }
  end

  context 'two enums, one el + one el' do
    let(:enums) { [[1], [2]] }
    it { is_expected.to match_array([1, 2]) }
  end

  context 'two enums, one el + two el' do
    let(:enums) { [[1], [2, 3]] }
    it { is_expected.to match_array([1, 2, 3]) }
  end

  context 'two enums, two el + empty' do
    let(:enums) { [[1, 2], []] }
    it { is_expected.to match_array([1, 2]) }
  end

  context 'two enums, two el + one el' do
    let(:enums) { [[1, 2], [3]] }
    it { is_expected.to match_array([1, 2, 3]) }
  end

  context 'two enums, two el + two el' do
    let(:enums) { [[1, 2], [3, 4]] }
    it { is_expected.to match_array([1, 2, 3, 4]) }
  end
end

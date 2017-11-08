# frozen_string_literal: true

describe SlowEnumeratorTools::Merger do
  subject { described_class.merge(enums).to_a }

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

  context 'error in taken elements' do
    subject { described_class.merge(enums) }

    let(:enum) do
      Enumerator.new do |y|
        y << 1
        y << 2
        raise 'boom'
      end.lazy
    end

    let(:enums) { [enum] }

    it 'does not raise right away' do
      subject
    end

    it 'does not raise when only taken' do
      subject.take(3)
    end

    it 'raises when evaluated' do
      expect { subject.take(3).to_a }
        .to raise_error(RuntimeError, 'boom')
    end
  end

  context 'error past taken elements' do
    subject { described_class.merge(enums) }

    let(:enum) do
      Enumerator.new do |y|
        y << 1
        y << 2
        y << 3
        raise 'boom'
      end.lazy
    end

    let(:enums) { [enum] }

    it 'does not raise right away' do
      subject
    end

    it 'does not raise when only taken' do
      subject.take(3)
    end

    it 'does not raise when evaluated' do
      expect(subject.take(3).to_a).to eq([1, 2, 3])
    end
  end
end

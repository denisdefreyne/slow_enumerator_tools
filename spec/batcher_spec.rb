# frozen_string_literal: true

describe SlowEnumeratorTools::Batcher do
  let(:wrapped) do
    Enumerator.new do |y|
      5.times do |i|
        y << i
        sleep 0.2
      end
    end
  end

  subject do
    described_class.batch(wrapped)
  end

  example do
    expect(subject.next).to eq([0])
  end

  example do
    subject.next
    expect(subject.next).to eq([1])
  end

  example do
    subject
    sleep 0.25
    expect(subject.next).to eq([0, 1])
  end

  example do
    subject
    sleep 0.45
    expect(subject.next).to eq([0, 1, 2])
  end

  context 'empty enumerable' do
    let(:wrapped) do
      Enumerator.new do |y|
      end
    end

    it 'returns nothing' do
      expect { subject.next }.to raise_error(StopIteration)
    end
  end

  context 'instant-erroring enumerable' do
    let(:wrapped) do
      Enumerator.new do |_y|
        raise 'boom'
      end
    end

    it 'returns nothing' do
      expect { subject.next }.to raise_error(RuntimeError, 'boom')
    end
  end

  context 'error in taken elements' do
    let(:wrapped) do
      Enumerator.new do |y|
        y << 1
        y << 2
        y << 3
        raise 'boom'
      end
    end

    it 'does not raise right away' do
      subject
      sleep 0.01
      subject
    end

    it 'does not raise when only taken' do
      subject
      sleep 0.01
      subject.take(1)
    end

    it 'raises when evaluated' do
      subject
      sleep 0.01
      expect { subject.take(1).first }
        .to raise_error(RuntimeError, 'boom')
    end
  end

  context 'error past taken elements' do
    let(:wrapped) do
      Enumerator.new do |y|
        y << 1
        y << 2
        y << 3
        sleep 0.1
        raise 'boom'
      end
    end

    it 'does not raise right away' do
      subject
      sleep 0.01
      subject
    end

    it 'does not raise when only taken' do
      subject
      sleep 0.01
      subject.take(1)
    end

    it 'does not raise when evaluated' do
      subject
      sleep 0.01
      expect(subject.take(1).first).to eq([1, 2, 3])
    end
  end
end

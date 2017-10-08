# frozen_string_literal: true

describe SlowEnumeratorTools::Bufferer do
  let(:wrapped) do
    Enumerator.new do |y|
      5.times do |i|
        y << i
        sleep 0.2
      end
    end
  end

  subject do
    described_class.buffer(wrapped)
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
end

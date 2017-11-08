# frozen_string_literal: true

describe SlowEnumeratorTools do
  it 'has a version number' do
    expect(SlowEnumeratorTools::VERSION).not_to be nil
  end

  it 'supports .merge shorthand' do
    expect(SlowEnumeratorTools.merge([[1, 2], [3, 4]]).to_a)
      .to match_array([1, 2, 3, 4])
  end

  it 'supports .batch shorthand' do
    expect(SlowEnumeratorTools.batch([1, 2]).to_a)
      .to match_array([[1, 2]])
  end

  it 'supports .buffer shorthand' do
    expect(SlowEnumeratorTools.buffer([1, 2], 5).to_a)
      .to match_array([1, 2])
  end
end

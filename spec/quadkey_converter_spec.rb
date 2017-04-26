require "spec_helper"

describe QuadkeyConverter do
  describe '#tileToQuadkey' do
    context 'latitude: 40.01234, longitude: -160.02324, detail: 16' do
      it 'returns "02201110223103220"' do
        location = { lat: 40.01234, lng: -160.02324 }
        detail = 16

        key = QuadkeyConverter.locationToQuadkey(location, detail)

        expect(key).to eq("02201110223103220")
      end
    end
  end
end

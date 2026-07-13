export default function createGetLatestLocationsUseCase({ courierRepository }) {
  return async function getLatestLocations() {
    return courierRepository.findLatestLocations();
  };
}

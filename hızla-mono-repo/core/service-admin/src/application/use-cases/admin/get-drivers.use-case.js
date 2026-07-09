export default function createGetDriversUseCase({ driverRepository }) {
  return async function getDrivers() {
    const drivers = await driverRepository.findPending();
    return { drivers };
  };
}

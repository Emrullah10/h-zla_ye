export default function createGetDashboardUseCase({ dashboardRepository }) {
  return async function getDashboard() {
    return dashboardRepository.getStats();
  };
}

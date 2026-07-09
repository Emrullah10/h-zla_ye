import datasources from '@hizla/datasource/index.js';
import {
  DashboardRepositoryImpl,
  DriverRepositoryImpl,
  AdminActionRepositoryImpl,
} from '#core/infrastructure/persistence/repositories/admin.repository-impl.js';
import createGetDashboardUseCase from '#core/application/use-cases/admin/get-dashboard.use-case.js';
import createGetDriversUseCase from '#core/application/use-cases/admin/get-drivers.use-case.js';
import createApproveDriverUseCase from '#core/application/use-cases/admin/approve-driver.use-case.js';
import createRejectDriverUseCase from '#core/application/use-cases/admin/reject-driver.use-case.js';

export const buildContainer = () => {
  const db = datasources.coreAppDb;

  const dashboardRepository = new DashboardRepositoryImpl(db);
  const driverRepository = new DriverRepositoryImpl(db);
  const adminActionRepository = new AdminActionRepositoryImpl(db);

  return {
    getDashboard: createGetDashboardUseCase({ dashboardRepository }),
    getDrivers: createGetDriversUseCase({ driverRepository }),
    approveDriver: createApproveDriverUseCase({ driverRepository, adminActionRepository }),
    rejectDriver: createRejectDriverUseCase({ driverRepository, adminActionRepository }),
  };
};

import { UserErrors } from '../../domain/user/user.errors.js';

export const validateLoginInput = ({ phone, password }) => {
  if (!phone) throw UserErrors.MISSING_PHONE();
  if (!password) throw UserErrors.MISSING_PASSWORD();
};

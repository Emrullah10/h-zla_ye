export class User {
  constructor({ userId, phone, passwordHash, role }) {
    this.userId = userId;
    this.phone = phone;
    this.passwordHash = passwordHash;
    this.role = role;
  }

  isAdmin() {
    return this.role === 'admin';
  }

  isCourier() {
    return this.role === 'courier';
  }
}

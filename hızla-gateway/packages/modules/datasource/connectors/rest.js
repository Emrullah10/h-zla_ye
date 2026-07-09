export default class Rest {
  constructor(settings) {
    this.name = settings.name;
    this.type = settings.type;
    this.baseUrl = settings.url;
  }
  async health() {
    return { isOnline: true, name: this.name, type: this.type };
  }
}

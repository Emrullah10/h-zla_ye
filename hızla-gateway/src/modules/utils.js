export function safeJSONStringify(obj) {
  return JSON.stringify(obj, (_, value) => {
    if (value instanceof Error) {
      return { message: value.message, stack: value.stack, name: value.name };
    }
    return value;
  });
}

export function safeJSONParse(str) {
  try {
    return JSON.parse(str);
  } catch {
    return undefined;
  }
}

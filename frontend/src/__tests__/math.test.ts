// frontend/src/__tests__/math.test.ts
import { describe, it, expect } from 'vitest';
import { add } from '../lib/math';

describe('add', () => {
  it('adds two numbers', () => {
    expect(add(1, 2)).toBe(3);
  });
});

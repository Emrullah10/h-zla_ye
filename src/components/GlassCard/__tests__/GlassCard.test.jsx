import { render, screen } from '@testing-library/react'
import { GlassCard } from '../GlassCard'

test('children render eder', () => {
  render(<GlassCard><span>test içerik</span></GlassCard>)
  expect(screen.getByText('test içerik')).toBeInTheDocument()
})

test('glassmorphic stilleri taşır', () => {
  const { container } = render(<GlassCard>x</GlassCard>)
  const el = container.firstChild
  expect(el.style.backdropFilter).toContain('blur')
})

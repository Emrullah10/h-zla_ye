import { useQuests } from '@features/courier/hooks/useQuests'
import { GlassCard } from '@components/GlassCard/GlassCard'
import { Loading } from '@components/Loading/Loading'

const RARITY_COLORS = {
  common: 'var(--text)',
  rare: 'var(--neon)',
  epic: 'var(--brand)',
}

export const QuestList = () => {
  const { data, isLoading } = useQuests()

  if (isLoading) return <Loading />

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '0.75rem', padding: '1rem' }}>
      {(data?.quests ?? []).map((quest) => (
        <GlassCard key={quest.id}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
            <div>
              <p style={{ fontWeight: 600, fontSize: '0.875rem', color: RARITY_COLORS[quest.rarity] ?? 'var(--text)' }}>
                {quest.title}
              </p>
              <p style={{ fontSize: '0.75rem', color: 'var(--text-secondary)', marginTop: '2px' }}>{quest.description}</p>
            </div>
            <div style={{ textAlign: 'right', flexShrink: 0, marginLeft: '1rem' }}>
              <p style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: '0.875rem', color: 'var(--brand)' }}>
                +{quest.reward}₺
              </p>
              <p style={{ fontSize: '0.75rem', color: 'var(--text-secondary)' }}>{quest.progress}/{quest.target}</p>
            </div>
          </div>
          <div style={{ marginTop: '0.75rem', height: '6px', background: 'var(--surface-container-highest)', borderRadius: '3px', overflow: 'hidden' }}>
            <div style={{
              height: '100%',
              background: 'linear-gradient(90deg, var(--brand), var(--brand-dark))',
              borderRadius: '3px',
              width: `${Math.min(100, (quest.progress / quest.target) * 100)}%`,
            }} />
          </div>
        </GlassCard>
      ))}
    </div>
  )
}

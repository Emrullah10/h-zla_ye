import { QuestList } from '@features/courier/components/QuestList/QuestList'

const Quests = () => (
  <div style={{ minHeight: '100%', background: 'var(--bg)' }}>
    <div style={{ padding: '1rem' }}>
      <h1 style={{ fontSize: '1.25rem', fontWeight: 600, color: 'var(--text)' }}>Görevler & Ödüller</h1>
    </div>
    <QuestList />
  </div>
)

export default Quests

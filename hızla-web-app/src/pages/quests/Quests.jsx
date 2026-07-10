import { QuestList } from '@features/courier/components/QuestList/QuestList'

const Quests = () => (
  <div style={{ minHeight: '100%', background: '#0e0e0e' }}>
    <div style={{ padding: '1rem' }}>
      <h1 style={{ fontSize: '1.25rem', fontWeight: 600, color: '#e2e2e2' }}>Görevler & Ödüller</h1>
    </div>
    <QuestList />
  </div>
)

export default Quests

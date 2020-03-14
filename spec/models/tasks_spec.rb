require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'Task validation' do
    it '全て設定されていること' do
      task = build(:task)
      expect(task).to be_valid
    end

    it 'name未入力の為NG' do
      task = build(:task, name: nil)
      task.valid?
      expect(task.errors[:name]).to include('を入力してください')
    end

    it 'activity_at未入力の為NG' do
      task = build(:task, activity_at: nil)
      task.valid?
      expect(task.errors[:activity_at]).to include('を入力してください')
    end

    it 'name activity_at以外は入力無しでもOK' do
      task = build(:task, weight: nil, lep: nil, set: nil, description: nil)
      expect(task).to be_valid
    end

    it 'nameが30文字以上の為NG' do
      task = build(:task, name: 'ハイパースーパーウルトラアルティメットマキシマムトレーニング2')
      task.valid?
      expect(task.errors[:name]).to include('は30文字以内で入力してください')
    end
  end
end

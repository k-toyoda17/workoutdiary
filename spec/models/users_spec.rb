require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'User validation' do
    it 'name email passwordが全て設定されていること' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'name未入力の為NG' do
      user = build(:user, name: nil)
      user.valid?
      expect(user.errors[:name]).to include('を入力してください')
    end

    it 'email未入力の為NG' do
      user = build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include('を入力してください')
    end

    it 'password未入力の為NG' do
      user = build(:user, password: nil)
      user.valid?
      expect(user.errors[:password]).to include('を入力してください')
    end

    it 'emailが既に存在した為NG' do
      create(:user, email: 'cristiano@example.com')
      user = build(:user, email: 'cristiano@example.com')
      user.valid?
      expect(user.errors[:email]).to include('はすでに存在します')
    end
  end
end